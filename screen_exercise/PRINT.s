SSISR		EQU 0X4000800C
SSIDR		EQU 0X40008008			
			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	TRANSMIT
			
TRANSMIT	PROC	
			PUSH	{R0, R1}
			LDR		R1, =SSISR
START		LDR		R0, [R1]
			ANDS	R0, R0, #0X2
			BEQ		START
			
BUSY		LDR		R0, [R1]
			ANDS	R0, R0, #0X10
			BNE		BUSY
			
			LDR		R1, =SSIDR
			STR		R5, [R1]
			
			LDR		R1, =SSISR
CHECK		LDR		R0, [R1]
			ANDS	R0, R0, #0X10
			BNE		CHECK
			POP		{R0, R1}
			BX		LR


			ENDP
			ALIGN
			END