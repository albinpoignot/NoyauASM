;*****************************************
; Segment et pile de données principale  *
;*****************************************

  PILE SEGMENT STACK 'STACK'
	  DW 200 DUP (?)
  PILE ENDS

  DonnesNoyau SEGMENT 'DATA'
    
  ;****************************
    TableControle LABEL WORD ;*
  ;****************************
      QE LISTE <NIL,NIL,NIL,NIL,IdCgQueueExp,TypeFPrio,0>                ;Initialisation de la cellule de garde de la QE
      FDP LISTE <NIL,NIL,NIL,NIL,IdCGFileDesProc,TypeFDP,0>              ;Initialisation de la cellule de garde de la FDP
      EnCours DW OFFSET pInit                                            ;Dans en cours nous mettons le 1er processus
      QeueEXP DW OFFSET QE                                               ;Pointeur sur la cellule de garde de la liste QE
      FileDesProc DW OFFSET FDP                                          ;Pointeur sur la cellule de garde de la liste FDP
    
  ;*****************************
    TableProcessus LABEL WORD ;*
  ;*****************************
      pInit Process <{NIL,NIL,NIL,NIL,IdPInit,TypeProcessus,1},CREATION, , ,NIL>  ;A remplacer par le futur 1er process genre l'horloge je pense

  ;*****************************
    TableSemaphore LABEL WORD ;*
  ;*****************************
      sInit Semaphor <<{NIL,NIL,NIL,NIL,IdSInit,TypeSemaphore,1},1>                   ;Semaphore servant a la gestion du 1er process

  DonnesNoyeau ENDS
    
END      

    