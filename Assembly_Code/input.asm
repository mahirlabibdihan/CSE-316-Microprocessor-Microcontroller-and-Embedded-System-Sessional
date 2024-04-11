.MODEL SMALL
.STACK 100H
.DATA
N DW ?
CR EQU 0DH
LF EQU 0AH
TXT DB 'Output: $'
.CODE   

INPUT PROC  
    INPUT_LOOP:
        MOV AH, 1   
        INT 21H
        
        CMP AL, CR
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP
        
        ; SUB AX, 48
        AND AX,000FH
        
        ; BX = 10*BX+AX
        MOV CX, AX
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        JMP INPUT_LOOP      
    END_INPUT_LOOP:
    RET
    
OUTPUT PROC
    OUTPUT_LOOP:
        ; DX = AX % 10       
        ; AX = AX / 10
        ; BX = AX
        XOR DX, DX
        MOV AX, BX
        MOV CX, 10
        DIV CX
        ADD DL, 48
        MOV BX, AX
        
        MOV AH, 2
        INT 21h
        
 
        CMP BX, 0
        JNE OUTPUT_LOOP
    END_OUTPUT_LOOP:
    RET

EVEN_ODD PROC
    CMP AL, 1
    JE ODD
    CMP AL, 3
    JE ODD
    CMP AL, 2
    JE EVEN
    CMP AL, 4
    JE EVEN
    
    ODD:
        MOV DL, 'o'
        JMP DISPLAY
        
        
    EVEN:
        MOV DL, 'e'
        JMP DISPLAY 
    
    DISPLAY:
        MOV AH, 2
        INT 21H
    RET
         
MAIN PROC
    MOV AX, @DATA
    
    ; Cannot use segment register with an immediate value
    MOV DS, AX
    ; interrupt to exit
    
    
     
    ;MOV N, BX
    ; Do works
    
    ;LEA DX, TXT         ;output first string        
    ;MOV AH, 9
    ;INT 21h
    ;MOV BX, N
             
    MOV DH, 0         
    MOV AX, 10
    MOV BX, 3
    
    DIV BX
              
    MOV AH, 4CH
    INT 21H   
MAIN ENDP
END MAIN