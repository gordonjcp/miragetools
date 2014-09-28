        org $8800
go        lda #'*#
        jsr $8030
        bra go
	clr $17,U
