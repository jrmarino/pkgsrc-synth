package main

import (
	"os"
	"path"
	"strings"
)

const (
	rePkgname = `^([\w\-.+]+)-(\d(?:\w|\.\d)*)$`
)

// Returns the pkgsrc top-level directory, relative to the given file or directory.
func findPkgsrcTopdir(fname string) string {
	for _, dir := range []string{".", "..", "../..", "../../.."} {
		if fileExists(fname + "/" + dir + "/mk/bsd.pkg.mk") {
			return dir
		}
	}
	return ""
}

func resolveVariableRefs(text string) string {
	if G.opts.Debug {
		defer tracecall1(text)()
	}

	visited := make(map[string]bool) // To prevent endless loops

	str := text
	for {
		replaced := regcomp(`\$\{([\w.]+)\}`).ReplaceAllStringFunc(str, func(m string) string {
			varname := m[2 : len(m)-1]
			if !visited[varname] {
				visited[varname] = true
				if G.Pkg != nil {
					if value, ok := G.Pkg.varValue(varname); ok {
						return value
					}
				}
				if G.Mk != nil {
					if value, ok := G.Mk.VarValue(varname); ok {
						return value
					}
				}
			}
			return "${" + varname + "}"
		})
		if replaced == str {
			return replaced
		}
		str = replaced
	}
}

func expandVariableWithDefault(varname, defaultValue string) string {
	mkline := G.Pkg.vardef[varname]
	if mkline == nil {
		return defaultValue
	}

	value := mkline.Value()
	value = resolveVarsInRelativePath(value, true)
	if containsVarRef(value) {
		value = resolveVariableRefs(value)
	}
	if G.opts.Debug {
		traceStep2("Expanded %q to %q", varname, value)
	}
	return value
}

func CheckfileExtra(fname string) {
	if G.opts.Debug {
		defer tracecall1(fname)()
	}

	if lines := LoadNonemptyLines(fname, false); lines != nil {
		ChecklinesTrailingEmptyLines(lines)
	}
}

func ChecklinesDescr(lines []*Line) {
	if G.opts.Debug {
		defer tracecall1(lines[0].Fname)()
	}

	for _, line := range lines {
		line.CheckLength(80)
		line.CheckTrailingWhitespace()
		line.CheckValidCharacters(`[\t -~]`)
		if contains(line.Text, "${") {
			line.Notef("Variables are not expanded in the DESCR file.")
		}
	}
	ChecklinesTrailingEmptyLines(lines)

	if maxlines := 24; len(lines) > maxlines {
		line := lines[maxlines]

		line.Warnf("File too long (should be no more than %d lines).", maxlines)
		Explain(
			"The DESCR file should fit on a traditional terminal of 80x25",
			"characters.  It is also intended to give a _brief_ summary about",
			"the package's contents.")
	}

	SaveAutofixChanges(lines)
}

func ChecklinesMessage(lines []*Line) {
	if G.opts.Debug {
		defer tracecall1(lines[0].Fname)()
	}

	explainMessage := func() {
		Explain(
			"A MESSAGE file should consist of a header line, having 75 \"=\"",
			"characters, followed by a line containing only the RCS Id, then an",
			"empty line, your text and finally the footer line, which is the",
			"same as the header line.")
	}

	if len(lines) < 3 {
		lastLine := lines[len(lines)-1]
		lastLine.Warnf("File too short.")
		explainMessage()
		return
	}

	hline := strings.Repeat("=", 75)
	if line := lines[0]; line.Text != hline {
		line.Warnf("Expected a line of exactly 75 \"=\" characters.")
		explainMessage()
	}
	lines[1].CheckRcsid(``, "")
	for _, line := range lines {
		line.CheckLength(80)
		line.CheckTrailingWhitespace()
		line.CheckValidCharacters(`[\t -~]`)
	}
	if lastLine := lines[len(lines)-1]; lastLine.Text != hline {
		lastLine.Warnf("Expected a line of exactly 75 \"=\" characters.")
		explainMessage()
	}
	ChecklinesTrailingEmptyLines(lines)
}

func CheckfileMk(fname string) {
	if G.opts.Debug {
		defer tracecall1(fname)()
	}

	lines := LoadNonemptyLines(fname, true)
	if lines == nil {
		return
	}

	NewMkLines(lines).Check()
	SaveAutofixChanges(lines)
}

