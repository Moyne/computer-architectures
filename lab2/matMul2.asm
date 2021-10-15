N EQU 4
M EQU 7
P EQU 5
.MODEL small
.STACK
.DATA
matA    DB  3,14,-15,9,26,-53,5,89,79,3,23,84,-6,26,43,-3,83,27,-9,50,28,-88,41,97,-103,69,39,-9
matB    DB  37,-101,0,58,-20,9,74,94,-4,59,-23,90,-78,16,-4,0,-62,86,20,89,9,86,28,0,-34,82,5,34,-21,1,70,-67,9,82,14
matRes  DW  N*P DUP (0)
.CODE
.STARTUP
XOR BX,BX
XOR DX,DX
XOR BP,BP
XOR CX,CX
LEA DI,matB
LEA SI,matRes
next:
MOV AL,matA[BX]
MOV AH,[DI]
IMUL AH
ADD DX,AX
ADC CL,0
CMP AX,0
JGE pos
ADD CL,0FFH
pos:
INC BX
ADD DI,P
INC CH
CMP CH,M
JNE next
CMP CL,0					;Checking to see if the value in the overflow matrix is positive or negative
JL  negOf
CMP DX,0					;Checking if the result is positive or negative
JL negAxPosCx
CMP CL,0					;If the result is positive and the value in the overflow matrix is 0 then there is no overflow
JE noOf
MOV [SI],7FFFH				;If the result is positive and the value in the overflow matrix is NOT 0 then there is a positive overflow(32767)
JMP ofOcc 
negAxPosCx:
MOV [SI],7FFFH				;If the result is negative and the value in the overflow matrix is positive or 0 then there is positive overflow(32767)
JMP ofOcc
negOf:
CMP DX,0					;Checking if the result is positive or negative
JL cxIsOnlySign
MOV [SI],0FFFFH				;If the result is positive and the value in the overflow matrix is negative it means that there is a negative overflow(-32768)
JMP ofOcc
cxIsOnlySign:
CMP CL,0FFH					;Comparing the value in the overflow matrix with a negative sign extension(-1)
JE noOf					;If the result is positive and the value in the overflow matrix is just a sign extension of a negative number(-1) it means that there is NOT an overflow
MOV [SI],0FFFFH				;If the result is positive and the value in the overflow matrix is just a sign extension of a negative number(-1) it means that there is a negative overflow(-32768)
JMP ofOcc
noOf:
MOV [SI],DX
ofOcc:
SUB CH,M
XOR CL,CL
ADD SI,2
XOR DX,DX
SUB BX,M  
SUB DI,M*P
INC DI
INC BP
CMP BP,P
JNE next
ADD BX,M
SUB BP,P 
SUB DI,P
CMP BX,N*M
JNE next
.EXIT
END
