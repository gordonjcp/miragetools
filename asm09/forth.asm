*** Mirage tiny Forth
*** includes ideas from (variously) jonesforth and Dave Dunfield's Cubix Forth

* the Mirage has IRQ handlers and stuff at the start
	org	$8000		beginning of forth code
* system variables used by ROM
fdccmd	fcb 0			store FDC command byte
fdcrtry	fcb 0			FDC retries
fdctrak	fcb 0			FDC track
fdcsect	fcb 0			FDC sector
fdcldad	fdb 0			used for OS loader address?
fdcstat	fcb 0			fdc status
fdcerr	fcb 0			error message for ROM routine	

* jump table, IRQs point to this
irqj	jmp start
firqj	jmp start
osj	jmp start

rstack	equ $8100
dstack	equ $8200

*** wait for ACIA, emit a character in B
chrout:
	lda $e100
	bita #$02
	beq chrout	wait for TDRE
	stb $e101
	rts
*** wait for ACIA, return character in D ready for stacking
chrin:
	lda $e100
	bita #$01
	beq chrin
	ldb $e101
	clra
	rts		return with A clear and char in B

start:
	orcc #$55
	ldu #dstack
	lds #rstack
loop:
	jsr chrin
	orb #$40
	jsr chrout
	jmp loop
	
