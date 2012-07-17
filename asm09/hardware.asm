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
	ldb ,x
	leax 1,x
	cmpx #aciain
	bne serialgetend
	ldx #aciabuffer
serialgetend
	stx aciaout
	puls x
	rts

serialput
	lda aciasr
	bita #$02	transmit flag?
	beq serialput
	stb aciadr
	rts

*** If we're going to run the Mirage IRQ handler, we need to either
*** disable the VIA timer interrupt, or handle T2 timing out here
*** T2 is a one-shot and if it times out then it takes off at 10kHz
irqhandler

	rti		dummy routine
firqhandler
	pshs a,x	save registers
	lda #$07
	sta $e201
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

*** functions for use in our Forth stack
* _getch - wait until we get a character
* return with it in B (low byte of D)
_getch	jsr serialchr
	beq _getch
	jsr serialget
	cmpb #$f1
	bne _getch	* not a quarterframe message
_getch1	jsr serialchr
	beq _getch1
	jsr serialget	* safe to assume another character is following
	clra
	rts
* _putch - put a character out over serial
_putch	pshs d
	ldb #$f1
	jsr serialput
	puls d
	jsr serialput
	rts

