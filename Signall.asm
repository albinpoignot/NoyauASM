;*********************************************************************
;* Procedure SIGNALL type NEAR                                         *
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
  