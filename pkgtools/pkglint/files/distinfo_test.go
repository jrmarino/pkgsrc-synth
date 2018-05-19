package main

import "gopkg.in/check.v1"

func (s *Suite) Test_ChecklinesDistinfo(c *check.C) {
	t := s.Init(c)

	t.SetupFileLines("patches/patch-aa",
		"$"+"NetBSD$ line is ignored",
		"patch contents")
	t.SetupFileLines("patches/patch-ab",
		"patch contents")
	G.CurrentDir = t.TmpDir()

	ChecklinesDistinfo(t.NewLines("distinfo",
		"should be the RCS ID",
		"should be empty",
		"MD5 (distfile.tar.gz) = 12345678901234567890123456789012",
		"SHA1 (distfile.tar.gz) = 1234567890123456789012345678901234567890",
		"SHA1 (patch-aa) = 6b98dd609f85a9eb9c4c1e4e7055a6aaa62b7cc7",
		"SHA1 (patch-ab) = 6b98dd609f85a9eb9c4c1e4e7055a6aaa62b7cc7",
		"SHA1 (patch-nonexistent) = 1234"))

	t.CheckOutputLines(
		"ERROR: distinfo:1: Expected \"$"+"NetBSD$\".",
		"NOTE: distinfo:2: Empty line expected.",
		"ERROR: distinfo:5: Expected SHA1, RMD160, SHA512, Size checksums for \"distfile.tar.gz\", got MD5, SHA1.",
		"WARN: distinfo:7: Patch file \"patch-nonexistent\" does not exist in directory \"patches\".")
}

func (s *Suite) Test_ChecklinesDistinfo_global_hash_mismatch(c *check.C) {
	t := s.Init(c)

	otherLine := t.NewLine("other/distinfo", 7, "dummy")
	G.Pkgsrc.Hashes = map[string]*Hash{"SHA512:pkgname-1.0.tar.gz": {"Some-512-bit-hash", otherLine}}
	lines := t.NewLines("distinfo",
		RcsID,
		"",
		"SHA512 (pkgname-1.0.tar.gz) = 12341234")

	ChecklinesDistinfo(lines)

	t.CheckOutputLines(
		"ERROR: distinfo:3: The hash SHA512 for pkgname-1.0.tar.gz is 12341234, which differs from Some-512-bit-hash in other/distinfo:7.",
		"ERROR: distinfo:EOF: Expected SHA1, RMD160, SHA512, Size checksums for \"pkgname-1.0.tar.gz\", got SHA512.")
}

func (s *Suite) Test_ChecklinesDistinfo_uncommitted_patch(c *check.C) {
	t := s.Init(c)

	t.SetupFileLines("patches/patch-aa",
		RcsID,
		"",
		"--- oldfile",
		"+++ newfile",
		"@@ -1,1 +1,1 @@",
		"-old",
		"+new")
	t.SetupFileLines("CVS/Entries",
		"/distinfo/...")
	lines := t.SetupFileLines("distinfo",
		RcsID,
		"",
		"SHA1 (patch-aa) = 5ad1fb9b3c328fff5caa1a23e8f330e707dd50c0")
	G.CurrentDir = t.TmpDir()

	ChecklinesDistinfo(lines)

	t.CheckOutputLines(
		"WARN: ~/distinfo:3: patches/patch-aa is registered in distinfo but not added to CVS.")
}

func (s *Suite) Test_ChecklinesDistinfo_unrecorded_patches(c *check.C) {
	t := s.Init(c)

	t.SetupFileLines("patches/CVS/Entries")
	t.SetupFileLines("patches/patch-aa")
	t.SetupFileLines("patches/patch-src-Makefile")
	lines := t.SetupFileLines("distinfo",
		RcsID,
		"",
		"SHA1 (distfile.tar.gz) = ...",
		"RMD160 (distfile.tar.gz) = ...",
		"SHA512 (distfile.tar.gz) = ...",
		"Size (distfile.tar.gz) = 1024 bytes")
	G.CurrentDir = t.TmpDir()

	ChecklinesDistinfo(lines)

	t.CheckOutputLines(
		"ERROR: ~/distinfo: patch \"patches/patch-aa\" is not recorded. Run \""+confMake+" makepatchsum\".",
		"ERROR: ~/distinfo: patch \"patches/patch-src-Makefile\" is not recorded. Run \""+confMake+" makepatchsum\".")
}

func (s *Suite) Test_ChecklinesDistinfo_manual_patches(c *check.C) {
	t := s.Init(c)

	t.SetupFileLines("patches/manual-libtool.m4")
	lines := t.SetupFileLines("distinfo",
		RcsID,
		"",
		"SHA1 (patch-aa) = ...")
	G.CurrentDir = t.TmpDir()

	ChecklinesDistinfo(lines)

	t.CheckOutputLines(
		"WARN: ~/distinfo:3: Patch file \"patch-aa\" does not exist in directory \"patches\".")
}
