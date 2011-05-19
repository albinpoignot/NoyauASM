;-----------------------------------------------------------------
;  TD N­1 : module GESTFILE.ASM du NOYAU           
;  Procedures de gestion de files (listes chainees)    
;-----------------------------------------------------------------

.286

INCLUDE DESCRIPT.STR    ; declaration du STRUC DESCRIPTEUR
INCLUDE CONST.INC
INCLUDE GESTFILE.PUB

SegNoyau SEGMENT BYTE PUBLIC 'CODE'
	ASSUME	CS:SegNoyau

;-----------------------------------------------------------------
;  Procedure InitVide                            
;  Type     : NEAR                               
;  Entree   : (DS:SI) = cellule de garde de la file  
;  Resultat : AUCUN                              
;-----------------------------------------------------------------
InitVide PROC NEAR

	PUSHF
	CLI

	MOV [SI].precFPrio, SI			; [SI].precFPrio : adressage indirect par registre : SI = offset, dans DS					; par défaut
	MOV [SI].suivFPrio, SI
	MOV [SI].suivFDP, SI
	MOV [SI].precFDP, SI

	MOV [SI].priorite, 0h

	POPF

	RET

InitVide ENDP

;-----------------------------------------------------------------
;  Procedure FileVide                            
;  Type     : NEAR                               
;  Entree   : (DS:SI) = cellule de garde de la file                                 
;  Resultat : ZF=0 si la file n'est pas vide, 1 si elle l'est 
;  Remarque : Attention ^ la gestion du registre dåetat
;-----------------------------------------------------------------
FileVide PROC NEAR

    CMP [SI].identite, idCGQueueExp
    JNE FDP_FV

    QE_FV:
	CMP [SI].precFPrio, SI
	JMP FIN_FV

    FDP_FV:
	CMP [SI].precFDP, SI

    FIN_FV:

    RET

FileVide ENDP

;-----------------------------------------------------------------
;  Procedure InsereItemXXX                       
;  Type     : NEAR                               
;  Entree   : (DS:BX) = cellule a inserer        
;             (DS:SI) = position d'insertion     
;  Resultat : AUCUN                              
;  Remarque : la cellule est inseree avant celle pointee pas (DS:SI)
;		se dZcompose en InsereItemFPrio et InsereItemFDP   
;-----------------------------------------------------------------	
InsereItemFPrio PROC NEAR

   PUSH DI
	MOV DI, [SI].precFPrio

	MOV [DI].suivFPrio, BX
	MOV [SI].precFPrio, BX

	MOV [BX].precFPrio, DI
	MOV [BX].suivFPrio, SI

   POP DI
	RET

InsereItemFPrio ENDP

InsereItemFDP PROC NEAR

    PUSH DI
	MOV DI, [SI].precFDP

	MOV [DI].suivFDP, BX
	MOV [SI].precFDP, BX

	MOV [BX].precFDP, DI
	MOV [BX].suivFDP, SI
    POP DI
	RET

InsereItemFDP ENDP

;-----------------------------------------------------------------
;  Procedure Insere                              
;  Type     : NEAR                               
;  Entree   : (DS:BX) = cellule a inserer        
;             (DS:SI) = cellule de garde de la file  
;  Resultat : AUCUN                              
;-----------------------------------------------------------------
Insere PROC NEAR

	PUSHA
	PUSHF
	CLI

	SiI_:	CMP [SI].Identite, IdCGQueueExp	; On vérifie si on pointe sur la queue d'exploitation
			JNE SinonI_

	; On cherche à insérer dans la QE
	AlorsI_: 
			CALL Recherche
			CALL InsereItemFPrio
			JMP FsiI_

	SinonI_:	CMP [SI].Identite, IdCGFileDesProc ; Sinon on vérifie qu'on pointe sur les descripteurs
			JNE FsiI_

			CALL Recherche
			CALL InsereItemFDP

	FsiI_:

	POPF
	POPA

	RET

Insere ENDP

