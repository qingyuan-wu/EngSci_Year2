.equ TIMER, 0xFFFEC600 //base address of timer
.equ HEX, 0xFF200020 //base address of HEX
.equ PERIOD, 10000000 // .1 second
.global _start
_start:
	LDR R8, =TIMER
	LDR R0, =PERIOD
	STR R0, [R8] // WRITE period to load register
	
	MOV R0, #0b011 // I=0 (interrupt), A=1 (auto-reload), E=1 (enable)
	STR R0, [R8, #16]
	
	LDR R2, =HEX
	MOV R0, #0
	MOV R3, #0
	MOV R4, #0
	BL hex_display // parameter passed in R0, return in R1
	LSL R3, R1, #8 //shift by 8 bits to align with hex display #1
DELAY:
	LDR R9, [R8, #0xC] // +12, load status register into R9
	CMP R9, #0
	BEQ DELAY // polling loop (repeated checking)
	
	STR R9, [R8, #0xC] //R9=1 -> write 1 to status reg to reset timeout bit to 0
	BL hex_display
	AND R3, #0xFF0000 // preserve 2nd byte of R3, zero out lowest byte
	ORR R3, R1
	
	STR R3, [R2] //update hex display - display 2 digits on hex 0 and hex 1
	
	ADD R0, #1
	CMP R0, #10
	BNE DELAY
	ADD R4, #1
	CMP R4, #10
	BNE update
	MOV R4, #0
update:
	MOV R0, R4
	BL hex_display
	LSL R3, R1, #16
	MOV R0, #0
	B DELAY
END: B END
	
hex_display:
	cmp r0, #0
	BNE check_1
	mov r1, #0b0111111 // seg 0 wants to light up
	B DONE
check_1:
	CMP R0, #1
	BNE check_2
	MOV R1, #0b0000110
	B DONE
check_2:
	CMP R0, #2
	BNE check_3
	MOV R1, #0b1011011
	B DONE
check_3:
	CMP R0, #3
	BNE check_4
	MOV R1, #0b1001111
	B DONE
check_4:
	CMP R0, #4
	BNE check_5
	MOV R1, #0b1100110
	B DONE
check_5:
	CMP R0, #5
	BNE check_6
	MOV R1, #0b1101101
	B DONE
check_6:
	CMP R0, #6
	BNE check_7
	MOV R1, #0b1111101
	B DONE
check_7:
	CMP R0, #7
	BNE check_8
	MOV R1, #0b0000111
	B DONE
check_8:
	CMP R0, #8
	BNE check_9
	MOV R1, #0b1111111
	B DONE
check_9:
	CMP R0, #9
	BNE DONE
	MOV R1, #0b1101111

DONE: mov PC, LR