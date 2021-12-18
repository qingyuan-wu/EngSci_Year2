/* Program that counts consecutive 1's */
.text
.global ONES
.global _start
_start:
	LDR R4, =TESTNUM // load data word into R4
	MOV R5, #0 //R5 stores the longest sequence of 1's in all the words
	LOOP:
		LDR R1, [R4]
		CMP R1, #-1 // -1 signifies end of list
		BEQ END
		BL ONES
		CMP R5, R0 // R0 is returned by ONES - number of consecutive 1's
		MOVLT R5, R0 // update R5, if necessary
		ADD R4, R4, #4
		//ADD R4, R4, #4
	B LOOP
	END: B END

ONES:
	MOV R0, #0 // result: longest sequence

	LOOP1:
		CMP R1, #0
		BEQ ENDLOOP
		ADD R0, #1
		LSR R2, R1, #1
		AND R1, R1, R2
	B LOOP1
	
	ENDLOOP: 
		MOV PC, LR
TESTNUM: .word 0x00c401fe
	.word 0x11232120
	.word 0xfe342ccd
	.word -1
.end