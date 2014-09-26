*** Ensoniq Mirage DSK ROM
*** listing by Tim Victor, Jul 4-6 1999
*** mailto:TimVictor@aol.com
*** Edited and converted to as9 by Gordon JC Pearce, Jul 7 2012 ;-)
*** ------------------------

fdccmd	equ $8000
fdcrtry	equ $8001
fdctrk	equ $8002
fdcsect	equ $8003
fdcbuff	equ $8004
fdcstat	equ $8006
fdcerr	equ $8007

	org $f000

*** Read sector from current track
*** sector number in fdcsect, data addr in X
*** terminates on NMI
fdcreadsector:
	lda   fdcsect	; sector number
	sta   $02	; FDC sector register, DP = $e8
	lda   #$88	; read sector command
	sta   fdccmd	; last command
	sta   $00	; FDC command register	; command register
fdcrd1:	sync  		; wait for interrupt (DRQ is hooked to /INT)
	lda   $03	; FDC data register	; FDC data reg
	sta   ,x+	; store byte and bump X
	bra   fdcrd1	; loop


*** skip (verify?) sector in current track
*** sector number in fdcsect, ignore data
*** possibly for directory? returns last byte read in A
fdcskipsector:
	lda   fdcsect
	sta   $02	; FDC sector register
	lda   #$88	; read sector command
	sta   fdccmd
	sta   $00	; FDC command register	; FDC cmd reg
fdcskip1:
	sync  
	lda   $03	; FDC data register	; FDC data reg
	bra   fdcskip1


*** write sector to current track
*** sector number in fdcsect, data addr in x
fdcwritesector:
	lda   fdcsect
	sta   $02	; FDC sector register	; FDC sector register
	lda   #$a8	; write sector command
	sta   fdccmd
	sta   $00	; FDC command register
fdcwrite1:
	sync  
	lda   ,x+
	sta   $03	; FDC data register
	bra   fdcwrite1


*** fill sector in current track with data byte
*** sector number in fdcsect, data addr in x
fdcfillsector:
	lda   fdcsect
	sta   $02	; FDC sector register
	lda   #$a8           ;write sector command
	sta   fdccmd
	sta   $00	; FDC command register
fdcfill1:
	sync  
	lda   ,x
	sta   $03	; FDC data register
	bra   fdcfill1


*** read all of current track
*** data addr in x
fdcreadtrack:
	lda   #$e8	;read track command
	sta   fdccmd
	sta   $00	; FDC command register
fdcreadtrack1:
	sync  
	lda   $03	; FDC data register
	sta   ,x+
	bra   fdcreadtrack1


*** write current track (format)
*** data addr in x
fdcwritetrack:
	lda   #$f8	;write track command
	sta   fdccmd
	sta   $00	; FDC command register
fdcwrite1:
	sync  
	lda   ,x+
	sta   $03	; FDC data register
	bra   fdcwrite1


*** step drive head to track 0
fdcrestore:
	lda   #$0c	;restore command
	sta   fdccmd
	sta  $00	; FDC command register
fdcrestore1:
	bra   fdcrestore1


*** step drive head to track
*** track number in fdctrk
fdcseektrack:
	lda   fdctrk
	sta  $03	; FDC data register
	lda   #$1c	;seek command
	sta   fdccmd
	sta  $00	; FDC command register
fdcseek1:
	bra   fdcseek1


*** step drive head inward by one track
fdcseekin:
	lda   #$58	;step in command
	sta   fdccmd
	sta  $00	; FDC command register
fdcseekin1:
	bra   fdcseekin1


*** step drive head outward by one track
fdcseekout:
	lda   #$78	;step out command
	sta   fdccmd
	sta   $00	; FDC command register
fdcseekout1:
	bra   fdcseekout1


*** reset fdc, cancel pending operations
fdcforceint:
	lda   #$d0	;force interrupt command
	sta   fdccmd
	sta  $00	; FDC command register
fdcforce1:
	ldb   $00	;while fdc busy bit set
	bitb  #$01
	bne   fdcforce1
	stb   fdcstat	; save the status
	ldy   #$0001	
	lbsr  countdown
	rts   


*** delay loop using count in y reg
*** 15 clock cycles per loop
countdown:
	nop   
	nop   
	nop   
	nop   
	leay  $-1,y        ;dec y
	bne   countdown
	rts   


*** fdc interrupt (nmi) handler
*** this is where all the FDC commands end up
nmivec:
	leas  $000c,s	; pop int context (12 bytes)
	ldb   $00	; read fdc status reg
	stb   fdcstat
	lda   fdccmd	; were we doing read or write sector?
	cmpa  #$88	; if read sector command
	beq   nmivec1
	lda   fdccmd
	cmpa  #$e8	; or write sector command,
	bne   nmivec2	; neither read nor write sector
nmivec1:
	ldb   fdcstat	; get the status
	andb  #$5c	; keep WP(s6), RNF(s4), CRC(s3), LD(s2)
	stb   fdcstat	; save the status
	bra   nmiend
