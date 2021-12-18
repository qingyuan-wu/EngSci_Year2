.global _start
.global SWAP

_start:
    LDR R4, =LIST
    LDR R1, [R4] // number of elements in LIST
    SUB R1, #1 // want to subtract since we're comparing with the next elem always
    MOV R2, #0 // R2 is the current index number
    MOV R7, #1 // R7 tracks if there has been a swapping that occurred
    
	ADD R4, R4, #4
	// LDR R0, [R4, #4]

    LOOP:
		LDR R4, =LIST
		ADD R4, R4, #4
		
        MOV R2, #0

        CMP R7, #0
        BEQ END // went through entire inner loop (length of list) without any swaps, return
        MOV R7, #0
        LOOP2:
            LDR R0, [R4] // R0 is current element in LIST
			ADD R4, R4, #4
            
            CMP R1, R2 // are we at end of array yet?
            BEQ LOOP
            ADD R2, #1
            LDR R5, [R4] // load R5, next element, before calling SWAP subroutine
            BL SWAP
            CMP R0, #1
            BEQ SWAPPED
        B LOOP2

        SWAPPED: 
            MOV R7, #1
            B LOOP2

    B LOOP
    END: B END

    SWAP:
        //LDR R5, [R0], #4 // R5 is next element; loaded outside
        CMP R0, R5
        BGT YES
        LDR R0, =0 // no swap
        B END_SWAP


        YES:
            MOV R6, R0 // R6 is the temp for swapping
            STR R5, [R0]
            STR R6, [R5] // issue is R5: R0, #4?????
            
            LDR R0, =1 //yes swap
            B END_SWAP

        END_SWAP: MOV PC, LR

LIST: .word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
.end