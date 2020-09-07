

NVIC_ST_CTRL_R		EQU		0xE000E010
NVIC_ST_RELOAD_R	EQU		0xE000E014
NVIC_ST_CURRENT_R	EQU		0xE000E018
NVIC_ST_CALIB_R		EQU		0xE000E01C
	
	
NVIC_ST_CTRL_COUNT		EQU  0x00010000  ;Count flag
NVIC_ST_CLK_SRC			EQU	 0x00000004 ;Clock source
NVIC_ST_CTRL_INTEN		EQU	 0x00000002 ;Interrupt enable
NVIC_ST_CTRL_ENABLE		EQU	 0x00000001 ;Counter mode
NVIC_ST_RELOAD_M		EQU	 0x00FFFFFF ;Counter lod value
	

RCC_BASE			EQU		0x40023800
AHB1ENR_OFFSET 		EQU		0x30
RCC_AHB1ENR			EQU		RCC_BASE + AHB1ENR_OFFSET
GPIOA_BASE			EQU		0x40020000
GPIOA_MODER_OFFSET	EQU		0x00
GPIOA_MODER			EQU		GPIOA_BASE + GPIOA_MODER_OFFSET
GPIOA_ODR_OFFSET	EQU		0x14
GPIOA_ODR			EQU		GPIOA_BASE + GPIOA_ODR_OFFSET	
	
GPIOA_EN			EQU		1<<	0

MODER5_OUT			EQU		1 << 10

LED_ON				EQU		1 << 5
LED_OFF				EQU		1 << 0
	
	
_10MSDELAY		EQU			160000


					AREA	|.text|,CODE,READONLY,ALIGN=2
					THUMB
					ENTRY
					EXPORT __main


__main
					
					BL		GPIO_Init
					BL		Systick_Init
		

loop
					BL		Blink
					B		loop
		

GPIO_Init
			
					LDR		R0,=RCC_AHB1ENR 
					LDR		R1,[R0]
					ORR		R1,#GPIOA_EN
					STR		R1,[R0]
	
					LDR		R0,=GPIOA_MODER 
					LDR		R1,[R0]
					ORR		R1,#MODER5_OUT
					STR		R1,[R0]
					
					MOV		R1,#0
					LDR		R2,=GPIOA_ODR
					
					;BX		LR

Systick_Init
					
					;SysTick->CTRL  =0;
					LDR		R1,=NVIC_ST_CTRL_R
					MOV		R0,#0
					STR		R0,[R1]
					
					;SyTick->LOAD	=NVIC_ST_RELOAD_M
					LDR		R1,=NVIC_ST_RELOAD_R
					LDR		R0,=NVIC_ST_RELOAD_M
					STR		R0,[R1]
					
					;SysTick->VAL =0;
					LDR		R1,=NVIC_ST_CURRENT_R
					MOV		R0,#0
					STR		R0,[R1]
					
					;Systick->CTRL  |=NVIC_ST_CLK_SRC |NVIC_ST_CTRL_ENABLE
					LDR		R1,=NVIC_ST_CTRL_R
					MOV		R0,#(NVIC_ST_CLK_SRC+NVIC_ST_CTRL_ENABLE)
					STR		R0,[R1]
					BX		LR

;Unit is in number clock cycles

SysTick_Wait
				  LDR		R1,=NVIC_ST_RELOAD_R
				  SUB		R0,#1
				  STR		R0,[R1]
				  LDR		R1,=NVIC_ST_CTRL_R
lp1				  
				  LDR		R3,[R1]
				  ANDS		R3,R3,#NVIC_ST_CTRL_COUNT   ; count set ?
				  BEQ		lp1
				  BX		LR
				  

Systick_Wait10ms
				PUSH		{R4,LR}
				MOVS			R4,R0
				BEQ				__done

lp2
				LDR			R0,=_10MSDELAY
				BL			SysTick_Wait
				SUBS		R4,#1
				BHI			lp2
				

__done
				POP		{R4,LR}
				BX			LR
				
	

Blink

				MOV			R1,#LED_ON
				STR			R1,[R2]
				
				MOV		  	R0,#100
				BL			Systick_Wait10ms
				
				MOV			R1,#LED_OFF
				STR			R1,[R2]
				
				MOV		  	R0,#100
				BL			Systick_Wait10ms
				
	
				B			Blink
				
				ALIGN
				END
					
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
				


					
					


	
	