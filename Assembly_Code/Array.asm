.MODEL SMALL
.STACK 100H
.DATA
CR EQU 0DH
LF EQU 0AH
ARRAY DB '5','6','7','8'

.CODE   
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA SI, ARRAY
    
    MOV BL, ARRAY[0]
    MOV CL, ARRAY[1]
    MOV BYTE PTR ARRAY[0], CL
    MOV BYTE PTR ARRAY[1], BL
    
    MOV DL, ARRAY[0]
    MOV AH, 2
    INT 21H
     
    MOV AH, 4CH
    INT 21H 
MAIN ENDP    
END MAIN