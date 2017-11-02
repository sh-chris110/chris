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
* Filename      : bsp.c
* Version       : V1.00
* Programmer(s) : NB
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                             INCLUDE FILES
*********************************************************************************************************
*/

#define   BSP_MODULE
#include  <bsp.h>
#include  <ucos_ii.h>

/*
*********************************************************************************************************
*                                             CLOCK SOURCES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                        REGISTER & BIT DEFINES
*********************************************************************************************************
*/

#define  SOCFPGA5XS1_BSP_RST_MNGR_BASE                     (CPU_INT32U )(0xFFA05000)

#define  SOCFPGA5XS1_BSP_RST_MNGR_MPU_MODULE_RST        (*(CPU_REG32 *)(SOCFPGA5XS1_BSP_RST_MNGR_BASE + 0x10))
#define  SOCFPGA5XS1_BSP_RST_MNGR_PERIPH_MODULE_RST     (*(CPU_REG32 *)(SOCFPGA5XS1_BSP_RST_MNGR_BASE + 0x14))

#define  SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_BASE             (CPU_INT32U )(0xFFFEF000)

#define  SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_CONTROL       (*(CPU_REG32 *)(SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_BASE + 0x100))       
#define  SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_INV_WAY       (*(CPU_REG32 *)(SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_BASE + 0x77C))       
#define  SOCFPGA5XS1_BSP_PL310_CACHE_SYNC               (*(CPU_REG32 *)(SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_BASE + 0x730))


/*
*********************************************************************************************************
*                                           LOCAL CONSTANTS
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                          LOCAL DATA TYPES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                            LOCAL TABLES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                       LOCAL GLOBAL VARIABLES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                               MACRO'S
*********************************************************************************************************
*/



/*
*********************************************************************************************************
*                                      LOCAL FUNCTION PROTOTYPES
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                     LOCAL CONFIGURATION ERRORS
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*********************************************************************************************************
**                                         GLOBAL FUNCTIONS
*********************************************************************************************************
*********************************************************************************************************
*/


/*
*********************************************************************************************************
*                                             BSP_LowLevelInit()
*
* Description : System Low Level Init (PLLs, External Memories, Boot loaders, etc).
*
* Argument(s) : none.
*
* Return(s)   : none.
*
* Caller(s)   : Startup Code.
* 
* Note(s)     : none.
*********************************************************************************************************
*/

void  BSP_LowLevelInit (void)
{

}


/*
*********************************************************************************************************
*                                             BSP_PreInit()
*
* Description : Board Support package pre-initialization.
*
* Argument(s) : none.
*
* Return(s)   : none.
*
* Caller(s)   : main()
*
* Note(s)     : (1) This function initializes all peripherals that don't require OS services or modules
*                   that need to be initialized before the OS is initialized (e.g External memories).
*
*               (2) FMzPLL is the source for GCLK/HCLK,VCLK, VCLK2.
*********************************************************************************************************
*/

void  BSP_PreInit (void)
{

    CPU_IntDis();                                               /* Disable all interrupts.                              */

#ifndef CONFIG_AMP
                                                                /* Release all peripherals and MPU from reset.          */
    SOCFPGA5XS1_BSP_RST_MNGR_MPU_MODULE_RST    = 0x0;
    SOCFPGA5XS1_BSP_RST_MNGR_PERIPH_MODULE_RST = 0x0;
#endif	
        
                                                                /* Configure MPU L2 Cache.                              */
 	SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_CONTROL   = 0x0;           /* Disable cache first to configure it.                 */
    SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_INV_WAY   = 0xF;
	
	while(SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_INV_WAY) {           /* Wait for the cache to finish invalidating.           */     
	}
	
	SOCFPGA5XS1_BSP_PL310_CACHE_SYNC           = 0x0;           /* Synchronize the cache.                               */
	SOCFPGA5XS1_BSP_PL310_CACHE_CTLR_CONTROL   = 0x1;           /* Enable cache.                                        */
	
    CSP_IntInit();                                              /* Initialize Interrupt controller module.              */

}


/*
*********************************************************************************************************
*                                             BSP_PostInit()
*
* Description : Board Support Package post initialization.
*
* Argument(s) : none.
*
* Return(s)   : none.
*
* Caller(s)   : Application.
*
* Note(s)     : (1) This function initializes all peripherlas that require OS services.
*********************************************************************************************************
*/

void  BSP_PostInit (void)
{          
}


/*
*********************************************************************************************************
*                                    OS_CSP_BSP_ExceptHandler()
*
* Description : Handles ARM exceptions.
*
* Argument(s) : Exception type.
*
*                   CPU_ARM_EXCEPT_RST              Reset exception.
*                   CPU_ARM_EXCEPT_UND              Undefined instruction.
*                   CPU_ARM_EXCEPT_SWI              Software interrupt.
*                   CPU_ARM_EXCEPT_ABORT_PREFETCH   Prefetch Abort.
*                   CPU_ARM_EXCEPT_ABORT_DATA       Data Abort.
*
* Return(s)   : none.
*
* Caller(s)   : OS_CPU_IntHandler().
*
* Note(s)     : (1) This exception handler is implemented with an infinite loop for 
*                   debugging porpuses only. 
*********************************************************************************************************
*/

void OS_CSP_BSP_ExceptHandler  (CPU_INT08U  except_type)
{
    switch (except_type) {
        case CPU_ARM_EXCEPT_RST:
        case CPU_ARM_EXCEPT_UND:
        case CPU_ARM_EXCEPT_SWI:
        case CPU_ARM_EXCEPT_ABORT_DATA:	 
        case CPU_ARM_EXCEPT_ABORT_PREFETCH:
             while (DEF_TRUE) {
                 ;
             }
    }
}