func Checkfile(fname string) {
	if G.opts.Debug {
		defer tracecall1(fname)()
	}

	basename := path.Base(fname)
	if hasPrefix(basename, "work") || hasSuffix(basename, "~") || hasSuffix(basename, ".orig") || hasSuffix(basename, ".rej") {
		if G.opts.Import {
			NewLineWhole(fname).Errorf("Must be cleaned up before committing the package.")
		}
		return
	}

	st, err := os.Lstat(fname)
	if err != nil {
		NewLineWhole(fname).Errorf("%s", err)
		return
	}

	if st.Mode().IsRegular() && st.Mode().Perm()&0111 != 0 && !isCommitted(fname) {
		line := NewLine(fname, 0, "", nil)
		line.Warnf("Should not be executable.")
		Explain(
			"No package file should ever be executable.  Even the INSTALL and",
			"DEINSTALL scripts are usually not usable in the form they have in",
			"the package, as the pathnames get adjusted during installation.",
			"So there is no need to have any file executable.")
	}

	switch {
	case st.Mode().IsDir():
		switch {
		case basename == "files" || basename == "patches" || basename == "CVS":
			// Ok
		case matches(fname, `(?:^|/)files/[^/]*$`):
			// Ok
		case !isEmptyDir(fname):
			NewLineWhole(fname).Warnf("Unknown directory name.")
		}

	case st.Mode()&os.ModeSymlink != 0:
		if !hasPrefix(basename, "work") {
			NewLineWhole(fname).Warnf("Unknown symlink name.")
		}

	case !st.Mode().IsRegular():
		NewLineWhole(fname).Errorf("Only files and directories are allowed in pkgsrc.")

	case basename == "ALTERNATIVES":
		if G.opts.CheckAlternatives {
			CheckfileExtra(fname)
		}

	case basename == "buildlink3.mk":
		if G.opts.CheckBuildlink3 {
			if lines := LoadNonemptyLines(fname, true); lines != nil {
				ChecklinesBuildlink3Mk(NewMkLines(lines))
			}
		}

	case hasPrefix(basename, "DESCR"):
		if G.opts.CheckDescr {
			if lines := LoadNonemptyLines(fname, false); lines != nil {
				ChecklinesDescr(lines)
			}
		}

	case basename == "distinfo":
		if G.opts.CheckDistinfo {
			if lines := LoadNonemptyLines(fname, false); lines != nil {
				ChecklinesDistinfo(lines)
			}
		}

	case basename == "DEINSTALL" || basename == "INSTALL":
		if G.opts.CheckInstall {
			CheckfileExtra(fname)
		}

	case hasPrefix(basename, "MESSAGE"):
		if G.opts.CheckMessage {
			if lines := LoadNonemptyLines(fname, false); lines != nil {
				ChecklinesMessage(lines)
			}
		}

	case matches(basename, `^patch-[-A-Za-z0-9_.~+]*[A-Za-z0-9_]$`):
		if G.opts.CheckPatches {
			if lines := LoadNonemptyLines(fname, false); lines != nil {
				ChecklinesPatch(lines)
			}
		}

	case matches(fname, `(?:^|/)patches/manual[^/]*$`):
		if G.opts.Debug {
			traceStep1("Unchecked file %q.", fname)
		}

	case matches(fname, `(?:^|/)patches/[^/]*$`):
		NewLineWhole(fname).Warnf("Patch files should be named \"patch-\", followed by letters, '-', '_', '.', and digits only.")

	case matches(basename, `^(?:.*\.mk|Makefile.*)$`) && !matches(fname, `files/`) && !matches(fname, `patches/`):
		if G.opts.CheckMk {
			CheckfileMk(fname)
		}

	case hasPrefix(basename, "PLIST"):
		if G.opts.CheckPlist {
			if lines := LoadNonemptyLines(fname, false); lines != nil {
				ChecklinesPlist(lines)
			}
		}

	case basename == "TODO" || basename == "README":
		// Ok

	case hasPrefix(basename, "CHANGES-"):
		// This only checks the file, but doesn’t register the changes globally.
		G.globalData.loadDocChangesFromFile(fname)

	case matches(fname, `(?:^|/)files/[^/]*$`):
		// Skip

	case basename == "spec":
		// Ok in regression tests

	default:
		NewLineWhole(fname).Warnf("Unexpected file found.")
		if G.opts.CheckExtra {
			CheckfileExtra(fname)
		}
	}
}

func ChecklinesTrailingEmptyLines(lines []*Line) {
	max := len(lines)
	last := max
	for last > 1 && lines[last-1].Text == "" {
		last--
	}
	if last != max {
		lines[last].Notef("Trailing empty lines.")
	}
}

