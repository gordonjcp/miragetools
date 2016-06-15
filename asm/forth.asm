* vim: syn=asm6809 noexpandtab ts=8
*	title	micro forth 1.0
*
* micro forth 1.0
*
*    this is a small fast implementation of a forth language for
* the motorola 6809 microprocessor. it is unique in that there is
* no interpreter, all words are directly executable.
*
* copyright 1984-2005 dave dunfield
* all rights reserved.
*
* system equates
*


; macro for A09

fccz	macro
	fcc &1
	fcb 0
	endm

osram	equ	$8000
sysram	equ	$8030
width	equ	65		terminal screen width margin
rstack	equ	sysram+254	return stack
dstack	equ	sysram+510	data stack
aciasr	equ $e100
aciadr	equ $e101

* the Mirage has IRQ handlers and stuff at the start
	org	osram		beginning of forth code
* system variables used by ROM
fdccmd	fcb 0			store FDC command byte
fdcrtry	fcb $09			FDC retries
fdctrak	fcb $0b			FDC track
fdcsect	fcb $05			FDC sector
fdcldad	fdb $0000		used for OS loader address?
fdcstat	fcb $00			fdc status
fdcerr	fcb $00			error message for ROM routine	

* jump table, IRQs point to this
irqj	jmp irqhandler
firqj	jmp firqhandler
osj	jmp start

sysvars	equ *
lstlok	fdb 0
temp	fdb 0
inpbuf	equ *
*lstlok	equ	sysvars		pointer to last word processed from input buffer
*temp	equ	lstlok+2	temporary storage
*inpbuf	equ	temp+2		input buffer

* the Mirage OS saves parameters from $8011 to $802e
	org	sysram+$230 		top of data stack
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
	ldb ,x+
	cmpx #aciain
	bne serialgetend
	ldx #aciabuffer
serialgetend
	stx aciaout
	puls x
	rts

serialput
	pshs a
serialput1
	lda aciasr
	bita #$02	transmit flag?
	beq serialput1
	stb aciadr
	puls a
	rts

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



* initializations, start up forth
start	
	lda #$0
	lds	#rstack		set up return stack
	ldu	#dstack		set up data stack
	lda	#$18		turn off LEDs
	sta	$e201
	lda #$7f
	sta $e20e		disable VIA interrupts
	jsr serialinit
	
	andcc #$bf		enable interrupt

	ldx	#strtmsg	point to startup message
	lbsr	pmsg1		display it
	jsr	[boot+3]	execute preset routine (usually 'quit')
	lbra	bye		exit forth
* subroutine to obtain variables address on stack.
* used by 'variable' type words
variab	ldx	,s++		get following address
	pshu	x		save
	rts			return to caller
* messages
prompt	fcb	$0a,$0d		new line
	fccz	'ok>'		; prompt
ermsg1	
	fccz	/error: '/	;error prefix
ermsg2	
	fccz	/' /		;error suffix
redmsg	
	fccz	'redef: '	;re-definition indicator

delmsg	fcb	8,32,8,0	bug when using strings?

strtmsg 
	fcb	$0d,$0a
	fcc	"Mirage micro forth"
	fcb	$0d,$0a,0
ledval	fdb 0
ledctr	fdb 0
ledctr1 fdb 0

*
* start	of user	dictionary
* dictionary format:
*   1)	- word descriptor byte, format:
*	bit 7	    - always set, indicates this is descriptor byte
*	bits 7-3    - currently not used
*	bit 2	    - no-compile bit, word cannot be used in compiles
*	bit 1	    - no-interactive bit, word cannot be used interactively
*	bit 0	    - execute on compile bit, compiler executes word immediatly
*		      instead of compiling into definition
*   2)	- word name, variable length, stored backwards
*   3)	- address of previous word in dictionary, address must point to first
*	  byte of code which immediatly follows this field in the word
*
*
* 'dropn' - drops a number of words from the stack
	fcb	$80
	fcc	'npord'
	fdb	0		** end of dictionary **
dropn	ldd	,u++		get operand
	aslb			multiply by
	rola			two for word stack entries
	leau	d,u		move user stack
	rts
* 'drop' - drop one word from the stack
	fcb	$80
	fcc	'pord'
	fdb	dropn
drop	leau	2,u		move stack pointer
	rts
* 'dup' - duplicate top of stack
	fcb	$80
	fcc	'pud'
	fdb	drop
dup	ldd	,u		get top of user stack
	std	,--u		duplicate
	rts
* 'over' duplicate one down from top of stack
	fcb	$80
	fcc	'revo'
	fdb	dup
over	ldd	2,u		get element
	std	,--u		duplicate
	rts
* 'rot' - rotate top three elements on stack
	fcb	$80
	fcc	'tor'
	fdb	over
rot	ldd	4,u		get bottom
	ldx	2,u		get middle
	stx	4,u		put on bottom
	bra	swap1		do rest
* 'swap' - swap top two elements on stack
	fcb	$80
	fcc	'paws'
	fdb	rot
swap	ldd	2,u		get lower one
swap1	ldx	,u		get top
	stx	2,u		place top at lower
	std	,u		place lower at top
	rts
* '0=' - test for tos equal to zero
	fcb	$80
	fcc	'=0'
	fdb	swap
zequ	ldd	,u		get top of stack
	beq	ret1		equal to zero?
	bra	ret0		no, return one
* '=' - test for equality
	fcb	$80
	fcc	'='
	fdb	zequ
equals	ldd	,u++		get top of stack
	cmpd	,u		compare with next
	beq	ret1		same, return 1
	bra	ret0		no, return zero
* '<>' - test for not equal
	fcb	$80
	fcc	'><'
	fdb	equals
notequ	ldd	,u++		get tos
	cmpd	,u		compare with next
	beq	ret0		not same, return 1
	bra	ret1		no, return 0