nmivec2:
	lda   fdccmd	; were we doing read or write track?
	cmpa  #$a8	; if read track command
	beq   nmivec3
	lda   fdccmd
	cmpa  #$f8	; or write track command,
	bne   nmivec4	; neither read nor write track
nmivec3:
	ldb   fdcstat
	andb  #$5c	; keep WP(s6), RNF(s4), CRC(s3), LD(s2) - RNF inapplicable for type iii
	stb   fdcstat
	bra   nmiend
nmivec4:
	ldb   fdcstat	; alright, must have been a seek
	andb  #$18	; keep SE(s4) and CRC(s3)
	stb   fdcstat
nmiend:	rts   


*** start up machine, assume nothing
coldstart:
	orcc  #$50	; mask interrupts
	lda   #$1f
	sta   $e202	; set via ddrb
	lda   #$10
	sta   $e200	; fd off, ram bank 0
	ldx   #$e400	; reset vcf chips
cold1:	
	clr   ,x+
	cmpx  #$e408
	bne   cold1
	sta   $e418	; write mpx addr preset
	lds   #$bf80	; init system sp
	jsr   clearram
cold2:
	jsr   hwsetup
	jsr   enablefd
	lda   #$40
	anda  $e200
	cmpa  #$00	; disk loaded?
	beq   cold4
	jsr   loadopsys
	lda   fdcstat
	cmpa  #$00
	beq   cold3
	jsr   seterrcode
	jsr   checkos
cold3:
	bra   cold5
cold4:
	jsr   disablefd
	lda   #$07	
	sta   fdcstat
	sta   fdcerr	; error code (p98) = "nd"
	jsr   checkos
cold5:
	lda   fdcstat
	cmpa  #$00	; if no err
	bne   cold2	; fall through and run os

*** jump to operating system in ram
runopsys:
	lda   $01
	sta   fdctrk	; copy fdc track reg
	lda   #$a6	; SET, T2, CB2, SR
	sta   $e20e	; VIA interrupt enable reg
	lda   #$95	; RX IRQ, 8n1, /16
	sta   $e100     ; ACIA control reg
	lda   #$30	; Floppy OFF (0x20 is CA3 input)
	sta   $e200	; VIA ORA
	jmp   $800e	; os entry vector


*** initialize via, qchip, uart
hwsetup:
	lda   #$e8	; direct page reg = fdc
	tfr   a,dp
	jsr   fdcforceint
	lda   #$7f
	sta   $e20e	; disable all VIA interrupts
	lda   #$cc
	sta   $e20b     ; VIA aux ctrl reg, t1 = squarewave on pb7, shift in under ext clock
* note that the shift register is used for the local keyboard
* and the squarewave drives the UART
	lda   #$0e
	sta   $e20c	; via periph ctrl reg // cb2 in/falling, ca1 falling, ca2 high out, ca1 falling
	lda   #$1f
	sta   $e203	; via data dir 1 reg
	lda   #$30
	sta   $e200	; stop FDD
	clr   $e206	; clear VIA timer 1 latch
	clr   $e207
	clr   $e204	; clear VIA timer 1 counter
	clr   $e205
	
	ldd   #$1388	; preset via timer 2, 2MHz/5000 = 400Hz?
	stb   $e208	; T2 latch low
	sta   $e209	; T2 latch high
	lda   #$ff
	sta   $ece1	; DOC osc enable reg, presumably $ff is "magic" reset?
	ldx   #$ec00
hwsetup1:
	clr   ,x+
	cmpx  #$ece0
	bne   hwsetup1
	jsr   qchipsetup
	lda   #$03	; ACIA master reset
	sta   $e100     ; ACIA control reg
	clr   fdcstat	; clear fd status vars
	clr   fdcerr
	clr   fdctrk
	clr   fdcsect
	lda   #$01
	sta   $bf8c          ;set flag for os load
	rts   


*** initialize qchip
*** (todo)
qchipsetup:
	ldx   #$ec80	; wavetable pointer registers
qchip1
	lda   #$10	*
	sta   ,x+	* write $10 to all of them, why?
	cmpx  #$eca0
	bne   qchip1	* loop over all registers
	ldx   #$eca0	; oscillator control registers
qchip2:
	lda   #$63	; channel 6, oneshot, stopped?
	sta   ,x+
	cmpx  #$ecc0
	bne   qchip2	* loop over all registers
	ldb   #$20
* wait for all voices to stop?
qchip3:
	lda   $ece0	* read interrupt register
	ldy   #$000c
	jsr   countdown	* wait
	decb
	cmpb  #$00	* done it 32 times?
	bne   qchip3	* loop
	rts   


*** fill all sample ram banks w/ $7f
clearram:
	clr   $bf85  ; counter
clearram1:
	lda   $bf85  ; get the value
	ora   $e200  ; via port b
	sta   $e200  ; ram bank select is in bits 0 and 1
	ldx   #$0000 ; bottom
	lda   #$7f
