*       title minibug.asm
*       (C) 2014 Gordon JC Pearce
*       Based fairly loosely on the old Motorola 6800 Minibug

stack   equ $8000

aciac   equ $e100
aciad   equ $e101

	org $8008
irqvec	jmp irqhandler	VIA and DOC
firqvec	jmp firqhandler	ACIA
osvec	jmp start

irqhandler
firqhandler
        rti
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

outs    lda #' '
        bsr outch
        rts


inch    rts
load    rts
change  rts
print   rts

start   orcc #$55       * disable interrupts
        lda #$03        * ACIA master reset
        sta aciac
        lda #$95        * /16, 8N1, RX Interrupt On
        sta aciac
        
* if the VIA isn't set up, we're in a spot of trouble
* fortunately hwsetup is called before we even try the disk
        
contrl  lds #stack      * stack pointer, will ultimately be top of upper bank 1
        lda #$0d        * carriage return
        bsr outch
        lda #$0a        * linefeed
        bsr outch
        
        jsr inch
        tfr a,b
        bsr outs
        cmpb #'l'
        bne ctrlmem
        jmp load
ctrlmem cmpb #'m'
        beq change
        cmpb #'p'
        beq print
        cmpb #'g'
        bne contrl
ctrlgo  jmp ctrlgo      * fixme

