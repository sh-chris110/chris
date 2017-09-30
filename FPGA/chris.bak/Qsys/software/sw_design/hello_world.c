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

int main()
{
  printf("Hello from Nios II!\n");
  alt_up_rs232_dev rs232 = {0};

  rs232.base = 0x00021028;
  alt_u8 data = '0';
  alt_u8 parity;

  while(1) {
	  alt_up_rs232_write_data(&rs232, '*');
	  alt_up_rs232_read_data(&rs232, &data, &parity);
	  printf ("got char:[%c]\n", data);
  	  usleep(2);
  }

  return 0;
}
