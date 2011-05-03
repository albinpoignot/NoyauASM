; **************************************
; Réalise l'extraction d'une cellule
; DS:SI pointe sur la cellule de garde
; DS:BX pointe sur la cellule à extraire
; **************************************
Extrait PROC NEAR

	PUSHA
	PUSHF
	CLI