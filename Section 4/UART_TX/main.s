

RCC_BASE			EQU		0x40023800
	
AHB1ENR_OFFSET 		EQU		0x30
RCC_AHB1ENR			EQU		RCC_BASE + AHB1ENR_OFFSET
GPIOA_BASE			EQU		0x40020000
GPIOA_MODER_OFFSET	EQU		0x00
GPIOA_MODER			EQU		GPIOA_BASE + GPIOA_MODER_OFFSET
GPIOA_AFRL_OFFSET	EQU		0x20
GPIOA_AFRL			EQU		GPIOA_BASE + GPIOA_AFRL_OFFSET
APB1ENR_OFFSET		EQU		0x40
RCC_APB1ENR			EQU		RCC_BASE +  APB1ENR_OFFSET


UART2_BASE			EQU		0x40004400

UART2_BRR_OFFSET	EQU		0x08
UART2_BRR			EQU		UART2_BASE + UART2_BRR_OFFSET
UART2_CR1_OFFSET    EQU		0x0C
UART2_CR1			EQU		UART2_BASE +  UART2_CR1_OFFSET
UART2_CR2_OFFSET	EQU	    0x10
UART2_CR2			EQU		UART2_BASE +  UART2_CR2_OFFSET
UART2_CR3_OFFSET	EQU		0x14
UART2_CR3			EQU		UART2_BASE +  UART2_CR3_OFFSET
UART2_SR_OFFSET		EQU		0x00
UART2_SR			EQU		UART2_BASE + UART2_SR_OFFSET

UART2_DR_OFFSET		EQU		0x04
UART2_DR			EQU		UART2_BASE + UART2_DR_OFFSET


UART2_EN			EQU		1<<17
GPIOA_EN			EQU		1<<0

GPIOA_ALT_SLT		EQU		0x20 	; =  0B    0010 0000 ; = 1<<5
AF7_SLT				EQU		0x700	; =  0B	   0111  0000 0000
	
BRR_CNF				EQU		0x683  ;9600 baudrate @ 16MHz
CR1_CNF				EQU		0x8 ;enable Tx, 8-bit data
CR2_CNF				EQU		0x0000 ;1 stop bit
CR3_CNF				EQU		0x0000 ;no flow control
UART2_CR1_EN		EQU		0x2000
	
	
TX_BF_FLG			EQU		0x80	
	

CR					EQU		0x0D
LF					EQU		0x0A
BS					EQU		0x08
ESC					EQU		0x1B
SPA					EQU		0x20
DEL					EQU		0x7F
	
	

					AREA	|.text|,CODE,READONLY,ALIGN=2
					THUMB
					ENTRY
					EXPORT	__main

__main
					BL		UART_Init
					
loop				MOV		R0,#0x59   ; 'Y'
					BL		UART_WriteChar
					
					MOV		R0,#0x65	;'E'
					BL		UART_WriteChar
					
					MOV		R0,#0x73	;'S'
					BL		UART_WriteChar
					
					MOV		R0,#CR
					BL		UART_WriteChar
					MOV		R0,#LF
					BL		UART_WriteChar
					
					

					
					B		loop
					
					
				
					
					
					
UART_Init					
					;RCC->AHB1ENR |=GPIOA_EN
					LDR		R0,=RCC_AHB1ENR
					LDR		R1,[R0]
					ORR		R1,#GPIOA_EN
					STR		R1,[R0]
					
					;RCC->APB1ENR |=UART2_EN
					LDR		R0,=RCC_APB1ENR
					LDR		R1,[R0]
					ORR		R1,#UART2_EN
					STR		R1,[R0]
					
					
					
					;GPIOA->AFR[0] |=  AF7_SLT
					LDR		R0,=GPIOA_AFRL
					LDR		R1,[R0]
					ORR		R1,#AF7_SLT
					STR		R1,[R0]
					
					;GPIOA->MODER |=GPIOA_ALT_SLT
					LDR		R0,=GPIOA_MODER
					LDR		R1,[R0]
					ORR		R1,#GPIOA_ALT_SLT
					STR		R1,[R0]
					
					
					;UART2->BRR	= BRR_CNF
					LDR		R0,=UART2_BRR
					MOVW	R1,#BRR_CNF
					STR		R1,[R0]
					
					;UART2->CR1 = CR1_CNF
					LDR		R0,=UART2_CR1
					MOV		R1,#CR1_CNF
					STR		R1,[R0]
					
					;UART2->CR2 =CR2_CNF
					LDR		R0,=UART2_CR2
					MOV		R1,#CR2_CNF
					STR		R1,[R0]
					
					;UART2->CR3 = CR3_CNF
					LDR		R0,=UART2_CR3
					MOV		R1,#CR3_CNF
					STR		R1,[R0]
					
					;UART2->CR1 |= UART2_CR1_EN
					LDR		R0,=UART2_CR1
					LDR		R1,[R0]
					ORR		R1,#UART2_CR1_EN
					STR		R1,[R0]
					BX		LR


UART_WriteChar
				
				    LDR      R1,=UART2_SR
					
oloop				LDR		R2,[R1]
					AND		R2,#TX_BF_FLG
					CMP		R2,#0x00
					BEQ		oloop
					UXTB	R1,R0
					LDR		R2,=UART2_DR
					STR		R1,[R2]
					BX 		LR
					
					ALIGN
					END
						

					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					



