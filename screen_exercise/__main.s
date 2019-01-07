
PORTA_DATA 		EQU 0x400043FC
SSIDR			EQU	0X40008008


			AREA 	main, CODE, READONLY
			THUMB
				
			IMPORT Init
			IMPORT DELAY
			EXTERN PRINT
			EXPORT __main
				
__main
			BL Init
			
loop
			LDR 	R1,=PORTA_DATA
			MOV 	R0,#0x08
			STR 	R0,[R1]
			MOV32 	R0, #1600000 ;100MS DELAY
			BL		DELAY
			MOV		R0, #0X80
			STR		R0, [R1]
			
			MOV		R5, #0X21
			BL		PRINT	
			MOV		R5, #0X90
			BL		PRINT
			MOV		R5, #0X20
			BL		PRINT
			MOV		R5, #0XC
			BL		PRINT

			MOV		R5, #0X1F
			BL		PRINT
			MOV		R0, #0X40
			STR		R0, [R1]
			MOV		R5, #0X05
			BL		PRINT
			MOV		R4, #0X7
			BL		PRINT
			MOV		R4, #0X0
			BL		PRINT			
			MOV		R4, #0X1F
			BL		PRINT	
			
			ALIGN
			END
			