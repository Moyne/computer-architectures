DIM EQU 10
.MODEL small
.STACK
.DATA
ARR DW 3,5,14,52,1,20,21,34,2,11
RESULT DW ?     
.CODE
.STARTUP
MOV BX,0  
MOV DI,0
MOV DX,0
loop:      ADD BX,ARR[DI]
           ADD DI,2  
           INC DX
           CMP DX,DIM
           JL loop    
MOV RESULT,BX
.EXIT
END