; *********************************************
; ZF = 1 si la liste pointée par DS:SI est vide
; ZF = 0 sinon
; *********************************************
ListeVide PROC NEAR

	Si1_: 	CMP [SI].precFPrio, SI	; Si [SI].precFPrio = SI Alors ZF = 1, la liste est considérée
			JNE Sinon1_				; comme vide, on vérifie si c'est vrai pour [SI].precFDP	
			JMP Fsi_

	Sinon1_ :	CMP [SI].precFDP, SI

	Fsi_:
	
ListeVide ENDP
