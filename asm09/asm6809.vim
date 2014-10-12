" Vim syntax file
" Language:	Motorola 6809 Assembler
" Maintainer:	David Roper <ebonhand09@gmail.com>
"
" This was originally based on asm68k.vim by Steve Wall
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" Partial list of register symbols
syn keyword asm6809Reg 	a b d x y s u pc dp cc

" M68000 opcodes - order is important!
syn match asm6809Opcode "\<ABX"
syn match asm6809Opcode "\<ADCA\s"
syn match asm6809Opcode "\<ADCB\s"
syn match asm6809Opcode "\<ADDA\s"
syn match asm6809Opcode "\<ADDB\s"
syn match asm6809Opcode "\<ADDD\s"
syn match asm6809Opcode "\<ANDA\s"
syn match asm6809Opcode "\<ANDB\s"
syn match asm6809Opcode "\<ANDCC\s"
syn match asm6809Opcode "\<ASL\s"
syn match asm6809Opcode "\<ASLA"
syn match asm6809Opcode "\<ASLB"
syn match asm6809Opcode "\<ASRA"
syn match asm6809Opcode "\<ASRB"
syn match asm6809Opcode "\<ASR\s"
syn match asm6809Opcode "\<BCC\s"
syn match asm6809Opcode "\<BCS\s"
syn match asm6809Opcode "\<BEQ\s"
syn match asm6809Opcode "\<BGE\s"
syn match asm6809Opcode "\<BGT\s"
syn match asm6809Opcode "\<BHI\s"
syn match asm6809Opcode "\<BHS\s"
syn match asm6809Opcode "\<BITA\s"
syn match asm6809Opcode "\<BITB\s"
syn match asm6809Opcode "\<BLE\s"
syn match asm6809Opcode "\<BLO\s"
syn match asm6809Opcode "\<BLS\s"
syn match asm6809Opcode "\<BLT\s"
syn match asm6809Opcode "\<BMI\s"
syn match asm6809Opcode "\<BNE\s"
syn match asm6809Opcode "\<BPL\s"
syn match asm6809Opcode "\<BRA\s"
syn match asm6809Opcode "\<BRN\s"
syn match asm6809Opcode "\<BSR\s"
syn match asm6809Opcode "\<BVC\s"
syn match asm6809Opcode "\<BVS\s"
syn match asm6809Opcode "\<CLR\s"
syn match asm6809Opcode "\<CLRA"
syn match asm6809Opcode "\<CLRB"
syn match asm6809Opcode "\<CMP\s"
syn match asm6809Opcode "\<CMPA\s"
syn match asm6809Opcode "\<CMPB\s"
syn match asm6809Opcode "\<CMPD\s"
syn match asm6809Opcode "\<CMPS\s"
syn match asm6809Opcode "\<CMPU\s"
syn match asm6809Opcode "\<CMPX\s"
syn match asm6809Opcode "\<CMPY\s"
syn match asm6809Opcode "\<COMA\s"
syn match asm6809Opcode "\<COMB\s"
syn match asm6809Opcode "\<COM\s"
syn match asm6809Opcode "\<CWAI"
syn match asm6809Opcode "\<DAA"
syn match asm6809Opcode "\<DEC\s"
syn match asm6809Opcode "\<DECA"
syn match asm6809Opcode "\<DECB"
syn match asm6809Opcode "\<EORA\s"
syn match asm6809Opcode "\<EORB\s"
syn match asm6809Opcode "\<EXG\s"
syn match asm6809Opcode "\<INC\s"
syn match asm6809Opcode "\<INCA"
syn match asm6809Opcode "\<INCB"
syn match asm6809Opcode "\<JMP\s"
syn match asm6809Opcode "\<JSR\s"
syn match asm6809Opcode "\<LBCC\s"
syn match asm6809Opcode "\<LBCS\s"
syn match asm6809Opcode "\<LBEQ\s"
syn match asm6809Opcode "\<LBGE\s"
syn match asm6809Opcode "\<LBGT\s"
syn match asm6809Opcode "\<LBHI\s"
syn match asm6809Opcode "\<LBHS\s"
syn match asm6809Opcode "\<LBLE\s"
syn match asm6809Opcode "\<LBLO\s"
syn match asm6809Opcode "\<LBLS\s"
syn match asm6809Opcode "\<LBLT\s"
syn match asm6809Opcode "\<LBMI\s"
syn match asm6809Opcode "\<LBNE\s"
syn match asm6809Opcode "\<LBPL\s"
syn match asm6809Opcode "\<LBRA\s"
syn match asm6809Opcode "\<LBRN\s"
syn match asm6809Opcode "\<LBSR\s"
syn match asm6809Opcode "\<LBVC\s"
syn match asm6809Opcode "\<LBVS\s"
syn match asm6809Opcode "\<LDA\s"
syn match asm6809Opcode "\<LDB\s"
syn match asm6809Opcode "\<LDD\s"
syn match asm6809Opcode "\<LDS\s"
syn match asm6809Opcode "\<LDU\s"
syn match asm6809Opcode "\<LDX\s"
syn match asm6809Opcode "\<LDY\s"
syn match asm6809Opcode "\<LEAS\s"
syn match asm6809Opcode "\<LEAU\s"
syn match asm6809Opcode "\<LEAX\s"
syn match asm6809Opcode "\<LEAY\s"
syn match asm6809Opcode "\<LSLA"
syn match asm6809Opcode "\<LSLB"
syn match asm6809Opcode "\<LSL\s"
syn match asm6809Opcode "\<LSR\s"
syn match asm6809Opcode "\<LSRA"
syn match asm6809Opcode "\<LSRB"
syn match asm6809Opcode "\<MUL"
syn match asm6809Opcode "\<NEGA"
syn match asm6809Opcode "\<NEGB"
syn match asm6809Opcode "\<NEG\s"
syn match asm6809Opcode "\<NOP"
syn match asm6809Opcode "\<ORA\s"
syn match asm6809Opcode "\<ORB\s"
syn match asm6809Opcode "\<ORCC\s"
syn match asm6809Opcode "\<PSHS\s"
syn match asm6809Opcode "\<PSHU\s"
syn match asm6809Opcode "\<PULS\s"
syn match asm6809Opcode "\<PULU\s"
syn match asm6809Opcode "\<ROLA"
syn match asm6809Opcode "\<ROLB"
syn match asm6809Opcode "\<ROL\s"
syn match asm6809Opcode "\<RORA"
syn match asm6809Opcode "\<RORB"
syn match asm6809Opcode "\<ROR\s"
syn match asm6809Opcode "\<RTI"
syn match asm6809Opcode "\<RTS"
syn match asm6809Opcode "\<SBCA\s"
syn match asm6809Opcode "\<SBCB\s"
syn match asm6809Opcode "\<SEX"
syn match asm6809Opcode "\<STA\s"
syn match asm6809Opcode "\<STB\s"
syn match asm6809Opcode "\<STD\s"
syn match asm6809Opcode "\<STS\s"
syn match asm6809Opcode "\<STU\s"
syn match asm6809Opcode "\<STX\s"
syn match asm6809Opcode "\<STY\s"
syn match asm6809Opcode "\<SUBA\s"
syn match asm6809Opcode "\<SUBB\s"
syn match asm6809Opcode "\<SUBD\s"
syn match asm6809Opcode "\<SWI"
syn match asm6809Opcode "\<SWI2"
syn match asm6809Opcode "\<SWI3"
syn match asm6809Opcode "\<SYNC"
syn match asm6809Opcode "\<TFR\s"
syn match asm6809Opcode "\<TSTA"
syn match asm6809Opcode "\<TSTB"
syn match asm6809Opcode "\<TST\s"


