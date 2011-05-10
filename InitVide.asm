; *********************************************
; Initialise une liste vide
; *********************************************
InitVide PROC NEAR

	PUSHF
	CLI
	
	MOV [SI].precFPrio, SI ; [SI].precFPrio : adressage indirect par registre : SI = offset, dans DS
						   ; par défaut

	MOV [SI].suivFPrio, SI
	MOV [SI].suivFDP, SI
	MOV [SI].suivFDP, SI
	
	MOV [SI].priorite, 0
	
	POPF
	
InitVide ENDP
