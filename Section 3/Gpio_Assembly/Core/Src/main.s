
.cpu cortex-m4
.syntax unified

.equ GPIOA_BASE, 0x40020000
.equ GPIOA_MODER_OFFSET,0x00
.equ GPIOA_ODR_OFFSET, 0x14

.equ GPIOA_MODER, GPIOA_BASE + GPIOA_MODER_OFFSET
.equ GPIOA_ODR, GPIOA_BASE + GPIOA_ODR_OFFSET

.equ RCC_BASE, 0x40023800
.equ AHB1NER_OFFSET, 0x30
.equ RCC_AHB1NER, RCC_BASE + AHB1NER_OFFSET

.equ GPIOA_EN, 1<<0
.equ MODER5_OUT, 1<<10
.equ LED_ON, 1<<5


		.section .text
		.globl   main

main:

		BL		GPIO_Init

GPIO_Init:
		//RCC->AHB1ENR |= GPIOA_EN

		//Load address of RCC_AHB1ENR to r0
		LDR		R0,=RCC_AHB1NER
		//Load vlaue at address found in r0 into r1
		LDR		R1,[R0]

		ORR     R1,#GPIOA_EN
		//Store the content in R1 at the address found in R0
		STR		R1,[R0]


		//GPIOA->MODER |=MODER5_OUT
		LDR		R0,=GPIOA_MODER
		LDR		R1,[R0]
		ORR     R1,#MODER5_OUT
		STR     R1,[R0]


		//GPIOA->ODR =LED_ON
		LDR		R0,=GPIOA_ODR
		LDR		R1,=LED_ON
		STR		R1,[R0]

		BX		LR

		.end












