N EQU 4
M EQU 7
P EQU 5
.MODEL small
.STACK
.DATA
matA    DB  3,14,-15,9,26,-53,5,89,79,3,23,84,-6,26,43,-3,83,27,-9,50,28,-88,41,97,-103,69,39,-9
matB    DB  37,-101,0,58,-20,9,74,94,-4,59,-23,90,-78,16,-4,0,-62,86,20,89,9,86,28,0,-34,82,5,34,-21,1,70,-67,9,82,14
matRes  DW  N*P DUP (0)
matOf   DB  N*P DUP (0)
nRow    DB  0 
indexOf DW  0
.CODE
.STARTUP 
XOR DX,DX					;Setting up pointers and counters 
LEA SI,matRes
LEA BX,matA
LEA DI,matB
setup:  
CMP DH,M                    ;check if I reached a new row in matA
JNE sameRow
INC nRow
SUB DH,M
CMP nRow,N                  ;check if I ended the matrix
JE end
ADD SI,P*2
ADD indexOf,P
LEA DI,matB
sameRow:                    ;I am in the same row
MOV CL,[BX]                 ;read the next value from matA that needs to be multiplicate with a whole row
loop:
MOV AL,[DI]                 ;read the new value from matB 
PUSH DI                     ;I have to use the overflow matrix so I have to push and then pop this pointer because I can't use BP
MOV DI,indexOf
IMUL CL
ADD [SI],AX
ADC matOf[DI],0             ;Adding the carry to the overflow matrix
CMP AX,0
JGE pos
ADD matOf[DI],0FFH          ;If the number is negative I still have to add 0FFFFH other than the carry in the overflow matrix
pos:
POP DI
INC indexOf                 ;Adjusting pointers and counters
ADD SI,2
INC DI
INC DL
CMP DL,P                    ;Checking if I reached the end of the row in matB
JNE loop
SUB DL,P                    ;If I reached a new row I must readjust the pointers and counters
SUB SI,P*2
SUB indexOf,P
INC DH                      ;Updating the index of which position in a row my pointer for matA is pointing to   
INC BX
JMP setup

end:
LEA BX,matRes
LEA DI,matOf
XOR DL,DL
controlOf:
MOV AX,[BX]
MOV CL,[DI]
CMP CL,0					;Checking to see if the value in the overflow matrix is positive or negative
JL  negOf
CMP AX,0					;Checking if the result is positive or negative
JL negAxPosCx
CMP CL,0					;If the result is positive and the value in the overflow matrix is 0 then there is no overflow
JE nextOf
MOV [BX],7FFFH				;If the result is positive and the value in the overflow matrix is NOT 0 then there is a positive overflow(32767)
JMP nextOf 
negAxPosCx:
MOV [BX],7FFFH				;If the result is negative and the value in the overflow matrix is positive or 0 then there is positive overflow(32767)
JMP nextOf
negOf:
CMP AX,0					;Checking if the result is positive or negative
JL cxIsOnlySign
MOV [BX],0FFFFH				;If the result is positive and the value in the overflow matrix is negative it means that there is a negative overflow(-32768)
JMP nextOf
cxIsOnlySign:
CMP CL,0FFH					;Comparing the value in the overflow matrix with a negative sign extension(-1)
JE nextOf					;If the result is positive and the value in the overflow matrix is just a sign extension of a negative number(-1) it means that there is NOT an overflow
MOV [BX],0FFFFH				;If the result is positive and the value in the overflow matrix is just a sign extension of a negative number(-1) it means that there is a negative overflow(-32768)
nextOf:						;Updating pointers and counters and checking if I reached the end of the matrix
ADD BX,2
INC DI
INC DL
CMP DL,N*P
JNE controlOf 
.EXIT   
END