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
* Filename      : bsp_pagetable.c
* Version       : V1.00
*********************************************************************************************************
*/

/*
*********************************************************************************************************
*                                             INCLUDE FILES
*********************************************************************************************************
*/

#include "bsp_pagetable.h"

/*
*********************************************************************************************************
*                                       LOCAL GLOBAL VARIABLES
*********************************************************************************************************
*/

static  CPU_INT32U  BSP_PageTable[4096] __attribute__ ((aligned (16*1024))) __attribute__ ((section ("PTABLE")));


/*
*********************************************************************************************************
*                                        BSP_PageTableInit()
*
* Description : This function initializes the MMU's page table
*
* Argument(s) : none.
*
* Return(s)   : none.
*
* Caller(s)   : Startup Code.
* 
* Note(s)     : This function is called during the startup sequence, so it should not invoke any
*               standard library routines.
*********************************************************************************************************
*/

CPU_INT32U  BSP_PageTableInit (void)
{
    CPU_INT32U  vaddr;
    CPU_INT32U  paddr;
    CPU_INT32U  i;
    CPU_INT32U  *pt_phys = (CPU_INT32U*)BSP_PAGETABLE_VIRT_TO_PHYS(BSP_PageTable);

        
    for(i = (sizeof(BSP_PageTable) / sizeof(CPU_INT32U)); i; i -= sizeof(CPU_INT32U)) {
        pt_phys[i]=0;
    }

    for (paddr = BSP_SDRAM_PHYS_BASE, vaddr = BSP_SDRAM_VIRT_BASE; vaddr <= (BSP_SDRAM_VIRT_BASE + BSP_SDRAM_SIZE); vaddr += BSP_PAGETABLE_L1_SECT_SIZE, paddr += BSP_PAGETABLE_L1_SECT_SIZE){
        pt_phys[BSP_PAGETABLE_VADDR_TO_L1_INDEX(vaddr)] = 
	BSP_PAGETABLE_L1_SECT(paddr, BSP_MEM_CACHE_TYPE(BSP_MEM_WBWA, BSP_MEM_WBWA) , 0, 0, 0, BSP_AP_PRW_URW, 1, 0);
    }

#ifdef CONFIG_AMP

    pt_phys[BSP_PAGETABLE_VADDR_TO_L1_INDEX(0xff900000)] = BSP_PAGETABLE_L1_SECT(0xff900000, BSP_MEM_SHAREABLE_DEVICE, 0, 0, 0, BSP_AP_PRW_URW, 1, 0);

    pt_phys[BSP_PAGETABLE_VADDR_TO_L1_INDEX(BSP_SDRAM_PHYS_BASE)] = BSP_PAGETABLE_L1_SECT(BSP_SDRAM_PHYS_BASE, BSP_MEM_CACHE_TYPE(BSP_MEM_WBWA, BSP_MEM_WBWA), 0, 0, 0, BSP_AP_PRW_URW, 1, 0);
#else
    for (paddr = 0xfff00000, vaddr = 0xfff00000; vaddr >= 0xff000000; vaddr -= BSP_PAGETABLE_L1_SECT_SIZE, paddr -= BSP_PAGETABLE_L1_SECT_SIZE){	
        pt_phys[BSP_PAGETABLE_VADDR_TO_L1_INDEX(vaddr)] = BSP_PAGETABLE_L1_SECT(paddr, BSP_MEM_SHAREABLE_DEVICE , 0, 0, 0, BSP_AP_PRW_URW, 1, 0);
    }
#endif
    return (CPU_INT32U)pt_phys;
}
