package main

// When files are read in by pkglint, they are interpreted in terms of
// lines. For Makefiles, line continuations are handled properly, allowing
// multiple raw lines to end in a single logical line. For other files
// there is a 1:1 translation.
//
// A difference between the raw and the logical lines is that the
// raw lines include the line end sequence, whereas the logical lines
// do not.
//
// Some methods allow modification of the raw lines contained in the
// logical line, but leave the “text” field untouched. These methods are
// used in the --autofix mode.

import (
	"fmt"
	"io"
	"path"
	"strconv"
	"strings"
)

type RawLine struct {
	Lineno int
	orignl string
	textnl string
}

func (rline *RawLine) String() string {
	return strconv.Itoa(rline.Lineno) + ":" + rline.textnl
}

type Line struct {
	Fname          string
	firstLine      int32 // Zero means not applicable, -1 means EOF
	lastLine       int32 // Usually the same as firstLine, may differ in Makefiles
	Text           string
	raw            []*RawLine
	changed        bool
	before         []string
	after          []string
	autofixMessage string
}

func NewLine(fname string, lineno int, text string, rawLines []*RawLine) *Line {
	return NewLineMulti(fname, lineno, lineno, text, rawLines)
}

// NewLineMulti is for logical Makefile lines that end with backslash.
func NewLineMulti(fname string, firstLine, lastLine int, text string, rawLines []*RawLine) *Line {
	return &Line{fname, int32(firstLine), int32(lastLine), text, rawLines, false, nil, nil, ""}
}

// NewLineEOF creates a dummy line for logging, with the “line number” EOF.
func NewLineEOF(fname string) *Line {
	return NewLineMulti(fname, -1, 0, "", nil)
}

// NewLineWhole creates a dummy line for logging messages that affect a file as a whole.
func NewLineWhole(fname string) *Line {
	return NewLine(fname, 0, "", nil)
}

func (line *Line) modifiedLines() []string {
	var result []string
	result = append(result, line.before...)
	for _, raw := range line.raw {
		result = append(result, raw.textnl)
	}
	result = append(result, line.after...)
	return result
}

func (line *Line) linenos() string {
	switch {
	case line.firstLine == -1:
		return "EOF"
	case line.firstLine == 0:
		return ""
	case line.firstLine == line.lastLine:
		return strconv.Itoa(int(line.firstLine))
	default:
		return strconv.Itoa(int(line.firstLine)) + "--" + strconv.Itoa(int(line.lastLine))
	}
}

func (line *Line) ReferenceFrom(other *Line) string {
	if line.Fname != other.Fname {
		return cleanpath(relpath(path.Dir(other.Fname), line.Fname)) + ":" + line.linenos()
	}
	return "line " + line.linenos()
}

func (line *Line) IsMultiline() bool {
	return line.firstLine > 0 && line.firstLine != line.lastLine
}

func (line *Line) printSource(out io.Writer) {
	if G.opts.PrintSource {
		io.WriteString(out, "\n")
		for _, before := range line.before {
			io.WriteString(out, "+ "+before)
		}
		for _, rawLine := range line.raw {
			if rawLine.textnl != rawLine.orignl {
				if rawLine.orignl != "" {
					io.WriteString(out, "- "+rawLine.orignl)
				}
				if rawLine.textnl != "" {
					io.WriteString(out, "+ "+rawLine.textnl)
				}
			} else {
				io.WriteString(out, "> "+rawLine.orignl)
			}
		}
		for _, after := range line.after {
			io.WriteString(out, "+ "+after)
		}
	}
}

func (line *Line) Fatalf(format string, args ...interface{}) {
	line.printSource(G.logErr)
	logs(llFatal, line.Fname, line.linenos(), format, fmt.Sprintf(format, args...))
}

func (line *Line) Errorf(format string, args ...interface{}) {
	line.printSource(G.logOut)
	logs(llError, line.Fname, line.linenos(), format, fmt.Sprintf(format, args...))
	line.logAutofix()
}
func (line *Line) Error0(format string)             { line.Errorf(format) }
func (line *Line) Error1(format, arg1 string)       { line.Errorf(format, arg1) }
func (line *Line) Error2(format, arg1, arg2 string) { line.Errorf(format, arg1, arg2) }

func (line *Line) Warnf(format string, args ...interface{}) {
	line.printSource(G.logOut)
	logs(llWarn, line.Fname, line.linenos(), format, fmt.Sprintf(format, args...))
	line.logAutofix()
}
func (line *Line) Warn0(format string)             { line.Warnf(format) }
func (line *Line) Warn1(format, arg1 string)       { line.Warnf(format, arg1) }
func (line *Line) Warn2(format, arg1, arg2 string) { line.Warnf(format, arg1, arg2) }

func (line *Line) Notef(format string, args ...interface{}) {
	line.printSource(G.logOut)
	logs(llNote, line.Fname, line.linenos(), format, fmt.Sprintf(format, args...))
	line.logAutofix()
}
func (line *Line) Note0(format string)             { line.Notef(format) }
func (line *Line) Note1(format, arg1 string)       { line.Notef(format, arg1) }
func (line *Line) Note2(format, arg1, arg2 string) { line.Notef(format, arg1, arg2) }

