@********************************************************************************************************
@                                     MICRIUM BOARD SUPPORT SUPPORT
@
@                          (c) Copyright 2003-2011; Micrium, Inc.; Weston, FL
@
@               All rights reserved.  Protected by international copyright laws.
@               Knowledge of the source code may NOT be used to develop a similar product.
@               Please help us continue to provide the Embedded community with the finest
@               software available.  Your honesty is greatly appreciated.
@********************************************************************************************************

@********************************************************************************************************
@
@                                      BOARD SUPPORT PACKAGE (BSP)
@
@                         Altera Virtual DEV-5XS1 Cortex-A9 MPCore DEVELOPMENT KIT
@
@ Filename      : bsp_utils.S
@ Version       : V1.00.00
@********************************************************************************************************



	.globl get_core_id 
get_core_id:	
	mrc  p15, 0, r0, c0, c0, 5
	ands r0, r0, #0x03
	bx lr

	.globl get_periphbase
get_periphbase:	
	mrc  p15, 4, r0, c0, c15, 0
	bx lr

	@replacement function for the ARM tools intrinsics
	
	.globl __disable_irq
__disable_irq:	
	mrs r0, cpsr
	orr r1, r0, #0xc0
	msr cpsr_c, r1
	@return old state in r0
	and r0, r0, #0xc0	
	bx lr

	.globl __enable_irq
__enable_irq:	
	mrs r0, cpsr
	mvn r1, #0xc0
	and r1, r0, r1
	msr cpsr_c, r1
	bx lr
	