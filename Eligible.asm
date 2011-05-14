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
    
    