func (line *Line) String() string {
	return line.Fname + ":" + line.linenos() + ": " + line.Text
}

func (line *Line) logAutofix() {
	if line.autofixMessage != "" {
		logs(llAutofix, line.Fname, line.linenos(), "%s", line.autofixMessage)
		line.autofixMessage = ""
	}
}

func (line *Line) AutofixInsertBefore(text string) bool {
	if G.opts.PrintAutofix || G.opts.Autofix {
		line.before = append(line.before, text+"\n")
	}
	return line.RememberAutofix("Inserting a line %q before this line.", text)
}

func (line *Line) AutofixInsertAfter(text string) bool {
	if G.opts.PrintAutofix || G.opts.Autofix {
		line.after = append(line.after, text+"\n")
	}
	return line.RememberAutofix("Inserting a line %q after this line.", text)
}

func (line *Line) AutofixDelete() bool {
	if G.opts.PrintAutofix || G.opts.Autofix {
		for _, rawLine := range line.raw {
			rawLine.textnl = ""
		}
	}
	return line.RememberAutofix("Deleting this line.")
}

func (line *Line) AutofixReplace(from, to string) bool {
	for _, rawLine := range line.raw {
		if rawLine.Lineno != 0 {
			if replaced := strings.Replace(rawLine.textnl, from, to, 1); replaced != rawLine.textnl {
				if G.opts.PrintAutofix || G.opts.Autofix {
					rawLine.textnl = replaced
				}
				return line.RememberAutofix("Replacing %q with %q.", from, to)
			}
		}
	}
	return false
}

func (line *Line) AutofixReplaceRegexp(from RegexPattern, to string) bool {
	for _, rawLine := range line.raw {
		if rawLine.Lineno != 0 {
			if replaced := regcomp(from).ReplaceAllString(rawLine.textnl, to); replaced != rawLine.textnl {
				if G.opts.PrintAutofix || G.opts.Autofix {
					rawLine.textnl = replaced
				}
				return line.RememberAutofix("Replacing regular expression %q with %q.", from, to)
			}
		}
	}
	return false
}

func (line *Line) RememberAutofix(format string, args ...interface{}) (hasBeenFixed bool) {
	if line.firstLine < 1 {
		return false
	}
	line.changed = true
	if G.opts.Autofix {
		logs(llAutofix, line.Fname, line.linenos(), format, fmt.Sprintf(format, args...))
		return true
	}
	if G.opts.PrintAutofix {
		line.autofixMessage = fmt.Sprintf(format, args...)
	}
	return false
}

func (line *Line) CheckAbsolutePathname(text string) {
	if G.opts.Debug {
		defer tracecall1(text)()
	}

	// In the GNU coding standards, DESTDIR is defined as a (usually
	// empty) prefix that can be used to install files to a different
	// location from what they have been built for. Therefore
	// everything following it is considered an absolute pathname.
	//
	// Another context where absolute pathnames usually appear is in
	// assignments like "bindir=/bin".
	if m, path := match1(text, `(?:^|\$[{(]DESTDIR[)}]|[\w_]+\s*=\s*)(/(?:[^"'\s]|"[^"*]"|'[^']*')*)`); m {
		if matches(path, `^/\w`) {
			checkwordAbsolutePathname(line, path)
		}
	}
}

func (line *Line) CheckLength(maxlength int) {
	if len(line.Text) > maxlength {
		line.Warnf("Line too long (should be no more than %d characters).", maxlength)
		Explain3(
			"Back in the old time, terminals with 80x25 characters were common.",
			"And this is still the default size of many terminal emulators.",
			"Moderately short lines also make reading easier.")
	}
}

func (line *Line) CheckValidCharacters(reChar RegexPattern) {
	rest := regcomp(reChar).ReplaceAllString(line.Text, "")
	if rest != "" {
		uni := ""
		for _, c := range rest {
			uni += fmt.Sprintf(" %U", c)
		}
		line.Warn1("Line contains invalid characters (%s).", uni[1:])
	}
}

func (line *Line) CheckTrailingWhitespace() {
	if hasSuffix(line.Text, " ") || hasSuffix(line.Text, "\t") {
		if !line.AutofixReplaceRegexp(`\s+\n$`, "\n") {
			line.Note0("Trailing white-space.")
			Explain2(
				"When a line ends with some white-space, that space is in most cases",
				"irrelevant and can be removed.")
		}
	}
}

func (line *Line) CheckRcsid(prefixRe RegexPattern, suggestedPrefix string) bool {
	if G.opts.Debug {
		defer tracecall(prefixRe, suggestedPrefix)()
	}

	if matches(line.Text, `^`+prefixRe+`\$`+`NetBSD(?::[^\$]+)?\$$`) {
		return true
	}

	if !line.AutofixInsertBefore(suggestedPrefix + "$" + "NetBSD$") {
		line.Error1("Expected %q.", suggestedPrefix+"$"+"NetBSD$")
		Explain3(
			"Several files in pkgsrc must contain the CVS Id, so that their",
			"current version can be traced back later from a binary package.",
			"This is to ensure reproducible builds, for example for finding bugs.")
	}
	return false
}
