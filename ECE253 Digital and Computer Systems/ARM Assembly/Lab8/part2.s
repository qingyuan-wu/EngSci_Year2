.global _start
.global SWAP

// PSEUDOCODE (Python)

@ def bubbleSort(L):
@     n = len(L)
@     swapped = True
@     while swapped == True:
@         swapped = False
@         for j in range(n-1):
@             if L[j] > L[j+1]:
@                 L[j], L[j+1] = L[j+1], L[j]
@                 swapped = True
@         n -= 1

_start:
    LDR R4, =LIST

    LDR R5, [R4] // first element is length of LIST
    SUB R5, #1 // subtract 1 because we compare current with next elem

    MOV R7, #1 // R7 checks has swapping occurred?

    LOOP:
        // reset to make sure we start checking at the first element:
        LDR R4, =LIST
        ADD R4, #4
        MOV R6, #0 //current index

        CMP R7, #0
        BEQ END

        // Prep for the loop, R7 is 0 until at least 1 successful swap occurs
        MOV R7, #0

        LOOP2: //inner loop iterates through the list, calling SWAP each time
            MOV R0, R4
            CMP R6, R5
            BEQ LOOP
            ADD R6, #1 // add 1 to index
            ADD R4, #4 // get next element

            BL SWAP
            CMP R0, #1
            BEQ SWAPPED

            B LOOP2

        SWAPPED: 
            MOV R7, #1 // set R7 to 1 to signify swapping (need to keep sorting)
            B LOOP2

    B LOOP    

END: B END
SWAP:
        // Load current and next element value into register:
        LDR R1, [R0]
        LDR R2, [R0, #4]

        CMP R1, R2
        // YES == we need to swap
        BGT YES
        // else: no swap
        MOV R0, #0 // 0 signifies no swap
        B END_SWAP

        YES:
            // swap by storing
            STR R2, [R0]
            STR R1, [R0, #4]
            
            MOV R0, #1 // 1 signifies yes swap
            B END_SWAP

        END_SWAP: MOV PC, LR    


// LIST: .word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
.end
