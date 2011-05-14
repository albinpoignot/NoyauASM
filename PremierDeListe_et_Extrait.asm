;**************************************************************
;* Procedure PremierDeListe de type NEAR                      *
;* Entrée DS:SI pointe sur la cellule de garde de la liste    *
;* Resultat BX = 0FFFFh si la liste est vide                  *
;*          BX != 0FFFFh DS:BX pointe sur la cellule extraite *                                          
;**************************************************************

PremierDeListe PROC NEAR

  pusha
  pushf
  cli

  ; Test si la liste est vide 

  CALL ListeVide
  JZ ListeEstVide     ; Si liste vide on passe directement à la fin de la fonction special pour liste vide

  ;Test si FPrio ou FDP

  CMP [SI].identite, IdCGQueueExp      ; grace à la fonction EQU defini auparamant Q = IdCGQueuExp et F = IdCGFileDesProc
  JNE FDP

  QE:
    MOV BX, [SI].SuivFPrio ; Case suivante de la cellule de garde i.e cellule à extraire  

    MOV [SI].SuivFPrio, [BX].SuivFPrio ; le nouveau suivant de la tete de liste est le suivant de la premiere cellule
    MOV AX, [BX].SuivFPrio 
    MOV [AX].PrecFPrio, SI ; Le precedent du 2eme element est la cellule de garde

    JMP Fin

  FDP:
    MOV BX, [SI].SuivFDP ; Case suivante de la cellule de garde i.e cellule à extraire  
    MOV AX, [BX].SuivFDP ; Case suivant de celle à extraire pour refaire le lien           

    MOV [SI].SuivFDP, AX
    MOV [AX].PrecFDP, SI

    JMP Fin

  listeEstVide:
    MOV BX, 0FFFFh

  Fin:
    popf
    popa
    RET

PremierDeListe ENDP

Extrait ENDP






