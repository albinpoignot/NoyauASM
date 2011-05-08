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

  CMP [SI].identite, Q      ; grace à la fonction EQU defini auparamant Q = IdCGQueuExp et F = IdCGFileDesProc
  JNE FDP

  QE:
    MOV BX, [SI].SuivFPrio ; Case suivante de la cellule de garde i.e cellule à extraire  

    MOV [SI].SuivFPrio, [BX].SuivFPrio ; le nouveau suivant de la tete de liste est le suivant de la premiere cellule
    MOV [ [BX].SuivFPrio ].PrecFPrio, SI ; Le precedent du 2eme element est la cellule de garde

    JMP Fin

  FDP:
    MOV BX, [SI].SuivFDP ; Case suivante de la cellule de garde i.e cellule à extraire  
    MOV AX, [BX].SuivFDP ; Case suivant de celle à extraire pour refaire le lien           /!\  Attention methode differentes de celle du dessus utilisation de AX, car je ne sais pas si [[BX].SuivFPrio].PrecFPrio marche

    MOV [SI].SuivFDP, AX
    MOV [AX].PrecFDP, SI

    JMP Fin

  listeEstVide:
    MOV BX, 0FFFFh

  Fin:
    popa
    popf


;************************************************************
;* Procedure Extrait de type NEAR                           *
;* Entrée DS:SI pointe sur la cellule de garde de la liste  *
;*        DS:BX pointe sur la cellule à extraire            *
;* Resultat aucun                                           *
;************************************************************
 
Extrait PROC NEAR

  pushf
  pusha
  cli

  ; Test si la liste est vide 

  CALL ListeVide
  JZ Fin     ; Si liste vide on passe directement à la fin de la fonction special pour liste vide
  
  ;Test si FPrio ou FDP

  CMP [SI].identite, Q      ; grace à la fonction EQU defini auparamant Q = IdCGQueuExp et F = IdCGFileDesProc
  JNE FDP

  QE:
    MOV AX, [SI].SuivFPrio
    
    Boucle:
      CMP AX, BX
      JE CelluleTrouveeQE

      CMP AX, SI
      JE Fin
  
      MOV AX, [AX].SuivFPrio
      
      JMP Boucle

    CelluleTrouveeQE:
      MOV [ [AX].SuivFPrio ].PrecFPrio, [AX].PrecFPrio
      MOV [ [AX].SuivFPrio ].SuivFPrio, [AX].SuivFPrio
      
      JMP Fin

;*******************************************************

  FDP:
    MOV AX, [SI].SuivFDP
    
    Boucle:
      CMP AX, BX
      JE CelluleTrouveeFDP

      CMP AX, SI
      JE Fin
  
      MOV AX, [AX].SuivFDP
      
      JMP Boucle

    CelluleTrouveeFDP:
      MOV [ [AX].SuivFDP ].PrecFDP, [AX].PrecFDP
      MOV [ [AX].SuivFDP ].SuivFDP, [AX].SuivFDP
      
  Fin:
    popa
    popf