func MatchVarassign(text string) (m bool, varname, spaceAfterVarname, op, valueAlign, value, spaceAfterValue, comment string) {
	i, n := 0, len(text)

	for i < n && text[i] == ' ' {
		i++
	}

	varnameStart := i
	for ; i < n; i++ {
		b := text[i]
		switch {
		case 'A' <= b && b <= 'Z',
			'a' <= b && b <= 'z',
			b == '_',
			'0' <= b && b <= '9',
			'$' <= b && b <= '.' && (b == '$' || b == '*' || b == '+' || b == '-' || b == '.'),
			b == '[',
			b == '{', b == '}':
			continue
		}
		break
	}
	varnameEnd := i

	if varnameEnd == varnameStart {
		return
	}

	for i < n && (text[i] == ' ' || text[i] == '\t') {
		i++
	}

	opStart := i
	if i < n {
		if b := text[i]; b == '!' || b == '+' || b == ':' || b == '?' {
			i++
		}
	}
	if i < n && text[i] == '=' {
		i++
	} else {
		return
	}
	opEnd := i

	if text[varnameEnd-1] == '+' && varnameEnd == opStart && text[opStart] == '=' {
		varnameEnd--
		opStart--
	}

	for i < n && (text[i] == ' ' || text[i] == '\t') {
		i++
	}

	valueStart := i
	valuebuf := make([]byte, n-valueStart)
	j := 0
	for ; i < n; i++ {
		b := text[i]
		if b == '#' && (i == valueStart || text[i-1] != '\\') {
			break
		} else if b != '\\' || i+1 >= n || text[i+1] != '#' {
			valuebuf[j] = b
			j++
		}
	}

	commentStart := i
	for text[i-1] == ' ' || text[i-1] == '\t' {
		i--
	}
	valueEnd := i

	commentEnd := n

	m = true
	varname = text[varnameStart:varnameEnd]
	spaceAfterVarname = text[varnameEnd:opStart]
	op = text[opStart:opEnd]
	valueAlign = text[0:valueStart]
	value = strings.TrimSpace(string(valuebuf[:j]))
	spaceAfterValue = text[valueEnd:commentStart]
	comment = text[commentStart:commentEnd]
	return
}

type DependencyPattern struct {
	pkgbase  string // "freeciv-client", "{gcc48,gcc48-libs}", "${EMACS_REQD}"
	lowerOp  string // ">=", ">"
	lower    string // "2.5.0", "${PYVER}"
	upperOp  string // "<", "<="
	upper    string // "3.0", "${PYVER}"
	wildcard string // "[0-9]*", "1.5.*", "${PYVER}"
}

func resolveVarsInRelativePath(relpath string, adjustDepth bool) string {
	tmp := relpath
	tmp = strings.Replace(tmp, "${PKGSRCDIR}", G.CurPkgsrcdir, -1)
	tmp = strings.Replace(tmp, "${.CURDIR}", ".", -1)
	tmp = strings.Replace(tmp, "${.PARSEDIR}", ".", -1)
	if contains(tmp, "${LUA_PKGSRCDIR}") {
		tmp = strings.Replace(tmp, "${LUA_PKGSRCDIR}", G.globalData.Latest("lang", `^lua[0-9]+$`, "../../lang/$0"), -1)
	}
	if contains(tmp, "${PHPPKGSRCDIR}") {
		tmp = strings.Replace(tmp, "${PHPPKGSRCDIR}", G.globalData.Latest("lang", `^php[0-9]+$`, "../../lang/$0"), -1)
	}
	if contains(tmp, "${SUSE_DIR_PREFIX}") {
		suseDirPrefix := G.globalData.Latest("emulators", `^(suse[0-9]+)_base`, "$1")
		tmp = strings.Replace(tmp, "${SUSE_DIR_PREFIX}", suseDirPrefix, -1)
	}
	if contains(tmp, "${PYPKGSRCDIR}") {
		tmp = strings.Replace(tmp, "${PYPKGSRCDIR}", G.globalData.Latest("lang", `^python[0-9]+$`, "../../lang/$0"), -1)
	}
	if contains(tmp, "${PYPACKAGE}") {
		tmp = strings.Replace(tmp, "${PYPACKAGE}", G.globalData.Latest("lang", `^python[0-9]+$`, "$0"), -1)
	}
	if G.Pkg != nil {
		tmp = strings.Replace(tmp, "${FILESDIR}", G.Pkg.Filesdir, -1)
		tmp = strings.Replace(tmp, "${PKGDIR}", G.Pkg.Pkgdir, -1)
	}

	if adjustDepth {
		if m, pkgpath := match1(tmp, `^\.\./\.\./([^.].*)$`); m {
			tmp = G.CurPkgsrcdir + "/" + pkgpath
		}
	}

	if G.opts.Debug {
		traceStep2("resolveVarsInRelativePath: %q => %q", relpath, tmp)
	}
	return tmp
}
