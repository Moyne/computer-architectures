.MODEL small
.STACK
.DATA
firstLine  DB 50 DUP(?)
secondLine DB 50 DUP(?)    
thirdLine  DB 50 DUP(?)
fourthLine DB 50 DUP(?)  
alphCount  DB 52 DUP(?)     
nLine      DB ?       
.CODE
.STARTUP  
MOV CH,0
MOV nLine,0
LEA BX,firstLine
MOV SI,0  
start:         
MOV DI,0
zero:
MOV alphCount[DI],0
INC DI
CMP DI,52
JB zero
MOV DI,0
MOV AH,2
MOV DL,10
INT 21H
MOV DL,35
INT 21H
MOV DL,10
INT 21H
MOV AH,1
MOV CH,0        
loop:
INT 21H
MOV BX[DI],AL       
CMP AL,13
JE enter   
JMP count 
enter:
INC DI
CMP DI,20
JB loop
MOV DI,50
back:
INC DI          
CMP DI,50
JB loop   

PUSH BX          
MOV DI,0
MOV AH,2 
MOV DL,10
INT 21H
PUSH DX
MOV DX,SI
ADD DL,65
CMP DL,90
JBE printMax
ADD DL,6
printMax:
INT 21H  
POP DX
MOV DL,10
INT 21H
SAR CH,1 
MOV BX,0
readCount:
MOV AL,alphCount[BX]
CMP AL,CH
JB next
MOV DL,BL
CMP DL,26
JB print
ADD DL,6
print:
PUSH AX
ADD DL,65
INT 21H 
MOV DL,32
INT 21H
POP AX
MOV AH,0
MOV CL,10
DIV CL 
MOV BH,AH    
MOV AH,2
CMP AL,0
JE residual
ADD AL,48
MOV DL,AL
INT 21H    
residual:
ADD BH,48
MOV DL,BH
INT 21H
MOV DL,32
INT 21H
MOV BH,0
next:
INC BL 
CMP BL,52
JB readCount
POP BX  
MOV CH,0
ADD nLine,1
MOV DL,10
INT 21H
JMP caesar
          
setupLoop:                
MOV DI,0
CMP nLine,1
JA thirdorfourth
LEA BX,secondLine
JMP start
thirdorfourth:
CMP nLine,2
JA fourthorend
LEA BX,thirdLine
JMP start
fourthorend:
CMP nLine,3
JA end  
LEA BX,fourthLine
JMP start

count:
SUB AL,65
CMP AL,32
JB cont
SUB AL,6
CMP AL,52
JAE back
JMP plus
cont:
CMP AL,0
JB back
CMP AL,26
JAE back    
plus:    
PUSH AX  
PUSH BX
MOV AH,0
MOV BX,AX
MOV AL,alphCount[BX]
INC AL
MOV alphCount[BX],AL
MOV CL,AL
CMP CL,CH
JB return
MOV CH,CL 
MOV SI,BX  
return:
POP BX
POP AX
JMP back
      
caesar:
MOV CL,BX[DI]
CMP CL,13
JNE contCloop
CMP DI,19
JB printC
MOV DI,50
JMP printC
contCloop:
CMP CL,65
JB printC
CMP CL,90
JBE maiusc
CMP CL,97
JB printC
CMP CL,122
JA printC 
ADD CL,nLine
CMP CL,122
JBE printC
SUB CL,58
JMP printC
maiusc:
ADD CL,nLine
CMP CL,90
JBE printC
ADD CL,6
printC:
MOV AH,2
MOV DL,CL
INT 21H
INC DI     
CMP DI,50
JB caesar
JMP setupLoop

end:
.EXIT
END