* '>' - test for greater
	fcb	$80
	fcc	'>'
	fdb	notequ
grtr	ldd	2,u		get lower element
	cmpd	,u++		compare with tos
	bgt	ret1		greater, return 1
	bra	ret0		no, return false
* '<' - test for less
	fcb	$80
	fcc	'<'
	fdb	grtr
less	ldd	2,u		get lower element
	cmpd	,u++		compare with tos
	blt	ret1		lower, return 1
	bra	ret0		no, return false
* '>=' - test for greater or equal to
	fcb	$80
	fcc	'=>'
	fdb	less
grequ	ldd	2,u		get lower
	cmpd	,u++		compare with tos
	blt	ret0		less, return false
ret1	ldb	#1		get one
	bra	rets		return it
* '<=' - test for less or equal to
	fcb	$80
	fcc	'=<'
	fdb	grequ
lesequ	ldd	2,u		get lower
	cmpd	,u++		compare with tos
	ble	ret1		lower or equal, return one
ret0	clrb			get zero result
rets	clra			zero high byte
	std	,u		save on stack
	rts
* '$out' - output character to terminal
	fcb	$80
	fcc	'tuo$'
	fdb	lesequ
dolout	
	ldb #$f1
	jsr serialput	
	ldd	,u++		get char from stack
	andb	#$7f		mask top bit
	jsr serialput
	rts
* '$in' - input character from terminal
	fcb	$80
	fcc	'ni$'
	fdb	dolout
dolin	jsr serialchr
	bne dolin1
dolin0
	inc ledctr
	bne dolin
	inc ledctr1
	lda ledctr1
	cmpa #$0a
	bne dolin
	clr ledctr1
	lda ledval
	inca
	cmpa #$6
	bne dolin2
	clra
dolin2	sta ledval
	ora #$08
	sta $e201
	bra dolin
dolin1
	jsr serialget
	cmpb #$f1
	bne dolin
dolin9
	jsr serialchr
	beq dolin9
	jsr serialget
	clra
	std	,--u		save on stack
	rts
* 'emit' - output character to general output
	fcb	$80
	fcc	'time'
	fdb	dolin
emit	jmp	[disp+3]	execute output routine in '(out)' variable
* 'key' - get character from general input
	fcb	$80
	fcc	'yek'
	fdb	emit
key	jmp	[inpt+3]	execute input routine in '(in)' variable
* 'u.' - output unsigned number in current base
	fcb	$80
	fcc	'.u'
	fdb	key
udot	bra	dot01		execute number output routine
* '.' - output signed number in current base
	fcb	$80
	fcc	'.'
	fdb	udot
dot	ldd	,u		get number from stack
	bpl	dot01		is positive, its ok
	ldb	#'-'		get minus sign
	pshu	a,b		save on stack
	jsr	emit		output minus sign
	jsr	neg		negate number
dot01	lda	#$ff		end if stream indicator
	pshs	a		save marker on return stack
dot1	ldd	base+3		get number base from 'base' variable
	pshu	a,b		save base
	jsr	usmod		perform division
	pulu	a,b		get remainder
	pshs	b		save for later
	ldd	,u		get result
	bne	dot1		if more, keep going
	leau	2,u		skip last result on stack
dot2	ldb	,s+		get character from stack
	lbmi	space		end of digits, output space and exit
	addb	#$30		convert to decimal number
	cmpb	#$39		in range?
	bls	dot3		yes, its ok
	addb	#7		convert to alpha
dot3	pshu	a,b		save on stack
	bsr	emit		output character
	bra	dot2		keep outputing
* '-!' - subtract from self and reassign
	fcb	$80
	fcc	'!-'
	fdb	dot
mstor	ldx	,u++		get address
	ldd	,x		get contents
	subd	,u++		subtract tos
	std	,x		resave contents
	rts
* '+!' - add to self and reassign
	fcb	$80
	fcc	'!+'
	fdb	mstor
pstor	ldx	,u++		get address
	ldd	,x		get contents
	addd	,u++		add is tos
	std	,x		resave contents
	rts
* 'c!' - character (byte) store operation
	fcb	$80
	fcc	'!c'
	fdb	pstor
vstorc	ldx	,u++		get address
	ldd	,u++		get data from stack
	stb	,x		save in variable
	rts
* '!' - word store operation
	fcb	$80
	fcc	'!'
	fdb	vstorc
vstor	ldx	,u++		get address
	ldd	,u++		get data
	std	,x		perform store
	rts
* 'c@' - character read operation
	fcb	$80
	fcc	'@c'
	fdb	vstor
vreadc	ldb	[,u]		get character from address
	clra			zero high byte
	bra	savsd		move to stack
* '@' - word read operation
	fcb	$80
	fcc	'@'
	fdb	vreadc
vread	ldd	[,u]		get word from address
	bra	savsd		place on stack
* '2/' - divide by two
	fcb	$80
	fcc	'/2'
	fdb	vread
shr	lsr	,u		shift high
	ror	1,u		shift low
	rts
* '2*' - multiply by two
	fcb	$80
	fcc	'*2'
	fdb	shr
shl	lsl	1,u		shift low
	rol	,u		shift high
	rts
* '+' - add operator
	fcb	$80
	fcc	'+'
	fdb	shl
add	ldd	,u++		get tos
	addd	,u		add in next
	bra	savsd		place result on stack
* '-' - subtract operator
	fcb	$80
	fcc	'-'
	fdb	add
sub	ldd	2,u		get lower operand
	subd	,u++		subtract tos
savsd	std	,u		place result on stack
	rts
* 'd-' double precision subtraction
	fcb	$80
	fcc	'-d'
	fdb	sub