" Valid labels
syn match asm6809Label		"^[a-z_?.\@][a-z0-9_?.$\@]*$"
syn match asm6809Label		"^[a-z_?.\@][a-z0-9_?.$\@]*\s"he=e-1

" Various number formats
syn match hexNumber		"\$[0-9a-fA-F]\+\>"
syn match hexNumber		"\<[0-9][0-9a-fA-F]*H\>"
syn match octNumber		"@[0-7]\+\>"
syn match octNumber		"\<[0-7]\+[QO]\>"
syn match binNumber		"%[01]\+\>"
syn match binNumber		"\<[01]\+B\>"
syn match decNumber		"\<[0-9]\+D\=\>"

" Character string constants
syn match asm6809StringError	"'[ -~]*'"
syn match asm6809StringError	"'[ -~]*$"
syn region asm6809String	start="'" skip="''" end="'" oneline contains=asm6809CharError
syn match asm6809CharError	"[^ -~]" contained

" Immediate data
syn match asm6809Immediate	"#\$[0-9a-fA-F]\+" contains=hexNumber
syn match asm6809Immediate	"#[0-9][0-9a-fA-F]*H" contains=hexNumber
syn match asm6809Immediate	"#@[0-7]\+" contains=octNumber
syn match asm6809Immediate	"#[0-7]\+[QO]" contains=octNumber
syn match asm6809Immediate	"#%[01]\+" contains=binNumber
syn match asm6809Immediate	"#[01]\+B" contains=binNumber
syn match asm6809Immediate	"#[0-9]\+D\=" contains=decNumber
syn match asm6809Symbol		"[a-z_?.][a-z0-9_?.$]*" contained
syn match asm6809Immediate	"#[a-z_?.][a-z0-9_?.$]*" contains=asm6809Symbol

