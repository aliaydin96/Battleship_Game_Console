ADC0_RIS 		EQU 0x40038004 ; Interrupt status
ADC0_SSFIFO2 	EQU 0x40038088 ; Channel 2 results
ADC0_SSFIFO3 	EQU 0x400380A8 ; Channel 3 results	
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample
ADC0_ISC		EQU	0x4003800C ; ISC
ADC0_SSFSTAT2	EQU	0X4003808C
PORTA_DATA 		EQU 0x400043FC
POSITION		EQU 0X20000400
BATTLE_COUNTER	EQU	0X2000040F
CIV_COUNTER		EQU	0X20000410
SCREEN_COUNTER  EQU 0X20000411
MINE_POSITION	EQU	0X20000412
TIMER0_CTL		EQU 0x4003000C	
MINE_COUNTER	EQU 0X20000424	
RESTART			EQU	0X20000428	

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
			EXTERN  FINAL
			EXTERN	BEGINING
			EXPORT __main
				
__main


			BL Init
			BL	LCD_INIT
			BL	GPIO_INIT
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			BL	CLEAR
			BL	BEGINING
			MOV32	R0, #0XFFFFFF
			BL	DELAY
						LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0x80
			BL	TRANSMIT
			MOV	R5, #0X40
			BL	TRANSMIT
			MOV	R5, #0X0C
			BL	TRANSMIT
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	REGISTERS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	R0  ==> GENERAL PURPOSES
;;;;;	R1  ==> GENERAL PURPOSES
;;;;;	R2  ==> CURSOR'S POSITION
;;;;;	R3  ==> X POSITION
;;;;;	R4  ==> CURSOR'S POSITION
;;;;;	R5  ==> DISPLAY REGISTER
;;;;;	R6  ==> Y POSITION
;;;;;	R7  ==> TIMER'S COUNTER
;;;;;	R8  ==> ADC RESULT 
;;;;;	R9  ==> ADC RESULT
;;;;;	R10 ==> FREE
;;;;;	R11 ==> FREE
;;;;;	R12 ==> FREE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			BL		CL_REG
			MOV32	R9,	 #0xFFFFFFFF
			STR		R10, [R1]
			LDR 	R1,=POSITION
			STR		R9, [R1]
			LDR 	R1,=MINE_POSITION
			STR		R10, [R1]
;			LDR 	R1,=RESTART
;			STR		R10, [R1]			
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
			
			LDR		R1, =SCREEN_COUNTER
			LDRB	R4, [R1]
			CMP		R4, #0
			BLEQ	DISPLAY_SHIP
			CMP		R4, #1
			BLEQ	DISPLAY_SHIP
			CMP		R4, #2
			BLEQ	CLEARBOX
			CMP		R4, #4
			BLEQ	DELAY_5MS
			LDR		R1, =SCREEN_COUNTER
			LDRB	R4, [R1]
			CMP		R4, #6
			ADDEQ   R4,#1
			STRB    R4,[R1]
			MOVEQ	R3, #0X03
			BLEQ	TIMER_INIT
			MOVEQ	R7, #20		;this counter for timer
			LDR 	R10, =SCREEN_COUNTER
			LDRB	R9,[R10]
			CMP 	R9,#12
			MOVEQ	R3, #0X0
			BLEQ	TIMER_INIT
			BLEQ  	FINAL
			LDR		R1, =SCREEN_COUNTER
			LDRB	R4, [R1]
			CMP		R4, #13
			BLEQ   	CL_REG		
			LDR		R1, =SCREEN_COUNTER
			LDRB	R4, [R1]
			CMP		R4, #11
			MOV32HI	R0, #0XFFFF
			BLHI	DELAY
			BHI   	getsample
			
