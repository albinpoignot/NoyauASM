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
