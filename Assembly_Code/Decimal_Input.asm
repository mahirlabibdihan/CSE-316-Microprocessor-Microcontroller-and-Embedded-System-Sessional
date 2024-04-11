.MODEL SMALL
.STACK 100H
.DATA
CR EQU 0DH
LF EQU 0AH
N DW ?
.CODE

; Range: [-32768, 32768]
; Will return the value in BX
INPUT PROC
    PUSH BP
    PUSH AX
    ; PUSH BX
    PUSH CX
    PUSH DX

    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    
    MOV AH, 1
    INT 21H
    
    CMP AL, '-'
    JE NEG_IN
     
    POS_IN:
        XOR DX, DX
        XOR CX, CX
        
        MOV CL, AL
        SUB CL, '0'
        ; BX = BX*10 + AL -> BX = AX*DX + CL
        
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        
        MOV AH, 1
        INT 21H
        
        CMP AL, CR
        JE END_INPUT_LOOP
        CMP AL, LF
        JE END_INPUT_LOOP
        JMP POS_IN
    
    NEG_IN:
        MOV AH, 1
        INT 21H
        
        CMP AL, CR
        JE MAKE_BX_NEG
        CMP AL, LF       
        JE MAKE_BX_NEG
        
        XOR DX, DX
        XOR CX, CX
        
        MOV CL, AL
        SUB CL, '0'
        ; BX = BX*10 + AL -> BX = AX*DX + CL
        
        MOV AX, 10
        MUL BX
        ADD AX, CX
        MOV BX, AX
        
        
        
        JMP NEG_IN
         
    MAKE_BX_NEG:
        NEG BX
            
    END_INPUT_LOOP:

    POP DX
    POP CX
    ; POP BX
    POP AX
    POP BP

; Will sent parameter in stack    
OUTPUT PROC
    ; Saving all registers
    PUSH BP
    MOV BP, SP
    
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    
    
    
    MOV BX, [BP+4]
    CMP BX, 0 
    JGE POS_OUT ; Check sign bit
    
    NEG_OUT:
        NEG BX 
        
        MOV AH, 2
        MOV DL, '-'
        INT 21H
    POS_OUT: 
        MOV AX, BX
        XOR CX, CX
        STACK_LOOP:
            ; DX = AX % 10       
            ; AX = AX / 10
            XOR DX, DX
            MOV BX, 10
            DIV BX
            
            PUSH DX
            INC CX
            CMP AX, 0
            JNE STACK_LOOP
        END_STACK_LOOP:
        
        PRINT_LOOP:
            POP DX
            ADD DL, '0'
            
            MOV AH, 2
            INT 21H
            
            DEC CX
            CMP CX, 0
            JNE PRINT_LOOP    
        END_PRINT_LOOP:
    
    ; Restoring all registers          
    POP DX
    POP CX
    POP BX
    POP AX
    POP BP
    RET 2
     
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
              
    
    CALL INPUT
    MOV N, BX
    
    MOV AH,2
    MOV DL, CR
    INT 21H
        
    MOV AH,2
    MOV DL, LF
    INT 21H
    
    PUSH N
    CALL OUTPUT
    
    MOV AH, 4CH
    INT 21H 
MAIN ENDP    
END MAIN