clearram2:
	sta   ,x+    ; store, bump x
	cmpx  #$8000 ; at top?
	bne   clearram2  ; no, carry on
	inc   $bf85  ; bump the counter
	lda   $bf85  ; get it
	cmpa  #$04   ; all four banks?
	bne   clearram1  ; no, continue
	lda   #$10   ; bank 0, floppy stopped
	sta   $e200  ; set via port b
	rts


*** read operating system into $8000
loadopsys:
	jsr   fdcrestore
	lda   fdcstat
	cmpa  #$00
	beq   loadopsys1
	lbra  loadopsysend	; bail, if the restore failed
loadopsys1:
	clr   $bf85          ;first part of os
	ldx   #$8000        ;load addr=$8000
	stx   fdcbuff
loadopsys10:
	lda   $bf85
	asla  
	asla  
	sta   $bf80          ;index into param table
	ldy   #$fb80         ;... at $fb80
	jsr   preparefd
	lda   fdcstat
	cmpa  #$00
	beq   loadopsys2
	lbra  loadopsysend       ;bail on err
loadopsys2:
	lda   $bf81          ;set track#
	sta   fdctrk
loadopsys8:
	lda   $bf82          ;set sector#
	sta   fdcsect
loadopsys6:
	lda   $bf8c          ;test os load flag,
	beq   loadopsys3          ;set at $f1b7 (dumb)
	jsr   saveparams
loadopsys3:
	jsr   loadossector
	lda   fdcstat
	cmpa  #$00
	beq   loadopsys4
	bra   loadopsysend        ;bail on err

loadopsys4:
	lda   $bf8c          ;test os load flag
	beq   loadopsys5
	pshs  x
	jsr   restoreparams
	clr   $bf8c          ;clr os load flag
	puls  x
loadopsys5:
	stx   fdcbuff
	inc   fdcsect          ;do next sector
	lda   fdcsect
	cmpa  #$06           ;while sector <= 5
	bne   loadopsys6
	inc   fdctrk          ;increment track
	lda   fdctrk
	cmpa  $bf83          ;quit if trk > max trk
	bhi   loadopsys7
	jsr   gototrack
	lda   fdcstat
	cmpa  #$00
	beq   loadopsys7
	bra   loadopsysend        ;bail on err
loadopsys7:
	lda   fdctrk          ;redundant track test
	cmpa  $bf83
	bls   loadopsys8          ;to top of trk loop
	inc   $bf85          ;second part of os
	lda   $bf85
	cmpa  #$02
	beq   loadopsys9
	cmpx  #$be00         ;all loaded? ($b000-$bdff?)
	lbne  loadopsys10          ;to top of main loop
loadopsys9:
	jsr   readsysparams
loadopsysend:
	jsr   disablefd
	rts   


*** copy os parameters to $8011-$802e
readsysparams:
	ldy   #$fb88         ;param table at $fb88
	clr   $bf80          ;table index = 0
	jsr   preparefd
	lda   fdcstat
	cmpa  #$00
	beq   readsysparams1
	lbra  readsysparamsend          ;bail on err
readsysparams1:
	ldx   #$0000         ;read sect to sample ram
	stx   fdcbuff          ;load address = $0000
	lda   $bf81          ;set track#
	sta   fdctrk
	lda   $bf82          ;set sector#
	sta   fdcsect
	jsr   loadossector
	lda   fdcstat
	cmpa  #$00
	beq   readsysparams2
	bra   readsysparamsend          ;bail on err
readsysparams2:
	ldy   #$802e
	sty   $bf8d
	ldy   #$0000
	ldx   #$8011         ;copy data to $8011
readsysparams3:
	lda   ,y+
	sta   ,x+
	cpx   $bf8d
	bne   readsysparams3
	ldx   #$0000         ;clear sample ram
	lda   #$7f
readsysparams4:
	sta   ,x+
	cmpx  #$0200
	bne   readsysparams4
readsysparamsend:
	rts   


*** check disk error code (p98)
*** flash error msg if non-zero
checkos:
	lda   fdcerr
	cmpa  #$01
	bne   checkosud
	ldd   #$7a9e         ;1 = "de"
	std   $bf8a
	bra   checkosflash
checkosud:
	cmpa  #$06
	bne   checkosnd
	ldd   #$387a         ;6 = "ud"
	std   $bf8a
	bra   checkosflash
checkosnd:
	cmpa  #$07
	bne   checkosflash
	ldd   #$2a7a         ;7 = "nd"
	std   $bf8a
checkosflash:
	lda   #$7f
	sta   $bf85
checkosflash1:
	jsr   showerrcode
	dec   $bf85          ;flash 128 times
	lda   $bf85
	bne   checkosflash1
	rts   


*** display error msg on leds
showerrcode:
	ldd   $bf8a          ;16-bit msg data
	sta   $bf88
	stb   $bf89
	clrb  
showerrcode7:
	stb   $bf87
	tfr   b,a
	ora   #$18
	ldb   #$80           ;check for "1" bits in data
	bitb  $bf86
	bne   showerrcode1
	asl   $bf88
	bra   showerrcode2

showerrcode1:
	asl   $bf88
	bcc   showerrcode2
	anda  #$f7
