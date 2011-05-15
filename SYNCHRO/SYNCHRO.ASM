;*************************************************
; SYNCHRO.ASM                                    *
;*************************************************

.286

INCLUDE PROCESS.STR    
INCLUDE SEMAPHOR.STR
INCLUDE CONST.INC
INCLUDE SYNCHRO.PUB
INCLUDE SEGMENT.ASM

SegNoyau SEGMENT BYTE PUBLIC 'CODE'
	ASSUME	CS:SegNoyau, DS:DonnesNoyau
      
	MOV AX, DonnesNoyau
	MOV DS, DonnesNoyau

 ;******************************************************
; DISPATCHER FAR                                      *
; Entrée : DS segment de donnée du noyau              *
; Resultat : aucun                                    *
;******************************************************

Dispatcher PROC FAR
  
  pushf
  pusha
  cli

  MOV BX, EnCours                              ;BX contient EnCours, On a surement un truc a faire pour que le segment de donné du noyau soit connu ici
  ; Sauvegarde de EnCours à faire
  MOV SI, QueueExp                             ;Si contient le pointeur sur la QueueExp

  CMP [BX].etat, ACTIF
  JE Processus_Actif

  Processus_Non_Acitf:                         ;le processus EnCours n'est plus actif, on change pour le plus prioritaire
    MOV [BX].RegSS, SS
    MOV [BX].RegSP, SP                         ;Sauvegarde du contexte de la pile du Processus
 
    CALL PremierDeListe NEAR                   ;EnCours devient le premier de la QE BX modifier par le CALL
    MOV EnCours, BX
  
    MOV [BX].etat, ACTIF                       ; le 1er processus de la QE devient acitf
    
    MOV SS, [BX].RegSS
    MOV SP, [BX].RegSP                         ;Restauration du contexte de la pile 

    JMP FIN

  Processus_Actif:                             ;le processus EnCours est toujours actif
    MOV AX, BX                                 ; sauvegarde du BX actuel pour comparaison à suivre
    CALL PremierDeListe NEAR                   ; on mets dans BX le process le plus prioritaire
  
    CMP AX, BX
    JE FIN

    Nest_Plus_Le_Plus_Prioritaire:             
      MOV [AX].etat, ACTIVABLE                   ;il passe alors dans l'etat activable 
    
  FIN:
    
    ;restauration de EnCours à faire
    popa
    popf
    
  RETF
ENDP

;*********************************************************************
;* Procedure SIGNALL type NEAR                                       *
;* Entrée DS : segment de données du noyau                           *
;*        SI : pointe le semaphore sur lequel s'effectue la synchro  * 
;* Resultat : Aucun                                                  *
;*********************************************************************

Signall PROC NEAR

  pushf
  cli
  
  CALL NEAR ListeVide                         ;Si il n'y a pas de processus en attente dans le semaphore
  JE semaphoreVide

  semaphoreNonVide:
    
    CALL PremierDeListe NEAR                  ;On recupere le processus qui attend dans le semaphore
    CALL Eligible NEAR                        ;On reinsere le processus en attente dans la QE
    JMP Fin

  semphoreVide:
    
    ADD [SI].compteur, 1                      ;On indique que la ressource est libre si plus personne n'est dans la file d'attente
  
  Fin:
    
    popf
    CALL Dispatcher FAR
    
  RET

Signall ENDP
  
;*********************************************************************
;* Procedure WAITT type NEAR                                         *
;* Entrée DS : segment de données du noyau                           *
;*        SI : pointe le semaphore sur lequel s'effectue la synchro  * 
;* Resultat : Aucun                                                  *
;*********************************************************************

; Demande un acces a une ressource, on a un compteur = nb d'acces qu'on peut faire à la ressource,
; on regarde le compteur si il est a 0 on le mets dans la file d'attente du semaphore, si a 1 on decremente le compteur et dans tous ls cas appelle le dispatcher

Waitt PROC NEAR
    
  pushf
  cli

  CMP [SI].Compteur, 0h
  JNE Acces

  AccesRefuse:
    SUB [SI].Compteur, 1  
    JMP Fin

  Acces:
                                                                             ; Trouver le processus actif Encours
    CALL NEAR PremierDeListe                                                 ; L'extraire de QE - PremierDeListe -> mets la cellule dans BX, SI pointe deja sur le semaphore
    CALL NEAR Insere                                                         ; L'inserer dans la liste d'attente du semaphore, Insere( cellule a inserer DS:BX, CG DS:SI ), CG de S 
    
    MOV [BX].File, SI                                                        ; maj des champ File du Ddp (normalement fait dans insere), ie: maj de File
    MOV [BX].Etat, NON_ACTIVABLE                                             ; EnCours.etat <- non activable

  Fin:

    popf
    CALL Dispatcher FAR   ; Appel au dispatcher

  RET

Waitt ENDP

;*********************************************************************
;* Procedure ELIGIBLE type NEAR                                      *
;* Entrée DS : segment de données du noyau                           *
;*        BX : pointe sur le descripteur à inserer                   * 
;* Resultat : Aucun                                                  *
;*********************************************************************

Eligible PROC NEAR

    pushf
    cli

    MOV SI, QueueEXP      ;On mets dans SI le pointeur sur la cellule de garde de la liste d'exploitation
    MOV [BX].File, SI          ;On mets dans la file la cellule de garde de la liste dans lequel est le DdP
    MOV [BX].etat, ACTIVABLE   ;On rend le process activable

    CALL Insere NEAR           ;On appelle la fonction inserer 

    popf
    RET

Eligible ENDP
    
;*********************************************************************
;* Procedure SUICIDE type NEAR                                       *
;* Entrée : Aucune                                                   *
;* Resultat : Le processus est termine,                              *
;*            il ne sera plus chaine apres appel au dispatcher       *
;*********************************************************************

Suicide PROC NEAR
  
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
Suicide ENDP

;*********************************************************************

ENDS

END

