/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "altera_up_avalon_rs232.h"
#include "altera_avalon_dma.h"
#include <unistd.h>
#include "alt_types.h"

//#include "altera_avalon_pio_regs.h"
#include <io.h>
#include "system.h"

#include "string.h"

//#include "altera_avalon_pio_regs.h"
#if UART
void print_cmdline(alt_up_rs232_dev *rs232){
	while (1) {
		if (alt_up_rs232_get_available_space_in_write_FIFO(rs232) > 5) {
			alt_up_rs232_write_data(rs232, '\n');
			alt_up_rs232_write_data(rs232, 'c');
			alt_up_rs232_write_data(rs232, 'm');
			alt_up_rs232_write_data(rs232, 'd');
			alt_up_rs232_write_data(rs232, '>');

			return;
		}

		usleep(5);
	}
}

unsigned int read_data(alt_up_rs232_dev *rs232) {
	alt_u8 data = '0';
	alt_u8 parity;
	unsigned int number = 0;
	unsigned int ret = 0;
	unsigned int all_number = 0;
	unsigned int memory_base = SDRAM_BASE;
	while (1) {
		number = alt_up_rs232_get_used_space_in_read_FIFO(rs232);
		for(int i = 0; i < number; i++) {
			alt_up_rs232_read_data(rs232, &data, &parity);
			alt_up_rs232_write_data(rs232, data);
			IOWR_8DIRECT(memory_base, all_number, data);
			all_number++;
			printf("%c", data);
			ret |= alt_up_rs232_check_parity(parity);
			if (data == '\n' || data == '\r') {
				return all_number;
			}
		}
	}

	return ret;
}
#endif

unsigned int caculate_convolution(){
	int ret = 0;
	return ret;
}

/*Using cable "USB-Blaster [3-11]", device 1, instance 0x00
Pausing target processor: not responding.
Resetting and trying again: FAILED
Leaving target processor paused*/


int main()
{
  printf("Hello from Nios II, Begin to run....!\n");


 // unsigned int n_test_base = 0x04041800;
 // unsigned int reg = *(volatile unsigned int *)(0x04041800);

  /*
  printf ("begin\n");
//  IOWR_32DIRECT(n_test_base, 0x0, 0xffff);
  reg = 0xffffffff;
  printf("adfasdf\n");
//  int ret = IORD_32DIRECT(n_test_base, 0x0);
  printf ("get return value: [%d]\n", reg); */

  while (1) {
	  int counter = 0;

	  while (counter < 5000000) {
		  counter++;
	  }
	  IOWR(0x04041000, 0x0, 2);
	  IOWR(0x04041000, 0x1, 1);
	  IOWR(0x04041000, 0x2, 1);
	  IOWR(0x04041000, 0x3, 1);
	  IOWR(0x04041000, 0x4, 1);
	  IOWR(0x04041000, 0x5, 1);
	  IOWR(0x04041000, 0x6, 1);
	  IOWR(0x04041000, 0x7, 1);
	  IOWR(0x04041000, 0x8, 2);
	  unsigned int ret = IORD(0x04041000, 0x9);
	  printf ("return value:[%d]\n", ret);
  }


  /*

  int mark = 0;

  while (1) {
	  	  printf ("running\n");
	   //delay 1s
	           int counter = 0;
	           while (counter < 5000000) {
	                   counter++;
	           }

	           if (mark == 0) {
	           // enable or disable the led[1];
	                   IOWR(0x04041000, 0x2, 256);
	                   mark = 1;
	                   printf("write done\n");

	           } else {
	                   unsigned int ret = IORD(0x04041000, 0x2);
	                   mark = 0;
	                   printf ("return value:[%d]\n", ret);
	           }

  }*/

#ifdef DMA

  // Test DMA

 //  unsigned int general_dma = (unsigned int) 0x4041800;

   char *img_original = (void *)0x2000000;
   char *img_original_rd = (void *)0x2000000;
   char *img_copy = (void *)0x30000000;

   int n_width = 800;
   int n_heigth = 600;
   int n_size = n_width * n_heigth;

   for (int i=0; i < n_size; i++) {
 	   *img_original = i%255;
 	   img_original++;
   }
   printf ("Construct data done..\n");

 alt_dma_txchan tx;
   tx = alt_dma_txchan_open(GENERAL_DMA_NAME);   //open tx channel

   if (tx != NULL ) {
	   alt_avalon_dma_tx_ioctl(tx,ALT_DMA_SET_MODE_8,NULL); // set it to 8 bits
	   if(alt_avalon_dma_send(tx, img_original, n_size, NULL, NULL)   < 0) {
		   printf ("Failure to post dma transtre\n");
	   }
	  //alt_dma_txchan_close(tx);   //close channel;
	  //IOWR_ALTERA_AVALON_DMA_CONTROL (DMA_0_BASE, 0);//
   } else {
	   printf ("open tx channel failed..\n");
   }

   alt_dma_rxchan rx;
   rx = alt_dma_rxchan_open(GENERAL_DMA_NAME); //open rx channel
   if(rx!=NULL) {
	   alt_avalon_dma_rx_ioctl(rx,ALT_DMA_SET_MODE_8,NULL);
	   if(alt_avalon_dma_prepare(rx, img_copy, n_size, NULL, NULL)   <0) {
		   printf("Failure to post receive..\n");
	   }
   } else {
	   printf ("open rx channel failed..\n");
   }

   printf ("DMA transfer Done..");

   for (int i=0; i < n_size; i++) {
 	  printf ("%d-%d\n", *(img_original_rd + i), *(img_original_rd+i));

   }
   while(1) {
	   usleep(2);
	   //printf ("running\n");
   }
#endif

#if UART
  alt_up_rs232_dev rs232 = {0};

  rs232.base = UART_COM_BASE;

  unsigned int ret = 0;
  unsigned int memory_base = SDRAM_BASE;
//  unsigned int offset = 0x0;

  while(1) {

	  print_cmdline(&rs232);
	  ret = read_data(&rs232);
	  printf ("\n");
	  for (int c = 0; c < ret; c++) {
		  alt_u8 mem_test = IORD_8DIRECT(memory_base, c);
		  printf ("%c", mem_test);
	  }

	  printf ("\n");

  }
#endif




  return 0;
}