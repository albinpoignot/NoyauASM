; TD Nø2 module CONST.INC           
; Constantes utilisees dans le noyau   
;-----------------------------------------------------------------

;-------
; TYPES
;-------
TypeSemaphore	EQU	'S'		 
TypeProcessus	EQU	'P'		   
TypeListe			EQU	'L'		   

;-----------
; IDENTITES
;-----------
; identite des cellules de garde
IdCGFileDesProc 	EQU	'F'
IdCGQueueExp			EQU	'Q'

; identite des processus
IdProcInit  equ  'i'
IdProc1			equ	 '1'
IdProc2			equ	 '2'
IdProc3			equ	 '3'

;-------
; ETATS
;-------
CREATION			EQU	'C'	  
ACTIF					EQU	'A'	   
ACTIVABLE			EQU	'a'	   
NON_ACTIVABLE	EQU	'N'	   
TERMINE 			EQU	'T'	   

;-----------
; PRIORITES
;-----------
PrioriteMin     EQU     250

;-------------------
; AUTRES CONSTANTES
;-------------------
Nil             EQU     0ffffh          
Infini          EQU     11111111b       
attribut				EQU			01001111b
ecran						EQU			0b800h

