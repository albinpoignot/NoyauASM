;-----------------------------------------------------------------
;  TD N°4 module HORLOGE.ASM du NOYAU                                       
;  Routine Timer et processus système HORLOGE                          
;-----------------------------------------------------------------

.286
; Declaration des structures
INCLUDE DESCRIPT.STR
INCLUDE PROCESS.STR   
INCLUDE SEMAPHOR.STR  
INCLUDE CONST.INC
INCLUDE HORLOGE.EXT
INCLUDE HORLOGE.PUB

DonneesNoyau SEGMENT WORD PUBLIC 'DATA'
DonneesNoyau ENDS

SegNoyau SEGMENT BYTE PUBLIC 'CODE'
	assume  cs:SegNoyau

;-----------------------------------------------------------------
;  Timer                                         
;-----------------------------------------------------------------
Timer   proc    far
	push    ds
	push    ax
	mov     ax,DonneesNoyau
	mov     ds,ax
	assume  ds:DonneesNoyau
	PUSH SI
	
	; Appel correct de l'ancienne IT 08h
	PUSHF
	CALL Ex_Int08h
	
	LEA SI, semHorloge
	CALL SIGNALL

	POP SI
	pop     ax
	pop     ds
	assume  ds:nothing
	iret              ; sortie normale : IRET = POPF + RET
Timer   ENDP

;-----------------------------------------------------------------
;  Horloge                                       
;-----------------------------------------------------------------
Horloge PROC    near
	mov     ax,DonneesNoyau
	mov     ds,ax
	assume  ds:DonneesNoyau

	


	ASSUME DS:nothing
	RET
Horloge ENDP

SegNoyau ENDS

	END