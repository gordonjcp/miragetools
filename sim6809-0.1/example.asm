	org	$0

	;; to display text on the console :
	;; X : addr of the C-string (termiated with '\0').
	;; A : 1 (simulator entry to display text)

	ldx	#txt
	lda	#1
	swi
	
	;; to read a string from input
	;; X : addr of the buffer
	;; B : size in bytes of the buffer
	;; A : 2 (simulator entry to read a string)
	;; return : the buffer is filled with the input
	;; string, truncated to the size of the buffer
	;; ('\0' included)

	ldx	#input
	ldb	#10
	lda	#2
	swi
	
	ldx	#txt2
	lda	#1
	swi

	ldx	#input
	lda	#1
	swi

	ldx	#endl
	lda	#1
	swi

	;; to terminate a 6809 program
	;; and return into the debugger
	;; A : 0
	
	lda	#0
	swi

txt	fcc	"Enter a string (9 chars max): "
endl	fcb	$0A,0

txt2	fcc	"Your entered this string : "
	fcb	0
	
input	rmb	10
	
	end
	