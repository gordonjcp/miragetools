* Mirage Forth
* (C) 2012 Gordon JC Pearce MM0YEQ <gordon@gjcp.net>
* 
* mforth.asm
* A small Forth environment for the Ensoniq Mirage
* 
* mforth is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 2 of the License, or
* any later version.
* 
* mforth is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with mforth.  If not, see <http://www.gnu.org/licenses/>.

******************************************************************
* Rough guide to the Mirage memory map
* $0000-$7fff bank-switched sample RAM
* $8000-$bfff OS RAM
* $c000-$dfff optional cartridge (RAM, ROM, hardware)
* $e000-$efff peripherals
* $f000-$ffff boot ROM
******************************************************************

osram	equ $8000
rstack	equ osram+256	* return stack
dstack	equ osram+512	* data stack
aciasr	equ $e100	* ACIA Status and Command register
aciadr	equ $e101	* ACIA Data register
	
	org osram	* beginning of forth code
* system variables used by boot ROM
fdccmd	fcb 0		* store FDC command byte
fdcrtry	fcb $09		* FDC retries
fdctrak	fcb $0b		* FDC track
fdcsect	fcb $05		* FDC sector
fdcldad	fdb $0000	* used for OS loader address?
fdcstat	fcb $00		* fdc status
fdcerr	fcb $00		* error message for ROM routine	

* jump table, IRQs point to this
irqj	jmp irqhandler
firqj	jmp firqhandler
osj	jmp start

	org dstack
*** some utility routines
*** set up serial handler, runopsys configured the UART for us
serialinit
	orcc #$55	* disable interrupts
	ldx #aciabuffer
	stx aciain
	stx aciaout	* buffer is empty
	clra
serial_loop1
	sta ,x+	* zero out 16 bytes
	cmpx #aciain
	bne serial_loop1
	lda #$95	 * ACIA control = RX interrupt, 8n1, no TX interrupt
	sta aciasr
	rts

*** get a character from buffer
serialget
	pshs x		* retain X
	ldx aciaout	* output pointer
	ldb ,x+	* load the char into b, bump x
	cmpx #aciain	* ran off end?
	bne serialget1  * no
	ldx #aciabuffer * yes, reset back to beginning of buffer
serialget1
	stx aciaout	* save pointer
	puls x		* put X back how we got it
	rts
	
*** write a character to serial
serialput
	pshs a
serialput1
	lda aciasr
	bita #$02	* transmit flag?
	beq serialput1	* not ready, loop
	stb aciadr
	puls a
	rts
	
*** write a character, with MIDI framing
prtchr	pshs b
	ldb #$f1	* MIDI Quarterframe Message
	jsr serialput	* send it
	puls b
	pshs b		* get char, save it
	andb #$7f	* mask top bit
	jsr serialput	* send it
	puls b		* restore chr
	rts

*** Write a string
prtstr  pshs x,b
prtstr1	ldb ,x+	* get character from message
	beq prtstr2	* end of message, exit
	jsr prtchr	* output to general output
	bra prtstr1	* get next character
prtstr2	puls b,x
	rts
	
*** IRQ handlers (NMI taken care of by ROM)
irqhandler
	rti		* dummy routine
firqhandler
	pshs a,x	* save registers
*	lda #$07
*	sta $e201
	ldx aciain	* input pointer
	lda aciasr	* get ACIA status
	bita #$80	* IRQ fired?
	beq firqend	* no, strange, oh well
	lda aciadr	* get the data from the ACIA
	sta ,x+	* save and nudge the pointer
	cmpx #aciain	* ran off end?
	bne firqend
	ldx #aciabuffer * yes, reset back to the start of the buffer 
firqend
	stx aciain	* save pointer
	puls x,a	* restore
	rti		

aciabuffer
	fcb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
aciain	fdb aciabuffer
aciaout	fdb aciabuffer

start	
	lda #$0
	lds #rstack	* set up return stack
	ldu #dstack	* set up data stack
	lda #$18	* turn off LEDs
	sta $e201	
	lda #$7f	* disable all VIA interrupts
	sta $e20e
	jsr serialinit
	
	andcc #$bf	* enable interrupt
*** below this line, will be replaced with Forth words
	ldy #begin
        ldx ,y++	* You'll see this idiom a lot
        jmp [,x++]
begin   fdb cold

*** actual Forth definitions below this line
dp0     fcb   $80	* flag byte
	fcc 'til'	* name is written backwards for search routine
	fdb   $0000       * lfa of zero indicates start of dictionary
lit     fdb *+2	* this is a primitive, so CFA points to the first byte of the actual code
        ldd ,y++	* read the value at the interpreter pointer and bump
        pshu  d	* stack
        ldx ,y++	* next word (told you you'd see this quite a bit)
        jmp [,x++]

	fcb $80
	fcc 'gsm.'
	fdb lit-6	* LFA points to the flag byte of the preceding word
dotmsg	fdb *+2
	pulu x
	jsr prtstr
	ldx ,y++
	jmp [,x++]
	
	fcb $80
	fcc 'hcnarb'
	fdb dotmsg-7
branch	fdb *+2
	ldd ,y		* interpreter pointer points to offset, get it in d
	leay d,y	* add d to interp ptr
	ldx ,y++	* next
	jmp [,x++]
	
cold	fdb docol
	fdb lit, bootmsg
	fdb dotmsg
	fdb branch, -2
	
die	jmp die

	
bootmsg	fcb $0d, $0a
	fcc "Mirage Forth 0.0"
	fcb $0d, $0a, $00

*** will become part of the real def for colon	
docol   pshs y		* save IP
        leay 0,x	* new IP is word pointer
        ldx  ,y++	* next
        jmp   [,x++]

	
