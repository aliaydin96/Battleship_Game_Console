PORTA_DATA 		EQU 0x400043FC


			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN  TRANSMIT
			EXPORT 	CIVILIAN
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CIVILIAN
			PUSH{R0-R12, LR}

			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			ADD R2, #3
			MOV	R5, R2
			BL	TRANSMIT
			MOV	R5, #0x41
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			ADD R12, #2
			MOV R9, #0X20
			MOV R10, #0X64
			MOV	R4, #0XE6
			MOV	R7, #0XFF
			LSL R9, R12
			LSL R10, R12
			LSL R4, R12
			LSL R7, R12
			

			MOV		R5, R9
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R9
			BL		TRANSMIT
			

			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R2
			BL	TRANSMIT
			MOV	R5, #0x42
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			REV16	R9, R9
			REV16   R10, R10
			REV16	R4, R4
			REV16   R7, R7

			MOV		R5, R9
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R9
			BL		TRANSMIT
		
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R2
			BL	TRANSMIT
			MOV	R5, #0x43
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			REV	R9, R9
			REV R10, R10
			REV	R4, R4
			REV R7, R7
			MOV		R5, R9
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R9
			BL		TRANSMIT
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R2
			BL	TRANSMIT
			MOV	R5, #0x44
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			REV16 R9, R9
			REV16 R10, R10
			REV16 R4, R4
			REV16 R7, R7
			MOV		R5, R9
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R7
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R9
			BL		TRANSMIT
			POP{R0-R12, LR}
			BX 		LR
			ALIGN
			END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				