showerrcode2:
	ldb   #$80
	bitb  $bf86
	bne   showerrcode3
	asl   $bf89
	bra   showerrcode4
showerrcode3:
	asl   $bf89
	bcc   showerrcode4
	anda  #$ef
showerrcode4:
	sta   $e201          ;multiplexed, two segs at a time
	ldy   #$0100
showerrcode5:
	leay  $-1,y
	bne   showerrcode5          ;pause
	inc   $bf86
	ldb   $bf87
	incb                 ;next bit position
	cmpb  #$07
	lbls showerrcode7
	rts

*** prepare for disk transfer
*** read params from table, step to track
preparefd:
	lda   $bf80
	leax  a,y
	lda   ,x+            ;get track#
	sta   $bf81
	sta   fdctrk
	lda   ,x+            ;get sector#
	sta   $bf82
	lda   ,x+            ;max track
	sta   $bf83
	lda   ,x             ;max sector
	sta   $bf84
	jsr   gototrack
	rts   


*** read sector of operating system
*** restore params if os flag set
loadossector:
	lda   #$0a           ;retry count = 10
	sta   fdcrtry
loadossector1:
	ldx   fdcbuff          ;x = buffer address
	jsr   fdcreadsector
	lda   fdcstat
	cmpa  #$00
	beq   loadossector2
	lda   $bf8c          ;test os load flag
	beq   loadossector2
	jsr   restoreparams
loadossector2:
	dec   fdcrtry          ;dec retry count
	lda   fdcrtry
	beq   loadossector3       ;exit if count = 0
	lda   fdcstat
	cmpa  #$00
	bne   loadossector1
loadossector3:
	lda   fdcstat          ;convoluted logic!
	cmpa  #$00
	beq   loadossectorend         ;normal exit if no err
	jsr   fdcseekout
	jsr   fdcseekin
	lda   $bf8c          ;test os load flag
	beq   loadossector4
	jsr   restoreparams
loadossector4:
	ldx   fdcbuff
	jsr   fdcreadsector  ;one last try?
loadossectorend:
	rts   


*** move fd head to track, with retry
gototrack:
	lda   #$02           ;retry count
	sta   fdcrtry
gototrack11:		
	jsr   fdcseektrack
	lda   fdcstat
	cmpa  #$00
	beq   gototrack12	; inconsistent label because there's a gototrack2 already
	jsr   fdcrestore     ;home disk if seek failed
	dec   fdcrtry
gototrack12:
	lda   fdcrtry          ;try again?
	beq   gototrackend
	lda   fdcstat
	cmpa  #$00
	bne   gototrack11
gototrackend:
	rts   


*** set disk error code (p98) after os load error
*** based on fdc status copy in fdcstat
seterrcode:
	lda   #$01           ;1=disk drive error
	sta   fdcerr
	lda   #$10
	bitb  fdcstat          ;test "not found" bit
	beq   seterrcodeend
	lda   #$06           ;6=unformatted disk
	sta   fdcerr
seterrcodeend:
	rts   


*** copy disk transfer params from $8000-$8007 to $bf8d-bf94
saveparams:
	ldx   #$bf8d
	ldy   #fdccmd
saveparams1:
	lda   ,y+
	sta   ,x+
	cmpy  #$8008
	bne   saveparams1
	rts   


*** copy disk transfer params from $bf8d-bf94 to fdccmd-8007
restoreparams:
	ldx   #fdccmd
	ldy   #$bf8d
restoreparams1:
	lda   ,y+
	sta   ,x+
	cmpx  #$8008
	bne   restoreparams1
	rts   


*** read sector from floppy
*** similar to loadossector
*** not used by rom code
readsector:
	lda   #$0a           ;retry count = 10
	sta   fdcrtry
readsector1:
	ldx   fdcbuff          ;x = buffer address
	jsr   fdcreadsector
	dec   fdcrtry          ;dec retry count
	lda   fdcrtry
	beq   readsector2        ;exit if count = 0
	lda   fdcstat
	cmpa  #$00
	bne   readsector1
readsector2:
	lda   fdcstat
	cmpa  #$00
	beq   readsectorend          ;normal exit if no err
	jsr   fdcseekout
	jsr   fdcseekin
	ldx   fdcbuff
	jsr   fdcreadsector  ;one last try?
readsectorend:
	rts   


*** write sector to floppy
*** not used by rom code
writesector:
	lda   #$0a           ;retry count = 10
	sta   fdcrtry
writesector1:
	ldx   fdcbuff          ;x = buffer address
	jsr   fdcwritesector
	dec   fdcrtry          ;dec retry count
	lda   fdcrtry
	beq   writesector2         ;exit if count = 0
	lda   fdcstat
	cmpa  #$00
	bne   writesector1
writesector2:
	lda   fdcstat
	cmpa  #$00
	beq   writesectorend         ;normal exit if no err
	jsr   fdcseekout
	jsr   fdcseekin
	ldx   fdcbuff
	jsr   fdcwritesector ;one last try?
writesectorend:
	rts   


