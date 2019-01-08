
PORTA_DATA 		EQU 0x400043FC

			AREA 	main, CODE, READONLY
			THUMB
			IMPORT	LCD_INIT
			IMPORT Init
			IMPORT DELAY
			EXTERN TRANSMIT
			EXPORT __main
				
__main
			BL Init
			BL	LCD_INIT
		
			
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			
			MOV		R5, #0x1f
			BL		TRANSMIT
			MOV		R5, #0X25
			BL		TRANSMIT
			MOV		R4, #0X0
			BL		TRANSMIT
			MOV		R4, #0X00
			BL		TRANSMIT			
			MOV		R4, #0X0
			BL		TRANSMIT
			MOV		R4, #0X0
			BL		TRANSMIT			
			MOV		R4, #0X0
			BL		TRANSMIT			
			MOV		R5, #0X0
			BL		TRANSMIT
;			MOV		R5, #0X11
;			BL		TRANSMIT
;			MOV		R4, #0X11
;			BL		TRANSMIT
;			MOV		R4, #0X11
;			BL		TRANSMIT			
;			MOV		R4, #0X7E
;			BL		TRANSMIT			
			
;			MOV		R4, #0X4
;			BL		TRANSMIT
;			MOV		R4, #0X1F
;			BL		TRANSMIT
			
;			LDR R1,=PORTA_DATA		
;			LDR	R0,[R1]
;			BIC	R0,#0x40				
;			STR	R0,[R1]	
			
FIN			B		FIN	
			ALIGN
			END
			