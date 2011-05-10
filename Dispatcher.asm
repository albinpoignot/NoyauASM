; *********************************************
; *
; * Entree : DS = segment de donnees du noyau * 
; * Resultat : aucun						  *
; *********************************************
DISPATCHER PROC FAR

	; LOCK
	; Svgd du contexte du processus EnCours
	;
	; Si EnCours.Etat != ACTIF 
	; Alors
	;	- svgd la pile de EnCours dans son descripteur
	;	- EnCours <- PremierQE
	;	- Encours.Etat <- ACTIF
	; 	- restauration de la pile de EnCours (le nouveau)
	; Sinon
	;	Si EnCours n'est pas le plus prioritaire
	;	Alors
	;		- Encore.Etat <- ACTIVABLE
	;		- svgd la pile de EnCours dans son descripteur
	;		- EnCours <- PremierQE
	;		- Encours.Etat <- ACTIF
	; 		- restauration de la pile de EnCours (le nouveau)
	;	FinSi
	; FinSi
	;
	; restauration du contexte du nouveau EnCours
	; UNLOCK
	; Activer EnCours
	
DISPATCHER ENDP