*** move fd head to track, with retry
*** identical to gototrack ($f3f1)
*** not used by rom code
gototrack2:
	lda   #$02
	sta   fdcrtry
gototrack21:
	jsr   fdcseektrack
	lda   fdcstat
	cmpa  #$00
	beq   gototrack22
	jsr   fdcrestore
	dec   fdcrtry
gototrack22:
	lda   fdcrtry
	beq   gototrack2end
	lda   fdcstat
	cmpa  #$00
	bne   gototrack21
gototrack2end:
	rts   


*** clear fdc enable bit in via
enablefd:
	lda   $e200
	anda  #$ef
	sta   $e200          ;via data reg 2
	ldy   #$ffff
	jsr   countdown
	rts   


*** set fdc enable bit in via
disablefd:
	lda   $e200
	ora   #$10
	sta   $e200          ;via data reg 2
	rts   


*** handler for via timer 2 interrupt
*** increment/decrement/toggle variables in os direct page
timer2int:
	ldd   #$1388	; 5000
	sta   $e209	; VIA t2 high
	andcc #$bf           ;clear firq mask bit
	com   $2e	* internal to ROM
	beq   timer2int1
	dec   $2f	* counted down every second interrupt?
	bra   timer2int2
timer2int1:
	dec   $30	* called every second interrupt?
	inc   $36
timer2int2:
	dec   $33
	lda   $37
	beq   timer2int3
	deca  
	sta   $37
timer2int3:
	lda   $31
	beq   timer2int4
	deca  
	sta   $31
timer2int4:
	lda   $32
	beq   timer2int5
	deca  
	sta   $32
timer2int5:
	ldd   $34
	beq   timer2intend
	subd  #$0001
	std   $34
timer2intend:
	rti   


*** perform some kind of lookup using table at $f94d-$fb4c
*** b reg has offset (in 16-bit words) into table
*** a reg has multiplier/shift value (0-7)
*** 16-bit result returned in a & b (d) register
unknown1:
	nega  
	adda  #$09
	pshs  a
	ldx   #$f94d
	abx   
	abx   
	ldd   ,x
	tst   ,s
	bmi   unknown12
unknown11:
	lsra  
	rorb  
	dec   ,s
	bpl   unknown11
unknown12:
	leas  $0001,s
	rts   


*** initialise timer 2
unknown2:
	ldd   #$1388		// 5000
	stb   $e208          ;restart via timer 2
	sta   $e209
	lda   #$a6
	sta   $e20e          ;via int enab reg
	ldd   #$8038
	tfr   a,dp
	rts   


*** seems to re-init some hw
unknown3:
	lda   #$7f	; unset all VIA interrupts
	sta   $e20e	; via int enab reg
	lda   #$03	; ACIA master reset
	sta   $e100	; ACIA command reg
	clr   $e200	; reset VIA port B
	nop   
	nop   
	lda   #$30
	sta   $e200	; turn off FDD
	lda   #$18	; turn off both LEDs and all scan lines
	sta   $e20f	; VIA port A
	rts   


*** copy from x to u, count in y
copybytes:
	lda   ,x+
	sta   ,u+
	leay  $-1,y
	bne   copybytes
	rts   


*** swap bytes at x with u, count in y
swapbytes:
	lda   ,x
	ldb   ,u
	sta   ,u+
	stb   ,x+
	leay  $-1,y
	bne   swapbytes
	rts   

*** sweep one filter
*** called from filter tuning routine
*** X contains filter address
*** B is set to $10
swponefilt:
	cmpb  #$10	* B is preloaded with $10 by the filter tuning routine
	beq   swponefilt1 
	jmp   ospanic	* Panic if B doesn't contain the right value to set up the VIA port? why?
			
swponefilt1:
	stb   $e200     * via data reg 2, motor off, muted, compressor input
	ldb   #$b0	* initial filter cutoff
swponefilt2:
	jsr   setmaxres
	bsr   unknown5	* measure filter
	ldy   #$0000
	bsr   unknown5	* measure filter four times
	bsr   unknown5
	bsr   unknown5
	bsr   unknown5
	cmpy  #$0000	* didn't hear the tone at all
	beq   swponefilt4 
	cmpy  #$0fa0		; 4000 decimal
	bcc   swponefilt4	* higher or same as some large number, end
	cmpy  #$0085
	bcs   swponefilt3 * lower than some smallish number, proceed
	incb  		* raise the cutoff
	bra   swponefilt2	* try again
swponefilt3:
	cmpy  #$0080	* higher?
	bhi   swponefilt4 * more than $80, less than $85, end
	decb  		* sweep down
	bra   swponefilt2 * try again
swponefilt4:
	subb  #$7a	* subtract some offset
	stb   $18,u	* store in the voice parameter table
	clrb  		* zero B
	jsr   setmaxres	* close filter
	stb   -16,x	* stop resonance
	rts   		* return

	nop   
	nop   
	nop   
	nop   
	nop   
	nop   

*** measure filter frequency
*** loops around incrementing Y and reading the ADC
unknown5:
	lda   $ece2		; doc adc
