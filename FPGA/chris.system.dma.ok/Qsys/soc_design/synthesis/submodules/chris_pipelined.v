// chris_pipelined.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module chris_pipelined (
		input  wire [3:0]  avs_s0_address,       //   avs_s0.address
		input  wire        avs_s0_read,          //         .read
		output wire [31:0] avs_s0_readdata,      //         .readdata
		output wire        avs_s0_readdatavalid, //         .readdatavalid
		input  wire        avs_s0_write,         //         .write
		input  wire [31:0] avs_s0_writedata,     //         .writedata
		output wire        avs_s0_waitrequest,   //         .waitrequest
		input  wire [3:0]  avs_s0_byteenable,    //         .byteenable
		input  wire        clock_clk,            //    clock.clk
		input  wire        reset_reset,          //    reset.reset
		output wire        ins_irq0_irq          // ins_irq0.irq
	);

	// TODO: Auto-generated HDL template

	assign avs_s0_readdata = 32'b00000000000000000000000000000000;

	assign avs_s0_waitrequest = 1'b0;

	assign avs_s0_readdatavalid = 1'b0;

	assign ins_irq0_irq = 1'b0;

endmodule