dminus	ldd	6,u		get low word of lower operand
	subd	2,u		subtract low word off higher operand
	std	6,u		resave lower word of operand
	ldd	4,u		get high word of lower operand
	sbcb	1,u		subtract top of stack
	sbcb	,u		with borrow from previous
	leau	4,u		fix up stack
	std	,u		place high word of result on stack
	rts
* 'd+' - double precision addition
	fcb	$80
	fcc	'+d'
	fdb	dminus
dplus	ldd	2,u		get low word of first operand
	addd	6,u		add low word of second operand
	std	6,u		resave
	ldd	,u		get high word of first
	adcb	5,u		add in high word of
	adca	4,u		second with carry
	leau	4,u		fix up stack
	std	,u		resave
	rts
* 'u*' - unsigned multiply
	fcb	$80
	fcc	'*u'
	fdb	dplus
umult	lda	1,u
	ldb	3,u
	mul
	pshs	a,b
	lda	,u
	ldb	2,u
	mul
	pshs	a,b
	lda	1,u
	ldb	2,u
	mul
	addd	1,s
	bcc	umul1
	inc	,s
umul1	std	1,s
	lda	,u
	ldb	3,u
	mul
	addd	1,s
	bcc	umul2
	inc	,s
umul2	std	1,s
	puls	d,x
	std	,u
	stx	2,u
	rts
* '*' - signed multiply
	fcb	$80
	fcc	'*'
	fdb	umult
mult	lda	1,u
	ldb	3,u
	mul
	pshs	a,b
	lda	,u
	ldb	3,u
	mul
	addb	,s
	stb	,s
	lda	1,u
	ldb	2,u
	mul
	addb	,s
	stb	,s
	puls	d
	leau	2,u
	std	,u
	rts
* 'm/mod' - division with remainder
	fcb	$80
	fcc	'dom/m'
	fdb	mult
msmod	clra
	clrb
	ldx	#33
msmodl	andcc	#$fe
msmodm	rol	5,u
	rol	4,u
	rol	3,u
	rol	2,u
	leax	-1,x
	beq	msmodd
	rolb
	rola
	cmpd	,u
	blo	msmodl
	subd	,u
	orcc	#1
	bra	msmodm
msmodd	std	,u
	rts
* 'u/mod' - unsigned division with remainder
	fcb	$80
	fcc	'dom/u'
	fdb	msmod
usmod	ldd	,u++
	clr	,-u
	clr	,-u
	std	,--u
	jsr	msmod
	ldd	,u++
	std	,u
	rts
* '/mod' - division giving remainder
	fcb	$80
	fcc	'dom/'
	fdb	usmod
slmod	lda	2,u
	pshs	a
	bpl	slmod2
	clra
	clrb
	subd	2,u
	std	2,u
	lda	,s
slmod2	eora	,u
	pshs	a
	ldd	,u
	beq	slmodr
	bpl	slmod1
	coma
	comb
	addd	#1
	std	,u
slmod1	clra
	clrb
	ldx	#17
slmodl	andcc	#$fe
slmodm	rol	3,u
	rol	2,u
	leax	-1,x
	beq	slmodd
	rolb
	rola
	cmpd	,u
	blo	slmodl
	subd	,u
	orcc	#1
	bra	slmodm
slmodd	tst	1,s
	bpl	slmod3
	coma
	comb
	addd	#1
slmod3	std	,u
	tst	,s++
	bpl	slmodr
	clra
	clrb
	subd	2,u
	std	2,u
slmodr	rts
* '/' - division
	fcb	$80
	fcc	'/'
	fdb	slmod
slash	bsr	slmod
	leau	2,u
	rts
* 'and' - logical and
	fcb	$80
	fcc	'dna'
	fdb	slash
and	ldd	,u++		get top of stack
	anda	,u		and high byte
	andb	1,u		and low byte
	bra	savds		save result and exit
* 'or' - logical or
	fcb	$80
	fcc	'ro'
	fdb	and
or	ldd	,u++		get top of stack
	ora	,u		or high byte
	orb	1,u		or low byte
	bra	savds		save result and exit
* 'xor' - logcal exclusive or
	fcb	$80
	fcc	'rox'
	fdb	or
xor	ldd	,u++		get top of stack
	eora	,u		xor high byte
	eorb	1,u		xor low byte
	bra	savds		save result and exit
* 'com' - complement operand
	fcb	$80
	fcc	'moc'
	fdb	xor
com	com	,u		complement high byte
	com	1,u		complement low byte
	rts
* 'neg' - negate operand
	fcb	$80
	fcc	'gen'
	fdb	com