unknown51:
	bsr   setmaxres
	leay  $0001,y		; increment y
	beq   unknown5end	; wrapped to zero? return
	lda   $ece2		; doc adc
	cmpa  #$90		; 144 decimal
	bcs   unknown51		; loop if less
unknown52:
	bsr   setmaxres
	leay  $0001,y		; inc y
	beq   unknown5end	// end, if zero
	lda   $ece2		// get doc adc
	cmpa  #$70		// 112 decimal
	bhi   unknown52	// loop if higher?
unknown5end
	rts   

*** set filter DAC for tuning, only called from swponefilt and unknown5
*** X initially set to $e418, filter DACs
*** B initially set to $b0
*** sets cutoff to B and resonance to maximum
setmaxres:
	lda   #$ff	maximum
	sta   ,x	DAC MUX preset
	sta   -16,x	DAC resonance
	stb   ,x	DAC MUX preset
	stb   -8,x	DAC cutoff
	rts   

*** Called from OS at AE1D during startup
*** U contains $E418, start of multiplexer and D contains $0000
*** leaves U pointing at next filter
*** note that the Mirage monitor disk docs have it wrong
*** cutoff is $e410-$e417
*** resonance is $e408-$e40f

setfilterdac:
	sta   ,u	* preset DAC for cutoff
	sta   -8,u	* set cutoff to A
	stb   ,u+	* preset DAC for resonance and advance U to next filter
	stb   -$11,u    * set resonance to B
	rts   


*** another qchip dealie
* probably not DOC, probably something to do with voice management
* pitch, maybe?
unknown8:
	orcc  #$50
	puls  u
	puls  a,b
	stb   -$7d,x
	sta   -$5d,x
	stb   -$7c,x
	sta   -$5c,x
	puls  a,b
	stb   -$7f,x
	sta   -$5f,x
	stb   -$7e,x
	sta   -$5e,x
	andcc #$af
	jmp   ,u

	fill $ff, 200

