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

; *********************************************
; ZF = 1 si la liste pointée par DS:SI est vide
; ZF = 0 sinon
; *********************************************
ListeVide PROC NEAR

	Si1_: 	CMP [SI].precFPrio, SI	; Si [SI].precFPrio = SI Alors ZF = 1, la liste est considérée
			JNE Sinon1_				; comme vide, on vérifie si c'est vrai pour [SI].precFDP	
			JMP Fsi_

	Sinon1_ :	CMP [SI].precFDP, SI

	Fsi_:
	
ListeVide ENDP

; ******************************************************
; Détermine la position d'insertion d'un élément
; DS:SI pointe sur la cellule qui suivra celle à insérer
; ******************************************************
Recherche PROC NEAR

	; /!\ ***********************
	; Par prudence !
	PUSHF
	CLI
	
	Si_:	CMP [SI].Identite, IdCGQueueExp	; On vérifie si on pointe sur la queue d'exploitation
			JNE Sinon_

	; On cherche à insérer dans la QE
	Alors_: MOV SI, [SI].suivFPrio
			
			CALL ListeVide
			JE Fsi_
			
			Tq_ : 	CMP [SI].Priorite, [BX].Priorite
					JNAE Ftq_
					
					MOV SI, [SI].suivFPrio
					
					CMP [SI].Identite, IdCGQueueExp
					JNE Fsi_
					
					JMP Tq_
			Ftq_:
			
			JMP Fsi_
			
	Sinon_:	CMP [SI].Identite, IdCGFileDesProc ; Sinon on vérifie qu'on pointe sur les descripteurs
			JNE Fsi_
			
			; On ne fait rien, on pointe déjà sur la cellule de garde
	
	Fsi_:
	
	POPF
	
Recherche ENDP


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
