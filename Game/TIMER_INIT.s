SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
;Nested Vector Interrupt Controller registers
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register
PORTA_DATA 			EQU 0x400043FC
SCREEN_COUNTER  	EQU 0X20000411
	
			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN TRANSMIT
			EXTERN FINAL
			EXTERN	DELAY
			EXPORT 	Timer0A_Handler
			EXPORT	TIMER_INIT


Timer0A_Handler	PROC
			PUSH {LR}
			
			LDR	R1,=TIMER0_ICR; Clear the Flag
			MOV	R0,#0x01;
			STR	R0,[R1]; Time Out Interrupt clearead

			BL CLEAR
			SUB R7, #1
			LDR  	R1,=SCREEN_COUNTER
			LDRB  	R0,[R1]
			CMP	 	R0, #13
			BEQ		STP
			CMP R7,#-1
			BLEQ ENDDD
			CMP	R7, #20
			BEQ TWENTY
			
			CMP	R7, #9
			BLGT	N1
			MOV	R5, #0X0
			BL	TRANSMIT
			
			CMP R7, #19
			BLEQ	N9			
			CMP R7, #18
			BLEQ N8
			CMP R7, #17
			BLEQ N7 
			CMP R7, #16
			BLEQ N6 
			CMP R7, #15
			BLEQ N5
			CMP R7, #14
			BLEQ N4 
			CMP R7, #13
			BLEQ N3 
			CMP R7, #12
			BLEQ	N2 
			CMP R7, #11
			BLEQ	N1
			CMP R7, #10
			BLEQ	N0 		
			CMP R7, #9
			BLEQ	N9			
			CMP R7, #8
			BLEQ N8
			CMP R7, #7
			BLEQ N7 
			CMP R7, #6
			BLEQ N6 
			CMP R7, #5
			BLEQ N5
			CMP R7, #4
			BLEQ N4 
			CMP R7, #3
			BLEQ N3 
			CMP R7, #2
			BLEQ	N2 
			CMP R7, #1
			BLEQ	N1
			CMP R7, #0
			BLEQ	N0 
			MOV32EQ	R0, #0XFFFF
			BLEQ	DELAY
			B	FINISH
			
TWENTY			
			BL	N2
			MOV	R5, #0X0
			BL	TRANSMIT
			BL	N0
STP
			LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]
			BIC R2, R2, #0x01
			STR R2, [R1]
ENDDD
			LDR  	R1,=SCREEN_COUNTER
			LDRB  	R0,[R1]
			MOV	 	R0, #12
			STRB	R0,[R1]
			
FINISH		POP	{LR}
			BX	LR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	CLEAR 14X8 BOX BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEAR		PUSH {LR}
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0xC7
			BL	TRANSMIT
			MOV	R5, #0X40
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			

			MOV	R4, #13			
LOOP		MOV	R5, #0X0	;CLEAR NUMBER PLACE
			BL	TRANSMIT
			SUBS R4, #1
			BNE	LOOP
			
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			BIC	R0,#0x40				
			STR	R0,[R1]
			
			MOV	R5, #0xC7
			BL	TRANSMIT
			MOV	R5, #0X40
			BL	TRANSMIT
			
			LDR R1,=PORTA_DATA		
			LDR	R0,[R1]
			ORR	R0,#0x40				
			STR	R0,[R1]	
			POP {LR}
			BX	LR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	CLEAR 14X8 BOX FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	NUMBERS	0-9	BEGINNING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
N0			PUSH 	{LR}	
			MOV		R5, #0X3E
			BL		TRANSMIT
			MOV		R5, #0X51
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT			
			MOV		R5, #0X45
			BL		TRANSMIT
			MOV		R5, #0X3E
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N1			PUSH 	{LR}	
			MOV		R5, #0X0
			BL		TRANSMIT
			MOV		R5, #0X42
			BL		TRANSMIT
			MOV		R5, #0X7F
			BL		TRANSMIT			
			MOV		R5, #0X40
			BL		TRANSMIT
			MOV		R5, #0X0
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N2			PUSH 	{LR}	
			MOV		R5, #0X42
			BL		TRANSMIT
			MOV		R5, #0X61
			BL		TRANSMIT
			MOV		R5, #0X51
			BL		TRANSMIT			
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X46
			BL		TRANSMIT			
			POP		{LR}
			BX		LR
	
