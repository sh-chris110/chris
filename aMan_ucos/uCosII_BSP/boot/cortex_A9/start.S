/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2010 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* The software shall only be used in conjunction with FPGAs and other devices *
* manufactured by Altera Corporation.                                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/
	 
	.globl start

#define Mode_USR 0x10
#define Mode_FIQ 0x11
#define Mode_IRQ 0x12
#define Mode_SVC 0x13
#define Mode_ABT 0x17
#define Mode_UND 0x1B
#define Mode_SYS 0x1F

#define I_Bit    0x80 
#define F_Bit    0x40 
		
		
start:	
	
        B	reset
        LDR     PC, Undefined_Addr
        LDR     PC, SVC_Addr
        LDR     PC, Prefetch_Addr
        LDR     PC, Abort_Addr
        NOP     @ Reserved for secure montor calls
        LDR     PC, IRQ_Addr
        LDR     PC, FIQ_Addr
        
        
Undefined_Addr:	 .word     OS_CPU_ARM_ExceptUndefInstrHndlr
SVC_Addr:        .word     OS_CPU_ARM_ExceptSwiHndlr
Prefetch_Addr:   .word     OS_CPU_ARM_ExceptPrefetchAbortHndlr
Abort_Addr:      .word     OS_CPU_ARM_ExceptDataAbortHndlr
IRQ_Addr:        .word     OS_CPU_ARM_ExceptIrqHndlr
FIQ_Addr:        .word     OS_CPU_ARM_ExceptFiqHndlr

reset:	
	mrs	r0, cpsr
	bic	r0, r0, #0x1f
	orr	r0, r0, #0xd3
	msr	cpsr_cxsf,r0
			
        mrc     p15, 0, r0, c1, c0, 2		
        orr     r0, r0, #(0x3  <<20)		
        orr     r0, r0, #(0x3  <<22)		
        mcr     p15, 0, r0, c1, c0, 2		
        isb
        mov     r0, #(0x1 << 30)  
	@vmsr	fpexc, r0 <- not correctly supported in binutils 2.22
	mcr     p10, 7, r0, cr8, cr0, 0 @alternate mnemonic for vmsr fpexec, r0
 
	@@ setup stack
	ldr sp, =usr_stack_end
	#ifdef CONFIG_AMP
	add sp,sp,#0x2000000
	#else
	bl  get_core_id
	cmp r0,#0
endless_loop:	
	bne endless_loop	
	#endif

	
	bl  BSP_PageTableInit

	@@  set translation table base 
	mcr    p15, 0, r0, c2, c0, 0
    
	ldr    r0, =0xFFFFFFFF             @ Set full access for all domains
	mcr    p15, 0, r0, c3, c0, 0

	mov	r0, #0
	mcr	p15, 0, r0, c8, c7, 0       @ Invalidate TLBs
	mcr	p15, 0, r0, c7, c5, 0	@ invalidate icache

    
	@ Enable the MMU, Dcache, WB, Branch predictor, Icache, strict alignment
	mrc    p15, 0, r1, c1, c0, 0
	ldr	r2, =0x40180d
	orr	r1, r1, r2
	mcr    p15, 0, r1, c1, c0, 0
	
	dsb
	isb

	@@ Now jump to the vitualised space
	ldr	pc, =jump_to_virt
	
jump_to_virt:	

	ldr sp, =usr_stack_end

	@@ set the stack pinters for svc and irq mode. We don@t do anything
	@@ that needs a stack in the other modes so don't bother 
	@@ setting them up
	msr     CPSR_c, #Mode_IRQ | I_Bit | F_Bit
	ldr	sp,=irq_stack_end

        msr     CPSR_c, #Mode_SVC | I_Bit | F_Bit

	ldr	r0,=bss_start		@ find start of bss segment
	ldr	r1,=bss_end		@ stop here
	mov	r2, #0x00000000		@ clear value
clbss_l:	
	str	r2, [r0]		@ clear BSS location
	cmp	r0, r1			@ are we at the end yet
	add	r0, r0, #4		@ increment clear index pointer
	bne	clbss_l			@ keep clearing till at end

	
	ldr	pc, =main	@ jump to OS entry


	.data 
	.align 5
fiq_stack_start:	
	.space 1024
fiq_stack_end:	
	.space 1024
irq_stack_end:	
	.space 4096
usr_stack_end:	

 