*** another qchip dealie
* probably not DOC, probably something to do with voice management
unknown9:
	orcc  #$50		// mask firq/irq
	ldd   $0002,s		// stack+2, return address?
	sta   -$3e,y		
	sta   -$3f,y
	stb   -$3d,y
	stb   -$3c,y
	andcc #$af		// unmask firq/irq
	puls  a,b		// top value off stack
	std   ,s		// put return address back
	rts   		// return

	fill $ff, 12
	fill $ff, 112
	fill $ff, 13
	fill 0, 3
	
        fcb $00,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02
        fcb $02,$03,$03,$03,$03,$04,$04,$05,$05,$06,$06,$07,$07,$08,$08,$09
        fcb $09,$0a,$0a,$0b,$0b,$0c,$0c,$0d,$0d,$0e,$0e,$0f,$0f,$10,$11,$12
        fcb $13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22
        fcb $23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32
        fcb $33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$42,$43
        fcb $45,$46,$48,$4a,$4c,$4e,$50,$52,$54,$56,$58,$5a,$5c,$5e,$61,$63
        fcb $66,$69,$6c,$6f,$72,$75,$78,$7b,$7f,$7f,$7f,$7f,$7f,$ff,$ff,$80
        fcb $00,$40,$00,$2e,$e0,$20,$00,$17,$70,$10,$00,$0b,$b8,$08,$00,$06
        fcb $66,$05,$1e,$04,$10,$03,$33,$02,$8f,$02,$19,$01,$99,$01,$47,$01
        fcb $06,$00,$cf,$00,$a3,$00,$83,$00,$68,$00,$53,$00,$42,$00,$36,$00
        fcb $29,$00,$21,$00,$1a,$00,$14,$00,$10,$00,$0d,$00,$0a,$00,$08,$00
        fcb $06,$00,$05,$00,$04,$00,$03,$00,$02,$00,$01,$00,$00,$00,$02,$04
        fcb $06,$08,$0a,$0c,$0e,$10,$12,$14,$16,$18,$1a,$1c,$1e,$20,$22,$24
        fcb $26,$28,$2a,$2c,$2e,$30,$32,$34,$36,$38,$3a,$3c,$3e,$40,$42,$44
        fcb $46,$48,$4a,$4c,$4e,$50,$52,$54,$56,$58,$5a,$5c,$5e,$60,$62,$64
        fcb $66,$68,$6a,$6c,$6e,$70,$72,$74,$75,$76,$77,$78,$79,$7a,$79,$78
        fcb $77,$76,$75,$74,$72,$70,$6e,$6c,$6a,$68,$66,$64,$62,$60,$5e,$5c
        fcb $5a,$58,$56,$54,$52,$50,$4e,$4c,$4a,$48,$46,$44,$42,$40,$3e,$3c
        fcb $3a,$38,$36,$34,$32,$30,$2e,$2c,$2a,$28,$26,$24,$22,$20,$1e,$1c
        fcb $1a,$18,$16,$14,$12,$10,$0e,$0c,$0a,$08,$06,$04,$02,$00,$fe,$fc
        fcb $fa,$f8,$f6,$f4,$f2,$f0,$ee,$ec,$ea,$e8,$e6,$e4,$e2,$e0,$de,$dc
        fcb $da,$d8,$d6,$d4,$d2,$d0,$ce,$cc,$ca,$c8,$c6,$c4,$c2,$c0,$be,$bc
        fcb $ba,$b8,$b6,$b4,$b2,$b0,$ae,$ac,$aa,$a8,$a6,$a4,$a2,$a0,$9e,$9c
        fcb $9a,$98,$96,$94,$92,$90,$8e,$8c,$8b,$8a,$89,$88,$87,$86,$87,$88
        fcb $89,$8a,$8b,$8c,$8e,$90,$92,$94,$96,$98,$9a,$9c,$9e,$a0,$a2,$a4
        fcb $a6,$a8,$aa,$ac,$ae,$b0,$b2,$b4,$b6,$b8,$ba,$bc,$be,$c0,$c2,$c4
        fcb $c6,$c8,$ca,$cc,$ce,$d0,$d2,$d4,$d6,$d8,$da,$dc,$de,$e0,$e2,$e4
        fcb $e6,$e8,$ea,$ec,$ee,$f0,$f2,$f4,$f6,$f8,$fa,$fc,$fe,$49,$11,$49
        fcb $44,$49,$76,$49,$a9,$49,$dc,$4a,$10,$4a,$43,$4a,$77,$4a,$aa,$4a
        fcb $de,$4b,$12,$4b,$46,$4b,$7b,$4b,$af,$4b,$e3,$4c,$18,$4c,$4d,$4c
        fcb $82,$4c,$b7,$4c,$ec,$4d,$22,$4d,$57,$4d,$8d,$4d,$c3,$4d,$f9,$4e
        fcb $2f,$4e,$65,$4e,$9b,$4e,$d2,$4f,$09,$4f,$40,$4f,$77,$4f,$ae,$4f
        fcb $e5,$50,$1d,$50,$54,$50,$8c,$50,$c4,$50,$fc,$51,$34,$51,$6c,$51
        fcb $a5,$51,$de,$52,$16,$52,$4f,$52,$89,$52,$c2,$52,$fb,$53,$35,$53
        fcb $6f,$53,$a9,$53,$e3,$54,$1d,$54,$57,$54,$92,$54,$cc,$55,$07,$55
        fcb $42,$55,$7e,$55,$b9,$55,$f4,$56,$30,$56,$6c,$56,$a8,$56,$e4,$57
        fcb $20,$57,$5d,$57,$99,$57,$d6,$58,$13,$58,$50,$58,$8e,$58,$cb,$59
        fcb $09,$59,$47,$59,$84,$59,$c3,$5a,$01,$5a,$3f,$5a,$7e,$5a,$bd,$5a
        fcb $fc,$5b,$3b,$5b,$7a,$5b,$ba,$5b,$f9,$5c,$39,$5c,$79,$5c,$ba,$5c
        fcb $fa,$5d,$3a,$5d,$7b,$5d,$bc,$5d,$fd,$5e,$3e,$5e,$80,$5e,$c1,$5f
        fcb $03,$5f,$45,$5f,$87,$5f,$c9,$60,$0c,$60,$4f,$60,$91,$60,$d4,$61
        fcb $18,$61,$5b,$61,$9f,$61,$e2,$62,$26,$62,$6b,$62,$af,$62,$f3,$63
        fcb $38,$63,$7d,$63,$c2,$64,$07,$64,$4d,$64,$92,$64,$d8,$65,$1e,$65
        fcb $64,$65,$ab,$65,$f1,$66,$38,$66,$7f,$66,$c6,$67,$0d,$67,$55,$67
        fcb $9d,$67,$e4,$68,$2d,$68,$75,$68,$bd,$69,$06,$69,$4f,$69,$98,$69
        fcb $e1,$6a,$2b,$6a,$75,$6a,$be,$6b,$09,$6b,$53,$6b,$9d,$6b,$e8,$6c
        fcb $33,$6c,$7e,$6c,$c9,$6d,$15,$6d,$61,$6d,$ad,$6d,$f9,$6e,$45,$6e
        fcb $91,$6e,$de,$6f,$2b,$6f,$78,$6f,$c6,$70,$13,$70,$61,$70,$af,$70
        fcb $fd,$71,$4c,$71,$9a,$71,$e9,$72,$38,$72,$88,$72,$d7,$73,$27,$73
        fcb $77,$73,$c7,$74,$17,$74,$68,$74,$b9,$75,$0a,$75,$5b,$75,$ac,$75
        fcb $fe,$76,$50,$76,$a2,$76,$f4,$77,$47,$77,$9a,$77,$ed,$78,$40,$78
        fcb $93,$78,$e7,$79,$3b,$79,$8f,$79,$e4,$7a,$38,$7a,$8d,$7a,$e2,$7b
        fcb $37,$7b,$8d,$7b,$e3,$7c,$39,$7c,$8f,$7c,$e5,$7d,$3c,$7d,$93,$7d
        fcb $ea,$7e,$41,$7e,$99,$7e,$f1,$7f,$49,$7f,$a1,$7f,$fa,$80,$53,$80
        fcb $ac,$81,$05,$81,$5f,$81,$b9,$82,$13,$82,$6d,$82,$c7,$83,$22,$83
        fcb $7d,$83,$d9,$84,$34,$84,$90,$84,$ec,$85,$48,$85,$a5,$86,$01,$86
        fcb $5e,$86,$bc,$87,$19,$87,$77,$87,$d5,$88,$33,$88,$92,$88,$f1,$89
        fcb $50,$89,$af,$8a,$0e,$8a,$6e,$8a,$ce,$8b,$2f,$8b,$8f,$8b,$f0,$8c
        fcb $51,$8c,$b3,$8d,$14,$8d,$76,$8d,$d8,$8e,$3b,$8e,$9e,$8f,$01,$8f
        fcb $64,$8f,$c7,$90,$2b,$90,$8f,$90,$f4,$91,$58,$91,$bd