CURSOR
			LDR		R1,=ADC0_SSFIFO2;
			LDR		R8,[R1]; R8 is the data PE3
			MOV		R0,#171; get the first digit
			UDIV	R8,R8,R0;			
			LDR		R1, =ADC0_SSFIFO3
			LDR		R9,[R1]
			MOV		R0,#75; get the first digit
			UDIV	R3,R9,R0;
			ADD		R3, R3,#0x85
			MOV	R6, #0x41
			SUBS R8, #1
			MOVEQ R2, #0x1
			MOVNE R2, #0x2
			MOVEQ R4, #0x3
			MOVNE R4, #0x7
			
LOP			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, R3
			BL	TRANSMIT
			MOV	R5, R6
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]
			CMP	R6, #0x41
			LSLEQ R2, R8
			LSLEQ R4, R8
			BEQ	WORK
			CMP	R6, #0X42
			REV16EQ	R2, R2
			REV16EQ R4, R4
			CMP	R6, #0X43
			REVEQ	R2, R2
			REVEQ R4, R4
WORK			
			CMP	R3, #0x85
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
			ADD	R6, #1
			CMP	R6, #0X44
			BNE LOP
			B	getsample;						

DISPLAY_SHIP
			PUSH	{R4, LR}
			LDR		R1, =CIV_COUNTER
			LDRB	R4, [R1]
			CMP		R4, #0
			BLS		BATTLE
			LDR		R1, =POSITION
			BL		CIVILIAN
			CMP		R4, #1
			BLS		BATTLE
			LDR		R1, =(POSITION + 2)
			BL		CIVILIAN
			CMP		R4, #2
			BLS		BATTLE
			LDR		R1, =(POSITION + 4)
			BL		CIVILIAN
			
BATTLE		
			LDR		R0, =BATTLE_COUNTER
			LDRB	R2, [R0]
			CMP		R2, #0
			BLS		FINISH
			LDR		R1, =(POSITION + 6)
			BL		BATTLESHIP
			CMP		R2, #1
			BLS		FINISH
			LDR		R1, =(POSITION + 8)
			BL		BATTLESHIP
			CMP		R2, #2
			BLS		FINISH
			LDR		R1, =(POSITION + 10)
			BL		BATTLESHIP			
			CMP		R2, #3
			BLS		FINISH
			LDR		R1, =(POSITION + 12)
			BL		BATTLESHIP	
			B		FINISH
FINISH		
			POP	{R4, LR}
			BX	LR
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	5 msec delay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELAY_5MS	
			PUSH 	{LR}	
			BL		DISPLAY_SHIP	
			MOV32	R0, #4000000
			BL		DELAY
			BL		CLEARBOX
			LDR		R1, =SCREEN_COUNTER
			LDRB	R4, [R1]
			ADD 	R4, #1
			STRB	R4, [R1]
			POP		{LR}
			BX		LR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;	CLEAR Y = 1-2-3-4 ROWS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEARBOX	PUSH{R0, R1, R2, LR}
			MOV	R6, #0X41
LOOP_CL			
			LDR R1,=PORTA_DATA
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0X86
			BL	TRANSMIT
			MOV	R5, R6
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
			ADD	R6, #1
			CMP	R6, #0X45
			BNE	LOOP_CL
			
			LDR		R1, =SCREEN_COUNTER
			LDRB	R4, [R1]
			ADD		R4, #1
			STRB 	R4, [R1]
			POP{R0, R1, R2, LR}
			BX	LR
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CL_REG		
			PUSH  {LR}
;			LDR R1,=PORTA_DATA		
;			LDR	R0,[R1]
;			ORR	R0,#0x40				
;			STR	R0,[R1]	
			BL		CLEAR
			BL		BOUNDARY
			MOV		R10, #0		
			LDR		R0, =BATTLE_COUNTER
			STR		R10, [R0]
			LDR		R1, =CIV_COUNTER
			STR		R10, [R1]
			LDR		R1, =SCREEN_COUNTER
			LDR 	R1,=MINE_COUNTER
			STR		R10, [R1]
			POP		{LR}
			BX		LR

			ALIGN
			END	