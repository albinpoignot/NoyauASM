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

Suicide ENDP
  