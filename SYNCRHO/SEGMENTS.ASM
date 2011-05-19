;-----------------------------------------------------------------
; TD N­2 module SEGMENTS.ASM du NOYAU           
; Declaration des segments de pile et de donnees  
;-----------------------------------------------------------------
INCLUDE DESCRIPT.STR
INCLUDE PROCESS.STR	; declaration du STRUC PROCESSUS
INCLUDE SEMAPHOR.STR	; declaration du STRUC SEMAPHORE
INCLUDE CONST.INC
INCLUDE SEGMENTS.PUB

lapile		SEGMENT stack 'stack'
        dw 20 dup (?)
lapile 		ENDS

DonneesNoyau 	SEGMENT WORD PUBLIC 'DATA'
attribut	db 01001111b
ecran		dw 0b800h

;----------------------------
TableCentrale  LABEL	word
;----------------------------
EnCours         word    p1
;A definir :
;QueueExp        
;FileDesProc     
;QE		
;FDP		

;----------------------------
TableProcessus	LABEL	word
;----------------------------
p1	PROCESSUS <{Nil,Nil,Nil,Nil,IdProc1,TypeProcessus,5},ACTIF,Nil,Nil,Nil>
p2	PROCESSUS <{Nil,Nil,Nil,Nil,IdProc2,TypeProcessus,20},ACTIVABLE,Nil,Nil,Nil>
p3	PROCESSUS <{Nil,Nil,Nil,Nil,IdProc3,TypeProcessus,10},ACTIVABLE,Nil,Nil,Nil>

;----------------------------
TableSemaphore  Label word
;----------------------------
;...

DonneesNoyau 	ENDS
		END
