

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


GPIOA_BSRR_OFFSET	EQU		0x18
GPIOA_BSRR			EQU		GPIOA_BASE	+ GPIOA_BSRR_OFFSET

UART2_EN			EQU		1<<17
GPIOA_EN			EQU		1<<0

GPIOA_ALT_SLT		EQU		0x80 	
AF7_SLT				EQU		0x7000	; =  0B	   0111 0000 0000 0000

MODER5_OUT			EQU		1<<10

BRR_CNF				EQU		0x008B  ;115200 baudrate @ 16MHz
CR1_CNF				EQU		0x4 ;enable Rx, 8-bit data
CR2_CNF				EQU		0x0000 ;1 stop bit
CR3_CNF				EQU		0x0000 ;no flow control
UART2_CR1_EN		EQU		0x2000

BSRR_5_SET			EQU		1<<5
BSRR_5_RESET		EQU		1<<21
	

;PA  : TX
;PA3 :RX

TX_BF_FLG			EQU		0x80	
RX_BF_FLG			EQU		0x20	

CR					EQU		0x0D
LF					EQU		0x0A
BS					EQU		0x08
ESC					EQU		0x1B
SPA					EQU		0x20
DEL					EQU		0x7F
	

ONESEC				EQU	   5333333

					AREA	|.text|,CODE,READONLY,ALIGN=2
					THUMB
					ENTRY
					EXPORT	__main

__main
					BL		IO_Init
					
loop				
					BL		UART_ReadChar
					BL		LED_Blink
		
					B		loop
					
					
				
					
					
					
IO_Init					
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
					
					
					;GPIOA->MODER |= MODER5_OUT
					LDR		R0,=GPIOA_MODER
					LDR		R1,[R0]
					ORR		R1,#MODER5_OUT
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

UART_ReadChar
					LDR		R1,=UART2_SR
					
iloop				LDR		R2,[R1]  ;read SR
					AND		R2,#RX_BF_FLG
					CMP		R2,#0x00
					BEQ		iloop
					
					LDR		R3,=UART2_DR
					LDR		R0,[R3]
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


Delay
					SUBS	R3,R3,#1
					BNE		Delay
					BX		LR

LED_Blink
					MOV		R3,R0
					CMP		R3,#0x0031 ; KEY1
					BEQ		pt0
					BX		LR
					

pt0

					MOVS	R0,#BSRR_5_SET
					LDR		R1,=GPIOA_BSRR
					STR		R0,[R1]
					
					LDR		R3,=ONESEC
					BL		Delay
					
					MOVS	R0,#BSRR_5_RESET
					LDR		R1,=GPIOA_BSRR
					STR		R0,[R1]
					
					LDR		R3,=ONESEC
					BL		Delay
					
					BL		UART_ReadChar
					
					
					ALIGN
					END
						

					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					



