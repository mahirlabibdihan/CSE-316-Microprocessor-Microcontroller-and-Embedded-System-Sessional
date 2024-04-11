.MODEL SMALL
.STACK 100H
.DATA

INV_PASS DB 'Invalid password$'
VAL_PASS DB 'Valid password$'

CR EQU 0DH
LF EQU 0AH

UP DB 0
LW DB 0
DG DB 0
XX DB 0

.CODE   
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    PASS_LOOP:
        MOV AH, 1
        INT 21H
        
        NEWLINE_CHECK:
            CMP AL, CR
            JE END_LOOP
            CMP AL, LF
            JE END_LOOP
            JMP UPPER_CASE
            
        ; One Upper
        UPPER_CASE:
            ; 41H=< =<5A
            CMP AL, 41H
            JL LOWER_CASE
            CMP AL, 5AH
            JG LOWER_CASE
            MOV UP, 1
            JMP PASS_LOOP
            
        ; One Lower
        LOWER_CASE:
            CMP AL, 61H
            JL DIGIT
            CMP AL, 7AH
            JG DIGIT
            MOV LW, 1
            JMP PASS_LOOP
              
        ; One Digit
        DIGIT:
            CMP AL, 30H
            JL DEFAULT
            CMP AL, 39H
            JG DEFAULT
            MOV DG, 1
            JMP PASS_LOOP
         
        ; 21H< c <7EH
        DEFAULT:
            CMP AL, 21H
            JL INVALID_CHAR
            CMP AL, 7EH
            JL INVALID_CHAR
            JMP PASS_LOOP
        
        INVALID_CHAR:
            MOV XX, 1
            JMP PASS_LOOP
             
    END_LOOP:
        CMP UP, 1
        JNE INVALID
        CMP LW, 1
        JNE INVALID
        CMP DG, 1
        JNE INVALID
        CMP XX, 0
        JNE INVALID
        JMP VALID
        
        
    INVALID:
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV AH, 2
        MOV DL, LF
        INT 21H
        MOV AH, 09H
        LEA DX, INV_PASS
        INT 21H
        JMP EXIT
        
    VALID:
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV AH, 2
        MOV DL, LF
        INT 21H
        MOV AH, 09H
        LEA DX, VAL_PASS
        INT 21H
        JMP EXIT
        
    EXIT:    
        MOV AH, 4CH
        INT 21H 
MAIN ENDP    
END MAIN