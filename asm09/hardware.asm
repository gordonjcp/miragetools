*	title hardware.asm
*	(C) 2012 Gordon JC Pearce <gordonjcp@gjcp.net>
*	implements some simple drivers for the Mirage hardware
*	(mostly ACIA)

osram	equ $8000	bottom of OS ram

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
	sta ,x+
	cmpx #aciain
	bne serial_loop1
	rts
	

irqhandler
	rti		dummy routine
firqhandler
	rti		dummy routine

aciabuffer
	fcb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
aciain	fdb aciabuffer
aciaout	fdb aciabuffer

*** test code
start	
	lds	#$9000
	jsr serialinit	clear the buffer and set pointers
hang	jmp hang
	

