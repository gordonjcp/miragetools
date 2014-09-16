*       title minibug.asm
*       (C) 2014 Gordon JC Pearce
*       Based fairly loosely on the old Motorola 6800 Minibug

ram     equ $8000
cksum   equ ram-1
xlo     equ cksum-1
xhi     equ xlo-1

stack   equ xhi


aciac   equ $e100
aciad   equ $e101

	org $8008
irqvec	jmp irqhandler	VIA and DOC
firqvec	jmp firqhandler	ACIA
osvec	jmp start

irqhandler
firqhandler
        rti

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
        bmi contrl      * below 0
        cmpa #'9'
        ble inhex1      * between 0 and 9
        cmpa #'a'       * 10-16?
        bmi contrl      * fixme, needs case insensitive
        cmpa #'f'
        bgt contrl
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

load    bra contrl
print   bra contrl

start   orcc #$55       * disable interrupts
        lda #$03        * ACIA master reset
        sta aciac
        lda #$95        * /16, 8N1, RX Interrupt On
        sta aciac
        
* if the VIA isn't set up, we're in a spot of trouble
* fortunately hwsetup is called before we even try the disk
        
contrl  lds #stack      * stack pointer, will ultimately be top of upper bank 1
        lda #$0d        * carriage return
        jsr outch
        lda #$0a        * linefeed
        jsr outch
        
        jsr inch
        tfr a,b
        jsr outs
        cmpb #'l'
        beq load
        cmpb #'m'
        beq change
        cmpb #'p'
        beq print
        cmpb #'g'
        beq ctrlgo
        lda #'?'
        jsr outch
        bra contrl
ctrlgo  jmp ctrlgo      * fixme

