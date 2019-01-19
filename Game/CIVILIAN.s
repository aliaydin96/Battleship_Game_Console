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
			LDRB	R2, [R1], #1
			LDRB	R12, [R1]
			MOV		R6, #0X41
			ADD R12, #1
			MOV R9, #0X40
			MOV R10, #0XD0
			MOV	R4, #0XD8
			MOV	R11, #0XFC
			ADD R2, #2
LOOP			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R2
			BL	TRANSMIT
			MOV	R5, R6
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			CMP	R6, #0X41
			LSLEQ R9, R12
			LSLEQ R10, R12
			LSLEQ R4, R12
			LSLEQ R11, R12
			BEQ		WORK
			CMP	R6, #0X42
			REV16EQ	R9, R9
			REV16EQ R10, R10
			REV16EQ	R4, R4
			REV16EQ R11, R11
			BEQ		WORK
			CMP	R6, #0X43
			REVEQ	R9, R9
			REVEQ R10, R10
			REVEQ	R4, R4
			REVEQ R11, R11
			BEQ		WORK
			CMP	R6, #0X44
			REV16EQ R9, R9
			REV16EQ R10, R10
			REV16EQ R4, R4
			REV16EQ R11, R11
WORK
			MOV		R5, R9
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R11
			BL		TRANSMIT
			MOV		R5, R4
			BL		TRANSMIT
			MOV		R5, R10
			BL		TRANSMIT
			MOV		R5, R9
			BL		TRANSMIT
			ADD		R6, #1
			CMP		R6, #0X45
			BNE		LOOP
			POP{R0-R12, LR}
			BX 		LR
			ALIGN
			END
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CIVILIAN	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				