PORTA_DATA 		EQU 0x400043FC


			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN  TRANSMIT
			EXPORT 	CIVILIAN
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CIVILIAN
			PUSH{R0, R1, R2, R3, R4, R6, R7, R8, LR}

			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			ADD R3, #3
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, #0x41
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			ADD R8, #2
			MOV R2, #0X20
			MOV R4, #0X64
			MOV	R6, #0XE6
			MOV	R7, #0XFF
			LSL R2, R8
			LSL R4, R8
			LSL R6, R8
			LSL R7, R8
			

			MOV		R5, R2
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R2
			BL		TRANSMIT
			

			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, #0x42
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			REV16	R2, R2
			REV16  R4, R4
			REV16	R6, R6
			REV16  R7, R7

			MOV		R5, R2
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R2
			BL		TRANSMIT
		
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, #0x43
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			REV	R2, R2
			REV R4, R4
			REV	R6, R6
			REV R7, R7
			MOV		R5, R2
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R2
			BL		TRANSMIT
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, #0x44
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			REV16 R2, R2
			REV16 R4, R4
			REV16 R6, R6
			REV16 R7, R7
			MOV		R5, R2
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R6
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R2
			BL		TRANSMIT
			POP{R0, R1, R2, R3, R4, R6, R7, R8, LR}
			BX 		LR
			ALIGN
			END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				