
; GPIO Registers
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register
;PORT E base address EQU 0x40024000
PORTA_DEN 		EQU 0x4000451C ; Digital Enable
PORTA_PCTL		EQU 0x4000452C ; Alternate function select
PORTA_AFSEL 	EQU 0x40004420 ; Enable Alt functions
PORTA_AMSEL 	EQU 0x40004528 ; Enable analog
PORTA_DIR		EQU	0x40004400	;Set direction
PORTA_DATA 		EQU 0x400043FC
	
RCGCSSI			EQU	0X400FE61C
SSICR0			EQU	0X40008000
SSICR1			EQU	0X40008004
SSICPSR			EQU	0X40008010



			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	Init
Init		PROC
			LDR R1, =RCGCSSI 
			LDR R0, [R1]
			ORR R0, R0, #0x01 
			STR R0, [R1]
			NOP
			NOP
			NOP 
			NOP
			
			LDR R1, =RCGCGPIO ; Turn on GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x01 
			STR R0, [R1]
			NOP
			NOP
			NOP ; Let clock stabilize
						
			LDR R1, =PORTA_DEN
			LDR R0, [R1]
			ORR R0, R0, #0xEC 
			STR R0, [R1]
			
			LDR R1, =PORTA_DIR
			MOV R0, #0XEC 
			STR R0, [R1]
			
			LDR		R1, =PORTA_DATA
			LDR		R0,[R1]
			ORR		R1,#0x80		
			STR		R1,[R0]
			
			LDR R1, =PORTA_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x2C 
			STR R0, [R1]

			LDR R1, =PORTA_PCTL
			LDR R0, [R1]
			MOV32 R0, #0x00202200 
			STR R0, [R1]
	
			LDR R1, =SSICR1
			LDR R0, [R1]
			BIC	R0, R0, #0X06
			STR R0, [R1]
			
				
			LDR	R1, =SSICPSR
			MOV	R0, #2
			STR R0, [R1]
			
			LDR R1, =SSICR0
			MOV32 R0, #0X2C7
			STR R0, [R1]

			LDR R1, =SSICR1
			LDR R0, [R1]
			ORR	R0, R0, #0X02
			STR R0, [R1]
			BX	LR
			ENDP
			ALIGN
			END