neg	bsr	com		complement operand
	bra	onep		increment (two's complement)
* 'abs' - give absolute value of operand
	fcb	$80
	fcc	'sba'
	fdb	neg
abs	ldd	,u		get value from stack
	bmi	neg		negative, convert
	rts
* '2-' - decrement by two
	fcb	$80
	fcc	'-2'
	fdb	abs
twom	ldd	,u		get top of stack
	subd	#2		decrement by two
savds	std	,u		resave top of stack
	rts
* '2+' - increment by two
	fcb	$80
	fcc	'+2'
	fdb	twom
twop	ldd	,u		get top of stack
	addd	#2		increment by two
	bra	savds		resave top of stack
* '1-' - decrement by one
	fcb	$80
	fcc	'-1'
	fdb	twop
onem	ldd	,u		get top of stack
	subd	#1		decrement by one
	bra	savds		resave top of stack
* '1+' - increment by one
	fcb	$80
	fcc	'+1'
	fdb	onem
onep	ldd	,u		get top of stack
	addd	#1		increment by one
	bra	savds		resave top of stack
* 'skip' - advance input pointer to non-blank
	fcb	$80
	fcc	'piks'
	fdb	onep
qskip	ldy	inptr+3		get current position in input buffer
qski1	lda	,y+		get character from input buffer
	cmpa	#' '		is it a space
	beq	qski1		yes, keep going
	leay	-1,y		backup to it
	sty	inptr+3		resave input pointer
	tsta			test for end of line
	rts
*
* subroutine to lookup words in dictionary from input line
* on exit: 'z' is set if word not found
*	if word is found ('z'=0), its address is stacked on the
*	data stack, and the word descriptor byte is returned in
*	the 'a' accumulator
*
lookup	pshs	x,y		save registers
	bsr	qskip		advance to word
	sty	lstlok		save incase error
	ldx	here+3		get start of dictionary
* scan dictionary, looking for word
lok1	pshs	x		save current address
	leax	-2,x		backup past preceding address
lok2	lda	,-x		get character from name
	bmi	lok3		decreiptor byte, start of word
	cmpa	,y+		does it match input buffer?
	beq	lok2		yes, keep matching till end of word
lok5	puls	x		restore pointer
	ldx	,--x		get address of previous word
	beq	lok4		end of dictionary, quit
	ldy	inptr+3		restore input pointer
	bra	lok1		try for this word
lok3	ldb	,y		get net char from input stream
	bsr	tsterm		is it a terminator?
	bne	lok5		no, word does not match
	puls	a,b		restore address of word
	std	,--u		save on stack
	bsr	qski1		skip to next non-blank
	lda	,x		get descriptor byte
	andcc	#$fb		clear 'z' flag
lok4	puls	x,y,pc
* routine to test for terminator character
tsterm	cmpb	#' '		is it a space?
	beq	tster1		yes, its ok
	tstb			is it null (end of line)?
tster1	rts
* ''' - tick: return address of a word
	fcb	$81
	fcc	/'/
	fdb	qskip
tick	bsr	lookup		look up word
	bne	tster1		found, return
	lbra	lokerr		word not found, cause error
	fcb	$80
	fcc	'cexe'
	fdb	tick
exec	jmp	[,u++]		execute at address on [tos]
* 'number' - get number from input stream in current base
	fdb	$80
	fcc	'rebmun'
	fdb	exec
number	pshs	x,y		save regs
	lbsr	qskip		advance to next word in input stream
	cmpa	#'-'		is it a negative number?
	pshs	cc		save flags fo later test
	bne	num4		no, not negative
	leay	1,y		skip '-' sign
num4	clra			start off
	clrb			with a zero result
	pshu	a,b		save on stack
num2	ldb	,y+		get char from souce
	subb	#'0'		convert to binary
	cmpb	#9		is it numeric digit?
	bls	num1		yes, its ok
	andb	#$df		smash case
	subb	#7		convert from alpha
	cmpb	#$0a		is it a valid number?
	blo	num3		no, cause error
num1	clra			zero high byte
	cmpd	base+3		are we within range of current base
	bhs	num3		no, cause error
	pshs	a,b		save number
	ldd	base+3		get base
	pshu	a,b		stack
	jsr	mult		perform multiply (old value already on data stack)
	puls	a,b		get new digit back
	addd	,u		add to old value
	std	,u		resave old value
	ldb	,y		get next character from number
	lbsr	tsterm		is it a terminator
	bne	num2		no, keep evaluating number
	sty	inptr+3		resave input pointer
	puls	cc,x,y		restore registers
	bne	num5		no negative, don't negate
	jsr	neg		negate value
num5	lbra	one		return true (success)
num3	puls	cc,x,y		clean up stack
	lbra	zero		return false (failure)
* 'space' - display a space on general output
	fcb	$80
	fcc	'ecaps'
	fdb	number
space	ldb	#' '		get a space
	pshu	a,b		placeon data stack
	jmp	emit		output
* 'cr' - display carriage-return, line-feed on general output
	fcb	$80
	fcc	'rc'
	fdb	space
cr	ldd	#$0d		get carriage return
	pshu	a,b		place on stack
	jsr	emit		output to general output
	ldb	#$0a		get line-feed
	pshu	a,b		place on stack
	jmp	emit		output to general output
* 'read' - read a line from input device
	fcb	$80
	fcc	'daer'
	fdb	cr
read	bsr	cr		new line
readnc	ldy	#inpbuf		point to input buffer
read1	jsr	key		get a key
	cmpb	#$0d		is it carriage return?
	beq	rdcrlf		yes, exit
	cmpb	#$0a		is it newline?
	beq	rdcrlf
	cmpb	#$08		is it backspace?
	beq	rdbksp
	cmpb	#$7f		is it delete?
	beq	rdbksp		
* normal key
	stb	,y+		save key in buffer
	jsr	emit		echo key
	bra	read1		go back for another
* delete key, delete previous character
rdbksp	leau	2,u		remove keycode from stack
	leay	-1,y		backup up input buffer pointer
	cmpy	#inpbuf		past beginning?
	blo	read		if so, re-initiate read
	ldx	#delmsg		point to delete message
	bsr	pmsg1		display
	bra	read1		go back for next key

* carriage return, terminate input
rdcrlf	leau	2,u		remove keycode from stack
	clr	,y		indicate end of input line
	ldy	#inpbuf		point to input buffer
	sty	inptr+3		set up input buffer pointer
pmsg2	rts
* '.msg' - display message, address on stack
	fcb	$80
	fcc	'gsm.'
	fdb	read
pmsg	ldx	,u++		get address
pmsg1	ldb	,x+		get character from message
	beq	pmsg2		end of message, exit
	pshu	a,b		save on stack
	jsr	emit		output to general output
	bra	pmsg1		get next character
* '.wrd' - display a word on general output (string)
	fcb	$80
	fcc	'drw.'
	fdb	pmsg
pwrd	ldx	,u++		get address of word
pwrd1	ldb	,x+		get character from word
	lbsr	tsterm		is it a terminator?
	beq	pmsg2		yes, quit
	pshu	a,b		save data on stack
	jsr	emit		output to general output
	bra	pwrd1		get next word
* 'quit - general command interpreter, used to terminate words
	fcb	$80
	fcc	'tiuq'
	fdb	pwrd
quit	jsr	rpfix		reset return stack
	ldx	#prompt		point to prompt
	bsr	pmsg1		display prompt
	lbsr	readnc		read a line of input
	jsr	space		seperate by a space
qui1	jsr	qskip		adance to non-blank
	beq	quit		null line, do nothing
	jsr	lookup		look up word
	beq	qui2		not found, try number
	bita	#$02		ok to execute interactivly?
	bne	conerr		no, force error
	jsr	[,u++]		execute word
	andcc #$bf		FIXME EVIL HACK nmi routine comes back with FIRQ disabled
	cmpu	#dstack		did stack underflow?
	bls	qui1		no, keep interpreting
	bsr	error		generate error message
	fccz	'stack empty'
* not a word, try for number
qui2	jsr	number		try for number
	ldd	,u++		get flag byte
	beq	lokerr		not a number. indicate not found
	bra	qui1		keep interpreting
* subroutine to generate error message, first displays 'error:' message,
* then name of last word processed, then error message text
error	ldx	#ermsg1		; get pointer to error message prefix
	bsr	pmsg1		display prefix
	ldx	lstlok		get address of last word from input buffer
	bsr	pwrd1		display word
	ldx	#ermsg2		; point to error message suffix
	bsr	pmsg1		display suffix
	ldx	,s++		get address of error message
	bsr	pmsg1		display message
	jsr	spfix		reset data stack
	bra	quit		and enter command intrepreter
* word was not found in the dictionary
lokerr	bsr	error		generate error message
	fccz	'not found'
* word can not be executed interactively
conerr	bsr	error		generate error message
	fccz	'cannot execute'
* '>r' - move word from data to return stack
	fcb	$80
	fcc	'r>'
	fdb	quit
tor	ldx	,s		get return address
	ldd	,u++		get data from data stack
	std	,s		place on return stack
	tfr	x,pc		return to caller
* '<r' - move word from return stack to data stack
	fcb	$80
	fcc	'r<'
	fdb	tor
fromr	ldx	,s++		get return address
	ldd	,s++		get data from return stack
	std	,--u		place on data stack
	tfr	x,pc		return to caller
* 'rp!' - reset return stack
	fcb	$80
	fcc	'!pr'
	fdb	fromr
rpfix	puls	a,b		get return address
	lds	#rstack		reset return stack
	tfr	d,pc		return to caller
* 'sp!' - reset data stack
	fcb	$80
	fcc	'!ps'
	fdb	rpfix
spfix	ldu	#dstack		reset data stack
voc9	rts
* ''s' - obtain stack address
	fcb	$80
	fcc	/s'/
	fdb	spfix
tics	stu	,--u		save data stack pointer
	rts
* 'vlist' - display words in dictionary
	fcb	$80
	fcc	'tsilv'
	fdb	tics
voc	ldx	here+3		get address of start of dictionary
voc1	jsr	cr		new line
	clra			zero character count
voc2	pshs	a,x		save count, current position
	leax	-2,x		backup to word name
voc3	ldb	,-x		get character from word name
	bmi	voc4		descriptor byte, end of name
	pshu	a,b		save on data stack
	jsr	emit		output to general output
	inc	,s		increment character count
	bra	voc3		keep outputing
voc4	jsr	space		seperate with a space
	puls	a,x		restore character count, position in dictionary
	inca			advance character count for space
	ldx	,--x		get address of next word
	beq	voc9		end of dictionary, exit
	cmpa	#width		are we beyond terminal width?
	blo	voc2		no, its ok
	bra	voc1		continue on new line
* 'bye' - exit forth
	fcb	$80
	fcc	'eyb'
	fdb	voc
bye	nop
* gjcp - fixme ssr
*	ssr	22		new line
*	ssr	0		exit to system
	jsr	cr
	lda	#$00
	swi

* 'forget' - remove one or more words from dictionary
	fcb	$80
	fcc	'tegrof'
	fdb	bye
forget	jsr	tick		locate words address
	pulu	x		get address
	cmpx	#usrspc		is it in kernal dictionary?
	blo	proerr		if so, can't be forgotton
	ldd	,--x		get address of previous word
	std	here+3		new dictionary start
forg1	lda	,-x		get character from name
	bpl	forg1		keep going till we find descriptor byte
	stx	free+3		new free space for dictionary
	rts
* word is protected, can't 'forget' it
proerr	lbsr	error		generate error message
	fccz	'protected'
* 'create' - create new word in dictionary
	fdb	$80
	fcc	'etaerc'
	fdb	forget
create	ldy	inptr+3		get input buffer position
	lbsr	lookup		see if it already exists
	beq	cre1		no, its ok
	leau	2,u		remove address of existing word
	ldx	#redmsg		point to redefinition message
	lbsr	pmsg1		output message
	tfr	y,x		point to word we are re-defining
	lbsr	pwrd1		output word to general output
cre1	lbsr	qski1		advance to next non-blank, save pointer
	lda	#$ff		start with count of -1
cre3	ldb	,y+		get character from word
	inca			advance word size count
	lbsr	tsterm		terminator character
	bne	cre3		look till we find end
	leay	-1,y		backup to last char
	sty	inptr+3		save new buffer position
	ldx	free+3		get address of free dictionary space
	ldb	#$80		get default descriptor byte
	stb	,x+		save in dictionary
cre2	ldb	,-y		get character from name
	stb	,x+		save in dictionary
	deca			reduce count of name length
	bne	cre2		move all of name into dictionary
	ldd	here+3		get address of previous entry
	std	,x++		save in dictionary
	stx	here+3		save new starting address
	stx	free+3		save new free space address
	rts
* 'allot' - allocate some space in the dictionary
	fcb	$80
	fcc	'tolla'
	fdb	create
allot	ldd	free+3		get address of free dictioanry space
	addd	,u++		offset by number of bytes requested
	std	free+3		resave new free pointer
	rts
* 'variable' - create a variable
	fcb	$80
	fcc	'elbairav'
	fdb	allot
var	bsr	create		create the variable name
	lda	#$bd		get a 'jsr' extended instruction
	sta	,x+		insert into dictionary
	ldd	#variab		get address of variable subroutine
	std	,x++		insert into dictionary
	ldd	,u++		get default variable value
	std	,x++		save into dictionary
	stx	free+3		set new free pointer
	rts
* ';' - end a colon definition, terminate compiling
	fcb	$83
	fcc	';'
	fdb	var
semi	ldd	-2,x		get last instruction complied
	cmpd	#$3606		is it 'pshu a,b'?
	beq	semi1		if so, its ok
	lda	-3,x		get instruction from dictionary
	cmpa	#$bd		is it 'jsr >'?
	bne	semi1		no, its ok
* convert 'jsr' followed by 'rts' to simple 'jmp'
	lda	#$7e		get 'jmp >' instruction
	sta	-3,x		save in dictionary
	bra	semi2		terminate compiling
semi1	lda	#$39		get 'rts' instruction
	sta	,x+		save in dictionary
semi2	stx	free+3		resave free pointer
	jmp	quit		re-enter command interpreter
* ':' - colon definition, begin compliing
	fcb	$84
	fcc	':'
	fdb	semi
colon	jsr	create		create new word
col1	jsr	qskip		advance to non-blank
	bne	col11		not end of line, its ok
	jsr	read		read another line (no semicolon yet)
	bra	col1		and continue scanning
*we have a word, compile into present definition
col11	lbsr	lookup		lookup word
	bne	col2		found, we have it
	jsr	number		try it as a number
	ldd	,u++		get flag
	lbeq	lokerr		number failed, its an error
* number to be compiled into dictionary
col12	bsr	brcl		compile literal value
	bra	col1		and keep scanning
* word to be compiled into dictionary
col2	bita	#$04		is it ok to compile?
	bne	interr		no, force error
	bita	#1		does it execute on compilation?
	beq	col3		no, normal word
	stu	temp		save stack pointer
	ldx	free+3		get free adress for ec functions
	jsr	[,u++]		execute word
	cmpu	temp		did it leave exactly one word on the stack?
	bne	col1		no, continue scanning
	bra	col12		special case, compile word as literal
* normal word, compile as word call
col3	bsr	comp1		compile call to word
	bra	col1		and keep scanning
* non-compile word encountered
interr	lbsr	error		generate error mesage
	fccz	'cannot compile'
* '[cr]' - compile a return instruction
	fcb	$82
	fcc	']rc['
	fdb	colon
brcr	ldx	free+3		get free address
	ldb	#$39		get 'rts' instruction
	bra	brc11		place into dictionaty
* '[cl]' - compile a literal value
	fcb	$82
	fcc	']lc['
	fdb	brcr
brcl	ldx	free+3		get free addres
	lda	#$cc		get 'ldd #' instruction
	sta	,x+		place in dictionary
	ldd	,u++		get data value
	std	,x++		place in dictionat
	ldd	#$3606		get 'pshu a,b' instruction
	bra	comp3		place in dictionary
* '[cw]' - compile call to a word into the dictionary
	fcb	$82
	fcc	']wc['
	fdb	brcl
brcw	ldx	free+3		get free address
	bra	comp1		compile into dictionry
* '[c2]' - compile a two byte (word) value into the dictionary
	fcb	$82
	fcc	']2c['
	fdb	brcw
brc2	ldx	free+3		get free address
	bra	comp3		compile two byte value
* '[c1]' - compile a single byte value into the dictionary
	fcb	$82
	fcc	']1c['
	fdb	brc2
brc1	ldx	free+3		get free address
	ldd	,u++		get value to compile
brc11	stb	,x+		place in dictionary
	bra	comp4		resave free pointer
* '[fc]' - force compilation of next word, even if normaly auto-exec
	fcb	$83
	fcc	']cf['
	fdb	brc1
brcf	jsr	tick		lookup word address
	bita	#$04		can it be compiled?
	bne	interr		no, get upset
* compile call to a word into dictionary
comp1	lda	#$bd		get 'jsr >' instruction
	sta	,x+		write to dictionary
comp2	ldd	,u++		get value from date stack
comp3	std	,x++		write to dictionary
comp4	stx	free+3		resave free pointer
	rts
* '[ni]' - cause last (or currently) compiled word to be non-interactive
	fcb	$81
	fcc	']in['
	fdb	brcf
brni	ldb	#2		get [ni] bit
	bra	setbit		set bit in descriptor byte
* '[nc]' - cause last (or currently) compiled word to be non-compiling
	fcb	$81
	fcc	']cn['
	fdb	brni
brnc	ldb	#4		get [nc] bit
	bra	setbit		set bit in descriptor byte
* '[ec]' - cause last (or currently) compiled word to execute when compiled
	fcb	$81
	fcc	']ce['
	fdb	brnc
brec	ldb	#1		get [ec] bit
* set a bit in the descriptor byte for last word in dictionary
setbit	ldy	here+3		get address of last word in dictionary
	leay	-2,y		backup to name
setb1	lda	,-y		get char from name
	bpl	setb1		keep reading till we get descriptor byte
	pshs	b		save bit to add
	ora	,s+		include bit in descriptor byte
	sta	,y		resave new descriptor
	rts
* 'exec>' - compile jump to remainder of this word into new word
	fcb	$82
	fcc	'>cexe'
	fdb	brec
does	ldx	free+3		get address of free dictionary
	lda	#$7e		get 'jmp >' instruction
	sta	,x+		save in dictionary
	puls	a,b		get address of remainder of this word
	bra	comp3		compile into dictionary
* '(' - brace, start of comment
	fcb	$81
	fcc	'('
	fdb	does
brace	ldy	inptr+3		get input pointer
brac1	lda	,y+		get data from buffer
	beq	brac3		end of line
	cmpa	#')'		is it closing brace?
	beq	brac2		yes, exit
	cmpa	#'('		is it nested opening brace?
	bne	brac1		no, its ok
	bsr	brac1		recurse
	bra	brac1		and keep looking
* end of line, with no closing comment
brac3	jsr	read		read another line
	bra	brace		and keep looking
brac2	sty	inptr+3		resave input pointer
	rts
* 'leave' - exit innermost do loop
	fcb	$82
	fcc	'evael'
	fdb	brace
leave	ldd	4,s		get loop limit
	std	2,s		set index to same value
	rts
* '+loop' - loop with value to add
	fcb	$83
	fcc	'pool+'
	fdb	leave
ploop	pulu	a		get structure type
	cmpa	#$81		is it do loop?
	bne	nsterr		no, nesting error
	ldd	#$ec62		'ldd 2,s'
	std	,x++		compile into dictionary
	ldd	#$e3c1		'addd ,u++'
	std	,x++		compile
	lda	#$ed		'std 2,s'
	sta	,x+		compile
	bra	loop1		end terminate normally
* 'loop' - normal do loop
	fcb	$83
	fcc	'pool'
	fdb	ploop
loop	pulu	a		get structure type
	cmpa	#$81		is it do loop?
	bne	nsterr		no, nesting error
	ldd	#$ec62		'ldd 2,s'
	std	,x++		place in dictionary
	ldd	#$c300		'addd #1'
	std	,x++		place in dictionary
	ldd	#$01ed		'std 2,s'
	std	,x++		place in dictionary
loop1	ldd	#$6210		; < catchup > (postbyte for std, prefix for cmpd)
	std	,x++		save in dictionary
	ldd	#$a3e4		'cmpd ,s'
	std	,x++		compile
	ldd	#$1025		'lblo'
	lbsr	unt1		calculate offset value and compile
	ldd	#$3264		'leas 4,s'
	std	,x++		compile
comret	stx	free+3		save new free pointer
	rts
* 'k' - third index value for do loop
	fcb	$80
	fcc	'k'
	fdb	loop
k	ldd	12,s		get index value
	bra	ijk		save it
* 'j' - second indev value for do loop
	fcb	$80
	fcc	'j'
	fdb	k
j	ldd	8,s		get index value
	bra	ijk		save it
* 'i' first index value for do loop
	fcb	$80
	fcc	'i'
	fdb	j
i	ldd	4,s		get index value
ijk	std	,--u		save on stack
	rts
* structure is nested improperly
nsterr	lbsr	error		generate error message
	fccz	'improper nesting'
* 'do' - start of do loop construct
	fcb	$83
	fcc	'od'
	fdb	i
do	lda	#$bd		get 'jsr >' instruction
	sta	,x+		compile into dictionary
	ldy	#tor		address of '>r' word
	sty	,x++		compile into dict
	sta	,x+		and another 'jsr >'
	sty	,x++		for another '>r'
	lda	#$81		indicate do loop
	pshu	a,x		save pgm counter etc
	bra	comret		resave free pointer
* 'forever' - begin loop forever
	fcb	$83
	fcc	'reverof'
	fdb	do
foreve	pulu	a,y		get loop construct identifier
	cmpa	#$80		was it a begin loop?
	bne	nsterr		no, improper nesting
	lda	#$7e		'jmp >' instruction
	sta	,x+		place in dictionary
	sty	,x++		include address to loop to
	bra	comret		resave free pointer
* 'until' - conditional begin loop
	fcb	$83
	fcc	'litnu'
	fdb	foreve
until	pulu	a		get structure identifier
	cmpa	#$80		is it a begin loop?
	bne	nsterr		no, bad nesting
	ldd	#$ecc1		'ldd ,u++'
	std	,x++		save in dictionary
	ldd	#$1027		'lbeq'
* compile long branch, and calculate offset from address on stack
unt1	std	,x++		save in dictionary
	leax	2,x		get current address
	pshs	x		save on stack
	pulu	a,b		get address to jump to
	subd	,s++		calculate offset
	std	-2,x		compile into dictionary
comr1	lbra	comret		resave free pointer
* 'while' - conditional begin loop
	fcb	$83
	fcc	'elihw'
	fdb	until
while	pulu	a		get structure identifier
	cmpa	#$80		is it a begin loop?
	bne	nsterr		no, improper nesting
	ldd	#$ecc1		'ldd ,u++'
	std	,x++		compile into dictionary
	ldd	#$1026		'lbne'
	bra	unt1		compile into dict with offset
* 'begin' - start a begin loop
	fcb	$83
	fcc	'nigeb'
	fdb	while
begin	lda	#$80		begin loop identifier
	pshu	a,x		save it and current position
	rts
* 'endif' - end an if statement
	fcb	$83
	fcc	'fidne'
	fdb	begin
endif	pulu	a		get structure identifier
	cmpa	#$82		is it 'if'?
	lbne	nsterr		no, bad nesting
	ldy	,u		get address
	tfr	x,d		get current free address
	subd	,u++		calculate offset
	std	-2,y		save in branch operand
	rts
* 'else' - else clause to an if statement
	fcb	$83
	fcc	'esle'
	fdb	endif
else	lda	#$16		'lbra'
	sta	,x+		compile into dictionary
	leax	2,x		skip to next free
	pshs	x		save address
	bsr	endif		compile in branch
	puls	x		restore address
	bra	if1		set up new if jumps
* 'if' - if condition
	fcb	$83
	fcc	'fi'
	fdb	else
if	ldd	#$ecc1		'ldd ,u++'
	std	,x++		compile
	ldd	#$1027		'lbeq'
	std	,x++		compile
	leax	2,x		advance to free
if1	lda	#$82		indicate if structure
	pshu	a,x		save with address on stack
comr2	lbra	comret		resave free pointer
* '."' display message on terminal
	fcb	$83
	fcc	'".'
	fdb	if
dotq	bsr	quote		compile string
	lda	#$bd		'jsr >'
	sta	,x+		compile into dict
	ldd	#pmsg		display message
	std	,x++		compile into dict
	bra	comr2		resave free pointer
* '"' - compile string into dictionary
	fcb	$83
	fcc	'"'
	fdb	dotq
quote	lda	#$8d		'bsr' instruction
	sta	,x++		compile into dict
	jsr	qskip		advance to non-blank
	pshs	x		save pointer
quo1	lda	,y+		get data from input buffer
	beq	unterr		end of line, error
	cmpa	#'"'		is it closing quote?
	beq	quo2		yes, exit
	sta	,x+		save in string
	bra	quo1		and keep processing
quo2	sty	inptr+3		save new input buffer pointer
	clr	,x+		indicate end of string
	ldy	,s		get address of bsr operand
	tfr	x,d		get current address
	subd	,s++		calculate offset for bsr
	stb	-1,y		save in operand
	lda	#$bd		'jsr >'
	sta	,x+		compile into dict
	ldd	#fromr		get '>r' address
	std	,x++		compile
	bra	comr2		resave free pointer
* unterminated string
unterr	lbsr	error		generate error message
	fccz	'unterminated'
* '0' - quicker zero
	fcb	$80
	fcc	'0'
	fdb	quote
zero	clra			zero high byte
	clrb			zero low byte
	std	,--u		save on data stack
	rts
* '1' - quicker one
	fcb	$80
	fcc	'1'
	fdb	zero
one	ldd	#1		get a value of one
	std	,--u		save on stack
	rts
*
* variables
*
* '(out)' - address of general output driver
	fcb	$80
	fcc	')tuo('
	fdb	one
disp	jsr	variab		variable subroutine
	fdb	dolout		default is '$out'
* '(in)' - address of general input driver
	fcb	$80
	fcc	')ni('
	fdb	disp
inpt	jsr	variab		variable subroutine
	fdb	dolin		default is '$in'
* '(go)' - address of word to execute at startup
	fcb	$80
	fcc	')og('
	fdb	inpt
boot	jsr	variab		variable subroutine
	fdb	quit		default is 'quit'
* '>in' - pointer to position in input buffer
	fcb	$80
	fcc	'ni>'
	fdb	boot
inptr	jsr	variab		variable subroutine
	fdb	inpbuf		default is start of buffer
* 'base' - current number conversion base
	fcb	$80
	fcc	'esab'
	fdb	inptr
base	jsr	variab		variable subroutine
	fdb	16		default is base 10
* 'free' - address of free memory following dictionary
	fcb	$80
	fcc	'eerf'
	fdb	base
free	jsr	variab		variable subroutine
	fdb	usrspc		default is end of dictionary

* 'reboot' - reboot the system
* 'ospanic' - show OS panic error and reboot
	fcb $80
	fcc 'toober'
	fdb free
reboot	jmp $fc7f
	fcb $80
	fcc 'cinapso'
	fdb reboot
ospanic	jmp $fc91

* 'setfilter' - take filter, cutoff, resonance and use ROM to poke filter
	fcb $80
	fcc 'retliftes'
	fdb ospanic
setfilter
	pshs x
	ldd ,u++	voice
	clra
	andb #$07	only eight of 'em
	pshs d
	puls x		get it in X
	ldd ,u++	resonance
	stb $e408,x
	ldd ,u++	cutoff
	stb $e410,x
	puls x
	rts
* motor
	fcb $80
	fcc 'rotom'
	fdb setfilter
motor	ldd ,u++	; on, off
	bitb #$01
	beq motor1
	jmp $f4c6	; rom motor on
	
motor1	jmp $f4d6
	rts
* seektrk
	fcb $80
	fcc 'krtkees'
	fdb motor
seektrk
	ldd ,u++	; unstack track
	stb $8002
	jsr $f06f
	andcc #$bf
	rts
* loadsec
	fcb $80
	fcc 'cesdaol'
	fdb seektrk
loadsec	ldd ,u++
	std $8004	load address
	ldd ,u++
	stb $8003	sector
	ldd ,u++
	stb $8002	track
	orcc #$55
	lda #$7f	
	jsr $f06f
	jsr $f448
	stx ,--u
	andcc #$bf
	rts
* savesec
	fcb $80
	fcc 'cesevas'
	fdb loadsec
savesec	ldd ,u++
	std $8004	load address
	ldd ,u++
	stb $8003	sector
	ldd ,u++
	stb $8002	track
	orcc #$55
	lda #$7f	
	jsr $f06f
	jsr $f476
	stx ,--u
	andcc #$bf
	rts
	
	fcb $80
	fcc 'cdadr'
	fdb savesec
rdadc	
	pshs u
	ldu #$b050
	ldx #$e418
	ldb #$10
	jsr $f571
	puls u
	rts

	fcb $80
	fcc 'enut'
	fdb rdadc
tune
	pshs y
	ldd ,u++
	ldx #$e418
	ldy #$0
	jsr $f5be
	sty ,--u
*	jsr $f5dc
	puls y
	rts
	
* 'here' - address of last word in dictionary
	fcb	$80
	fcc	'ereh'
	fdb	tune
here	jsr	variab		variable subroutine
	fdb	here		default is itself
* dictionary grows from here
usrspc	equ	*
