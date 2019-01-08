
PORTA_DATA 		EQU 0x400043FC

			AREA 	main, CODE, READONLY
			THUMB
			IMPORT	LCD_INIT
			IMPORT Init
			IMPORT DELAY
			EXTERN TRANSMIT
			EXTERN	TIMER_INIT
			EXTERN	Timer0A_Handler
			EXPORT __main
				
__main
			BL Init
			BL	LCD_INIT
			
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			
			BL		CLEAR
			BL		BOUNDARY
			BL		TIMER_INIT
			MOV	R7, #21
FIN					
;			MOV		R5, #0x0
;			BL		TRANSMIT
			
			B		FIN	
			
CLEAR		PUSH	{R0,R1,LR}
			MOV		R0,#0
			MOV		R1, #503
LOOP		MOV		R5, #0X0
			PUSH	{R0,R1}
			BL		TRANSMIT
			POP		{R0,R1}
			ADD		R0, #1
			CMP		R0,R1
			BNE		LOOP
			POP		{R0,R1,LR}
			BX		LR
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
			ADD	R5, #0XC6
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	BOUNDARY LINES FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
;N0			PUSH 	{LR}	
;			MOV		R5, #0X3E
;			BL		TRANSMIT
;			MOV		R5, #0X51
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT			
;			MOV		R5, #0X45
;			BL		TRANSMIT
;			MOV		R5, #0X3E
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N1			PUSH 	{LR}	
;			MOV		R5, #0X0
;			BL		TRANSMIT
;			MOV		R5, #0X42
;			BL		TRANSMIT
;			MOV		R5, #0X7F
;			BL		TRANSMIT			
;			MOV		R5, #0X40
;			BL		TRANSMIT
;			MOV		R5, #0X0
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N2			PUSH 	{LR}	
;			MOV		R5, #0X42
;			BL		TRANSMIT
;			MOV		R5, #0X61
;			BL		TRANSMIT
;			MOV		R5, #0X51
;			BL		TRANSMIT			
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X46
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR
;	
;N3			PUSH 	{LR}	
;			MOV		R5, #0X21
;			BL		TRANSMIT
;			MOV		R5, #0X41
;			BL		TRANSMIT
;			MOV		R5, #0X45
;			BL		TRANSMIT			
;			MOV		R5, #0X4B
;			BL		TRANSMIT
;			MOV		R5, #0X31
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N4			PUSH 	{LR}	
;			MOV		R5, #0X18
;			BL		TRANSMIT
;			MOV		R5, #0X14
;			BL		TRANSMIT
;			MOV		R5, #0X12
;			BL		TRANSMIT			
;			MOV		R5, #0X7F
;			BL		TRANSMIT
;			MOV		R5, #0X10
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N5			PUSH 	{LR}	
;			MOV		R5, #0X27
;			BL		TRANSMIT
;			MOV		R5, #0X45
;			BL		TRANSMIT
;			MOV		R5, #0X45
;			BL		TRANSMIT			
;			MOV		R5, #0X45
;			BL		TRANSMIT
;			MOV		R5, #0X39
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N6			PUSH 	{LR}	
;			MOV		R5, #0X3C
;			BL		TRANSMIT
;			MOV		R5, #0X4A
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT			
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X30
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N7			PUSH 	{LR}	
;			MOV		R5, #0X1
;			BL		TRANSMIT
;			MOV		R5, #0X71
;			BL		TRANSMIT
;			MOV		R5, #0X9
;			BL		TRANSMIT			
;			MOV		R5, #0X5
;			BL		TRANSMIT
;			MOV		R5, #0X3
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N8			PUSH 	{LR}	
;			MOV		R5, #0X36
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT			
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X36
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR

;N9			PUSH 	{LR}	
;			MOV		R5, #0X6
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT			
;			MOV		R5, #0X29
;			BL		TRANSMIT
;			MOV		R5, #0X1E
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR
		

;A			
;			PUSH 	{LR}
;			MOV		R5, #0X7E
;			BL		TRANSMIT
;			MOV		R5, #0X11
;			BL		TRANSMIT
;			MOV		R5, #0X11
;			BL		TRANSMIT			
;			MOV		R5, #0X11
;			BL		TRANSMIT
;			MOV		R5, #0X7E
;			BL		TRANSMIT	
;			POP		{LR}
;			BX		LR
;B_			PUSH 	{LR}	
;			
;			POP		{LR}
;			BX		LR			
;C			PUSH 	{LR}	
;			
;			POP		{LR}
;			BX		LR
;D			PUSH 	{LR}	
;			
;			POP		{LR}
;			BX		LR
;E			PUSH 	{LR}	
;			
;			POP		{LR}
;			BX		LR			

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
;	
;K			PUSH 	{LR}
;			MOV		R5, #0X7F
;			BL		TRANSMIT
;			MOV		R5, #0X8
;			BL		TRANSMIT
;			MOV		R5, #0X14
;			BL		TRANSMIT
;			MOV		R5, #0X22
;			BL		TRANSMIT			
;			MOV		R5, #0X41
;			BL		TRANSMIT
;			POP		{LR}
;			BX		LR	
;			
;L			PUSH 	{LR}
;			MOV		R5, #0X7F
;			BL		TRANSMIT
;			MOV		R5, #0X40
;			BL		TRANSMIT
;			MOV		R5, #0X40
;			BL		TRANSMIT
;			MOV		R5, #0X40
;			BL		TRANSMIT			
;			MOV		R5, #0X40
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR	



;M			PUSH 	{LR}
;			MOV		R5, #0X7F
;			BL		TRANSMIT
;			MOV		R5, #0X02
;			BL		TRANSMIT
;			MOV		R5, #0XC
;			BL		TRANSMIT
;			MOV		R5, #0X2
;			BL		TRANSMIT			
;			MOV		R5, #0X7F
;			BL		TRANSMIT				
;			POP		{LR}
;			BX		LR

;N			PUSH 	{LR}			
;			MOV		R5, #0X7F
;			BL		TRANSMIT
;			MOV		R5, #0X04
;			BL		TRANSMIT
;			MOV		R5, #0X8
;			BL		TRANSMIT
;			MOV		R5, #0X10
;			BL		TRANSMIT			
;			MOV		R5, #0X7F
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR	

;S			PUSH 	{LR}			
;			MOV		R5, #0X46
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT
;			MOV		R5, #0X49
;			BL		TRANSMIT			
;			MOV		R5, #0X31
;			BL		TRANSMIT			
;			POP		{LR}
;			BX		LR			
			ALIGN
			END	