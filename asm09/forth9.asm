**************************************************
*                                                *
*               forth for the 6809               *

* Adapted for the Ensoniq Mirage from original code
* from windforth.zip

* the Mirage has 32K sample pages from $0000 to $7fff
* and 16K of OS RAM from 0x8000 to $0xbfff

* many assumptions must be changed in this code, because
* it is supposed to be run from ROM with certain things
* copied to a small amount of RAM.  Obviously on the Mirage
* everything is in RAM.



*    forth register assignments                  *
*                                                *
*    forth  6809     forth preservation rules    *
*    -----  ----     ------------------------    *
*                                                *
*    ip      y       interpreter pointer.        *
*                    must be preserved           *
*                    across forth words.         *
*                                                *
*    w       x       word pointer                *
*                                                *
*    sp      u       parameter stack pointer.    *
*                    must be preserved across    *
*                    forth words.                *
*                                                *
*    rp      s       return stack.               *
*                    must be preserved across    *
*                    forth words.                *
*                                                *
*           release and version numbers          *
*                                                *
**************************************************
figrel  equ   1
figrev  equ   0
usrver  equ   0

**************************************************
*                                                *
*            ascii characters used               *
*                                                *
**************************************************
abl     equ   $0020          ; a blank
acr     equ   $00d0          ; a carriage return
adot    equ   $002e          ; a period
bell    equ   $0007          ; a bell (^g)
bsin    equ   $005f          ; an input delete
bsout   equ   $0008          ; a output backspace
dle     equ   $0010          ; (^p)
lf      equ   $00a0          ; a line feed
ff      equ   $00c0          ; a form feed

**************************************************
*                                                *
*               memory allocation                *
*                                                *
**************************************************
rams    equ   $8000          ; start of ram
em      equ   $b000          ; end of ram + 1
nscr    equ   $0000          ; number of 1024 byte screens
kbbuf   equ   $0080          ; data bytes per disk buffer
us      equ   $0040          ; user variable space
rts     equ   $00a0          ; return stack and terminal buffer
co      equ   $0084          ; data bytes per buffer plus 4
nbuf    equ   $0000          ; number of buffers
buf1    equ   $b000          ; first disk buffer
initr0  equ   buf1-us        ; base of return stack
inits0  equ   initr0-rts     ; base of parameter stack

aciac   equ   $e100          ; acia control
aciad   equ   $e101          ; acia data

**************************************************
*                                                *
*             start of forth             *
*                                                *
**************************************************
	org $800e
	jmp orig

        org   $8100
orig    lda   #$03           ; configure the acia
        sta   aciac
        lda   #$16
        sta   aciac
        ldy   #entry
        lds   #$c000         ; initial stack pointers
        ldu   #$bf00
        ldx   ,y++           ; set up is done, now do forth
        jmp   [,x++]
entry   fdb   cold

**************************************************
*                                                *
*                initial user table              *
*                                                *
**************************************************
top     fdb   rtask-7        ; top word in forth vocabulary
utable  fdb   inits0         ; initial parameter stack base
        fdb   initr0         ; initial return stack base
        fdb   inits0         ; initial tib
        fdb   32             ; initial width
        fdb   0              ; initial warning
        fdb   initdp         ; initial fence
        fdb   initdp         ; initial dp
        fdb   rforth+6       ; initial voc-link
up      fdb   initr0         ; initial user area pointer
rpp     fdb   initr0         ; initial return stack pointer

**************************************************
*                                                *
*           start of the forth dictionary        *
*                                                *
**************************************************
dp0     fcb   $83
        fcc   'li'
        fcb   $f4            ; 't'+$80
        fdb   $0000          ; lfa of zero indicates start of dictionary
lit     fdb   *+2
        ldd   ,y++           ; get literal
        pshu  d              ; push to user stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $87
        fcc   'execut'
        fcb   $e5
        fdb   lit-6
exec    fdb   *+2
        pulu  x              ; get cfa from parameter stack
        jmp   [,x++]         ; execute next

        fcb   $86
        fcc   'branc'
        fcb   $e8
        fdb   exec-10
bran    fdb   *+2
bran1   ldd   ,y             ; get offset value
        leay  d,y            ; add offset to instruction pointer
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $87
        fcc   '0branc'
        fcb   $e8
        fdb   bran-9
zbran   fdb   *+2
        pulu  d
        cmpd  #0             ; is top of stack zero?
        beq   bran1          ; yes, must branch
        leay  2,y            ; no, skip branch offset
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $86
        fcc   '(loop'
        fcb   $a9
        fdb   zbran-10
xloop   fdb   *+2
        ldd   #$0001         ; assume an increment of 1
xloo1   addd  0,s            ; add increment to loop index
        std   0,s            ; put the new index on the stack
        cmpd  2,s            ; compare index with limit
        blt   bran1          ; branch if index < limit
        leas  4,s            ; drop the index and the limit
        leay  2,y            ; skip the branch offset
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $87
        fcc   '(+loop'
        fcb   $a9
        fdb   xloop-9
xploo   fdb   *+2
        pulu  d              ; get the increment value
        bra   xloo1          ; go do loop

        fcb   $84
        fcc   '(do'
        fcb   $a9
        fdb   xploo-10
xdo     fdb   *+2
        pulu  d,x            ; get initial index and limit values
        pshs  x,d            ; push to system stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $e9
        fdb   xdo-7
ido     fdb   *+2
        ldd   0,s            ; get the index
        pshu  d              ; push it to the parameter stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $85
        fcc   'digi'
        fcb   $f4
        fdb   ido-4
digit   fdb   *+2
        clra                 ; clear high byte
        ldb   3,u            ; ascii digit is low byte of 2nd on the stack
        subb  #$30           ; convert to binary
        blo   digi2          ; not a number
        cmpb  #$0a           ; ascii 0-9?
        blo   digi1          ; yes, check against base
        cmpb  #$11           ; ascii a-z?
        blo   digi2          ; no, less than 'a'
        cmpb  #$2a
        bhi   digi2          ; no, greater than 'z'
        subb  #7             ; legal letter - convert to binary
digi1   cmpb  1,u            ; compare number to base (on top of stack)

        bhs   digi2          ; error if greater than or equal
        std   2,u            ; no error leave number on the stack
        ldd   #1             ; true flag
        std   0,u            ; put flag on top of stack
        bra   digi3          ; next
digi2   leau  2,u            ; adjust stack
        ldd   #0             ; false flag
        std   0,u            ; put it on the stack
digi3   ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $86
        fcc   '(find'
        fcb   $a9
        fdb   digit-8
pfind   fdb   *+2
        pshs  y              ; save ip
        pulu  x              ; lfa of first word in the dictionary search
pfin1   ldy   0,u            ; location of packed string (here)
        ldb   0,x            ; get dictionary word length
        tfr   b,a            ; save the length byte temporarily
        andb  #$3f           ; mask off the two highest bits
        cmpb  0,y            ; compare it with the packed string
        bne   pfin5          ; lengths don't match - get another word
pfin2   leax  1,x            ; ok so far - look at the text
        leay  1,y            ;
        ldb   0,x            ; get next character
        cmpb  0,y            ; compare with packed string
        beq   pfin2          ; ok so far - go on to next character
        andb  #$7f           ; doesn't match - toggle high bit
        cmpb  0,y            ; try again
        bne   pfin6          ; doesn't match - go get next word
pfin3   leax  5,x            ; we have an exact match - get pfa
        tfr   a,b            ; retrieve length byte
        clra                 ; d now contains the string length byte
        stx   0,u            ; replace location of packed string with pfa
        ldx   #1             ; boolean true flag
        pshu  d              ; put string length on the stack
        pshu  x              ; put boolean flag on the stack
pfin4   puls  y              ; restore ip
        ldx   ,y++           ; next
        jmp   [,x++]
pfin5   leax  1,x            ; skip character count
pfin6   tst   0,x+           ; test sign bit
        bpl   pfin6          ; keep looking - sign bit is not set
pfin7   ldx   0,x            ; get lfa
        cmpx  #0             ; if zero we're at the end of the dictionary
        bne   pfin1          ; look at next word - lfa in x
        stx   0,u            ; put a boolean false on the stack
        bra   pfin4          ; next

        fcb   $87
        fcc   'enclos'
        fcb   $e5
        fdb   pfind-9
encl    fdb   *+2
        pshs  y              ; save the ip
        pulu  d              ; terminator character is now in b
        ldx   0,u            ; get starting address, but keep it on the stack
        ldy   #-1            ; set counter
        leax  -1,x           ; decrement starting address
encl1   leay  1,y            ; increment counter
        leax  1,x            ; increment address
        cmpb  0,x            ; is character a terminator?
        beq   encl1          ; yes, continue looking
        pshu  y              ; character must be text, so push count offset
        tst   0,x            ; is the character a null?
        bne   encl2          ; no, continue
        tfr   y,x            ; copy counter
        leay  1,y            ; increment counter
        bra   encl5          ; do the push, get ip and do next
