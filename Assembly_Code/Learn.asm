.MODEL SMALL
.STACK 100H
.DATA
    ; DB - Define Byte - 8bit
    ; DW - Define Word - Depends on machine   
    DIHAN DW '5'
    OHI DB '4'  
    STRING DB "Hello World$"
.CODE   
MAIN PROC
    ; DS generally points at segment where variables are defined
    ; AX - Accum        
    
    ; MOV MEM, MEM not allowed
    MOV DS, @DATA  
    ;MOV DS, AX  
    
    MOV AL, 12 ; FOR printing
    SUB AL, 12
    ;MOV DL, ZF 
    MOV AH, 2
    INT 21H ; DL will be printed 
    
    LEA DX, STRING
    MOV AH, 09H
    INT 21H  
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP

END MAIN
