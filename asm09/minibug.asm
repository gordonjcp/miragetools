*       title minibug.asm
*       (C) 2014 Gordon JC Pearce
*       Based fairly loosely on the old Motorola 6800 Minibug
* 	loads into sequencer RAM at ba00

ramtop  equ $bfff	* last byte of sequencer RAM
cksum   equ ramtop	* checksum for S-record
xlo     equ cksum-1	* used for two-byte hex entry
xhi     equ xlo-1	* used for two-byte hex entry
bytect  equ xhi-1	* byte count for S-record
sstack	equ bytect-2	* holds stack pointer on entry
sregs	equ $bfc0	* stack registers on entry

stack   equ $bf80	* ROM uses this address anyway

aciac   equ $e100
aciad   equ $e101

	org $ba00
* start by saving stack pointer then stacking all registers
entry	sts sstack
	lds #sregs
	pshs a,b,x,y,cc,u
	orcc #$50
	jmp start

* restore old stack and return
return	lds #sregs
	puls a,b,x,y,cc,u
	lds sstack
	rts

* inch - fetch a single character, with MIDIterm framing

inch    pshs b          * save B
        ldb #$01        * receive data register flag
inch1   bitb aciac      * check acia
        beq inch1       * wait
        lda aciad       * get the byte
        cmpa #$f1       * MIDI Quarter Frame message?
        bne inch1       * no, wait until it is
inch2   bitb aciac      * wait again
        beq inch2
        lda aciad       * fetch the byte
        cmpa #$7f       * RUBOUT?
        beq inch        * ignore, go back for another
        puls b          * restore B and fall through to...
                
* outch - output a single character, with MIDIterm framing
outch   pshs b,a        * save B, byte to send in A
        ldb #$02        * transmit data register flag
outch1  bitb aciac      * check acia
        beq outch1      * wait
        lda #$f1        * MIDI Quarter Frame message
        sta aciad       * transmit
        puls a          * get wanted byte
outch2  bitb aciac      * wait again
        beq outch2
        sta aciad       * transmit
        puls b          * restore B
        rts
        
* outs - output a space
outs    lda #' '
        bsr outch
        rts

* outhl - hex left digit
outhl   lsra
        lsra
        lsra
        lsra
* outhr - hex right digit
outhr   anda #$0f       * mask
        adda #'0'
        cmpa #'9'
        bls outch
        adda #$07
        bra outch

* outhex - output a hex byte
outhex  lda ,x
        bsr outhl
        lda ,x
        bsr outhr
        rts

* outhexs - output hex byte followed by space
outhexs bsr outhex
        lda #' '
        bra outch

* inhex - read a hex character
inhex   bsr inch
        cmpa #'0'
        lbmi ctrl      * below 0
        cmpa #'9'
        ble inhex1      * between 0 and 9
        ora #$20        * smash case
        cmpa #'a'       * 10-16?
        bmi ctrl      * fixme, needs case insensitive
        cmpa #'f'
        bgt ctrl
        suba #$07       * remove offset
inhex1  rts        

* byte - get a hex byte
byte    bsr inhex
        asla
        asla
        asla
        asla
        tfr a,b
        bsr inhex
        anda #$0f       * ensure it's four bits
        pshs b
        adda ,s+
        tfr a,b
        adda cksum
        sta cksum
        tfr b,a
        rts
        
* baddr - get a 16-bit hex word
baddr   bsr byte
        sta xhi
        bsr byte
        sta xlo
        ldx xhi
        rts
        
* change - edit memory
change  bsr baddr
        bsr outs
        bsr outhexs
        bsr byte
        sta ,x
        bra ctrl

load    jsr inch
        cmpa #'S'
        bne load        * wait until we get an S
        jsr inch        * get type
        cmpa #'9'
        beq load3       * start address
        cmpa #'1'
        bne load        * not a data record
        clr cksum
        bsr byte        * fetch length
        suba #$02       * correct it
        sta bytect
        bsr baddr       * get address
load1   bsr byte
        dec bytect
        beq load2       * zero bytes
        sta ,x+
        bra load1
load2   inc cksum
        beq load
        jmp ctrlerr
load3   jmp ctrl
  
start        
ctrl  lds #stack      * stack pointer, will ultimately be top of upper bank 1
        lda #$0d        * carriage return
        jsr outch
        lda #$0a        * linefeed
        jsr outch
	lda #'>'
	jsr outch
	jsr outs
        
        jsr inch
        tfr a,b
        jsr outs
        cmpb #'l'
        beq load
        cmpb #'m'
        beq change
        cmpb #'g'
        beq ctrlgo
	cmpb #'r'	* return
	lbeq return 
ctrlerr lda #'?'
        jsr outch
        bra ctrl
ctrlgo  jsr baddr
        jsr ,x
	jmp ctrl