encl2   leay  1,y            ; increment counter
        leax  1,x            ; increment address
        cmpb  0,x            ; is the character a terminator?
        beq   encl4          ; yes, finish up
        tst   0,x            ; no, is it a null?
        bne   encl2          ; no, continue looking
encl3   tfr   y,x            ; counters are equal
        bra   encl5          ; do the push
encl4   tfr   y,x            ; copy counter
        leax  1,x            ; increment the counter
encl5   pshu  y,x            ; do the push
        puls  y              ; restore ip
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   'emi'
        fcb   $f4
        fdb   encl-10
emit    fdb   docol
        fdb   pemit
        fdb   one
        fdb   outt
        fdb   pstor
        fdb   semis

        fcb   $83
        fcc   'ke'
        fcb   $f9
        fdb   emit-7
key     fdb   docol
        fdb   pkey
        fdb   semis

        fcb   $89
        fcc   '?termina'
        fcb   $ec
        fdb   key-6
qterm   fdb   docol
        fdb   pqter
        fdb   semis

        fcb   $82
        fcc   'c'
        fcb   $f2
        fdb   qterm-12
cr      fdb   docol
        fdb   lit
        fdb   $0d
        fdb   pemit
        fdb   lit
        fdb   $0a
        fdb   pemit
        fdb   semis

        fcb   $85
        fcc   'cmov'
        fcb   $e5
        fdb   cr-5
cmove   fdb   *+2
        pshs  y              ; save the instruction pointer
        pulu  d              ; get the count
        addd  0,u            ; add it to the destination address
        pulu  x,y            ; destination in x, source in y
        pshu  d              ; put final destination addr. on stack
cmov1   lda   ,y+            ; do the move
        sta   ,x+
        cmpx  0,u            ; at the final destination?
        blt   cmov1          ; if not, continue
        leau  2,u            ; drop final destination from the stack
        puls  y              ; restore the instruction pointer
        ldx   ,y++           ; nex
        jmp   [,x++]

        fcb   $82
        fcc   'u'
        fcb   $aa
        fdb   cmove-8
ustar   fdb   *+2            ; unsigned multiplication subroutine
        ldd   0,u            ; get op2
        std   -2,s           ; save it just below the return stack
        ldd   2,u            ; get op1
        std   -4,s           ; save it also
        clr   0,u            ; clear high order word
        clr   1,u            ;
        lda   -3,s           ; get op1 low byte
        ldb   -1,s           ; get op2 low byte
        mul                  ; multiply
        std   2,u            ; save the first partial product on the stack
        lda   -4,s           ; get op1 high byte
        ldb   -1,s           ; get op2 low byte
        mul                  ; multiply
        addd  1,u            ; add to first partial product
        std   1,u            ; and update
        lda   -3,s           ; get op1 low byte
        ldb   -2,s           ; get op2 high byte
        mul                  ; multiply
        addd  1,u            ; add to second partial product
        std   1,u            ; and update
        bcc   nocary         ; check for a carry into high byte
        inc   0,u            ; add carry if neccesary
nocary  lda   -4,s           ; get op1 high byte
        ldb   -2,s           ; get op2 high byte
        mul                  ; multply
        addd  0,u            ; add to third partial product
        std   0,u            ; and update - result is on stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'u'
        fcb   $af
        fdb   ustar-5
uslas   fdb   *+2            ; 32 by 16 unsigned division routine
        ldd   0,u            ; get divisor
        cmpd  #0             ; check for a divide by zero
        bne   usla1          ; ok - continue
        ldd   #-1            ; trap a divide by zero
        leau  6,u            ; drop all data from stack
        pshu  d              ; set flags
        pshu  d              ;
        bra   usla4          ; next
usla1   lda   #32            ; set counter for 32 bit division
        pshu  a              ; 0,u is the counter - 1,u is the divisor
        ldd   3,u            ; 3,u and 5,u are the high and low words of
        clra                 ; the dividend
        clrb                 ;
usla2   asl   6,u            ; shift dividend and quotient
        rol   5,u
        rol   4,u
        rol   3,u
        rolb                 ; shift dividend into d register
        rola
        cmpd  1,u            ; is dividend greater than the divisor?
        blo   usla3          ; no, skip subtraction
        subd  1,u            ; yes, do subtraction
        inc   6,u            ; increment low byte quotient
usla3   dec   0,u            ; decrement counter
        bne   usla2          ; loop for a non-zero count
        ldx   5,u            ; now the remainder is in d, the quotient is at 5,u
        leau  7,u            ; drop data on the stack
        pshu  d              ; push remainder
        pshu  x              ; push quotient
usla4   ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'an'
        fcb   $e4
        fdb   uslas-5
andd    fdb   *+2
        pulu  d              ; get top of stack
        anda  0,u            ; and high order byte
        andb  1,u            ; and low order byte
        std   0,u            ; leave result on stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'o'
        fcb   $f2
        fdb   andd-6
orr     fdb   *+2
        pulu  d              ; get top of stack
        ora   0,u            ; or high order byte
        orb   1,u            ; or low order byte
        std   0,u            ; leave result on stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'xo'
        fcb   $f2
        fdb   orr-5
xorr    fdb   *+2
        pulu  d              ; get top stack
        eora  0,u            ; xor high order byte
        eorb  1,u            ; xor low order byte
        std   0,u            ; leave result on stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'sp'
        fcb   $c0
        fdb   xorr-6
spat    fdb   *+2
        tfr   u,d            ; get current parameter stack pointer
        pshu  d              ; put it on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'sp'
        fcb   $a1
        fdb   spat-6
spsto   fdb   *+2
        ldx   up             ; initial user pointer
        leax  6,x            ; point to location in user table
        ldu   0,x            ; get parameter stack pointer
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'rp'
        fcb   $c0
        fdb   spsto-6
rpat    fdb   *+2
        pshu  s              ; get current return stack pointer
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'rp'
        fcb   $a1
        fdb   rpat-6
rpsto   fdb   *+2
        ldx   up             ; initial user pointer
        leax  8,x            ; point to location in user table
        lds   0,x            ; get return stack pointer
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   ';'
        fcb   $f3
        fdb   rpsto-6
semis   fdb   *+2
        puls  y              ; fetch old ip
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $85
        fcc   'leav'
        fcb   $e5
        fdb   semis-5
leave   fdb   *+2
        ldd   0,s            ; get index
        std   2,s            ; store at limit
        ldx   ,y++           ; next
        jmp   [0,x]

        fcb   $82
        fcc   '>'
        fcb   $f2
        fdb   leave-8
tor     fdb   *+2
        pulu  d              ; get top of parameter stack
        pshs  d              ; push it to the return stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'r'
        fcb   $be
        fdb   tor-5
fromr   fdb   *+2
        puls  d              ; get top of return stack
        pshu  d              ; push it to the parameter stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $d2
        fdb   fromr-5
rr      fdb   ido+2          ; does the same as i

        fcb   $82
        fcc   '0'
        fcb   $bd
        fdb   rr-4
zequ    fdb   *+2
        pulu  d              ; get top of stack
        ldx   #1             ; assume true
        cmpd  #0             ; compare to zero
        beq   zeq1           ; see if assumtion is correct
        leax  -1,x           ; no, it is false
zeq1    pshu  x              ; leave flag
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   '0'
        fcb   $bc
        fdb   zequ-5
zless   fdb   *+2
        pulu  d              ; get top of stack
        ldx   #1             ; assume true
        cmpd  #0             ; compare to zero
        blt   zless1         ; check assumption
        leax  -1,x           ; no, it is false
zless1  pshu  x              ; leave flag
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $ab
        fdb   zless-5
plus    fdb   *+2
        pulu  d              ; get top of stack
        addd  0,u            ; add it to new top of stack
        std   0,u            ; put sum on top of stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'd'
        fcb   $ab
        fdb   plus-4
dplus   fdb   *+2
        clra                 ; clear a and the carry bit
        ldb   #4             ; do four bytes
        tfr   u,x            ; get a reference to the top of the stack
dplu1   lda   3,x            ; get a byte from d2
        adca  7,x            ; add it to a byte from d1 with the carry
        sta   7,x            ; update
        leax  -1,x           ; adjust x
        decb                 ; decrement counter
        bne   dplu1          ; loop if not done
        leau  4,u            ; adjust stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $85
        fcc   'minu'
        fcb   $f3
        fdb   dplus-5
minus   fdb   *+2
        clra
        clrb                 ; clear d
        subd  0,u            ; get twos complement in d
        std   0,u            ; update
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $86
        fcc   'dminu'
        fcb   $f3
        fdb   minus-8
dminu   fdb   *+2
        com   0,u            ; complement the high order bytes of
        com   1,u            ; the double number
        com   2,u            ;
        neg   3,u            ; twos complement the lowest byte
        bne   dmin1          ; and add carrys as needed
        inc   2,u            ;
        bne   dmin1          ;
        inc   1,u            ;
        bne   dmin1          ;
        inc   0,u            ;
