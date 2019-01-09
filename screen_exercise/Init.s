
; GPIO Registers
RCGCGPIO 		EQU 0x400FE608 ; GPIO clock register
;PORT A base address EQU 0x40004000
PORTA_DEN 		EQU 0x4000451C ; Digital Enable
PORTA_PCTL		EQU 0x4000452C ; Alternate function select
PORTA_AFSEL 	EQU 0x40004420 ; Enable Alt functions
PORTA_AMSEL 	EQU 0x40004528 ; Enable analog
PORTA_DIR		EQU	0x40004400	;Set direction
PORTA_DATA 		EQU 0x400043FC
;PORT E base address EQU 0x40024000
PORTE_DEN 		EQU 0x4002451C ; Digital Enable
PORTE_PCTL		EQU 0x4002452C ; Alternate function select
PORTE_AFSEL 	EQU 0x40024420 ; Enable Alt functions
PORTE_AMSEL 	EQU 0x40024528 ; Enable analog
PORTE_DIR		EQU	0x40024400	;Set direction
;PORT F base address EQU 0x40025000
PORTF_DEN 		EQU 0x4002551C ; Digital Enable
PORTF_PCTL		EQU 0x4002552C ; Alternate function select
PORTF_AFSEL 	EQU 0x40025420 ; Enable Alt functions
PORTF_AMSEL 	EQU 0x40025528 ; Enable analog
PORTF_DIR		EQU	0x40025400	;Set direction
PORTF_DATA 		EQU 0x400253FC
; ADC Registers
RCGCADC 		EQU 0x400FE638 ; ADC clock register
;ADC0 base address EQU 0x40038000
ADC0_ACTSS 		EQU 0x40038000 ; Sample sequencer (ADC0 base address)
ADC0_RIS 		EQU 0x40038004 ; Interrupt status
ADC0_IM 		EQU 0x40038008 ; Interrupt select
ADC0_EMUX 		EQU 0x40038014 ; Trigger select
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample
ADC0_SSMUX2 	EQU 0x40038080 ; Input channel select
ADC0_SSCTL2 	EQU 0x40038084 ; Sample sequence control
ADC0_SSFIFO2 	EQU 0x40038088 ; Channel 2 results
ADC0_PP 		EQU 0x40038FC4 ; Sample rate
ADC0_SSMUX3 	EQU 0x400380A0 ; Input channel select
ADC0_SSCTL3 	EQU 0x400380A4 ; Sample sequence control
ADC0_SSFIFO3 	EQU 0x400380A8 ; Channel 3 results	
ADC0_SSPRI 		EQU 0x40038020
;SSI REGISTERS	
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
			NOP
			
			LDR R1, =RCGCADC ; Turn on ADC clock
			LDR R0, [R1]
			ORR R0, R0, #0x03 ; set bit 0 to enable ADC0 clock
			STR R0, [R1]
			NOP
			NOP
			NOP ; Let clock stabilize
			NOP
			NOP
			
			LDR R1, =RCGCGPIO ; Turn on GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x31 
			STR R0, [R1]
			NOP
			NOP
			NOP ; Let clock stabilize
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
;;;;;;;;;;	SSI INITIALIZE 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;						
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
			MOV	R0, #6
			STR R0, [R1]
			
			LDR R1, =SSICR0
			MOV32 R0, #0XC7
			STR R0, [R1]

			LDR R1, =SSICR1
			LDR R0, [R1]
			ORR	R0, R0, #0X02
			STR R0, [R1]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
;;;;;;;;;;	ADC INITIALIZE 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			; Setup GPIO to make PE3 input for ADC0
			; Setup GPIO to make PE2 input for ADC0
			; Enable alternate functions
			LDR R1, =PORTE_AFSEL
			MOV R0, #0x18 ; set bit 3-4 to enable alt functions on PE3 AND PE4
			STR R0, [R1]
			
			
			LDR R1, =PORTE_DIR
			LDR R0, [R1]
			BIC R0, R0, #0x18 ; set bit 3-4 to input for PE3 AND PE2
			STR R0, [R1]
			; PCTL does not have to be configured
			; since ADC0 is automatically selected when
			; port pin is set to analog.
			; Disable digital on PE3 AND PE2
			LDR R1, =PORTE_DEN
			LDR R0, [R1]
			BIC R0, R0, #0x18 ; clear bit 3-2 to disable analog on PE3 AND PE2
			STR R0, [R1]
			; Enable analog on PE3
			LDR R1, =PORTE_AMSEL
			LDR R0, [R1]
			ORR R0, R0, #0x18 ; set bit 3-2 to enable analog on PE3 AND PE2
			STR R0, [R1]
			; Disable sequencer while ADC setup
			LDR R1, =ADC0_ACTSS
			LDR R0, [R1]
			BIC R0, R0, #0x0C ; clear bit 2 to disable seq 2
			STR R0, [R1]
			; Select trigger source
			LDR R1, =ADC0_EMUX
			LDR R0, [R1]
			BIC R0, R0, #0xFF00 ; clear bits 15:12 to select SOFTWARE
			STR R0, [R1] ; trigger
			; Select input channel
			LDR R1, =ADC0_SSMUX2
			MOV	R0, #0x0 ;AIN0 IS INPUT
			STR R0, [R1]
			; Config sample sequence
			LDR R1, =ADC0_SSCTL2
			LDR R0, [R1]
			ORR R0, R0, #0x6 ; set bits 2:1 (IE0, END0)
			STR R0, [R1]
			
			LDR R1, =ADC0_SSMUX3
			LDR	R0, [R1]
			ORR R0, R0, #0x9  ;AIN9 IS INPUT
			STR R0, [R1]
			; Config sample sequence
			LDR R1, =ADC0_SSCTL3
			LDR R0, [R1]
			ORR R0, R0, #0x6 ; set bits 2:1 (IE0, END0)
			STR R0, [R1]
			
			LDR R1, =ADC0_SSPRI
			LDR R0, [R1]
			ORR R0, R0, #0x1000 ; set bits 3:0 to 1 for 125k sps
			STR R0, [R1]			
			; Set sample rate
			LDR R1, =ADC0_PP
			LDR R0, [R1]
			ORR R0, R0, #0x03 ; set bits 3:0 to 1 for 125k sps
			STR R0, [R1]
			; Done with setup, enable sequencer
			LDR R1, =ADC0_ACTSS
			LDR R0, [R1]
			ORR R0, R0, #0x0C ; set bit 2 to enable seq 2
			STR R0, [R1] ; sampling enabled but not initiated yet			
			BX	LR
			ENDP
			ALIGN
			END