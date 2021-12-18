.data
LIST: .word 7, 8, 10, 12, 13, 15, 16,18,20,2,4
N: .word 11
/*
PYTHON
max_streak = 0
streak = 0
for elem in list:

	if elem % 2 == 0:
		streak += 1
		if streak > max_streak:
			max_streak = streak
	else:
		streak = 0
*/
.text
.global _start
_start:
	LDR R0, =LIST
	MOV R3, #0 // max_streak
	MOV R4, #0 // streak (current)
	LDR R5, =N //number of elements
	LDR R5, [R5]
	B LOOP
END: B END

LOOP:
	SUB R5, #1
	CMP R5, #0
	BLT END
	LDR R1, [R0]
	ADD R0, #4
	ANDS R1, R1, #1
	BEQ EVEN
	//odd, reset streak
	MOV R4, #0
	B LOOP
	
EVEN:
	ADD R4, #1
	CMP R4, R3
	BGT UPDATE
	B LOOP
UPDATE:
	MOV R3, R4
	B LOOP
.end