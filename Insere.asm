; ******************************************************
; Réalise l'insertion d'une cellule dans la QE
; DS:SI pointe sur la cellule qui suivra celle à insérer
; ******************************************************
InsereItemFPrio PROC NEAR

	MOV DI, [SI].precFPrio
	
	MOV [DI].suivFPrio, BX
	MOV [SI].precFPrio, BX
	
	MOV [BX].precFPrio, DI
	MOV [BX].suivFPrio, SI

InsereItemFPrio ENDP


; ******************************************************
; Réalise l'insertion d'une cellule dans la FDP
; DS:SI pointe sur la cellule qui suivra celle à insérer
; ******************************************************
InsereItemFDP PROC NEAR
	
	MOV DI, [SI].precFDP
	
	MOV [DI].suivFDP, BX
	MOV [SI].precFDP, BX
	
	MOV [BX].precFDP, DI
	MOV [BX].suivFDP, SI
	
InsereItemFDP ENDP


; ************************************************
; Réalise l'insertion d'une cellule
; DS:BX pointe sur la cellule à insérer
; DS:SI pointe sur la cellule de garde de la liste
; ************************************************
Insere PROC NEAR

	PUSHA
	PUSHF
	CLI
	
	Si_:	CMP [SI].Identite, IdCGQueueExp	; On vérifie si on pointe sur la queue d'exploitation
			JNE Sinon_

	; On cherche à insérer dans la QE
	Alors_: 
			CALL Recherche
			CALL InsereItemFPrio
			JMP Fsi_
			
	Sinon_:	CMP [SI].Identite, IdCGFileDesProc ; Sinon on vérifie qu'on pointe sur les descripteurs
			JNE Fsi_
			
			CALL Recherche
			CALL InsereItempFDP
			
	Fsi_:
	
	POPF
	POPA
	
Insere ENDP
