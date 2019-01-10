ADC0_RIS 		EQU 0x40038004 ; Interrupt status
ADC0_SSFIFO2 	EQU 0x40038088 ; Channel 2 results
ADC0_SSFIFO3 	EQU 0x400380A8 ; Channel 3 results	
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample
ADC0_ISC		EQU	0x4003800C ; ISC
ADC0_SSFSTAT2	EQU	0X4003808C
PORTA_DATA 		EQU 0x400043FC
POSITION		EQU 0X20000400
			AREA 	main, CODE, READONLY
			THUMB
			IMPORT	LCD_INIT
			IMPORT Init
			IMPORT DELAY
			EXTERN OutChar
			EXTERN TRANSMIT
			EXTERN	TIMER_INIT
			EXTERN  BATTLESHIP
			EXTERN  BOUNDARY
			EXTERN  CIVILIAN
			EXTERN	Timer0A_Handler
			EXTERN	GPIOPortF_Handler
			EXTERN 	GPIO_INIT
			EXPORT __main
				
__main
			BL Init
			BL	LCD_INIT
			BL	GPIO_INIT
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			BL		CLEAR
			BL		BOUNDARY
;			BL		TIMER_INIT
;			MOV	R7, #21		;this counter for timer 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	REGISTERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	R0  ==> GENERAL PURPOSES
;;;;;	R1  ==> GENERAL PURPOSES
;;;;;	R2  ==> CURSOR'S POSITION
;;;;;	R3  ==> X POSITION
;;;;;	R4  ==> CURSOR'S POSITION
;;;;;	R5  ==> DISPLAY REGISTER
;;;;;	R6  ==> FREE
;;;;;	R7  ==> TIMER'S COUNTER
;;;;;	R8  ==> ADC RESULT 
;;;;;	R9  ==> ADC RESULT
;;;;;	R10 ==> FREE
;;;;;	R11 ==> FREE
;;;;;	R12 ==> FREE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getsample	LDR		R1,=ADC0_PSSI; request a sample
			LDR		R0,[R1];
			ORR		R0,R0,#0x0C; get a sample
			STR		R0,[R1];
				
loop		LDR		R1,=ADC0_RIS; check for interrup flag
			LDR		R0,[R1];
			ANDS	R0,#0x0C;
			BEQ		loop
			
			LDR		R1,=ADC0_ISC; clear the interrupt flag
			LDR		R0,[R1];
			ORR		R0,#0x0C;
			STR		R0,[R1]; Interrupt flag is cleared
			
			LDR		R1,=ADC0_SSFIFO2;
			LDR		R8,[R1]; R8 is the data PE3
			
			
			LDR		R1, =ADC0_SSFIFO3
			LDR		R9,[R1]

CURSOR	
;			BL		BOUNDARY
;			BL		BATTLESHIP
;			BL		CIVILIAN
			MOV		R0,#75; get the first digit
			UDIV	R3,R9,R0;
			ADD		R3, #0X84
			MOV		R0,#174; get the first digit
			UDIV	R8,R8,R0;
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, #0x41
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			
			SUBS R8, #1
			MOVEQ R2, #0X1
			MOVNE R2, #0X2
			MOVEQ	R4, #0X3
			MOVNE R4, #0X7
			LSL R2, R8
			LSL R4, R8

			
			CMP	R3, #0X85
			MOVEQ R5, #0XFF			
			MOVNE R5, #0X0
			BL	TRANSMIT		
			MOV R5, R2  ;NE
			BL	TRANSMIT
			MOV	R5, R4 
			BL	TRANSMIT			
			MOV	R5, R2
			BL	TRANSMIT	
			MOV	R5, #0X0
			BL	TRANSMIT	
			

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

			CMP	R3, #0X85
			MOVEQ R5, #0XFF			
			MOVNE R5, #0X0
			BL	TRANSMIT		
			MOV R5, R2 ;NE
			BL	TRANSMIT
			MOV	R5, R4	
			BL	TRANSMIT			
			MOV	R5, R2
			BL	TRANSMIT	
			MOV	R5, #0X0
			BL	TRANSMIT
		
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

			CMP	R3, #0X85
			MOVEQ R5, #0XFF			
			MOVNE R5, #0X0
			BL	TRANSMIT		
			MOV R5, R2 ;NE
			BL	TRANSMIT
			MOV	R5, R4	
			BL	TRANSMIT			
			MOV	R5, R2
			BL	TRANSMIT	
			MOV	R5, #0X0
			BL	TRANSMIT
			B		getsample;						

FIN							
			B		FIN	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CLEAR WHOLE SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEAR		PUSH	{R0,R1,LR}
			MOV		R0,#0
			MOV		R1, #503
LOOP		MOV		R5, #0X0
			BL		TRANSMIT
			ADD		R0, #1
			CMP		R0,R1
			BNE		LOOP
			POP		{R0,R1,LR}
			BX		LR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CLEAR Y = 1 ROW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEARBOX1	PUSH{R0, R1, R2, LR}
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0X86
			BL	TRANSMIT
			MOV	R5, #0X41
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			MOV	R2, #0X86
			
LOOP_C		MOV		R5, #0X0
			BL		TRANSMIT
			ADD	R2, #1
			CMP	R2, #0XC5
			BNE	LOOP_C
			
			POP{R0, R1, R2, LR}
			BX	LR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CLEAR Y = 2 ROW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEARBOX2	PUSH{R0, R1, R2, LR}
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0X86
			BL	TRANSMIT
			MOV	R5, #0X42
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			MOV	R2, #0X86
			
LOOP_C_2	MOV		R5, #0X0
			BL		TRANSMIT
			ADD	R2, #1
			CMP	R2, #0XC5
			BNE	LOOP_C_2
			
			POP{R0, R1, R2, LR}
			BX	LR			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CLEAR Y = 3 ROW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEARBOX3	PUSH{R0, R1, R2, LR}
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0X86
			BL	TRANSMIT
			MOV	R5, #0X43
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			MOV	R2, #0X86
			
LOOP_C_3	MOV		R5, #0X0
			BL		TRANSMIT
			ADD	R2, #1
			CMP	R2, #0XC5
			BNE	LOOP_C_3
			
			POP{R0, R1, R2, LR}
			BX	LR			
			

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