dmin1   ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   'ove'
        fcb   $f2
        fdb   dminu-9
over    fdb   *+2
        ldd   2,u            ; get 2nd item on stack
        pshu  d              ; put it on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   'dro'
        fcb   $f0
        fdb   over-7
drop    fdb   *+2
        leau  2,u            ; adjust stack pointer
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   'swa'
        fcb   $f0
        fdb   drop-7
swap    fdb   *+2
        pulu  d              ; get top of stack
        pulu  x              ; get 2nd on stack
        pshu  d              ; top of stack is now 2nd
        pshu  x              ; 2nd is now top of stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $83
        fcc   'du'
        fcb   $f0
        fdb   swap-7
dup     fdb   *+2
        ldd   0,u            ; get top of stack
        pshu  d              ; push it back on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   '2du'
        fcb   $f0
        fdb   dup-6
tdup    fdb   *+2
        ldd   0,u            ; get high order word
        ldx   2,u            ; get low order word
        pshu  x,d            ; do the dup
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   '+'
        fcb   $a1
        fdb   tdup-7
pstor   fdb   *+2
        pulu  x              ; get address
        pulu  d              ; get increment
        addd  0,x            ; do addition
        std   0,x            ; store addition
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $86
        fcc   'toggl'
        fcb   $e5
        fdb   pstor-5
toggl   fdb   *+2
        pulu  d,x            ; get bit pattern in b, address in x
        eorb  0,x            ; do the toggle
        stb   0,x            ; replace byte
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $c0
        fdb   toggl-9
at      fdb   *+2
        ldd   [0,u]          ; fetch word pointed to by top of stack
        std   0,u            ; put word on the top of stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'c'
        fcb   $c0
        fdb   at-4
cat     fdb   *+2
        ldb   [0,u]          ; fetch byte pointed to by top of stack
        clra                 ; clear high order byte
        std   0,u            ; put word on the top of the stack
        ldx   ,y++           ; next
        jmp   [,x++]


        fcb   $82
        fcc   '2'
        fcb   $c0
        fdb   cat-5
tat     fdb   *+2
        pulu  x              ; get pointer
        ldd   2,x            ; get least significant word
        pshu  d              ; push it
        ldd   0,x            ; get most significant word
        pshu  d              ; push it
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $a1
        fdb   tat-5
store   fdb   *+2
        pulu  x              ; get address
        pulu  d              ; get word in d register
        std   0,x            ; store word at address
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'c'
        fcb   $a1
        fdb   store-4
cstor   fdb   *+2
        pulu  x              ; get address
        pulu  d              ; get byte in b register
        stb   0,x            ; store byte at address
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   '2'
        fcb   $a1
        fdb   cstor-5
tstor   fdb   *+2
        pulu  x              ; get address
        pulu  d              ; get most significant word
        std   0,x            ; store it
        pulu  d              ; get least significant word
        std   2,x            ; store it
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $c1
        fcb   $ba
        fdb   tstor-5
colon   fdb   docol
        fdb   qexec
        fdb   scsp
        fdb   curr
        fdb   at
        fdb   cont
        fdb   store
        fdb   creat
        fdb   rbrac
        fdb   pscod
docol   pshs  y              ; store ip
        leay  0,x            ; new ip = wp
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $c1
        fcb   $bb
        fdb   colon-4
semi    fdb   docol
        fdb   qcsp
        fdb   comp
        fdb   semis
        fdb   smudg
        fdb   lbrac
        fdb   semis

        fcb   $84
        fcc   'noo'
        fcb   $f0
        fdb   semi-4
noop    fdb   docol
        fdb   semis

        fcb   $88
        fcc   'constan'
        fcb   $f4
        fdb   noop-7
con     fdb   docol
        fdb   creat
        fdb   smudg
        fdb   comma
        fdb   pscod
docon   ldd   0,x            ; get data pointed to by wp
        pshu  d              ; push it on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $88
        fcc   'variabl'
        fcb   $e5
        fdb   con-11
var     fdb   docol
        fdb   con
        fdb   pscod
dovar   pshu  x              ; push the word pointer on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   'use'
        fcb   $f2
        fdb   var-11
user    fdb   docol
        fdb   con
        fdb   pscod
douse   ldd   up             ; get initial user pointer
        addd  0,x            ; add the offset
        pshu  d              ; put it on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $b0
        fdb   user-7
zero    fdb   docon
        fdb   0

        fcb   $81
        fcb   $b1
        fdb   zero-4
one     fdb   docon
        fdb   1

        fcb   $81
        fcb   $b2
        fdb   one-4
two     fdb   docon
        fdb   2

        fcb   $81
        fcb   $b3
        fdb   two-4
three   fdb   docon
        fdb   3

        fcb   $82
        fcc   'b'
        fcb   $ec
        fdb   three-4
bls     fdb   docon
        fdb   $20

        fcb   $83
        fcc   'c/'
        fcb   $ec
        fdb   bls-5
csll    fdb   docon
        fdb   64

        fcb   $85
        fcc   'firs'
        fcb   $f4
        fdb   csll-6
first   fdb   docon
        fdb   buf1

        fcb   $85
        fcc   'limi'
        fcb   $f4
        fdb   first-8
limit   fdb   docon
        fdb   em

        fcb   $85
        fcc   'b/bu'
        fcb   $e6
        fdb   limit-8
bbuf    fdb   docon
        fdb   kbbuf

        fcb   $85
        fcc   'b/sc'
        fcb   $f2
        fdb   bbuf-8
bscr    fdb   docon
        fdb   $08

        fcb   $87
        fcc   '+origi'
        fcb   $ee
        fdb   bscr-8
porig   fdb   docol
        fdb   lit
        fdb   orig
        fdb   plus
        fdb   semis

*************************************************
*                                               *
*                 user variables                *
*                                               *
*************************************************
        fcb   $82
        fcc   's'
        fcb   $b0
        fdb   porig-10
szero   fdb   douse
        fdb   6

        fcb   $82
        fcc   'r'
        fcb   $b0
        fdb   szero-5
rzero   fdb   douse
        fdb   8

        fcb   $83
        fcc   'ti'
        fcb   $e2
        fdb   rzero-5
tib     fdb   douse
        fdb   10

        fcb   $85
        fcc   'widt'
        fcb   $e8
        fdb   tib-6
width   fdb   douse
        fdb   12

        fcb   $87
        fcc   'warnin'
        fcb   $e7
        fdb   width-8
warn    fdb   douse
        fdb   14

        fcb   $85
        fcc   'fenc'
        fcb   $e5
        fdb   warn-10
fence   fdb   douse
        fdb   16

        fcb   $82
        fcc   'd'
        fcb   $f0
        fdb   fence-8
dp      fdb   douse
        fdb   18

        fcb   $88
        fcc   'voc-lin'
        fcb   $eb
        fdb   dp-5
vocl    fdb   douse
        fdb   20

        fcb   $83
        fcc   'bl'
        fcb   $eb
        fdb   vocl-11
blk     fdb   douse
        fdb   22

        fcb   $82
        fcc   'i'
        fcb   $ee
        fdb   blk-6
inn     fdb   douse
        fdb   24

        fcb   $83
        fcc   'ou'
        fcb   $f4
        fdb   inn-5
outt    fdb   douse
        fdb   26

        fcb   $83
        fcc   'sc'
        fcb   $f2
        fdb   outt-6
scr     fdb   douse
        fdb   28

        fcb   $86
        fcc   'offse'
        fcb   $f4
        fdb   scr-6
ofset   fdb   douse
        fdb   30

        fcb   $87
        fcc   'contex'
        fcb   $f4
        fdb   ofset-9
cont    fdb   douse
        fdb   32

        fcb   $87
        fcc   'curren'
        fcb   $f4
        fdb   cont-10
curr    fdb   douse
        fdb   34

        fcb   $85
        fcc   'stat'
        fcb   $e5
        fdb   curr-10
state   fdb   douse
        fdb   36

        fcb   $84
        fcc   'bas'
        fcb   $e5
        fdb   state-8
base    fdb   douse
        fdb   38

        fcb   $83
        fcc   'dp'
        fcb   $ec
        fdb   base-7
dpl     fdb   douse
        fdb   40

        fcb   $83
        fcc   'fl'
        fcb   $e4
        fdb   dpl-6
fld     fdb   douse
        fdb   42

        fcb   $83
        fcc   'cs'
        fcb   $f0
        fdb   fld-6
cspp    fdb   douse
        fdb   44

        fcb   $82
        fcc   'r'
        fcb   $a3
        fdb   cspp-6
rnum    fdb   douse
        fdb   46

        fcb   $83
        fcc   'hl'
        fcb   $e4
        fdb   rnum-5
hld     fdb   douse
        fdb   48

*************************************************
*                                               *
*            end of user variables              *
*                                               *
*************************************************
        fcb   $82
        fcc   '1'
        fcb   $ab
        fdb   hld-6
onep    fdb   *+2
        ldd   0,u            ; get top of parameter stack
        addd  #1             ; increment top of parameter stack
        std   0,u            ; put word back on stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   '2'
        fcb   $ab
        fdb   onep-5
