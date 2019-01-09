ADC0_RIS 		EQU 0x40038004 ; Interrupt status
ADC0_SSFIFO2 	EQU 0x40038088 ; Channel 3 results
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample
ADC0_ISC		EQU	0x4003800C ; ISC
ADC0_SSFSTAT2	EQU	0X4003808C
PORTA_DATA 		EQU 0x400043FC

			AREA 	main, CODE, READONLY
			THUMB
			IMPORT	LCD_INIT
			IMPORT Init
			IMPORT DELAY
			EXTERN OutChar
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
;			BL		TIMER_INIT
;			MOV	R7, #21		;this counter for timer 
			MOV		R6,#0;
			MOV		R7, #0
			MOV		R11, #0
getsample	LDR		R1,=ADC0_PSSI; request a sample
			LDR		R0,[R1];
			ORR		R0,R0,#0x04; get a sample
			STR		R0,[R1];
				
loop		LDR		R1,=ADC0_RIS; check for interrup flag
			LDR		R0,[R1];
			ANDS	R0,#0x04;
			BEQ		loop
			
			LDR		R1,=ADC0_ISC; clear the interrupt flag
			LDR		R0,[R1];
			ORR		R0,#0x04;
			STR		R0,[R1]; Interrupt flag is cleared
			
			LDR		R1,=ADC0_SSFIFO2;
			LDR		R8,[R1]; R2 is the data
			LDR		R9,[R1]
		
			SUB		R0,R9,R6; check sampled data - previous > 1pix
			CMP		R0,#70;
			BGT		LEFT_RIGHT;
;			SUB		R0,R8,R7; check sampled data - previous > 1pix
;			CMP		R0,#160;
;			BGT		UP_DOWN;
;			SUB		R0,R7,R8;
;			CMP		R0,#160; check previous - sampled data > 1 pix
;			BLT		getsample;
			SUB		R0,R6,R9;
			CMP		R0,#70; check previous - sampled data > 1 pix
			BLT		getsample;
				
LEFT_RIGHT	MOV		R6,R9;
			MOV		R0,#73; get the first digit
			UDIV	R3,R9,R0;
			ADD		R3, #0X85
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, #0X42
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			CMP	R3, #0X85
			MOVEQ R5, #0XFF			
			MOVNE R5, #0X0
			BL	TRANSMIT
			MOV R5, #0X2
			BL	TRANSMIT
			MOV	R5, #0X7
			BL	TRANSMIT			
			MOV	R5, #0X2
			BL	TRANSMIT
			MOV	R5, #0X0
			BL	TRANSMIT			
			B		getsample;	

;UP_DOWN		MOV		R7,R8;
;			MOV		R0,#170; get the first digit
;			UDIV	R10,R8,R0;
;			CMP		R10, #8
;			MOVCS	R4, #0X42
;			CMP		R10, #16
;			MOVCC	R4, #0X42
;			SUBCC	R10, #8
;			MOVCS	R4, #0X41
;			
;			LDR R1,=PORTA_DATA
;			LDR	R0,[R1]
;			BIC	R0,#0x40				
;			STR	R0,[R1]
;			
;			MOV	R5, #0X8F
;			BL	TRANSMIT
;			MOV	R5, R4
;			BL	TRANSMIT
;			
;			LDR R1,=PORTA_DATA
;			LDR	R0,[R1]
;			ORR	R0,#0x40				
;			STR	R0,[R1]	
;			CMP	R4, #0X42
;			BEQ	BLOCK2

;			B		getsample;

;BLOCK2		PUSH	{R10}
;			MOV R5, #0X0 
;			BL	TRANSMIT
;			SUBS R10, R10, R11
;			BMI	BLOCK2_NEG
;			MOV R5, #0X2 
;			LSL R5, R10
;			BL	TRANSMIT
;			MOV	R5, #0X7 
;			LSL R5, R10
;			BL	TRANSMIT			
;			MOV	R5, #0X2 
;			LSL R5, R10
;			BL	TRANSMIT
;			B	BLOCK2_END
;BLOCK2_NEG	
;			MOV R5, #0X2 
;			LSR R5, R10
;			BL	TRANSMIT
;			MOV	R5, #0X7 
;			LSR R5, R10
;			BL	TRANSMIT			
;			MOV	R5, #0X2 
;			LSR R5, R10
;			BL	TRANSMIT
;			
;BLOCK2_END	MOV	R5, #0X0
;			BL	TRANSMIT
;			POP	{R10}
;			MOV	R11, R10
;			B		getsample;
FIN							
			B		FIN	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CLEAR WHOLE SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	BOUNDARY LINES FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	NUMBERS	0-9	BEGINNING
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	NUMBERS	0-9	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	CHAR	A-Z	BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;I			PUSH 	{LR}	
;			MOV		R5, #0X00
;			BL		TRANSMIT
;			MOV		R5, #0X41
;			BL		TRANSMIT
;			MOV		R5, #0X7F
;			BL		TRANSMIT			
;			MOV		R5, #0X41
;			BL		TRANSMIT
;			MOV		R5, #0X00
;			BL		TRANSMIT
;			POP		{LR}
;			BX		LR
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	CHAR	A-Z	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			ALIGN
			END	