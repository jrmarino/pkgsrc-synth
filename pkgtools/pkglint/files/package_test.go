package main

import (
	check "gopkg.in/check.v1"
)

func (s *Suite) Test_Package_pkgnameFromDistname(c *check.C) {
	pkg := NewPackage("dummy")
	pkg.vardef["PKGNAME"] = NewMkLine(NewLine("Makefile", 5, "PKGNAME=dummy", nil))

	c.Check(pkg.pkgnameFromDistname("pkgname-1.0", "whatever"), equals, "pkgname-1.0")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME}", "distname-1.0"), equals, "distname-1.0")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:S/dist/pkg/}", "distname-1.0"), equals, "pkgname-1.0")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:S|a|b|g}", "panama-0.13"), equals, "pbnbmb-0.13")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:S|^lib||}", "libncurses"), equals, "ncurses")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:S|^lib||}", "mylib"), equals, "mylib")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:tl:S/-/./g:S/he/-/1}", "SaxonHE9-5-0-1J"), equals, "saxon-9.5.0.1j")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:C/beta/.0./}", "fspanel-0.8beta1"), equals, "${DISTNAME:C/beta/.0./}")
	c.Check(pkg.pkgnameFromDistname("${DISTNAME:S/-0$/.0/1}", "aspell-af-0.50-0"), equals, "aspell-af-0.50.0")

	c.Check(s.Output(), equals, "")
}

func (s *Suite) Test_Package_ChecklinesPackageMakefileVarorder(c *check.C) {
	s.UseCommandLine(c, "-Worder")
	pkg := NewPackage("x11/9term")

	pkg.ChecklinesPackageMakefileVarorder(s.NewMkLines("Makefile",
		"# $"+"NetBSD$",
		"",
		"DISTNAME=9term",
		"CATEGORIES=x11"))

	c.Check(s.Output(), equals, "")

	pkg.ChecklinesPackageMakefileVarorder(s.NewMkLines("Makefile",
		"# $"+"NetBSD$",
		"",
		"DISTNAME=9term",
		"CATEGORIES=x11",
		"",
		".include \"../../mk/bsd.pkg.mk\""))

	c.Check(s.Output(), equals, ""+
		"WARN: Makefile:6: The canonical position for the required variable COMMENT is here.\n"+
		"WARN: Makefile:6: The canonical position for the required variable LICENSE is here.\n")
}

func (s *Suite) Test_Package_getNbpart(c *check.C) {
	pkg := NewPackage("category/pkgbase")
	pkg.vardef["PKGREVISION"] = NewMkLine(NewLine("Makefile", 1, "PKGREVISION=14", nil))

	c.Check(pkg.getNbpart(), equals, "nb14")

	pkg.vardef["PKGREVISION"] = NewMkLine(NewLine("Makefile", 1, "PKGREVISION=asdf", nil))

	c.Check(pkg.getNbpart(), equals, "")
}

func (s *Suite) Test_Package_determineEffectivePkgVars__precedence(c *check.C) {
	pkg := NewPackage("category/pkgbase")
	pkgnameLine := NewMkLine(NewLine("Makefile", 3, "PKGNAME=pkgname-1.0", nil))
	distnameLine := NewMkLine(NewLine("Makefile", 4, "DISTNAME=distname-1.0", nil))
	pkgrevisionLine := NewMkLine(NewLine("Makefile", 5, "PKGREVISION=13", nil))

	pkg.defineVar(pkgnameLine, pkgnameLine.Varname())
	pkg.defineVar(distnameLine, distnameLine.Varname())
	pkg.defineVar(pkgrevisionLine, pkgrevisionLine.Varname())

	pkg.determineEffectivePkgVars()

	c.Check(pkg.EffectivePkgbase, equals, "pkgname")
	c.Check(pkg.EffectivePkgname, equals, "pkgname-1.0nb13")
	c.Check(pkg.EffectivePkgversion, equals, "1.0")
}

