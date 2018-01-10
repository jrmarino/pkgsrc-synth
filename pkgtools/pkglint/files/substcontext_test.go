package main

import (
	"fmt"
	"gopkg.in/check.v1"
)

func (s *Suite) Test_SubstContext__incomplete(c *check.C) {
	s.Init(c)
	G.opts.WarnExtra = true
	ctx := NewSubstContext()

	ctx.Varassign(newSubstLine(10, "PKGNAME=pkgname-1.0"))

	c.Check(ctx.id, equals, "")

	ctx.Varassign(newSubstLine(11, "SUBST_CLASSES+=interp"))

	c.Check(ctx.id, equals, "interp")

	ctx.Varassign(newSubstLine(12, "SUBST_FILES.interp=Makefile"))

	c.Check(ctx.IsComplete(), equals, false)

	ctx.Varassign(newSubstLine(13, "SUBST_SED.interp=s,@PREFIX@,${PREFIX},g"))

	c.Check(ctx.IsComplete(), equals, false)

	ctx.Finish(newSubstLine(14, ""))

	s.CheckOutputLines(
		"WARN: Makefile:14: Incomplete SUBST block: SUBST_STAGE.interp missing.")
}

func (s *Suite) Test_SubstContext__complete(c *check.C) {
	s.Init(c)
	G.opts.WarnExtra = true
	ctx := NewSubstContext()

	ctx.Varassign(newSubstLine(10, "PKGNAME=pkgname-1.0"))
	ctx.Varassign(newSubstLine(11, "SUBST_CLASSES+=p"))
	ctx.Varassign(newSubstLine(12, "SUBST_FILES.p=Makefile"))
	ctx.Varassign(newSubstLine(13, "SUBST_SED.p=s,@PREFIX@,${PREFIX},g"))

	c.Check(ctx.IsComplete(), equals, false)

	ctx.Varassign(newSubstLine(14, "SUBST_STAGE.p=post-configure"))

	c.Check(ctx.IsComplete(), equals, true)

	ctx.Finish(newSubstLine(15, ""))

	s.CheckOutputEmpty()
}

func (s *Suite) Test_SubstContext__OPSYSVARS(c *check.C) {
	s.Init(c)
	G.opts.WarnExtra = true
	ctx := NewSubstContext()

	ctx.Varassign(newSubstLine(11, "SUBST_CLASSES.SunOS+=prefix"))
	ctx.Varassign(newSubstLine(12, "SUBST_CLASSES.NetBSD+=prefix"))
	ctx.Varassign(newSubstLine(13, "SUBST_FILES.prefix=Makefile"))
	ctx.Varassign(newSubstLine(14, "SUBST_SED.prefix=s,@PREFIX@,${PREFIX},g"))
	ctx.Varassign(newSubstLine(15, "SUBST_STAGE.prefix=post-configure"))

	c.Check(ctx.IsComplete(), equals, true)

	ctx.Finish(newSubstLine(15, ""))

	s.CheckOutputEmpty()
}

func (s *Suite) Test_SubstContext__no_class(c *check.C) {
	s.Init(c)
	s.UseCommandLine("-Wextra")
	ctx := NewSubstContext()

	ctx.Varassign(newSubstLine(10, "UNRELATED=anything"))
	ctx.Varassign(newSubstLine(11, "SUBST_FILES.repl+=Makefile.in"))
	ctx.Varassign(newSubstLine(12, "SUBST_SED.repl+=-e s,from,to,g"))
	ctx.Finish(newSubstLine(13, ""))

	s.CheckOutputLines(
		"WARN: Makefile:11: SUBST_CLASSES should come before the definition of \"SUBST_FILES.repl\".",
		"WARN: Makefile:13: Incomplete SUBST block: SUBST_STAGE.repl missing.")
}

