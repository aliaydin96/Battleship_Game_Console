PORTA_DATA 		EQU 0x400043FC


			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN  TRANSMIT
			EXPORT 	CIVILIAN
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CIVILIAN
			PUSH{R0, R1, LR}
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0XAC
			BL	TRANSMIT
			MOV	R5, #0X42
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			MOV		R5, #0X20
			BL		TRANSMIT
			MOV		R5, #0X64
			BL		TRANSMIT
			MOV		R5, #0XE6
			BL		TRANSMIT
			MOV		R5, #0XFF
			BL		TRANSMIT
			MOV		R5, #0XE6
			BL		TRANSMIT
			MOV		R5, #0X64
			BL		TRANSMIT
			MOV		R5, #0X20
			BL		TRANSMIT
			POP{R0, R1, LR}
			BX 		LR
			END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				