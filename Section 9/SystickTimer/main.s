


NVIC_ST_CTRL_R		EQU		0xE000E010
NVIC_ST_RELOAD_R	EQU		0xE000E014
NVIC_ST_CURRENT_R	EQU		0xE000E018
	

NVIC_ST_CTRL_COUNT		EQU		0x00010000  ;count flag
NVIC_ST_CTRL_CLK_SRC	EQU		0x00000004  ;clock source
NVIC_ST_CTRL_INTEN		EQU		0x00000002  ;interrupt 
NVIC_ST_CTRL_ENABLE		EQU		0x00000001  ;counter mode
NVIV_ST_RELOAD_M		EQU		0x00FFFFFF  ;current load value 
	

SYSCRL_BASE						EQU		 0x400FE000
RGGCGPIO_OFFSET					EQU		 0x608 
SYSCRL_RGGCGPIO_R				EQU		 SYSCRL_BASE + RGGCGPIO_OFFSET

GPIOF_BASE						EQU		 0x40025000
GPIOF_DIR_OFFSET				EQU		 0x400
GPIOF_DIR_R						EQU		 GPIOF_BASE + GPIOF_DIR_OFFSET

GPIOF_DEN_OFFSET				EQU		 0x51C
GPIOF_DEN_R						EQU		 GPIOF_BASE + GPIOF_DEN_OFFSET

GPIOF_DATA_OFFSET				EQU		 0x3FC
GPIOF_DATA_R					EQU		 GPIOF_BASE + GPIOF_DATA_OFFSET


GPIOF_EN						EQU		1<<5
LED_RED							EQU		1<<1
LED_BLUE						EQU		1<<2
LED_GREEN						EQU		1<<3

RED_OFF							EQU		0<<1


_10msDelay						EQU		160000
    	
;	16 000 000 = 1hz = 1000ms
;	1000ms  =  1hz
;    10ms  =	 ?
;	==>(10/1000) *1  = 1/100hz 
;	16 000 000 * (1/100) = 160000


;New Registers
GPIOF_PUR_OFFSET				EQU		 0x510
GPIOF_PUR_R						EQU		 GPIOF_BASE + GPIOF_PUR_OFFSET


GPIOF_LCK_OFFSET				EQU		 0x520
GPIOF_LCK_R						EQU		 GPIOF_BASE + GPIOF_LCK_OFFSET

GPIOF_CR_OFFSET					EQU		 0x524
GPIOF_CR_R						EQU		 GPIOF_BASE + GPIOF_CR_OFFSET
LOCK_KEY    					EQU 0x4C4F434B  ; Unlocks the GPIO_CR register

ONESEC				EQU		16000000

						AREA    |.text|, CODE, READONLY, ALIGN=2
						THUMB
						ENTRY
						EXPORT __main


__main
					BL		GPIO_Init
					BL		_led_on
					BL		Systick_Init
					
loop					
				    LDR		R0,=100
					BL		SysTickWait10ms
					BL		_led_on
					
					LDR		R0,=100
					BL		SysTickWait10ms
					BL		_led_off
					
					B		loop

_led_on
					LDR		R1,=GPIOF_DATA_R
					MOV		R0,#LED_RED
					STR		R0,[R1]
					BX		LR

_led_off
					LDR		R1,=GPIOF_DATA_R
					MOV		R0,#RED_OFF
					STR		R0,[R1]
					BX		LR
					
					
GPIO_Init
					 LDR	 R1, =SYSCRL_RGGCGPIO_R 
					 LDR	 R0,[R1]
					 ORR	 R0,R0,#GPIOF_EN
					 STR	 R0,[R1]
					 NOP
					 NOP
					 
					 
					 LDR	 R1,=GPIOF_DIR_R
					 LDR	 R0,[R1]
					 ORR	 R0,R0,#LED_RED
					 STR	 R0,[R1]
					 
					 LDR	 R1,=GPIOF_DEN_R
					 LDR	 R0,[R1]
					 ORR	 R0,R0,#LED_RED
					 STR	 R0,[R1]
					 
					 BX		LR
					 
		 
Systick_Init
					LDR		R1,=NVIC_ST_CTRL_R
					MOV		R0,#0
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_RELOAD_R
					LDR		R0,=NVIV_ST_RELOAD_M
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_CURRENT_R
					MOV		R0,#0
					STR		R0,[R1]
					
					LDR		R1,=NVIC_ST_CTRL_R
					MOV		R0,#(NVIC_ST_CTRL_ENABLE +NVIC_ST_CTRL_CLK_SRC)
					STR		R0,[R1]
					
					BX		LR

SysTick_Wait
				    LDR	    R1,=NVIC_ST_RELOAD_R
					SUB		R0,#1
					STR     R0,[R1]
					LDR		R1,=NVIC_ST_CTRL_R
lp1					
					LDR		R3,[R1]
					ANDS	R3,R3,#NVIC_ST_CTRL_COUNT
					BEQ		lp1
					BX		LR

SysTickWait10ms
					PUSH	{R4,LR}
					MOVS	R4,R0
					BEQ		__done

lp2
					LDR		R0,=_10msDelay
					BL		SysTick_Wait
					SUBS	R4,R4,#1
					BHI		lp2
			
__done
					POP		{R4,LR}
					BX		LR
					
					ALIGN
					END
						