" Special items for comments
syn keyword asm6809Todo		contained TODO

" Operators
syn match asm6809Operator	"[-+*/]"	" Must occur before Comments
syn match asm6809Operator	"SIZEOF"
syn match asm6809Operator	"<"		" shift left
syn match asm6809Operator	">"		" shift right
syn match asm6809Operator	"&"		" bit-wise logical and
syn match asm6809Operator	"!"		" bit-wise logical or
syn match asm6809Operator	"!!"		" exclusive or
syn match asm6809Operator	"<>"		" inequality
syn match asm6809Operator	"|"		" bit-wise logical or
syn match asm6809Operator	"="		" must be before other ops containing '='
syn match asm6809Operator	">="
syn match asm6809Operator	"<="
syn match asm6809Operator	"=="		" operand existance - used in macro definitions

" Comments
syn match asm6809Comment	";.*" contains=asm6809Todo
"syn match asm6809Comment	"\s!.*"ms=s+1 contains=asm6809Todo
"syn match asm6809Comment	"^\s*[*!].*" contains=asm6809Todo
syn match asm6809Comment	"\*.*$"

" Include
syn match asm6809Include	"\<INCLUDE\s"
syn match asm6809Include	"\<INCLUDEBIN\s"

" Standard macros
syn match asm6809Cond		"\<IF\(\.[BWL]\)\=\s"
syn match asm6809Cond		"\<THEN\(\.[SL]\)\=\>"
syn match asm6809Cond		"\<ELSE\(\.[SL]\)\=\>"
syn match asm6809Cond		"\<ENDI\>"
syn match asm6809Cond		"\<BREAK\(\.[SL]\)\=\>"

" Macro definition
syn match asm6809Macro		"\<MACRO\>"
syn match asm6809Macro		"\<LOCAL\s"
syn match asm6809Macro		"\<MEXIT\>"
syn match asm6809Macro		"\<ENDM\>"
syn match asm6809MacroParam	"\\[0-9]"

" Conditional assembly
syn match asm6809PreCond	"\<IFC\s"
syn match asm6809PreCond	"\<IFDEF\s"
syn match asm6809PreCond	"\<IFEQ\s"
syn match asm6809PreCond	"\<IFGE\s"
syn match asm6809PreCond	"\<IFGT\s"
syn match asm6809PreCond	"\<IFLE\s"
syn match asm6809PreCond	"\<IFLT\s"
syn match asm6809PreCond	"\<IFNC\>"
syn match asm6809PreCond	"\<IFNDEF\s"
syn match asm6809PreCond	"\<IFNE\s"
syn match asm6809PreCond	"\<ELSEC\>"
syn match asm6809PreCond	"\<ENDC\>"

" Loop control
syn match asm6809PreCond	"\<REPT\s"
syn match asm6809PreCond	"\<IRP\s"
syn match asm6809PreCond	"\<IRPC\s"
syn match asm6809PreCond	"\<ENDR\>"

