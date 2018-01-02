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
// logical line, but leave the Text field untouched. These methods are
// used in the --autofix mode.

import (
	"fmt"
	"io"
	"netbsd.org/pkglint/regex"
	"path"
	"strconv"
	"strings"
)

type Line = *LineImpl

type RawLine struct {
	Lineno int
	orignl string
	textnl string
}

func (rline *RawLine) String() string {
	return strconv.Itoa(rline.Lineno) + ":" + rline.textnl
}

type LineImpl struct {
	Filename       string
	firstLine      int32 // Zero means not applicable, -1 means EOF
	lastLine       int32 // Usually the same as firstLine, may differ in Makefiles
	Text           string
	raw            []*RawLine
	Changed        bool
	before         []string
	after          []string
	autofixMessage string
}

func NewLine(fname string, lineno int, text string, rawLines []*RawLine) Line {
	return NewLineMulti(fname, lineno, lineno, text, rawLines)
}

// NewLineMulti is for logical Makefile lines that end with backslash.
func NewLineMulti(fname string, firstLine, lastLine int, text string, rawLines []*RawLine) Line {
	return &LineImpl{fname, int32(firstLine), int32(lastLine), text, rawLines, false, nil, nil, ""}
}

// NewLineEOF creates a dummy line for logging, with the "line number" EOF.
func NewLineEOF(fname string) Line {
	return NewLineMulti(fname, -1, 0, "", nil)
}

// NewLineWhole creates a dummy line for logging messages that affect a file as a whole.
func NewLineWhole(fname string) Line {
	return NewLine(fname, 0, "", nil)
}

// modifiedLines returns the text after the fixes, including line breaks and newly inserted lines
func (line *LineImpl) modifiedLines() []string {
	var result []string
	result = append(result, line.before...)
	for _, raw := range line.raw {
		result = append(result, raw.textnl)
	}
	result = append(result, line.after...)
	return result
}

func (line *LineImpl) Linenos() string {
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

func (line *LineImpl) ReferenceFrom(other Line) string {
	if line.Filename != other.Filename {
		return cleanpath(relpath(path.Dir(other.Filename), line.Filename)) + ":" + line.Linenos()
	}
	return "line " + line.Linenos()
}

func (line *LineImpl) IsMultiline() bool {
	return line.firstLine > 0 && line.firstLine != line.lastLine
}

func (line *LineImpl) printSource(out io.Writer) {
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

func (line *LineImpl) Fatalf(format string, args ...interface{}) {
	line.printSource(G.logErr)
	logs(llFatal, line.Filename, line.Linenos(), format, fmt.Sprintf(format, args...))
}

func (line *LineImpl) Errorf(format string, args ...interface{}) {
	line.printSource(G.logOut)
	logs(llError, line.Filename, line.Linenos(), format, fmt.Sprintf(format, args...))
	line.logAutofix()
}

func (line *LineImpl) Warnf(format string, args ...interface{}) {
	line.printSource(G.logOut)
	logs(llWarn, line.Filename, line.Linenos(), format, fmt.Sprintf(format, args...))
	line.logAutofix()
}

func (line *LineImpl) Notef(format string, args ...interface{}) {
	line.printSource(G.logOut)
	logs(llNote, line.Filename, line.Linenos(), format, fmt.Sprintf(format, args...))
	line.logAutofix()
}

func (line *LineImpl) String() string {
	return line.Filename + ":" + line.Linenos() + ": " + line.Text
}

func (line *LineImpl) logAutofix() {
	if line.autofixMessage != "" {
		logs(llAutofix, line.Filename, line.Linenos(), "%s", line.autofixMessage)
		line.autofixMessage = ""
	}
}

func (line *LineImpl) AutofixInsertBefore(text string) bool {
	if G.opts.PrintAutofix || G.opts.Autofix {
		line.before = append(line.before, text+"\n")
	}
	return line.RememberAutofix("Inserting a line %q before this line.", text)
}

func (line *LineImpl) AutofixInsertAfter(text string) bool {
	if G.opts.PrintAutofix || G.opts.Autofix {
		line.after = append(line.after, text+"\n")
	}
	return line.RememberAutofix("Inserting a line %q after this line.", text)
}

func (line *LineImpl) AutofixDelete() bool {
	if G.opts.PrintAutofix || G.opts.Autofix {
		for _, rawLine := range line.raw {
			rawLine.textnl = ""
		}
	}
	return line.RememberAutofix("Deleting this line.")
}

func (line *LineImpl) AutofixReplace(from, to string) bool {
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

func (line *LineImpl) AutofixReplaceRegexp(from regex.Pattern, to string) bool {
	for _, rawLine := range line.raw {
		if rawLine.Lineno != 0 {
			if replaced := regex.Compile(from).ReplaceAllString(rawLine.textnl, to); replaced != rawLine.textnl {
				if G.opts.PrintAutofix || G.opts.Autofix {
					rawLine.textnl = replaced
				}
				return line.RememberAutofix("Replacing regular expression %q with %q.", from, to)
			}
		}
	}
	return false
}

func (line *LineImpl) RememberAutofix(format string, args ...interface{}) (hasBeenFixed bool) {
	if line.firstLine < 1 {
		return false
	}
	line.Changed = true
	if G.opts.Autofix {
		logs(llAutofix, line.Filename, line.Linenos(), format, fmt.Sprintf(format, args...))
		return true
	}
	if G.opts.PrintAutofix {
		line.autofixMessage = fmt.Sprintf(format, args...)
	}
	return false
}

func (line *LineImpl) AutofixMark(reason string) {
	line.RememberAutofix(reason)
	line.logAutofix()
	line.Changed = true
}
