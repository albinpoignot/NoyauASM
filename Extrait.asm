; **************************************
; Réalise l'extraction d'une cellule
; DS:SI pointe sur la cellule de garde
; DS:BX pointe sur la cellule à extraire
; **************************************
Extrait PROC NEAR

	PUSHA
	PUSHF
	CLI
	
	Si_:	CMP [SI].Identite, IdCGQueueExp	; On vérifie si on pointe sur la queue d'exploitation
			JNE Sinon_

	; On cherche à extraire de la QE
	Alors_: 		
			CALL ListeVide
			JE Fsi_
			
			MOV DI, [BX].precFPrio ; Stockage de la cellule précédente
			MOV [DI].suivFPrio, [BX].suivFPrio ; MaJ du chainage
			
			MOV DI, [BX].suivFPrio ; Stockage de la cellule suivante
			MOV [DI].precFPrio, [BX].precFPrio ; MaJ du chainage
			
			JMP Fsi_
			
	Sinon_:	CMP [SI].Identite, IdCGFileDesProc ; Sinon on vérifie qu'on pointe sur les descripteurs
			JNE Fsi_
			
			CALL ListeVide
			JE Fsi_
			
			MOV DI, [BX].precFDP ; Stockage de la cellule précédente
			MOV [DI].suivFDP, [BX].suivFDP ; MaJ du chainage
			
			MOV DI, [BX].suivFDP ; Stockage de la cellule suivante
			MOV [DI].precFDP, [BX].precFDP ; MaJ du chainage
	
	Fsi_:
	
	POPF
	POPA
	
Extrait ENDP