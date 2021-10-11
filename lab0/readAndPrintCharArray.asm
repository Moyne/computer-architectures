DIM EQU 10
.MODEL small
.STACK
.DATA
ARR DB DIM DUP(?)  
.CODE
.STARTUP
MOV BX,0  
MOV DI,0
MOV DX,0   
MOV AH,1
read:      INT 21H
           MOV ARR[DI],AL
           INC DI
           CMP DI,DIM
           JL read  
MOV DI,0  
MOV AH,2 
MOV DL,10
INT 21H
write:     MOV DL,ARR[DI]
           INT 21H
           INC DI
           CMP DI,DIM
           JL write
.EXIT
END