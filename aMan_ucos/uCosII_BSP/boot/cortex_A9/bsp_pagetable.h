/*
*********************************************************************************************************
*                                     MICRIUM BOARD SUPPORT SUPPORT
*
*                          (c) Copyright 2003-2011; Micrium, Inc.; Weston, FL
*
*               All rights reserved.  Protected by international copyright laws.
*               Knowledge of the source code may NOT be used to develop a similar product.
*               Please help us continue to provide the Embedded community with the finest
*               software available.  Your honesty is greatly appreciated.
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*
*                                      BOARD SUPPORT PACKAGE (BSP)
*
*                          Altera Virtual DEV-5XS1 Cortex-A9 MPCore DEVELOPMENT KIT
*
* Filename      : bsp_pagetable.h
* Version       : V1.00
*********************************************************************************************************
*/

#ifndef BSP_PAGETABLE
#define BSP_PAGETABLE

/*
*********************************************************************************************************
*                                             INCLUDE FILES
*********************************************************************************************************
*/

#include  <cpu.h>
#include  <string.h>

/*
*********************************************************************************************************
*                                            LOCAL DEFINES
*********************************************************************************************************
*/

#ifdef CONFIG_AMP
#define BSP_SDRAM_PHYS_BASE                  0x2000000UL
#else
#define BSP_SDRAM_PHYS_BASE                  0UL
#endif
#define BSP_SDRAM_VIRT_BASE                  0UL
#define BSP_SDRAM_SIZE                      (256 * 1024 * 1024)

#define BSP_MEM_STRONGLY_ORDERED             0x0
#define BSP_MEM_SHAREABLE_DEVICE             0x1
#define BSP_MEM_OIWB_NWA                     0x2
#define BSP_MEM_OIWT_NWA                     0x3
#define BSP_MEM_OINC                         0x4
#define BSP_MEM_OIWB_WA                      0x7
#define BSP_MEM_NON_SHAREABLE_DEVICE         0x8
#define BSP_MEM_CACHE_TYPE(outer, inner)    (0x10 | ((outer)<<2) | (inner))
#define BSP_MEM__NC                            0
#define BSP_MEM_WBWA                           1
#define BSP_MEM_WTNWA                          2
#define BSP_MEM_WBNWA                          3

#define BSP_AP_PNA_UNA                         0
#define BSP_AP_PRW_UNA                         1
#define BSP_AP_PRW_URO                         2
#define BSP_AP_PRW_URW                         3
#define BSP_AP_PRO_UNA                         5
#define BSP_AP_PRO_URO                         7

#define BSP_PAGETABLE_L1_SECT_SIZE           0x100000

/*
*********************************************************************************************************
*                                              MACRO'S
*********************************************************************************************************
*/

#define BSP_PAGETABLE_L1_FAULT(id) LONG(id<<2)


#define BSP_PAGETABLE_L1_PGTBL(addr, dom, ns) \
	(((addr) << 10) | (((dom) & 0xf)<<5) | (((ns) & 1)<<3)  | 0x1)


#define BSP_PAGETABLE_L1_SECT(addr, mem_type , xn, ns, dom, ap, s, ng) \
	(((addr) & ~((1<< 20)-1)) | (((ns) & 1)<<19) | (((ng) & 1)<<17) | \
	(((s) & 1)<<16) | (((ap) & 0x4)<<15) | (((mem_type) & 0x1c)<<10) |\
	(((ap) & 3)<< 10) | (((dom) & 0xf)<<5) | (((mem_type) & 3)<<2) | 0x2)


#define BSP_PAGETABLE_L1_SUPSECT(addr, type, xn, ns, dom, ap, s, ng)	\
	((((addr) & ~0xFF) << 24) | (((ns) & 1)<<19) | (1<<18) |	\
	(((ng) & 1)<<17) | (((s) & 1)<<16) | (((ap) & 1)<<15) |\
	(((tex) & 0x7)<<12) | (((ap) & 3)<< 10) | (((mem_type) & 3)<<2) | 0x2)

#define BSP_PAGETABLE_PHYS_TO_VIRT(addr) \
	((CPU_INT32U)(addr) - (BSP_SDRAM_PHYS_BASE) + (BSP_SDRAM_VIRT_BASE))

#define BSP_PAGETABLE_VIRT_TO_PHYS(addr) \
        ((CPU_INT32U)(addr) - (BSP_SDRAM_VIRT_BASE) + (BSP_SDRAM_PHYS_BASE))

#define BSP_PAGETABLE_VADDR_TO_L1_INDEX(addr) ((addr)>> 20)

#endif 
