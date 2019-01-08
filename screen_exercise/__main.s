
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
			
			MOV		R5, #0X0
			BL		TRANSMIT			
			BL		M
			MOV		R5, #0x0
			BL		TRANSMIT
			BL		A
			MOV		R5, #0X0
			BL		TRANSMIT			
			BL		L
			MOV		R5, #0X0
			BL		TRANSMIT
			MOV		R5, #0X0
			BL		TRANSMIT
			MOV		R5, #0X0
			BL		TRANSMIT			
			BL		M
			MOV		R5, #0x0
			BL		TRANSMIT
			BL		I
			MOV		R5, #0x0
			BL		TRANSMIT
			BL		S
			MOV		R5, #0x0
			BL		TRANSMIT
			BL		I
			MOV		R5, #0x0
			BL		TRANSMIT
			BL		N
			MOV		R5, #0x0
			BL		TRANSMIT
			MOV		R5, #0x0
			BL		TRANSMIT			
			MOV		R5, #0X0
			BL		TRANSMIT			
			BL		A
			MOV		R5, #0X0
			BL		TRANSMIT			
			BL		M
			MOV		R5, #0X0
			BL		TRANSMIT			
			BL		K
			MOV		R5, #0X0
			BL		TRANSMIT			
;			LDR R1,=PORTA_DATA		
;			LDR	R0,[R1]
;			BIC	R0,#0x40				
;			STR	R0,[R1]	
			
FIN			
;			MOV		R5, #0x0
;			BL		TRANSMIT
			
			B		FIN	

		

A			
			PUSH 	{LR}
			MOV		R5, #0X7E
			BL		TRANSMIT
			MOV		R5, #0X11
			BL		TRANSMIT
			MOV		R5, #0X11
			BL		TRANSMIT			
			MOV		R5, #0X11
			BL		TRANSMIT
			MOV		R5, #0X7E
			BL		TRANSMIT	
			POP		{LR}
			BX		LR
			
I			PUSH 	{LR}	
			MOV		R5, #0X00
			BL		TRANSMIT
			MOV		R5, #0X41
			BL		TRANSMIT
			MOV		R5, #0X7F
			BL		TRANSMIT			
			MOV		R5, #0X41
			BL		TRANSMIT
			MOV		R5, #0X00
			BL		TRANSMIT
			POP		{LR}
			BX		LR
	
K			PUSH 	{LR}
			MOV		R5, #0X7F
			BL		TRANSMIT
			MOV		R5, #0X8
			BL		TRANSMIT
			MOV		R5, #0X14
			BL		TRANSMIT
			MOV		R5, #0X22
			BL		TRANSMIT			
			MOV		R5, #0X41
			BL		TRANSMIT
			POP		{LR}
			BX		LR	
			
L			PUSH 	{LR}
			MOV		R5, #0X7F
			BL		TRANSMIT
			MOV		R5, #0X40
			BL		TRANSMIT
			MOV		R5, #0X40
			BL		TRANSMIT
			MOV		R5, #0X40
			BL		TRANSMIT			
			MOV		R5, #0X40
			BL		TRANSMIT			
			POP		{LR}
			BX		LR	



M			PUSH 	{LR}
			MOV		R5, #0X7F
			BL		TRANSMIT
			MOV		R5, #0X02
			BL		TRANSMIT
			MOV		R5, #0XC
			BL		TRANSMIT
			MOV		R5, #0X2
			BL		TRANSMIT			
			MOV		R5, #0X7F
			BL		TRANSMIT				
			POP		{LR}
			BX		LR

N			PUSH 	{LR}			
			MOV		R5, #0X7F
			BL		TRANSMIT
			MOV		R5, #0X04
			BL		TRANSMIT
			MOV		R5, #0X8
			BL		TRANSMIT
			MOV		R5, #0X10
			BL		TRANSMIT			
			MOV		R5, #0X7F
			BL		TRANSMIT			
			POP		{LR}
			BX		LR	

S			PUSH 	{LR}			
			MOV		R5, #0X46
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT			
			MOV		R5, #0X31
			BL		TRANSMIT			
			POP		{LR}
			BX		LR			
			ALIGN
			END	