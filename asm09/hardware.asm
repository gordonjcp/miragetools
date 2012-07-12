*	title hardware.asm
*	(C) 2012 Gordon JC Pearce <gordonjcp@gjcp.net>
*	implements some simple drivers for the Mirage hardware
*	(mostly ACIA)

osram	equ $8000	bottom of OS ram
aciasr	equ $e100
aciadr	equ $e101

	org $8008
irqvec	jmp irqhandler	VIA and DOC
firqvec	jmp firqhandler	ACIA
osvec	jmp start

*** parameters are loaded to here, with standard OS
*** I see no reason to change this

	org $8030	

*** set up FIRQ handler, runopsys configured the UART for us
serialinit		
	orcc #$55	disable interrupts
	ldx #aciabuffer
	stx aciain
	stx aciaout	buffer is empty
	clra
serial_loop1
	sta ,x+		zero out 16 bytes
	cmpx #aciain
	bne serial_loop1
	lda #$95	ACIA control = RX interrupt, 8n1, no TX interrupt
	sta aciasr
	rts

*** test if a character is available
serialchr
	pshs x
	ldx aciain
	cmpx aciaout
	puls x
	rts
	
*** get a character from buffer
serialget
	pshs x
	ldx aciaout
	lda ,x+
	cmpx #aciain
	bne serialgetend
	ldx #aciabuffer
serialgetend
	stx aciaout
	puls x
	rts

serialput
	pshs b
serialput1
	ldb aciasr
	bitb #$02	transmit flag?
	beq serialput1
	sta aciadr
	puls b
	rts

irqhandler
	rti		dummy routine
firqhandler
	pshs a,x	save registers
	ldx aciain	input pointer
	lda aciasr	get ACIA status
	bita #$80	IRQ fired?
	beq firqend	no, must have been an error but we don't care
	lda aciadr	get the data from the ACIA
	sta ,x+		save and nudge the pointer
	cmpx #aciain	ran off end?
	bne firqend
	ldx #aciabuffer
firqend
	stx aciain	save pointer
	puls x,a	restore
	rti		

aciabuffer
	fcb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
aciain	fdb aciabuffer
aciaout	fdb aciabuffer


counter fdb 0
*** test code
start	
	lds #$9000
	jsr serialinit	clear the buffer and set pointers
	andcc #$aa	enable FIRQ
	
	ldx 0
	stx counter
loop	jsr serialchr
	bne showchr
	inc counter
	bne loop
	jmp loop
showchr
	jsr serialget
	jsr serialput
	jmp loop
