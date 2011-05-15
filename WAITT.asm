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