twop    fdb   *+2
        ldd   0,u            ; get top of parameter stack
        addd  #2             ; add 2
        std   0,u            ; put word back on stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $84
        fcc   'her'
        fcb   $e5
        fdb   twop-5
here    fdb   docol
        fdb   dp
        fdb   at
        fdb   semis

        fcb   $85
        fcc   'allo'
        fcb   $f4
        fdb   here-7
allot   fdb   docol
        fdb   dp
        fdb   pstor
        fdb   semis

        fcb   $81
        fcb   $ac
        fdb   allot-8
comma   fdb   docol
        fdb   here
        fdb   store
        fdb   two
        fdb   allot
        fdb   semis

        fcb   $82
        fcc   'c'
        fcb   $ac
        fdb   comma-4
ccomm   fdb   docol
        fdb   here
        fdb   cstor
        fdb   one
        fdb   allot
        fdb   semis

        fcb   $81
        fcb   $ad
        fdb   ccomm-5
subb    fdb   *+2
        ldd   2,u            ; get first value
        subd  0,u            ; do subtraction
        leau  2,u            ; adjust stack
        std   0,u            ; put difference on top of stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $81
        fcb   $bd
        fdb   subb-4
equal   fdb   docol
        fdb   subb
        fdb   zequ
        fdb   semis

        fcb   $81
        fcb   $bc
        fdb   equal-4
less    fdb   *+2
        pulu  d              ; get top of stack
        ldx   #0             ; assume a false
        cmpd  0,u            ; compare with new top of stack
        ble   less1          ; yes it is false
        leax  1,x            ; no it is true
less1   stx   0,u            ; leave flag on the stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $82
        fcc   'u'
        fcb   $bc
        fdb   less-4
uless   fdb   docol
        fdb   tdup
        fdb   xorr
        fdb   zless
        fdb   zbran
        fdb   ules1-*
        fdb   drop
        fdb   zless
        fdb   zequ
        fdb   bran
        fdb   ules2-*
ules1   fdb   subb
        fdb   zless
ules2   fdb   semis

        fcb   $81
        fcb   $be
        fdb   uless-5
great   fdb   docol
        fdb   swap
        fdb   less
        fdb   semis

        fcb   $83
        fcc   'ro'
        fcb   $f4
        fdb   great-4
rot     fdb   *+2
        pshs  y              ; save ip
        pulu  d,x,y          ; s1 in d, s2 in x, s3 in y
        pshu  d,x            ; put s1 and s2 back on stack
        pshu  y              ; put s3 on top of stack
        puls  y              ; restore ip
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $85
        fcc   'spac'
        fcb   $e5
        fdb   rot-6
space   fdb   docol
        fdb   bls
        fdb   emit
        fdb   semis

        fcb   $84
        fcc   '-du'
        fcb   $f0
        fdb   space-8
ddup    fdb   docol
        fdb   dup
        fdb   zbran
        fdb   ddup1-*
        fdb   dup
ddup1   fdb   semis

        fcb   $88
        fcc   'travers'
        fcb   $e5
        fdb   ddup-7
trav    fdb   docol
        fdb   swap
trav1   fdb   over
        fdb   plus
        fdb   lit
        fdb   $7f
        fdb   over
        fdb   cat
        fdb   less
        fdb   zbran
        fdb   trav1-*
        fdb   swap
        fdb   drop
        fdb   semis

        fcb   $86
        fcc   'lates'
        fcb   $f4
        fdb   trav-11
lates   fdb   docol
        fdb   curr
        fdb   at
        fdb   at
        fdb   semis

        fcb   $83
        fcc   'lf'
        fcb   $e1
        fdb   lates-9
lfa     fdb   docol
        fdb   lit
        fdb   4
        fdb   subb
        fdb   semis

        fcb   $83
        fcc   'cf'
        fcb   $e1
        fdb   lfa-6
cfa     fdb   docol
        fdb   two
        fdb   subb
        fdb   semis

        fcb   $83
        fcc   'nf'
        fcb   $e1
        fdb   cfa-6
nfa     fdb   docol
        fdb   lit
        fdb   5
        fdb   subb
        fdb   lit
        fdb   -1
        fdb   trav
        fdb   semis

        fcb   $83
        fcc   'pf'
        fcb   $e1
        fdb   nfa-6
pfa     fdb   docol
        fdb   one
        fdb   trav
        fdb   lit
        fdb   5
        fdb   plus
        fdb   semis

        fcb   $84
        fcc   '!cs'
        fcb   $f0
        fdb   pfa-6
scsp    fdb   docol
        fdb   spat
        fdb   cspp
        fdb   store
        fdb   semis

        fcb   $86
        fcc   '?erro'
        fcb   $f2
        fdb   scsp-7
qerr    fdb   docol
        fdb   swap
        fdb   zbran
        fdb   qerr1-*
        fdb   error
        fdb   bran
        fdb   qerr2-*
qerr1   fdb   drop
qerr2   fdb   semis

        fcb   $85
        fcc   '?com'
        fcb   $f0
        fdb   qerr-9
qcomp   fdb   docol
        fdb   state
        fdb   at
        fdb   zequ
        fdb   lit
        fdb   $11
        fdb   qerr
        fdb   semis

        fcb   $85
        fcc   'qexe'
        fcb   $e3
        fdb   qcomp-8
qexec   fdb   docol
        fdb   state
        fdb   at
        fdb   lit
        fdb   $12
        fdb   qerr
        fdb   semis

        fcb   $86
        fcc   '?pair'
        fcb   $f3
        fdb   qexec-8
qpair   fdb   docol
        fdb   subb
        fdb   lit
        fdb   $13
        fdb   qerr
        fdb   semis

        fcb   $84
        fcc   '?cs'
        fcb   $f0
        fdb   qpair-9
qcsp    fdb   docol
        fdb   spat
        fdb   cspp
        fdb   at
        fdb   subb
        fdb   lit
        fdb   $14
        fdb   qerr
        fdb   semis

        fcb   $88
        fcc   '?loadin'
        fcb   $f7
        fdb   qcsp-7
qload   fdb   docol
        fdb   blk
        fdb   at
        fdb   zequ
        fdb   lit
        fdb   $16
        fdb   qerr
        fdb   semis

        fcb   $87
        fcc   'compil'
        fcb   $e5
        fdb   qload-11
comp    fdb   docol
        fdb   qcomp
        fdb   fromr
        fdb   dup
        fdb   twop
        fdb   tor
        fdb   at
        fdb   comma
        fdb   semis

        fcb   $c1
        fcb   $fb
        fdb   comp-10
lbrac   fdb   docol
        fdb   zero
        fdb   state
        fdb   store
        fdb   semis

        fcb   $81
        fcb   $fd
        fdb   lbrac-4
rbrac   fdb   docol
        fdb   lit
        fdb   $00c0
        fdb   state
        fdb   store
        fdb   semis

        fcb   $86
        fcc   'smudg'
        fcb   $e5
        fdb   rbrac-4
smudg   fdb   docol
        fdb   lates
        fdb   lit
        fdb   $20
        fdb   toggl
        fdb   semis

        fcb   $83
        fcc   'he'
        fcb   $f8
        fdb   smudg-9
hex     fdb   docol
        fdb   lit
        fdb   16
        fdb   base
        fdb   store
        fdb   semis

        fcb   $87
        fcc   'decima'
        fcb   $ec
        fdb   hex-6
deca    fdb   docol
        fdb   lit
        fdb   10
        fdb   base
        fdb   store
        fdb   semis

        fcb   $87
        fcc   '(;code'
        fcb   $a9
        fdb   deca-10
pscod   fdb   docol
        fdb   fromr
        fdb   lates
        fdb   pfa
        fdb   cfa
        fdb   store
        fdb   semis

        fcb   $c5
        fcc   ';cod'
        fcb   $e5
        fdb   pscod-10
semic   fdb   docol
        fdb   qcsp
        fdb   comp
        fdb   pscod
        fdb   lbrac
        fdb   semis

        fcb   $87
        fcc   '<build'
        fcb   $f3
        fdb   semic-8
build   fdb   docol
        fdb   zero
        fdb   con
        fdb   semis

        fcb   $85
        fcc   'does'
        fcb   $be
        fdb   build-10
does    fdb   docol
        fdb   fromr
        fdb   lates
        fdb   pfa
        fdb   store
        fdb   pscod
dodoe   pshs  y              ; save instruction pointer
        ldy   ,x++           ; ip=[wp] , wp=wp+2
        pshu  x              ; put wp on parameter stack
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $85
        fcc   'coun'
        fcb   $f4
        fdb   does-8
count   fdb   docol
        fdb   dup
        fdb   onep
        fdb   swap
        fdb   cat
        fdb   semis

        fcb   $84
        fcc   'typ'
        fcb   $e5
        fdb   count-8
types   fdb   docol
        fdb   ddup
        fdb   zbran
        fdb   type1-*
        fdb   over
        fdb   plus
        fdb   swap
        fdb   xdo