;-----------------------------------------------------------------
;  Procedure Recherche                           
;  Type     : NEAR                               
;  Entree   : (DS:BX) = cellule a inserer        
;             (DS:SI) = cellule de garde de la file  
;  Resultat : (DS:SI) = position d'insertion     
;  Remarque : l'insertion se fait dans l'ordre croissant des priorites
;		  pour la Queue d'Exp, par ordre d'ajout pour la File 
;-----------------------------------------------------------------
Recherche PROC NEAR

	; /!\ ***********************
	; Par prudence !
	PUSH AX
	PUSHF
	CLI

	CALL FileVide
	JE FsiR_

	SiR_:	CMP [SI].Identite, IdCGQueueExp	; On vérifie si on pointe sur la queue d'exploitation
		JNE SinonR_

	AlorsR_:   MOV SI, [SI].suivFPrio


			TqR_: 	MOV AH, [BX].priorite
				CMP [SI].priorite, AH
				JAE FtqR_

				MOV SI, [SI].suivFPrio

				CMP [SI].priorite, 0h
				JE FsiR_

				JMP TqR_
			FtqR_:

			JMP FsiR_

	SinonR_:	CMP [SI].Identite, IdCGFileDesProc ; Sinon on vérifie qu'on pointe sur les descripteurs
			JE FsiR_

			; On ne fait rien, on pointe déjà sur la cellule de garde

	FsiR_:

	POPF
	POP AX

	RET

Recherche ENDP

;-----------------------------------------------------------------
;  Procedure Extrait                             
;  Type     : NEAR                               
;  Entree   : (DS:BX) = cellule a extraire       
;  Resultat : (DS:BX) = cellule extraite
;-----------------------------------------------------------------
Extrait PROC NEAR

	PUSHA
	PUSHF
	PUSH DI
	CLI

	CALL FileVide
	JE FsiE_

	SiE_:	CMP [SI].Identite, IdCGQueueExp	; On vérifie si on pointe sur la queue d'exploitation
		JNE SinonE_
								    ; On cherche à extraire de la QE
	AlorsE_: 		

		MOV DI, [BX].precFPrio ; Stockage de la cellule précédente
		MOV AX, [BX].suivFPrio
		MOV [DI].suivFPrio, AX ; MaJ du chainage

		MOV DI, [BX].suivFPrio
		MOV AX, [BX].precFPrio
		MOV [DI].precFPrio, AX ; MaJ du chainage

		JMP FsiE_

	SinonE_:
		CMP [SI].Identite, IdCGFileDesProc ; Sinon on vérifie qu'on pointe sur les descripteurs
		JNE FsiE_

		MOV DI, [BX].precFDP ; Stockage de la cellule précédente
		MOV AX, [BX].suivFDP
		MOV [DI].suivFDP, AX ; MaJ du chainage

		MOV DI, [BX].suivFDP ; Stockage de la cellule suivante
		MOV AX, [BX].precFDP
		MOV [DI].precFDP, AX ; MaJ du chainage

	FsiE_:

	POP DI
	POPA
	POPF

	RET

Extrait ENDP

;-----------------------------------------------------------------
;  Procedure PremierDeFile                       
;  Type     : NEAR                               
;  Entree   : (DS:SI) = cellule de garde de la file  
;  Resultat : BX = 0FFFFh, file vide
;	      BX != 0FFFFh, (DS :BX) pointe sur la cellule extraite
;-----------------------------------------------------------------
PremierDeFile PROC NEAR

  PUSH DI
  PUSH SI
  PUSHF
  CLI

  ; Test si la liste est vide 

  CALL FileVide
  JZ ListeEstVide     ; Si liste vide on passe directement à la fin de la fonction special pour liste vide

  ;Test si FPrio ou FDP

  CMP [SI].identite, IdCGQueueExp      ; grace à la fonction EQU defini auparamant Q = IdCGQueuExp et F = IdCGFileDesProc
  JNE FDP

  QE:
    MOV BX, [SI].SuivFPrio ; Case suivante de la cellule de garde i.e cellule à extraire  

    MOV DI, [BX].SuivFPrio
    MOV [SI].SuivFPrio, DI ; le nouveau suivant de la tete de liste est le suivant de la premiere cellule
    MOV [DI].precFPrio, SI

    JMP Fin

  FDP:
    MOV BX, [SI].SuivFDP ; Case suivante de la cellule de garde i.e cellule à extraire

    MOV DI, [BX].SuivFDP
    MOV [SI].SuivFDP, DI ; le nouveau suivant de la tete de liste est le suivant de la premiere cellule
    MOV [DI].precFDP, SI

    JMP Fin

  listeEstVide:
    MOV BX, 0FFFFh

  Fin:
    POPF
    POP SI
    POP DI

    RET

PremierDeFile ENDP

SegNoyau ENDS    ;Fin du segment

END              ;Fin du fichier 
