
;Nested Vector Interrupt Controller registers
NVIC_EN0_INT30		EQU 0x40000000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI7			EQU 0xE000E41C ; IRQ 28 to 31 Priority Register
; GPIO Registers
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register
;PORT F base address EQU 0x40025000
PORTF_DEN 		EQU 0x4002551C ; Digital Enable
PORTF_PCTL		EQU 0x4002552C ; Alternate function select
PORTF_AFSEL 	EQU 0x40025420 ; Enable Alt functions
PORTF_AMSEL 	EQU 0x40025528 ; Enable analog
PORTF_DIR		EQU	0x40025400	;Set direction
PORTF_DATA 		EQU 0x400253FC
PORTF_LOCK		EQU	0X40025520
GPIO_LOCK_KEY	EQU	0x4C4F434B
GPIO_PORTF_CR_R	EQU	0x40025524
PORTF_PUR		EQU	0x40025510
GPIO_PORTF_IS	EQU	0X40025404
GPIO_PORTF_IBE	EQU	0X40025408
GPIO_PORTF_IEV	EQU	0X4002540C
GPIO_PORTF_IM	EQU	0X40025410
GPIO_PORTF_RIS	EQU	0X40025414	
GPIO_PORTF_ICR	EQU	0X4002541C
	
POSITION		EQU 0X20000400	
BATTLE_COUNTER	EQU	0X20000419
CIV_COUNTER		EQU	0X2000041A
	
			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN BATTLESHIP
			EXTERN CIVILIAN
			EXPORT	GPIOPortF_Handler
			EXPORT 	GPIO_INIT
			
GPIOPortF_Handler	PROC
			PUSH	{R0, R1, R2, R4, R5, LR}
			MOV	R2, #10
LOOP2		MOV	R1, #0XFFFF
LOOP		SUBS	R1, #1
			BNE LOOP
			SUBS R2, #1
			BNE LOOP2

			LDR	R1, =GPIO_PORTF_RIS
			LDR R0, [R1]
			LDR	R1, =GPIO_PORTF_ICR
			MOV	R2, #0X11
			STR	R2, [R1]
			MOV		R5, #0
			LDR		R1, =BATTLE_COUNTER
			LDRB	R2, [R1]
			LDR		R1, =CIV_COUNTER
			LDRB	R4, [R1]
			ADD	R5, R2, R4
			CMP	R5, #4
			BEQ FINISH
			ANDS R0, #0X1
			BNE	CIV
			LDR	R0, =BATTLE_COUNTER
			LDRB	R2, [R0]
			CMP	R2, #4
			BGE FINISH
			CMP	R2, #2
			BGT FOUR_B
			CMP	R2, #1
			BGT THIRD_B
			CMP	R2, #0
			BGT SECOND_B
			LDR	R0, =(POSITION + 13)
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R2, #1
			LDR	R0, =BATTLE_COUNTER
			STRB	R2, [R0]
			B	FINISH
SECOND_B		
			LDR	R0, =(POSITION + 16)
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R2, #1
			LDR	R0, =BATTLE_COUNTER
			STRB	R2, [R0]
			B	FINISH
THIRD_B
			LDR	R0, =(POSITION + 19)
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R2, #1
			LDR	R0, =BATTLE_COUNTER
			STRB	R2, [R0]
			B FINISH
FOUR_B
			LDR	R0, =(POSITION + 22)
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R2, #1
			LDR	R0, =BATTLE_COUNTER
			STRB	R2, [R0]
			B FINISH
			
CIV			
			LDR R1, =CIV_COUNTER
			LDRB	R4, [R1]
			CMP	R4, #3
			BGE FINISH
			CMP	R4, #1
			BGT THIRD
			CMP	R4, #0
			BGT SECOND
			LDR	R0, =POSITION
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R4, #1
			LDR	R1, =CIV_COUNTER
			STRB	R4, [R1]
			B	FINISH
SECOND		
			LDR	R0, =(POSITION + 3)
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R4, #1
			LDR	R1, =CIV_COUNTER
			STRB	R4, [R1]
			B	FINISH
THIRD
			LDR	R0, =(POSITION + 6)
			STR	R3, [R0], #1 ;X POSITION
			STR	R6, [R0], #1 ;Y POSITION
			STR	R8, [R0]	 ;SHIFTING
			ADD	R4, #1
			LDR	R1, =CIV_COUNTER
			STRB	R4, [R1]
FINISH			
			
			POP	{R0, R1, R2, R4, R5, LR}
			BX	LR
			ENDP
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;	GPIO INIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				
GPIO_INIT	PROC                    
			LDR R1 , =RCGCGPIO
			LDR R0 , [ R1 ]
			ORR R0 , R0 , #0x20;Port F clock enabled
			STR R0 , [ R1 ]
			NOP		;Wait for clock to stabilize
			NOP
			NOP
			LDR R1, =PORTF_LOCK
			LDR	R0, =GPIO_LOCK_KEY
			STR	R0, [R1]
			LDR R1, =GPIO_PORTF_CR_R
			MOV R0, #0xFF
			STR R0, [R1]			
			LDR R1 , =PORTF_DIR ; Config of Port F starts
			MOV R0 , #0x2 
			STR R0 , [ R1 ]
			LDR R1 , =PORTF_AFSEL
			LDR R0 , [ R1 ]
			BIC R0 , #0xFF
			STR R0 , [ R1 ]
			LDR R1 , =PORTF_DEN
			LDR R0 , [ R1 ]
			ORR R0 , #0xFF
			STR R0 , [ R1 ]
			LDR R1 , =PORTF_PUR
			LDR R0 , [ R1 ]
			ORR R0 , #0x11
			STR R0 , [ R1 ]

			LDR	R1, =GPIO_PORTF_IS
			LDR R2, =GPIO_PORTF_IBE
			LDR R3, =GPIO_PORTF_IEV
			LDR R4, =GPIO_PORTF_IM
			LDR R5, =GPIO_PORTF_ICR
			MOV R0, #0x00
			STR R0, [R1]
			STR R0, [R2]
			STR	R0, [R3]
			MOV	R0, #0x11
			STR R0, [R4]
			STR R0, [R5]	

			LDR R1, =NVIC_PRI7
			LDR R2, [R1]
			AND R2, R2, #0xFF00FFFF ;
			ORR R2, R2, #0x00400000 ;
			STR R2, [R1]
			LDR R1, =NVIC_EN0
			MOV R2, #0x40000000 ; set bit 19 to enable interrupt 19
			STR R2, [R1]
; Enable timer
;			LDR R1 , =PORTF_DATA
;			MOV R0, #0x0
;			STR	R0, [R1]			
			BX LR; end

			ALIGN
			ENDP
			END
				


	