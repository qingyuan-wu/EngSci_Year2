.global _start
_start:
	MOV SP, #0x10000 // stack pointer
	LDR R1, =0xFF200000 //LEDs 9-0
	LDR R3, =0xFF200040 //we care about switch 3
	MOV R4, #0 // check pause
	
	//timer stuff
	LDR R8, =0xFFFEC600 //timer
	LDR R0, =100000000 // 1 second
	STR R0, [R8]
	MOV R0, #0b011
	STR R0, [R8, #8]
	MOV R5, #1 // a count to determine which LEDs to light up

DISPLAY:

ONE:
	CMP R5, #1
	BNE TWO
	ADD R5, #1
	LDR R2, =0b1000000001
	STR R2, [R1]
	B DELAY

TWO:
	CMP R5, #2
	BNE THREE
	ADD R5, #1
	
	LDR R2, =0b0100000010
	STR R2, [R1]
	B DELAY

THREE:
	CMP R5, #3
	BNE FOUR
	ADD R5, #1
	
	LDR R2, =0b0010000100
	STR R2, [R1]
	B DELAY
FOUR:
	CMP R5, #4
	BNE FIVE
	ADD R5, #1
	
	LDR R2, =0b0001001000
	STR R2, [R1]
	B DELAY

FIVE:
	CMP R5, #5
	BNE END
	MOV R5, #1
	
	LDR R2, =0b0000110000
	STR R2, [R1]
	B DELAY

DELAY:
	PUSH {R1-R5}

PAUSE:
	LDR R5, [R3]
	CMP R5, #0b111
	BGT PAUSE
	LDR R2, [R8, #0xC]
	CMP R2, #0
	BEQ PAUSE
	
	STR R2, [R8, #0xC]
	
	POP {R1-R5}
	B DISPLAY
	
END: B END