type2   fdb   ido
        fdb   cat
        fdb   emit
        fdb   xloop
        fdb   type2-*
        fdb   bran
        fdb   type3-*
type1   fdb   drop
type3   fdb   semis

        fcb   $89
        fcc   '-trailin'
        fcb   $e7
        fdb   types-7
dtrai   fdb   docol
        fdb   dup
        fdb   zero
        fdb   xdo
dtra1   fdb   over
        fdb   over
        fdb   plus
        fdb   one
        fdb   subb
        fdb   cat
        fdb   bls
        fdb   subb
        fdb   zbran
        fdb   dtra2-*
        fdb   leave
        fdb   bran
        fdb   dtra3-*
dtra2   fdb   one
        fdb   subb
dtra3   fdb   xloop
        fdb   dtra1-*
        fdb   semis

        fcb   $84
        fcc   '(."'
        fcb   $a9
        fdb   dtrai-12
pdotq   fdb   docol
        fdb   rr
        fdb   count
        fdb   dup
        fdb   onep
        fdb   fromr
        fdb   plus
        fdb   tor
        fdb   types
        fdb   semis

        fcb   $c2
        fcc   '.'
        fcb   $a2
        fdb   pdotq-7
dotq    fdb   docol
        fdb   lit
        fdb   $22
        fdb   state
        fdb   at
        fdb   zbran
        fdb   dotq1-*
        fdb   comp
        fdb   pdotq
        fdb   words
        fdb   here
        fdb   cat
        fdb   onep
        fdb   allot
        fdb   bran
        fdb   dotq2-*
dotq1   fdb   words
        fdb   here
        fdb   count
        fdb   types
dotq2   fdb   semis

        fcb   $86
        fcc   'expec'
        fcb   $f4
        fdb   dotq-5
expec   fdb   docol
        fdb   over
        fdb   plus
        fdb   over
        fdb   xdo
expe1   fdb   key
        fdb   dup
        fdb   lit
        fdb   bsout
        fdb   equal
        fdb   zbran
        fdb   expe2-*
        fdb   drop
        fdb   dup
        fdb   ido
        fdb   equal
        fdb   dup
        fdb   fromr
        fdb   two
        fdb   subb
        fdb   plus
        fdb   tor
        fdb   zbran
        fdb   expe6-*
        fdb   lit
        fdb   bell
        fdb   bran
        fdb   expe7-*
expe6   fdb   lit
        fdb   bsout
expe7   fdb   bran
        fdb   expe3-*
expe2   fdb   dup
        fdb   lit
        fdb   $0d
        fdb   equal
        fdb   zbran
        fdb   expe4-*
        fdb   leave
        fdb   drop
        fdb   bls
        fdb   zero
        fdb   bran
        fdb   expe5-*
expe4   fdb   dup
expe5   fdb   ido
        fdb   cstor
        fdb   zero
        fdb   ido
        fdb   onep
        fdb   store
expe3   fdb   emit
        fdb   xloop
        fdb   expe1-*
        fdb   drop
        fdb   semis

        fcb   $85
        fcc   'quer'
        fcb   $f9
        fdb   expec-9
query   fdb   docol
        fdb   tib
        fdb   at
        fdb   lit
        fdb   $50
        fdb   expec
        fdb   zero
        fdb   inn
        fdb   store
        fdb   semis

        fcb     $c1
        fcb     $80
        fdb     query-8
null    fdb     docol
        fdb     blk
        fdb     at
        fdb     zbran
        fdb     null1-*
        fdb     one
        fdb     blk
        fdb     pstor
        fdb     zero
        fdb     inn
        fdb     store
        fdb     blk
        fdb     at
        fdb     bscr
        fdb     one
        fdb     subb
        fdb     andd
        fdb     zequ
        fdb     zbran
        fdb     null2-*
        fdb     qexec
        fdb     fromr
        fdb     drop
null2   fdb     bran
        fdb     null3-*
null1   fdb     fromr
        fdb     drop
null3   fdb     semis


        fcb   $84
        fcc   'fil'
        fcb   $ec
        fdb   null-4
fill    fdb   *+2
        pshs  y              ; save ip
        pulu  d,x,y          ; character in b, count in x, address in y
fill1   stb   ,y+            ; store character
        leax  -1,x           ; decrement counter
        bne   fill1          ; loop until done
        puls  y              ; get ip
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $85
        fcc   'eras'
        fcb   $e5
        fdb   fill-7
erasee  fdb   docol
        fdb   zero
        fdb   fill
        fdb   semis

        fcb   $86
        fcc   'blank'
        fcb   $f3
        fdb   erasee-8
blank   fdb   docol
        fdb   bls
        fdb   fill
        fdb   semis

        fcb   $84
        fcc   'hol'
        fcb   $e4
        fdb   blank-9
hold    fdb   docol
        fdb   lit
        fdb   -1
        fdb   hld
        fdb   pstor
        fdb   hld
        fdb   at
        fdb   cstor
        fdb   semis

        fcb   $83
        fcc   'pa'
        fcb   $e4
        fdb   hold-7
pad     fdb   docol
        fdb   here
        fdb   lit
        fdb   $44
        fdb   plus
        fdb   semis

        fcb   $84
        fcc   'wor'
        fcb   $e4
        fdb   pad-6
words   fdb   docol
        fdb   tib
        fdb   at
        fdb   inn
        fdb   at
        fdb   plus
        fdb   swap
        fdb   encl
        fdb   here
        fdb   lit
        fdb   $0022
        fdb   blank
        fdb   inn
        fdb   pstor
        fdb   over
        fdb   subb
        fdb   tor
        fdb   rr
        fdb   here
        fdb   cstor
        fdb   plus
        fdb   here
        fdb   onep
        fdb   fromr
        fdb   cmove
        fdb   semis

        fcb   $88
        fcc   '(number'
        fcb   $a9
        fdb   words-7
pnumb   fdb   docol
pnum1   fdb   onep
        fdb   dup
        fdb   tor
        fdb   cat
        fdb   base
        fdb   at
        fdb   digit
        fdb   zbran
        fdb   pnum2-*
        fdb   swap
        fdb   base
        fdb   at
        fdb   ustar
        fdb   drop
        fdb   rot
        fdb   base
        fdb   at
        fdb   ustar
        fdb   dplus
        fdb   dpl
        fdb   at
        fdb   onep
        fdb   zbran
        fdb   pnum3-*
        fdb   one
        fdb   dpl
        fdb   pstor
pnum3   fdb   fromr
        fdb   bran
        fdb   pnum1-*
pnum2   fdb   fromr
        fdb   semis

        fcb   $86
        fcc   'numbe'
        fcb   $f2
        fdb   pnumb-11
numb    fdb   docol
        fdb   zero
        fdb   zero
        fdb   rot
        fdb   dup
        fdb   onep
        fdb   cat
        fdb   lit
        fdb   $2d
        fdb   equal
        fdb   dup
        fdb   tor
        fdb   plus
        fdb   lit
        fdb   -1
numb1   fdb   dpl
        fdb   store
        fdb   pnumb
        fdb   dup
        fdb   cat
        fdb   bls
        fdb   subb
        fdb   zbran
        fdb   numb2-*
        fdb   dup
        fdb   cat
        fdb   lit
        fdb   $2e
        fdb   subb
        fdb   zero
        fdb   qerr
        fdb   zero
        fdb   bran
        fdb   numb1-*
numb2   fdb   drop
        fdb   fromr
        fdb   zbran
        fdb   numb3-*
        fdb   dminu
numb3   fdb   semis

        fcb   $85
        fcc   '-fin'
        fcb   $e4
        fdb   numb-9
dfind   fdb   docol
        fdb   bls
        fdb   words
        fdb   here
        fdb   cont
        fdb   at
        fdb   at
        fdb   pfind
        fdb   dup
        fdb   zequ
        fdb   zbran
        fdb   dfin1-*
        fdb   drop
        fdb   here
        fdb   lates
        fdb   pfind
dfin1   fdb   semis

        fcb   $87
        fcc   '(abort'
        fcb   $a9
        fdb   dfind-8
pabor   fdb   docol
        fdb   abort
        fdb   semis

        fcb   $85
        fcc   'erro'
        fcb   $f2
        fdb   pabor-10
error   fdb   docol
        fdb   warn
        fdb   at
        fdb   zless
        fdb   zbran
        fdb   erro1-*
        fdb   pabor
erro1   fdb   here
        fdb   count
        fdb   types
        fdb   pdotq
        fcb   2
        fcc   '? '
        fdb   mess
        fdb   spsto
        fdb   blk
        fdb   at
        fdb   ddup
        fdb   zbran
        fdb   err02-*
        fdb   inn
        fdb   at
        fdb   swap
err02   fdb   quit
        fdb   semis          ; never executed

        fcb   $83
        fcc   'id'
        fcb   $ae
        fdb   error-8
