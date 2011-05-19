;-----------------------------------------------------------------
;  TD N­2 : module SYNCHRO.ASM du NOYAU            
;  Noyau de synchronisation                      
;-----------------------------------------------------------------
.286                    ; utilisation des instructions du 80286
INCLUDE DESCRIPT.STR    ; declaration du STRUC DESCRIPTEUR
INCLUDE PROCESS.STR     ; declaration du STRUC PROCESSUS
INCLUDE SEMAPHOR.STR	; declaration du STRUC SEMAPHORE
INCLUDE CONST.INC
INCLUDE SYNCHRO.PUB
INCLUDE SYNCHRO.EXT

;pour que l'etiquette soit connue a l'assemblage
DonneesNoyau     SEGMENT WORD PUBLIC 'DATA'	
DonneesNoyau     ENDS

SegNoyau    SEGMENT BYTE PUBLIC 'CODE'		
	assume  cs:SegNoyau,ds:DonneesNoyau

;-----------------------------------------------------------------
;  Procedure Dispatcher                          
;  Type     : FAR                                
;  Entree   : (DS) = segment de donnees du noyau 
;  Resultat : AUCUN (primitive systeme)          
;-----------------------------------------------------------------

Dispatcher	PROC FAR
	; a faire	; LOCK
	push    ds	; sauvegarde du contexte courant
	push    es
	pusha
	assume  ds:DonneesNoyau	; chaque processus peut utiliser son propre segment. 
				            ; Il faut donc se replacer sur le bon segment

; a faire .....

	popa		; restauration du contexte
	pop    es               
	pop    ds
	popf
	assume ds:nothing
	retf
Dispatcher 	ENDP

;-----------------------------------------------------------------
;  Procedure Eligible                            
;  Type     : NEAR                               
;  Entree   : (DS) = segment des donnees du noyau
;             (BX) = pointe le descripteur a inserer  
;  Resultat : AUCUN (primitive)                  
;-----------------------------------------------------------------

Eligible    	PROC NEAR
	
	pushf
    cli

    MOV SI, QueueEXP      ;On mets dans SI le pointeur sur la cellule de garde de la liste d'exploitation
    MOV [BX].File, SI          ;On mets dans la file la cellule de garde de la liste dans lequel est le DdP
    MOV [BX].etat, ACTIVABLE   ;On rend le process activable

    CALL Insere NEAR           ;On appelle la fonction inserer 

    popf
    RET

Eligible        ENDP

;-----------------------------------------------------------------
;  Procedure Waitt                               
;  Type     : NEAR                               
;  Entree   : (DS) = segment des donnees du noyau
;             (SI) = pointe le semaphore         
;  Resultat : AUCUN (primitive avec semaphore verrouille a l'entree)   
;-----------------------------------------------------------------
Waitt   	PROC NEAR

  pushf
  PUSH BX
  cli

  CMP [SI].Compteur, 0h
  JNE Acces_W

  AccesRefuse:
    SUB [SI].Compteur, 1  
    JMP Fin_W

  Acces_W:
                                                                             ; Trouver le processus actif Encours
    CALL NEAR PremierDeListe                                                 ; L'extraire de QE - PremierDeListe -> mets la cellule dans BX, SI pointe deja sur le semaphore
    CALL NEAR Insere                                                         ; L'inserer dans la liste d'attente du semaphore, Insere( cellule a inserer DS:BX, CG DS:SI ), CG de S 
    
    MOV [BX].File, SI                                                        ; maj des champ File du Ddp (normalement fait dans insere), ie: maj de File
    MOV [BX].Etat, NON_ACTIVABLE                                             ; EnCours.etat <- non activable

  Fin_W:

	POP BX
    popf
	
    CALL Dispatcher FAR   ; Appel au dispatcher

  RET
  
Waitt       	ENDP

;-----------------------------------------------------------------
;  Procedure Signall                             
;  Type     : NEAR                               
;  Entree   : (DS) = segment des donnees du noyau
;             (SI) = pointe le semaphore         
;  Resultat : AUCUN (primitive avec semaphore verrouille a l'entree)   
;-----------------------------------------------------------------
Signall PROC NEAR

  pushf
  cli
  
  CALL ListeVide NEAR                         ;Si il n'y a pas de processus en attente dans le semaphore
  JE semaphoreVide_S

  semaphoreNonVide_S:
    
    CALL PremierDeListe NEAR                  ;On recupere le processus qui attend dans le semaphore
    CALL Eligible NEAR                        ;On reinsere le processus en attente dans la QE
    JMP Fin_S

  semphoreVide_S:
    
    ADD [SI].compteur, 1                      ;On indique que la ressource est libre si plus personne n'est dans la file d'attente
  
  Fin_S:
    
    popf
    CALL Dispatcher FAR
    
  RET

Signall ENDP

;-----------------------------------------------------------------
;  Procedure Suicide                             
;  Type     : NEAR                               
;  Entree   : aucune (EnCours)  
;  Resultat : suicide le processus pointe par EnCours : le processus 
; 		  n'est plus chaine, il disparait naturellement  
;-----------------------------------------------------------------
Suicide 	PROC    Near                            
  
  pusha
  pushf
  cli

  MOV BX, EnCours
  MOV [BX].etat, TERMINE
   
  ; Faudra demander au prof mais pour moi il faudrai l'enlever de QE
  
  MOV SI, QueueEXP
  CALL EXTRAIT NEAR
  MOV [BX].File, FileDesProc

  popf
  popa
  
  CALL Dispatcher FAR

  RET
  
Suicide 	ENDP

SegNoyau	ENDS
    		END