*** led display patterns for hexadecimal 0-f
*** more led display patterns: l n o p r u _ - [top bar] c u

ledpatterns:
        fcb $fc,$60,$da,$f2,$66,$b6,$be,$e0,$fe,$e6,$ee,$3e,$9c,$7a,$9e,$8e
        fcb $1c,$2a,$3a,$ce,$0a,$7c,$10,$02,$80,$1a,$38



*** fascinating permutation of values from
*** 0 to 23, no idea why
        fcb $10,$03,$01,$11,$06,$04,$12,$09,$07,$15,$05,$0e,$16,$08,$0c,$17
        fcb $00,$0f,$14,$02,$0d,$13,$0a,$0b

*** track/sector info for os load
	fcb $00,$00,$01,$05,$02,$05,$0a,$05 


*** track/sector info for system parameters
	fcb $0b,$05,$0b,$05 


*** track/sector info for os flags
	fcb $20,$05,$22,$05 


*** track/sector info for lower sounds
	fcb $02,$00,$0e,$04,$1c,$00,$28,$04,$36,$00,$42,$04 


*** track/sector info for upper sounds
	fcb $0f,$00,$1b,$04,$29,$00,$35,$04,$43,$00,$4f,$04


*** track/sector info for short sequences
	fcb $14,$05,$17,$05,$23,$05,$26,$05,$37,$05,$3a,$05,$18,$05,$1b,$05
	fcb $1c,$05,$1f,$05,$27,$05,$2a,$05,$2b,$05,$2e,$05,$3b,$05,$3e,$05


*** track/sector info for long sequences
	fcb $0c,$05,$1f,$05,$23,$05,$36,$05,$37,$05,$4a,$05

*** something to do with the directory bytes
	fcb $00,$00,$00,$02,$08,$20,$04,$00,$10,$00,$40,$06,$18,$60,$01,$02
	fcb $04,$08,$10,$20,$40,$80,$01,$02,$04,$e6,$9d,$7b,$fe,$fd,$fb,$fe
	fcb $fe,$fd,$fd,$fb,$01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$03,$03
	fcb $04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$06,$06,$06
	fcb $06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07,$07,$07,$07,$08,$08
	fcb $08,$08,$08,$08,$08,$08,$09,$09,$09,$09,$09,$09,$09,$09,$0a,$0a
	fcb $0a,$0a,$0a,$0a,$0a,$0b,$0b,$0b,$0b,$0b,$0b,$0c,$0c,$0c,$0c,$0c
	fcb $0d,$0d,$0d,$0d,$0d,$0e,$0e,$0e,$0e,$0f,$0f,$0f,$0f,$0f,$10,$10
	fcb $10,$10,$11,$11,$11,$12,$12,$13,$13,$14,$14,$15,$16,$17,$19,$1b
	fcb $1e,$21,$23,$26,$29,$2c,$2f,$32,$36,$3b,$41,$48,$51,$5a,$64,$6e
	fcb $79,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f


*** check for expansion cartridge, jump to startup code
*** Checks for a sequence of $00-$0f in the first 16 bytes of cart ROM
*** Thanks to Caithleanne Logan for pointing this out
resetvec:
	clra  
	ldx   #$c000
resetvec1:
	cmpa  ,x+
	lbne  coldstart	// not zero?
	inca  
	cmpa  #$10
	bne   resetvec1
	jmp   $c010

ospanic:
	lda   #$02
	sta   fdcsect
ospanic1:
	lda   #$7f
	sta   fdcrtry
	ldd   #$fdb7         ;flash ".o.s" message
	std   $bf8a
ospanic2:
	jsr   showerrcode
	dec   fdcrtry
	lda   fdcrtry
	bne   ospanic2
	dec   fdcsect
	lda   fdcsect
	bne   ospanic1
	jmp   coldstart

	fill $ff,825

*** cpu vectors
	fdb	resetvec; reserved
	fdb	resetvec; swi3
	fdb 	resetvec; swi2
	fdb	$800b	; firq
	fdb	$8008	; irq
	fdb	resetvec; swi
	fdb	nmivec	; nmi
	fdb	resetvec; reset

