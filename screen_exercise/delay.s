			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	DELAY

DELAY		PROC
LOOP		SUBS R0, #1
			BNE	 LOOP
			BX	LR
			ENDP
			ALIGN
			END
				
				
				