iddot   fdb   docol
        fdb   pad
        fdb   lit
        fdb   $20
        fdb   lit
        fdb   $5f
        fdb   fill
        fdb   dup
        fdb   pfa
        fdb   lfa
        fdb   over
        fdb   subb
        fdb   pad
        fdb   swap
        fdb   cmove
        fdb   pad
        fdb   count
        fdb   lit
        fdb   $1f
        fdb   andd
        fdb   types
        fdb   space
        fdb   semis

        fcb   $86
        fcc   'creat'
        fcb   $e5
        fdb   iddot-6
creat   fdb   docol
        fdb   dfind
        fdb   zbran
        fdb   creat1-*
        fdb   drop
        fdb   nfa
        fdb   iddot
        fdb   lit
        fdb   4
        fdb   mess
        fdb   space
creat1  fdb   here
        fdb   dup
        fdb   cat
        fdb   width
        fdb   at
        fdb   min
        fdb   onep
        fdb   allot
        fdb   dup
        fdb   lit
        fdb   $a0
        fdb   toggl
        fdb   here
        fdb   one
        fdb   subb
        fdb   lit
        fdb   $80
        fdb   toggl
        fdb   lates
        fdb   comma
        fdb   curr
        fdb   at
        fdb   store
        fdb   here
        fdb   twop
        fdb   comma
        fdb   semis

        fcb   $c9
        fcc   '[compile'
        fcb   $fd
        fdb   creat-9
bcomp   fdb   docol
        fdb   dfind
        fdb   zequ
        fdb   zero
        fdb   qerr
        fdb   drop
        fdb   cfa
        fdb   comma
        fdb   semis

        fcb   $c7
        fcc   'litera'
        fcb   $ec
        fdb   bcomp-12
liter   fdb   docol
        fdb   state
        fdb   at
        fdb   zbran
        fdb   lite1-*
        fdb   comp
        fdb   lit
        fdb   comma
lite1   fdb   semis

        fcb   $c8
        fcc   'dlitera'
        fcb   $ec
        fdb   liter-10
dlite   fdb   docol
        fdb   state
        fdb   at
        fdb   zbran
        fdb   dlit1-*
        fdb   swap
        fdb   liter
        fdb   liter
dlit1   fdb   semis

        fcb   $86
        fcc   '?stac'
        fcb   $eb
        fdb   dlite-11
qstac   fdb   docol
        fdb   spat
        fdb   szero
        fdb   at
        fdb   swap
        fdb   uless
        fdb   one
        fdb   qerr
        fdb   spat
        fdb   here
        fdb   lit
        fdb   $80
        fdb   plus
        fdb   uless
        fdb   lit
        fdb   7
        fdb   qerr
        fdb   semis

        fcb   $89
        fcc   'interpre'
        fcb   $f4
        fdb   qstac-9
inter   fdb   docol
inte1   fdb   dfind
        fdb   zbran
        fdb   inte2-*
        fdb   state
        fdb   at
        fdb   less
        fdb   zbran
        fdb   inte3-*
        fdb   cfa
        fdb   comma
        fdb   bran
        fdb   inte4-*
inte3   fdb   cfa
        fdb   exec
inte4   fdb   qstac
        fdb   bran
        fdb   inte5-*
inte2   fdb   here
        fdb   numb
        fdb   dpl
        fdb   at
        fdb   onep
        fdb   zbran
        fdb   inte6-*
        fdb   dlite
        fdb   bran
        fdb   inte7-*
inte6   fdb   drop
        fdb   liter
inte7   fdb   qstac
inte5   fdb   bran
        fdb   inte1-*
        fdb   semis          ; never executed

        fcb   $89
        fcc   'immediat'
        fcb   $e5
        fdb   inter-12
immed   fdb   docol
        fdb   lates
        fdb   lit
        fdb   $40
        fdb   toggl
        fdb   semis

        fcb   $8a
        fcc   'vocabular'
        fcb   $f9
        fdb   immed-12
vocab   fdb   docol
        fdb   build
        fdb   lit
        fdb   $81a0
        fdb   comma
        fdb   curr
        fdb   at
        fdb   cfa
        fdb   comma
        fdb   here
        fdb   vocl
        fdb   at
        fdb   comma
        fdb   vocl
        fdb   store
        fdb   does
dovoc   fdb   twop
        fdb   cont
        fdb   store
        fdb   semis

**************************************************
*                                                *
*       forth is not included here for the       *
*       romable version because forth is a       *
*       variable and must lie in ram             *
*                                                *
**************************************************

        fcb   $8b
        fcc   'definition'
        fcb   $f3
        fdb   vocab-13
defin   fdb   docol
        fdb   cont
        fdb   at
        fdb   curr
        fdb   store
        fdb   semis

        fcb   $c1
        fcb   $a8
        fdb   defin-14
paren   fdb   docol
        fdb   lit
        fdb   $29
        fdb   words
        fdb   semis

        fcb   $84
        fcc   'qui'
        fcb   $f4
        fdb   paren-4
quit    fdb   docol
        fdb   zero
        fdb   blk
        fdb   store
        fdb   lbrac
quit1   fdb   rpsto
        fdb   cr
        fdb   query
        fdb   inter
        fdb   state
        fdb   at
        fdb   zequ
        fdb   zbran
        fdb   quit2-*
        fdb   pdotq
        fcb   2
        fcc   'ok'
quit2   fdb   bran
        fdb   quit1-*
        fdb   semis          ; never executed

        fcb   $85
        fcc   'abor'
        fcb   $f4
        fdb   quit-7
abort   fdb   docol
        fdb   spsto
        fdb   deca
        fdb   qstac
        fdb   cr
        fdb   rforth
        fdb   defin
        fdb   quit
        fdb   semis          ; never executed

        fcb   $84
        fcc   'war'
        fcb   $fd
        fdb   abort-8
warm    fdb   docol
        fdb   abort
        fdb   semis          ; never executed

        fcb   $84
        fcc   'col'
        fcb   $e4
        fdb   warm-7
cold    fdb   docol
        fdb   lit	
        fdb   utable		; user variable table
        fdb   lit
        fdb   up		
        fdb   at
        fdb   lit
        fdb   6
        fdb   plus
        fdb   lit
        fdb   16
        fdb   cmove
        fdb   spsto
        fdb   lit
        fdb   forths
        fdb   lit
        fdb   rams
        fdb   lit
        fdb   taske-forths
        fdb   cmove
        fdb   lit
        fdb   top
        fdb   at
        fdb   lit
        fdb   rforth+6
        fdb   store
        fdb   cr
        fdb   dotcpu
        fdb   pdotq
        fcb   14
        fcc   'microforth '
        fcb   figrel+$30
        fcb   adot
        fcb   figrev+$30
        fdb   cr
        fdb   pdotq
        fcb   44
        fcc   'southern illinois university at edwardsville'
        fdb   cr
        fdb   pdotq
        fcb   20
        fcc   'micro-controller lab'
        fdb   cr
        fdb   pdotq
        fcb   28
        fcc   'dictionary space available: '
        fdb   spat
        fdb   dp
        fdb   at
        fdb   subb
        fdb   udot
        fdb   pdotq
        fcb   5
        fcc   'bytes'
        fdb   cr
        fdb   abort
        fdb   semis          ; never executed

        fcb   $84
        fcc   's->'
        fcb   $e4
        fdb   cold-7
stod    fdb   docol
        fdb   dup
        fdb   zless
        fdb   minus
        fdb   semis

        fcb   $82
        fcc   '+'
        fcb   $ad
        fdb   stod-7
pm      fdb   docol
        fdb   zless
        fdb   zbran
        fdb   pm1-*
        fdb   minus
pm1     fdb   semis

        fcb   $83
        fcc   'd+'
        fcb   $ad
        fdb   pm-5
dpm     fdb   docol
        fdb   zless
        fdb   zbran
        fdb   dpm1-*
        fdb   dminu
dpm1    fdb   semis

        fcb   $83
        fcc   'ab'
        fcb   $f3
        fdb   dpm-6
abs     fdb   docol
        fdb   dup
        fdb   pm
        fdb   semis

        fcb   $84
        fcc   'dab'
        fcb   $f3
        fdb   abs-6
dabs    fdb   docol
        fdb   dup
        fdb   dpm
        fdb   semis

        fcb   $83
        fcc   'mi'
        fcb   $ee
        fdb   dabs-7
min     fdb   docol
        fdb   tdup
        fdb   great
        fdb   zbran
        fdb   min1-*
        fdb   swap
min1    fdb   drop
        fdb   semis

        fcb   $83
        fcc   'ma'
        fcb   $f8
        fdb   min-6
max     fdb   docol
        fdb   tdup
        fdb   less
        fdb   zbran
        fdb   max1-*
        fdb   swap
max1    fdb   drop
        fdb   semis

        fcb   $82
        fcc   'm'
        fcb   $aa
        fdb   max-6
