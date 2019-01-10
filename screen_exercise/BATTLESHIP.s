PORTA_DATA 		EQU 0x400043FC


			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN  TRANSMIT
			EXPORT 	BATTLESHIP
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	BATTLESHIP	BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
BATTLESHIP	PUSH{R0, R1, LR}

;			LDR R1,=PORTA_DATA
;			LDR	R0,[R1]
;			BIC	R0,#0x40				
;			STR	R0,[R1]
;			
;			MOV	R5, #0XAC
;			BL	TRANSMIT
;			MOV	R5, #0X42
;			BL	TRANSMIT
;			
;			LDR R1,=PORTA_DATA
;			LDR	R0,[R1]
;			ORR	R0,#0x40				
;			STR	R0,[R1]
			
			MOV		R5, #0XC0
			BL		TRANSMIT
			MOV		R5, #0XC4
			BL		TRANSMIT
			MOV		R5, #0X3E
			BL		TRANSMIT
			MOV		R5, #0X3F
			BL		TRANSMIT
			MOV		R5, #0X3E
			BL		TRANSMIT
			MOV		R5, #0XC4
			BL		TRANSMIT
			MOV		R5, #0XC0
			BL		TRANSMIT
			POP{R0, R1, LR}
			BX 		LR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	BATTLESHIP	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
			END