" Directives (some styled like Macro for visual impact)
syn match asm6809Macro		"\<ALIGN\s"
syn match asm6809Macro		"\<CHIP\s"
syn match asm6809Macro		"\<COMLINE\s"
syn match asm6809Macro		"\<COMMON\(\.S\)\=\s"
syn match asm6809Macro		"\<DC\(\.[BWLSDXP]\)\=\s"
syn match asm6809Macro		"\<DC\.\\[0-9]\s"me=e-3	" Special use in a macro def
syn match asm6809Macro		"\<DCB\(\.[BWLSDXP]\)\=\s"
syn match asm6809Macro		"\<DS\(\.[BWLSDXP]\)\=\s"
syn match asm6809Macro		"\<END\>"
syn match asm6809Macro		"\<ENDSECTION\>"
syn match asm6809Macro		"\<ENDSTRUCT\>"
syn match asm6809Macro		"\<EQU\s"
syn match asm6809Macro		"\<FEQU\(\.[SDXP]\)\=\s"
syn match asm6809Macro		"\<FAIL\>"
syn match asm6809Macro		"\<FOPT\s"
syn match asm6809Macro		"\<\(NO\)\=FORMAT\>"
syn match asm6809Macro		"\<IDNT\>"
syn match asm6809Macro		"\<\(NO\)\=LIST\>"
syn match asm6809Macro		"\<LLEN\s"
syn match asm6809Macro		"\<MASK2\>"
syn match asm6809Macro		"\<NAME\s"
syn match asm6809Macro		"\<NOOBJ\>"
syn match asm6809Macro		"\<OFFSET\s"
syn match asm6809Macro		"\<OPT\>"
syn match asm6809Macro		"\<ORG\(\.[SL]\)\=\>"
syn match asm6809Macro		"\<\(NO\)\=PAGE\>"
syn match asm6809Macro		"\<PLEN\s"
syn match asm6809Macro		"\<REG\s"
syn match asm6809Macro		"\<RESTORE\>"
syn match asm6809Macro		"\<SAVE\>"
syn match asm6809Macro		"\<SECT\(\.S\)\=\s"
syn match asm6809Macro		"\<SECTION\(\.S\)\=\s"
syn match asm6809Macro		"\<SET\s"
syn match asm6809Macro		"\<SPC\s"
syn match asm6809Macro		"\<STRUCT\s"
syn match asm6809Macro		"\<STRUCT\>"
syn match asm6809Macro		"\<TTL\s"
syn match asm6809Macro		"\<XCOM\s"
syn match asm6809Macro		"\<XDEF\s"
syn match asm6809Macro		"\<XREF\(\.S\)\=\s"
syn match asm6809Macro		"\<EXPORT\>"
syn match asm6809Macro		"\<IMPORT\>"

" Data directives
syn match asm6809Directive	"\<FCB\s"
syn match asm6809Directive	"\<\.DB\s"
syn match asm6809Directive	"\<\.BYTE\s"
syn match asm6809Directive	"\<FDB\s"
syn match asm6809Directive	"\<\.DW\s"
syn match asm6809Directive	"\<\.WORD\s"
syn match asm6809Directive	"\<FQB\s"
syn match asm6809Directive	"\<\.QUAD\s"
syn match asm6809Directive	"\<\.4BYTE\s"
syn match asm6809Directive	"\<FCC\s"
syn match asm6809Directive	"\<\.ASCII\s"
syn match asm6809Directive	"\<\.STR\s"
syn match asm6809Directive	"\<FCN\s"
syn match asm6809Directive	"\<\.ASCIZ\s"
syn match asm6809Directive	"\<\.STRZ\s"
syn match asm6809Directive	"\<FCS\s"
syn match asm6809Directive	"\<\.ASCIS\s"
syn match asm6809Directive	"\<\.STRS\s"
syn match asm6809Directive	"\<ZMB\s"
syn match asm6809Directive	"\<ZMD\s"
syn match asm6809Directive	"\<ZMQ\s"
syn match asm6809Directive	"\<RMB\s"
syn match asm6809Directive	"\<\.BLKB\s"
syn match asm6809Directive	"\<\.DS\s"
syn match asm6809Directive	"\<\.RS\s"
syn match asm6809Directive	"\<RMD\s"
syn match asm6809Directive	"\<RMQ\s"

syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_asm6809_syntax_inits")
  if version < 508
    let did_asm6809_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  " Comment Constant Error Identifier PreProc Special Statement Todo Type
  "
  " Constant			Boolean Character Number String
  " Identifier			Function
  " PreProc			Define Include Macro PreCondit
  " Special			Debug Delimiter SpecialChar SpecialComment Tag
  " Statement			Conditional Exception Keyword Label Operator Repeat
  " Type			StorageClass Structure Typedef

  HiLink asm6809Comment		Comment
  HiLink asm6809Todo		Todo

  HiLink hexNumber		Number		" Constant
  HiLink octNumber		Number		" Constant
  HiLink binNumber		Number		" Constant
  HiLink decNumber		Number		" Constant

  HiLink asm6809Immediate	SpecialChar	" Statement
  "HiLink asm6809Symbol		Constant

  HiLink asm6809String		String		" Constant
  HiLink asm6809CharError	Error
  HiLink asm6809StringError	Error

  HiLink asm6809Reg		Identifier
  HiLink asm6809Operator	Identifier

  HiLink asm6809Include		Include		" PreProc
  HiLink asm6809Macro		Macro		" PreProc
  HiLink asm6809MacroParam	Keyword		" Statement

  HiLink asm6809Directive	Special
  HiLink asm6809PreCond		Special


  HiLink asm6809Opcode		Statement
  HiLink asm6809Cond		Conditional	" Statement
  HiLink asm6809Repeat		Repeat		" Statement

  HiLink asm6809Label		Type
  delcommand HiLink
endif

let b:current_syntax = "asm6809"
