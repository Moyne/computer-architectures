DIM EQU 10
.MODEL small
.STACK
.DATA
ARR DB DIM DUP(?)  
.CODE
.STARTUP
MOV BL,-1  
MOV DI,0
MOV AH,1
read:      INT 21H
           MOV ARR[DI],AL
           INC DI
           CMP BL,-1
           JE firstChar
           CMP AL,BL
           JAE continue
           MOV BL,AL
continue:  CMP DI,DIM
           JL read
           JMP result 
firstChar: MOV BL,AL
           JMP continue 
result:    MOV DI,0  
           MOV AH,2 
           MOV DL,10
           INT 21H
           MOV DL,BL
           INT 21H
.EXIT
END