func (s *Suite) Test_Package_checkPossibleDowngrade(c *check.C) {
	G.Pkg = NewPackage("category/pkgbase")
	G.CurPkgsrcdir = "../.."
	G.Pkg.EffectivePkgname = "package-1.0nb15"
	G.Pkg.EffectivePkgnameLine = NewMkLine(NewLine("category/pkgbase/Makefile", 5, "PKGNAME=dummy", nil))
	G.globalData.LastChange = map[string]*Change{
		"category/pkgbase": &Change{
			Action:  "Updated",
			Version: "1.8",
			Line:    NewLine("doc/CHANGES", 116, "dummy", nil),
		},
	}

	G.Pkg.checkPossibleDowngrade()

	c.Check(s.Output(), equals, "WARN: category/pkgbase/Makefile:5: The package is being downgraded from 1.8 (see ../../doc/CHANGES:116) to 1.0nb15\n")

	G.globalData.LastChange["category/pkgbase"].Version = "1.0nb22"

	G.Pkg.checkPossibleDowngrade()

	c.Check(s.Output(), equals, "")
}

func (s *Suite) Test_checkdirPackage(c *check.C) {
	s.CreateTmpFile(c, "Makefile", ""+
		"# $"+"NetBSD$\n")
	G.CurrentDir = s.tmpdir

	checkdirPackage(s.tmpdir)

	c.Check(s.Output(), equals, ""+
		"WARN: ~/Makefile: Neither PLIST nor PLIST.common exist, and PLIST_SRC is unset. Are you sure PLIST handling is ok?\n"+
		"WARN: ~/distinfo: File not found. Please run \"@BMAKE@ makesum\".\n"+
		"ERROR: ~/Makefile: Each package must define its LICENSE.\n"+
		"WARN: ~/Makefile: No COMMENT given.\n")
}

func (s *Suite) Test_checkdirPackage__meta_package_without_license(c *check.C) {
	s.CreateTmpFileLines(c, "Makefile",
		"# $"+"NetBSD$",
		"",
		"META_PACKAGE=\tyes")
	G.CurrentDir = s.tmpdir
	G.globalData.InitVartypes()

	checkdirPackage(s.tmpdir)

	c.Check(s.Output(), equals, "WARN: ~/Makefile: No COMMENT given.\n") // No error about missing LICENSE.
}

func (s *Suite) Test_Package__varuse_at_load_time(c *check.C) {
	s.CreateTmpFileLines(c, "doc/CHANGES-2016",
		"# dummy")
	s.CreateTmpFileLines(c, "doc/TODO",
		"# dummy")
	s.CreateTmpFileLines(c, "licenses/bsd-2",
		"# dummy")
	s.CreateTmpFileLines(c, "mk/fetch/sites.mk",
		"# dummy")
	s.CreateTmpFileLines(c, "mk/bsd.pkg.mk",
		"# dummy")
	s.CreateTmpFileLines(c, "mk/defaults/options.description",
		"option Description")
	s.CreateTmpFileLines(c, "mk/defaults/mk.conf",
		"# dummy")
	s.CreateTmpFileLines(c, "mk/tools/bsd.tools.mk",
		".include \"defaults.mk\"")
	s.CreateTmpFileLines(c, "mk/tools/defaults.mk",
		"TOOLS_CREATE+=false",
		"TOOLS_CREATE+=nice",
		"TOOLS_CREATE+=true",
		"_TOOLS_VARNAME.nice=NICE")
	s.CreateTmpFileLines(c, "mk/bsd.prefs.mk",
		"# dummy")

	s.CreateTmpFileLines(c, "category/pkgbase/Makefile",
		"# $"+"NetBSD$",
		"",
		"COMMENT= Unit test",
		"LICENSE= bsd-2",
		"PLIST_SRC=#none",
		"",
		"USE_TOOLS+= echo false",
		"FALSE_BEFORE!= echo false=${FALSE}",
		"NICE_BEFORE!= echo nice=${NICE}",
		"TRUE_BEFORE!= echo true=${TRUE}",
		"",
		".include \"../../mk/bsd.prefs.mk\"",
		"",
		"USE_TOOLS+= nice",
		"FALSE_AFTER!= echo false=${FALSE}",
		"NICE_AFTER!= echo nice=${NICE}",
		"TRUE_AFTER!= echo true=${TRUE}",
		"",
		"do-build:",
		"\t${ECHO} before: ${FALSE_BEFORE} ${NICE_BEFORE} ${TRUE_BEFORE}",
		"\t${ECHO} after: ${FALSE_AFTER} ${NICE_AFTER} ${TRUE_AFTER}",
		"\t${ECHO}; ${FALSE}; ${NICE}; ${TRUE}",
		"",
		".include \"../../mk/bsd.pkg.mk\"")
	s.CreateTmpFileLines(c, "category/pkgbase/distinfo",
		"$"+"NetBSD$")

	(&Pkglint{}).Main("pkglint", "-q", "-Wperm", s.tmpdir+"/category/pkgbase")

	c.Check(s.Output(), equals, ""+
		"WARN: ~/category/pkgbase/Makefile:8: To use the tool \"FALSE\" at load time, bsd.prefs.mk has to be included before.\n"+
		"WARN: ~/category/pkgbase/Makefile:9: To use the tool \"NICE\" at load time, bsd.prefs.mk has to be included before.\n"+
		"WARN: ~/category/pkgbase/Makefile:10: To use the tool \"TRUE\" at load time, bsd.prefs.mk has to be included before.\n"+
		"WARN: ~/category/pkgbase/Makefile:16: To use the tool \"NICE\" at load time, it has to be added to USE_TOOLS before including bsd.prefs.mk.\n")
}