mstar   fdb   docol
        fdb   tdup
        fdb   xorr
        fdb   tor
        fdb   abs
        fdb   swap
        fdb   abs
        fdb   ustar
        fdb   fromr
        fdb   dpm
        fdb   semis

        fcb   $82
        fcc   'm'
        fcb   $af
        fdb   mstar-5
mslas   fdb   docol
        fdb   over
        fdb   tor
        fdb   tor
        fdb   dabs
        fdb   rr
        fdb   abs
        fdb   uslas
        fdb   fromr
        fdb   rr
        fdb   xorr
        fdb   pm
        fdb   swap
        fdb   fromr
        fdb   pm
        fdb   swap
        fdb   semis

        fcb   $81
        fcb   $aa
        fdb   mslas-5
star    fdb   docol
        fdb   mstar
        fdb   drop
        fdb   semis

        fcb   $84
        fcc   '/mo'
        fcb   $e4
        fdb   star-4
slmod   fdb   docol
        fdb   tor
        fdb   stod
        fdb   fromr
        fdb   mslas
        fdb   semis

        fcb   $81
        fcb   $af
        fdb   slmod-7
slash   fdb   docol
        fdb   slmod
        fdb   swap
        fdb   drop
        fdb   semis

        fcb   $83
        fcc   'mo'
        fcb   $c4
        fdb   slash-4
mod     fdb   docol
        fdb   slmod
        fdb   drop
        fdb   semis

        fcb   $85
        fcc   '*/mo'
        fcb   $e4
        fdb   mod-6
ssmod   fdb   docol
        fdb   tor
        fdb   mstar
        fdb   fromr
        fdb   mslas
        fdb   semis

        fcb   $82
        fcc   '*'
        fcb   $af
        fdb   ssmod-8
sslash  fdb   docol
        fdb   ssmod
        fdb   swap
        fdb   drop
        fdb   semis

        fcb   $85
        fcc   'm/mo'
        fcb   $e4
        fdb   sslash-5
msmod   fdb   docol
        fdb   tor
        fdb   zero
        fdb   rr
        fdb   uslas
        fdb   fromr
        fdb   swap
        fdb   tor
        fdb   uslas
        fdb   fromr
        fdb   semis

        fcb   $87
        fcc   'messag'
        fcb   $e5
        fdb   msmod-8
mess    fdb   docol
        fdb   warn
        fdb   at
        fdb   zbran
        fdb   mess1-*
        fdb   ddup
        fdb   zbran
        fdb   mess2-*
        fdb   lit
        fdb   4
        fdb   ofset
        fdb   at
        fdb   bscr
        fdb   slash
        fdb   subb
        fdb   pdotq
        fcb   6
        fcc   ' dline'
        fdb   space
mess2   fdb   bran
        fdb   mess3-*
mess1   fdb   pdotq
        fcb   6
        fcc   'msg # '
        fdb   dot
mess3   fdb   semis

getkey	lda aciac
	asra 
	bcc getkey	; loop for keypress
	ldb aciad	; discard MIDI
getkey1	lda aciac
	asra
	bcc getkey1	; loop for keypress
	ldb aciad
	clra
	rts

pkey    fdb   *+2
	jsr getkey
pkey1   pshu  d              ; push character to the stack
        ldx   ,y++           ; next
        jmp   [,x++]

pqter   fdb   *+2
        lda   aciac          ; get control status of the acia
        asra                 ; check if buffer is empty
        bcc   pqter1         ; if so push zero flag
        ldb   aciad          ; if not, get key
        clra
        pshu  d
        bra   pqter2         ; go do next
pqter1  ldd   #0
        pshu  d              ; push flag
pqter2  ldx   ,y++           ; next
        jmp   [,x++]

* gjcp - emit seems to embed the acia driver right here
pemit   fdb   *+2
	ldb #$f1	; midi quarterframe
pemit0	lda aciac
	asra
	asra
	bcc pemit0	; loop waiting for acia to go ready
	stb aciad	; write the character
	
        pulu  d              ; character in b register
        andb  #$7f           ; mask off the highest bit
pemit1  lda   aciac          ; get acia status
        asra                 ; check if ready to transmit
        asra
        bcc   pemit1         ; loop if not ready
        stb   aciad          ; transmit character
        ldx   ,y++           ; next
        jmp   [,x++]

        fcb   $c1
        fcb   $a7
        fdb   mess-10
tick    fdb   docol
        fdb   dfind
        fdb   zequ
        fdb   zero
        fdb   qerr
        fdb   drop
        fdb   liter
        fdb   semis

        fcb   $86
        fcc   'forge'
        fcb   $f4
        fdb   tick-4
forget  fdb   docol
        fdb   curr
        fdb   at
        fdb   cont
        fdb   at
        fdb   subb
        fdb   lit
        fdb   $18
        fdb   qerr
        fdb   tick
        fdb   dup
        fdb   fence
        fdb   at
        fdb   less
        fdb   lit
        fdb   $15
        fdb   qerr
        fdb   dup
        fdb   nfa
        fdb   dp
        fdb   store
        fdb   lfa
        fdb   at
        fdb   cont
        fdb   at
        fdb   store
        fdb   semis

        fcb   $84
        fcc   'bac'
        fcb   $eb
        fdb   forget-9
back    fdb   docol
        fdb   here
        fdb   subb
        fdb   comma
        fdb   semis

        fcb   $c5
        fcc   'begi'
        fcb   $ee
        fdb   back-7
begin   fdb   docol
        fdb   qcomp
        fdb   here
        fdb   one
        fdb   semis

        fcb   $c5
        fcc   'endi'
        fcb   $e6
        fdb   begin-8
endiff  fdb   docol
        fdb   qcomp
        fdb   two
        fdb   qpair
        fdb   here
        fdb   over
        fdb   subb
        fdb   swap
        fdb   store
        fdb   semis

        fcb   $c4
        fcc   'the'
        fcb   $ee
        fdb   endiff-8
then    fdb   docol
        fdb   endiff
        fdb   semis

        fcb   $c2
        fcc   'd'
        fcb   $ef
        fdb   then-7
do      fdb   docol
        fdb   comp
        fdb   xdo
        fdb   here
        fdb   three
        fdb   semis

        fcb   $c4
        fcc   'loo'
        fcb   $f0
        fdb   do-5
loopc   fdb   docol
        fdb   three
        fdb   qpair
        fdb   comp
        fdb   xloop
        fdb   back
        fdb   semis

        fcb   $c5
        fcc   '+loo'
        fcb   $f0
        fdb   loopc-7
ploop   fdb   docol
        fdb   three
        fdb   qpair
        fdb   comp
        fdb   xploo
        fdb   back
        fdb   semis

        fcb   $c5
        fcc   'unti'
        fcb   $ec
        fdb   ploop-8
until   fdb   docol
        fdb   one
        fdb   qpair
        fdb   comp
        fdb   zbran
        fdb   back
        fdb   semis

        fcb   $c3
        fcc   'en'
        fcb   $e4
        fdb   until-8
end     fdb   docol
        fdb   until
        fdb   semis

        fcb   $c5
        fcc   'agai'
        fcb   $ee
        fdb   end-6
again   fdb   docol
        fdb   one
        fdb   qpair
        fdb   comp
        fdb   bran
        fdb   back
        fdb   semis

        fcb   $c6
        fcc   'repea'
        fcb   $f4
        fdb   again-8
repeat  fdb   docol
        fdb   tor
        fdb   tor
        fdb   again
        fdb   fromr
        fdb   fromr
        fdb   two
        fdb   subb
        fdb   endiff
        fdb   semis

        fcb   $c2
        fcc   'i'
        fcb   $e6
        fdb   repeat-9
if      fdb   docol
        fdb   comp
        fdb   zbran
        fdb   here
        fdb   zero
        fdb   comma
        fdb   two
        fdb   semis

        fcb   $c4
        fcc   'els'
        fcb   $e5
        fdb   if-5
else    fdb   docol
        fdb   two
        fdb   qpair
        fdb   comp
        fdb   bran
        fdb   here
        fdb   zero
        fdb   comma
        fdb   swap
        fdb   two
        fdb   endiff
        fdb   two
        fdb   semis

        fcb   $c5
        fcc   'whil'
        fcb   $e5
        fdb   else-7
while   fdb   docol
        fdb   if
        fdb   twop
        fdb   semis

        fcb   $86
        fcc   'space'
        fcb   $f3
        fdb   while-8
spacs   fdb   docol
        fdb   zero
        fdb   max
        fdb   ddup
        fdb   zbran
        fdb   spac2-*
        fdb   zero
        fdb   xdo
spac1   fdb   space
        fdb   xloop
        fdb   spac1-*
spac2   fdb   semis

        fcb   $82
        fcc   '<'
        fcb   $a3
        fdb   spacs-9
bdigs   fdb   docol
        fdb   pad
        fdb   hld
        fdb   store
        fdb   semis

        fcb   $82
        fcc   '#'
        fcb   $be
        fdb   bdigs-5
edigs   fdb   docol
        fdb   drop
        fdb   drop
        fdb   hld
        fdb   at
        fdb   pad
        fdb   over
        fdb   subb
        fdb   semis

        fcb   $84
        fcc   'sig'
        fcb   $ee
        fdb   edigs-5