func (s *Suite) Test_SubstContext__conditionals(c *check.C) {
	s.Init(c)
	s.UseCommandLine("-Wextra")

	simulateSubstLines(
		"10: SUBST_CLASSES+=         os",
		"11: SUBST_STAGE.os=         post-configure",
		"12: SUBST_MESSAGE.os=       Guessing operating system",
		"13: SUBST_FILES.os=         guess-os.h",
		"14: .if ${OPSYS} == NetBSD",
		"15: SUBST_FILTER_CMD.os=    ${SED} -e s,@OPSYS@,NetBSD,",
		"16: .elif ${OPSYS} == Darwin",
		"17: SUBST_SED.os=           -e s,@OPSYS@,Darwin1,",
		"18: SUBST_SED.os=           -e s,@OPSYS@,Darwin2,",
		"19: .elif ${OPSYS} == Linux",
		"18: SUBST_SED.os=           -e s,@OPSYS@,Linux,",
		"19: .else",
		"20: SUBST_VARS.os=           OPSYS",
		"21: .endif",
		"22: ")

	// All the other lines are correctly determined as being alternatives
	// to each other. And since every branch contains some transformation
	// (SED, VARS, FILTER_CMD), everything is fine.
	s.CheckOutputLines(
		"WARN: Makefile:18: All but the first \"SUBST_SED.os\" lines should use the \"+=\" operator.")
}

func (s *Suite) Test_SubstContext__one_conditional_missing_transformation(c *check.C) {
	s.Init(c)
	s.UseCommandLine("-Wextra")

	simulateSubstLines(
		"10: SUBST_CLASSES+=         os",
		"11: SUBST_STAGE.os=         post-configure",
		"12: SUBST_MESSAGE.os=       Guessing operating system",
		"13: SUBST_FILES.os=         guess-os.h",
		"14: .if ${OPSYS} == NetBSD",
		"15: SUBST_FILES.os=         -e s,@OpSYS@,NetBSD,", // A simple typo, this should be SUBST_SED.
		"16: .elif ${OPSYS} == Darwin",
		"17: SUBST_SED.os=           -e s,@OPSYS@,Darwin1,",
		"18: SUBST_SED.os=           -e s,@OPSYS@,Darwin2,",
		"19: .else",
		"20: SUBST_VARS.os=           OPSYS",
		"21: .endif",
		"22: ")

	s.CheckOutputLines(
		"WARN: Makefile:15: All but the first \"SUBST_FILES.os\" lines should use the \"+=\" operator.",
		"WARN: Makefile:18: All but the first \"SUBST_SED.os\" lines should use the \"+=\" operator.",
		"WARN: Makefile:22: Incomplete SUBST block: SUBST_SED.os, SUBST_VARS.os or SUBST_FILTER_CMD.os missing.")
}

func (s *Suite) Test_SubstContext__nested_conditionals(c *check.C) {
	s.Init(c)
	s.UseCommandLine("-Wextra")

	simulateSubstLines(
		"10: SUBST_CLASSES+=         os",
		"11: SUBST_STAGE.os=         post-configure",
		"12: SUBST_MESSAGE.os=       Guessing operating system",
		"14: .if ${OPSYS} == NetBSD",
		"13: SUBST_FILES.os=         guess-netbsd.h",
		"15: .  if ${ARCH} == i386",
		"16: SUBST_FILTER_CMD.os=    ${SED} -e s,@OPSYS,NetBSD-i386,",
		"17: .  elif ${ARCH} == x86_64",
		"18: SUBST_VARS.os=          OPSYS",
		"19: .  else",
		"20: SUBST_SED.os=           -e s,@OPSYS,NetBSD-unknown",
		"21: .  endif",
		"22: .else",
		"23: SUBST_SED.os=           -e s,@OPSYS@,unknown,",
		"24: .endif",
		"25: ")

	// The branch in line 23 omits SUBST_FILES.
	s.CheckOutputLines(
		"WARN: Makefile:25: Incomplete SUBST block: SUBST_FILES.os missing.")
}

func simulateSubstLines(texts ...string) {
	ctx := NewSubstContext()
	for _, lineText := range texts {
		var lineno int
		fmt.Sscanf(lineText[0:4], "%d: ", &lineno)
		text := lineText[4:]
		line := newSubstLine(lineno, text)

		switch {
		case text == "":
			ctx.Finish(line)
		case hasPrefix(text, "."):
			ctx.Conditional(line)
		default:
			ctx.Varassign(line)
		}
	}
}

func newSubstLine(lineno int, text string) MkLine {
	return NewMkLine(NewLine("Makefile", lineno, text, nil))
}