func (s *Suite) Test_Package_loadPackageMakefile(c *check.C) {
	makefile := s.CreateTmpFile(c, "category/package/Makefile", ""+
		"# $"+"NetBSD$\n"+
		"\n"+
		"PKGNAME=pkgname-1.67\n"+
		"DISTNAME=distfile_1_67\n"+
		".include \"../../category/package/Makefile\"\n")
	pkg := NewPackage("category/package")
	G.CurrentDir = s.tmpdir + "/category/package"
	G.CurPkgsrcdir = "../.."
	G.Pkg = pkg

	pkg.loadPackageMakefile(makefile)

	c.Check(s.Output(), equals, "")
}

func (s *Suite) Test_Package_conditionalAndUnconditionalInclude(c *check.C) {
	G.globalData.InitVartypes()
	s.CreateTmpFileLines(c, "category/package/Makefile",
		mkrcsid,
		"",
		"COMMENT\t=Description",
		"LICENSE\t= gnu-gpl-v2",
		".include \"../../devel/zlib/buildlink3.mk\"",
		".if ${OPSYS} == \"Linux\"",
		".include \"../../sysutils/coreutils/buildlink3.mk\"",
		".endif",
		".include \"../../mk/bsd.pkg.mk\"")
	s.CreateTmpFileLines(c, "category/package/options.mk",
		mkrcsid,
		"",
		".if !empty(PKG_OPTIONS:Mzlib)",
		".  include \"../../devel/zlib/buildlink3.mk\"",
		".endif",
		".include \"../../sysutils/coreutils/buildlink3.mk\"")
	s.CreateTmpFileLines(c, "category/package/PLIST",
		"@comment $"+"NetBSD$",
		"bin/program")
	s.CreateTmpFileLines(c, "category/package/distinfo",
		"$"+"NetBSD$")

	s.CreateTmpFileLines(c, "devel/zlib/buildlink3.mk", "")
	s.CreateTmpFileLines(c, "licenses/gnu-gpl-v2", "")
	s.CreateTmpFileLines(c, "mk/bsd.pkg.mk", "")
	s.CreateTmpFileLines(c, "sysutils/coreutils/buildlink3.mk", "")

	pkg := NewPackage("category/package")
	G.globalData.Pkgsrcdir = s.tmpdir
	G.CurrentDir = s.tmpdir + "/category/package"
	G.CurPkgsrcdir = "../.."
	G.Pkg = pkg

	checkdirPackage("category/package")

	c.Check(s.Output(), equals, ""+
		"WARN: ~/category/package/options.mk:3: Unknown option \"zlib\".\n"+
		"WARN: ~/category/package/options.mk:4: \"../../devel/zlib/buildlink3.mk\" is included conditionally here (depending on PKG_OPTIONS) and unconditionally in Makefile:5.\n"+
		"WARN: ~/category/package/options.mk:6: \"../../sysutils/coreutils/buildlink3.mk\" is included unconditionally here and conditionally in Makefile:7 (depending on OPSYS).\n")
}
