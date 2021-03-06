package main

import (
	"fmt"
)

//go:generate goyacc -o shellyacc.go -v shellyacc.log -p shyy shell.y

type ShAtomType uint8

const (
	shtSpace    ShAtomType = iota
	shtVaruse              // ${PREFIX}
	shtWord                // while, cat, ENV=value
	shtOperator            // (, ;, |
	shtComment             // # ...
	shtSubshell            // $$(
)

func (t ShAtomType) String() string {
	return [...]string{
		"space",
		"varuse",
		"word",
		"operator",
		"comment",
		"subshell",
	}[t]
}

func (t ShAtomType) IsWord() bool {
	switch t {
	case shtVaruse, shtWord:
		return true
	}
	return false
}

type ShAtom struct {
	Type    ShAtomType
	MkText  string
	Quoting ShQuoting
	Data    interface{}
}

func (atom *ShAtom) String() string {
	if atom.Type == shtWord && atom.Quoting == shqPlain && atom.Data == nil {
		return fmt.Sprintf("%q", atom.MkText)
	}
	if atom.Type == shtVaruse {
		varuse := atom.Data.(*MkVarUse)
		return fmt.Sprintf("varuse(%q)", varuse.varname+varuse.Mod())
	}
	return fmt.Sprintf("ShAtom(%v, %q, %s)", atom.Type, atom.MkText, atom.Quoting)
}

// VarUse returns a read access to a Makefile variable, or nil for plain shell tokens.
func (atom *ShAtom) VarUse() *MkVarUse {
	if atom.Type == shtVaruse {
		return atom.Data.(*MkVarUse)
	}
	return nil
}

// ShQuoting describes the context in which a string appears
// and how it must be unescaped to get its literal value.
type ShQuoting uint8

const (
	shqPlain ShQuoting = iota
	shqDquot
	shqSquot
	shqBackt
	shqSubsh
	shqDquotBackt
	shqBacktDquot
	shqBacktSquot
	shqSubshSquot
	shqDquotBacktDquot
	shqDquotBacktSquot
)

func (q ShQuoting) String() string {
	return [...]string{
		"plain",
		"d", "s", "b", "S",
		"db", "bd", "bs", "Ss",
		"dbd", "dbs",
	}[q]
}

func (q ShQuoting) ToVarUseContext() vucQuoting {
	switch q {
	case shqPlain:
		return vucQuotPlain
	case shqDquot:
		return vucQuotDquot
	case shqSquot:
		return vucQuotSquot
	case shqBackt:
		return vucQuotBackt
	}
	return vucQuotUnknown
}

// See http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_10_02
type ShToken struct {
	MkText string // The text as it appeared in the Makefile, after replacing `\#` with `#`
	Atoms  []*ShAtom
}

func NewShToken(mkText string, atoms ...*ShAtom) *ShToken {
	return &ShToken{mkText, atoms}
}

func (token *ShToken) String() string {
	return fmt.Sprintf("ShToken(%v)", token.Atoms)
}
