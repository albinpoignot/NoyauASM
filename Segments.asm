; ...
; ...
; les piles des processus
; ...
; ...

DonneesNoyau SEGMENT 'data'
	; ...
	; ...
	
	TableCentrale LABEL word
		QE LISTE <NIL, NIL, NIL, NIL, IdCGQueueExp, TypeFPrio, 0>
		FDP LISTE <NIL, NIL, NIL, NIL, IdCGFileDesProc, TypeFDP, 0>
		
		EnCours DW OFFSET pInit
		QueueExp word QE ; <=> DW OFFSET QE
		FileDesProc word FDP
	
	; ...
	; ...
	
	TableDesProcessus LABEL word
		pInit PROCESS < {NIL, NIL, NIL, NIL, IdPInit, TypeProcessus, 0}, CREATION, , , NIL >
	
	; ...
	; ...