N3			PUSH 	{LR}	
			MOV		R5, #0X21
			BL		TRANSMIT
			MOV		R5, #0X41
			BL		TRANSMIT
			MOV		R5, #0X45
			BL		TRANSMIT			
			MOV		R5, #0X4B
			BL		TRANSMIT
			MOV		R5, #0X31
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N4			PUSH 	{LR}	
			MOV		R5, #0X18
			BL		TRANSMIT
			MOV		R5, #0X14
			BL		TRANSMIT
			MOV		R5, #0X12
			BL		TRANSMIT			
			MOV		R5, #0X7F
			BL		TRANSMIT
			MOV		R5, #0X10
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N5			PUSH 	{LR}	
			MOV		R5, #0X27
			BL		TRANSMIT
			MOV		R5, #0X45
			BL		TRANSMIT
			MOV		R5, #0X45
			BL		TRANSMIT			
			MOV		R5, #0X45
			BL		TRANSMIT
			MOV		R5, #0X39
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N6			PUSH 	{LR}	
			MOV		R5, #0X3C
			BL		TRANSMIT
			MOV		R5, #0X4A
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT			
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X30
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N7			PUSH 	{LR}	
			MOV		R5, #0X1
			BL		TRANSMIT
			MOV		R5, #0X71
			BL		TRANSMIT
			MOV		R5, #0X9
			BL		TRANSMIT			
			MOV		R5, #0X5
			BL		TRANSMIT
			MOV		R5, #0X3
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N8			PUSH 	{LR}	
			MOV		R5, #0X36
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT			
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X36
			BL		TRANSMIT			
			POP		{LR}
			BX		LR

N9			PUSH 	{LR}	
			MOV		R5, #0X6
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT
			MOV		R5, #0X49
			BL		TRANSMIT			
			MOV		R5, #0X29
			BL		TRANSMIT
			MOV		R5, #0X1E
			BL		TRANSMIT			
			POP		{LR}
			BX		LR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	NUMBERS	0-9	FINISH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
			ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	TIMER INITIALIZE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TIMER_INIT	PROC
			LDR R1, =SYSCTL_RCGCTIMER ; Start Timer0
			LDR R2, [R1]
			ORR R2, R2, #0X01
			STR R2, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			LDR R1, =TIMER0_CTL ; disable timer during setup LDR R2, [R1]
			BIC R2, R2, #0x01
			STR R2, [R1]
			LDR R1, =TIMER0_CFG ; set 32 bit mode
			MOV R2, #0x00
			STR R2, [R1]
			LDR R1, =TIMER0_TAMR
			MOV R2, #0x02 ; set to periodic, count down
			STR R2, [R1]
			LDR R1, =TIMER0_TAILR ; initialize match clocks
			LDR R2, =15999999 ;1 SEC 
			STR R2, [R1]
			LDR R1, =TIMER0_IMR ; enable timeout interrupt
			MOV	R2, #0X01
			STR R2, [R1]
; Configure interrupt priorities
; Timer0A is interrupt #19.
; Interrupts 16-19 are handled by NVIC register PRI4.
; Interrupt 19 is controlled by bits 31:29 of PRI4.
; set NVIC interrupt 19 to priority 2
			LDR R1, =NVIC_PRI4
			LDR R2, [R1]
			AND R2, R2, #0x00FFFFFF ; clear interrupt 19 priority
			ORR R2, R2, #0x40000000 ; set interrupt 19 priority to 2
			STR R2, [R1]
; NVIC has to be enabled
; Interrupts 0-31 are handled by NVIC register EN0
; Interrupt 19 is controlled by bit 19
; enable interrupt 19 in NVIC
			LDR R1, =NVIC_EN0
			MOV R2, #0x080000 ; set bit 19 to enable interrupt 19
			STR R2, [R1]
; Enable timer
			LDR R1, =TIMER0_CTL
			LDR R2, [R1]
			ORR R2, R2, R3;#0x03 ; set bit0 to enable
			STR R2, [R1] ; and bit 1 to stall on debug			
			
			BX	LR
			ENDP
			ALIGN
			END
				