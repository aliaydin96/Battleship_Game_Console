PORTA_DATA 		EQU 0x400043FC


			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN  TRANSMIT
			EXPORT 	BOUNDARY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	BOUNDARY LINES BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BOUNDARY	
			PUSH	{LR}
			MOV	R3, #0X85
			MOV	R4, #0XC6
UPPER_LOWER_BOUND
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0
			ADD	R5, R3
			BL	TRANSMIT
			MOV	R5, #0X40
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			
			MOV		R5, #0X80
			BL		TRANSMIT	
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0
			ADD	R5, R3
			BL	TRANSMIT
			MOV	R5, #0X45
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]

			MOV		R5, #0X1
			BL		TRANSMIT
			
			ADD		R3, #1
			CMP		R3, R4
			BNE UPPER_LOWER_BOUND

			MOV	R3, #0X41
			MOV	R4, #0X45
			
LEFT_RIGHT_BOUND

			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0
			ADD	R5, #0X85
			BL	TRANSMIT
			MOV	R5, #0
			ADD	R5, R3
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			MOV		R5, #0XFF
			BL		TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0
			ADD	R5, #0XC5
			BL	TRANSMIT
			MOV	R5, #0
			ADD	R5, R3
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			MOV		R5, #0XFF
			BL		TRANSMIT
			
			ADD	R3, #1
			CMP	R3, R4
			BNE	LEFT_RIGHT_BOUND
			POP {LR}
			BX LR 
			END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	BOUNDARY LINES FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;