sign    fdb   docol
        fdb   rot
        fdb   zless
        fdb   zbran
        fdb   sign1-*
        fdb   lit
        fdb   $2d
        fdb   hold
sign1   fdb   semis

        fcb   $81
        fcb   $a3
        fdb   sign-7
dig     fdb   docol
        fdb   base
        fdb   at
        fdb   msmod
        fdb   rot
        fdb   lit
        fdb   9
        fdb   over
        fdb   less
        fdb   zbran
        fdb   dig1-*
        fdb   lit
        fdb   7
        fdb   plus
dig1    fdb   lit
        fdb   $30
        fdb   plus
        fdb   hold
        fdb   semis

        fcb   $82
        fcc   '#'
        fcb   $d3
        fdb   dig-4
digs    fdb   docol
digs1   fdb   dig
        fdb   over
        fdb   over
        fdb   orr
        fdb   zequ
        fdb   zbran
        fdb   digs1-*
        fdb   semis

        fcb   $83
        fcc   'd.'
        fcb   $f2
        fdb   digs-5
ddotr   fdb   docol
        fdb   tor
        fdb   swap
        fdb   over
        fdb   dabs
        fdb   bdigs
        fdb   digs
        fdb   sign
        fdb   edigs
        fdb   fromr
        fdb   over
        fdb   subb
        fdb   spacs
        fdb   types
        fdb   semis

        fcb   $82
        fcc   '.'
        fcb   $f2
        fdb   ddotr-6
dotr    fdb   docol
        fdb   tor
        fdb   stod
        fdb   fromr
        fdb   ddotr
        fdb   semis

        fcb   $82
        fcc   'd'
        fcb   $ae
        fdb   dotr-5
ddot    fdb   docol
        fdb   zero
        fdb   ddotr
        fdb   space
        fdb   semis

        fcb   $81
        fcb   $ae
        fdb   ddot-5
dot     fdb   docol
        fdb   stod
        fdb   ddot
        fdb   semis

        fcb   $81
        fcb   $bf
        fdb   dot-4
ques    fdb   docol
        fdb   at
        fdb   dot
        fdb   semis

        fcb   $82
        fcc   'u'
        fcb   $ae
        fdb   ques-4
udot    fdb   docol
        fdb   zero
        fdb   ddot
        fdb   semis

        fcb   $85
        fcc   'vlis'
        fcb   $f4
        fdb   udot-5
vlist   fdb   docol
        fdb   base
        fdb   at
        fdb   tor
        fdb   hex
        fdb   cr
        fdb   cr
        fdb   lit
        fdb   0
        fdb   outt
        fdb   store
        fdb   cont
        fdb   at
        fdb   at
vlist1  fdb   dup
        fdb   dup
        fdb   lit
        fdb   0
        fdb   bdigs
        fdb   dig
        fdb   dig
        fdb   dig
        fdb   dig
        fdb   edigs
        fdb   types
        fdb   dup
        fdb   onep
        fdb   cat
        fdb   lit
        fdb   $007f
        fdb   andd
        fdb   zbran
        fdb   vlist2-*
        fdb   space
        fdb   iddot
        fdb   bran
        fdb   vlist3-*
vlist2  fdb   pdotq
        fcb   5
        fcc   ' null'
        fdb   drop
vlist3  fdb   outt
        fdb   at
        fdb   lit
        fdb   60
        fdb   great
        fdb   zbran
        fdb   vlist4-*
        fdb   cr
        fdb   lit
        fdb   0
        fdb   outt
        fdb   store
        fdb   bran
        fdb   vlist5-*
vlist4  fdb   lit
        fdb   20
        fdb   outt
        fdb   at
        fdb   over
        fdb   mod
        fdb   subb
        fdb   spacs
vlist5  fdb   pfa
        fdb   lfa
        fdb   at
        fdb   dup
        fdb   zequ
        fdb   qterm
        fdb   dup
        fdb   zbran
        fdb   vlist6-*
        fdb   key
        fdb   drop
vlist6  fdb   orr
        fdb   zbran
        fdb   vlist1-*
        fdb   drop
        fdb   cr
        fdb   cr
        fdb   fromr
        fdb   base
        fdb   store
        fdb   semis

        fcb   $84
        fcc   '.cp'
        fcb   $f5
        fdb   vlist-8
dotcpu  fdb   docol
        fdb   pdotq
        fcb   5
        fcc   '6809 '
        fdb   semis

        fcb   $84
        fcc   'dum'
        fcb   $f0
        fdb   dotcpu-7
dump    fdb   docol
        fdb   base
        fdb   at
        fdb   tor
        fdb   hex
        fdb   cr
        fdb   cr
        fdb   lit
        fdb   5
        fdb   spacs
        fdb   lit
        fdb   16
        fdb   lit
        fdb   0
        fdb   xdo
dump1   fdb   ido
        fdb   lit
        fdb   3
        fdb   dotr
        fdb   xloop
        fdb   dump1-*
        fdb   lit
        fdb   2
        fdb   spacs
        fdb   lit
        fdb   16
        fdb   lit
        fdb   0
        fdb   xdo
dump2   fdb   ido
        fdb   lit
        fdb   0
        fdb   bdigs
        fdb   dig
        fdb   edigs
        fdb   types
        fdb   xloop
        fdb   dump2-*
        fdb   cr
        fdb   over
        fdb   plus
        fdb   swap
        fdb   dup
        fdb   lit
        fdb   15
        fdb   andd
        fdb   xorr
        fdb   xdo
dump3   fdb   cr
        fdb   ido
        fdb   lit
        fdb   0
        fdb   lit
        fdb   4
        fdb   ddotr
        fdb   space
        fdb   ido
        fdb   lit
        fdb   16
        fdb   plus
        fdb   ido
        fdb   tdup
        fdb   xdo
dump4   fdb   ido
        fdb   cat
        fdb   space
        fdb   lit
        fdb   0
        fdb   bdigs
        fdb   dig
        fdb   dig
        fdb   edigs
        fdb   types
        fdb   xloop
        fdb   dump4-*
        fdb   lit
        fdb   2
        fdb   spacs
        fdb   xdo
dump5   fdb   ido
        fdb   cat
        fdb   dup
        fdb   lit
        fdb   32
        fdb   less
        fdb   over
        fdb   lit
        fdb   126
        fdb   great
        fdb   orr
        fdb   zbran
        fdb   dump6-*
        fdb   drop
        fdb   lit
        fdb   46
dump6   fdb   emit
        fdb   xloop
        fdb   dump5-*
        fdb   lit
        fdb   16
        fdb   xploo
        fdb   dump3-*
        fdb   cr
        fdb   fromr
        fdb   base
        fdb   store
        fdb   semis

**************************************************
*                                                *
*   the following 2 words are used to burn the   *
*   2k eeprom located at address 0000 on the     *
*   development system. they may be removed as   *
*   long as the lfa's are re-adjusted.           *
*                                                *
**************************************************
        fcb   $84
        fcc   'eec'
        fcb   $a1
        fdb   dump-7
eecsto  fdb   *+2            ; on entry address is top of stack, data is second
        ldd   2,u            ; get byte in b, address is top of stack
        lda   #$ff           ; erase byte
        sta   [0,u]
        bsr   delay          ; wait for delay
        lda   [0,u]          ; read data
        stb   [0,u]          ; store data
        bsr   delay          ; wait for delay
        ldb   [0,u]          ; read data
        leau  4,u            ; drop address and data
        ldx   ,y++           ; next
        jmp   [,x++]

delay   ldx   #$0470
delay1  leax  -1,x
        bne   delay1
        rts

        fcb   $86
        fcc   'eemov'
        fcb   $c5
        fdb   eecsto-7
eemov   fdb   docol
        fdb   lit
        fdb   0
        fdb   xdo
eemo1   fdb   dup
        fdb   onep
        fdb   rot
        fdb   dup
        fdb   onep
        fdb   tor
        fdb   cat
        fdb   rot
        fdb   eecsto
        fdb   fromr
        fdb   swap
        fdb   xloop
        fdb   eemo1-*
        fdb   drop
        fdb   drop
        fdb   semis

**************************************************
*                                                *
*    the following is copied to ram by cold      *
*                                                *
**************************************************
forths  fcb   $c5            ; the start of the forth vocabulary
        fcc   'fort'
        fcb   $e8
        fdb   eemov-9
forth   fdb   dodoe
        fdb   dovoc
        fdb   $81a0
        fdb   rtask-7
        fdb   0

        fcb   $84
        fcc   'tas'
        fcb   $eb
        fdb   rforth-8
task    fdb   docol          ; last word in vocabulary
        fdb   semis
taske   equ   *              ; the end of the romable dictionary

rforth  equ   rams+forth-forths        ; location of forth in ram
rtask   equ   rams+task-forths         ; location of task in ram
initdp  equ   rams+taske-forths        ; initial dp in ram
