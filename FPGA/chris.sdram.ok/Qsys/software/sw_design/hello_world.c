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
#include <unistd.h>
#include "alt_types.h"

//#include "altera_avalon_pio_regs.h"
#include <io.h>
#include "system.h"

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

int main()
{
  printf("Hello from Nios II!\n");

  alt_up_rs232_dev rs232 = {0};

  rs232.base = UART_COM_BASE;

  unsigned int ret = 0;
  unsigned int memory_base = SDRAM_BASE;
//  unsigned int offset = 0x0;

  while(1) {
	  //IOWR_16DIRECT(memory_base, offset, 0x78);
	  print_cmdline(&rs232);
	  ret = read_data(&rs232);
	  //int mem = IORD_16DIRECT(memory_base, offset);
	  //printf ("\nrecive with return code:[%d] with memory :[%x]\n", ret, mem);
	  printf ("\n");
	  for (int c = 0; c < ret; c++) {
		  alt_u8 mem_test = IORD_8DIRECT(memory_base, c);
		  printf ("%c", mem_test);
	  }

	  printf ("\n");

  }

  return 0;
}
