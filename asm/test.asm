        org $8800
go        lda #'*#
        jsr $8030
        bra go
	clr $17,U

	org $ba00
	pshs a,b
	orcc #$50
	ldb #$02
o1	bitb $e100
	beq o1
	lda #$f1
	sta $e101
o2	bitb $e100
	beq o2
	lda 42
	sta $e101
	puls b,a
	andcc #$af
	rts

