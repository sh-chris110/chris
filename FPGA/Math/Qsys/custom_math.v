// custom_math.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module custom_math (
		input  wire [7:0]  avs_s0_address,     //   avs_s0.address
		input  wire        avs_s0_read,        //         .read
		output wire [31:0] avs_s0_readdata,    //         .readdata
		input  wire        avs_s0_write,       //         .write
		input  wire [31:0] avs_s0_writedata,   //         .writedata
		output wire        avs_s0_waitrequest, //         .waitrequest
		input  wire        clock_clk,          //    clock.clk
		input  wire        reset_reset,        //    reset.reset
		output wire        ins_irq0_irq,       // ins_irq0.irq
		output wire [7:0]  avm_m0_address,     //   avm_m0.address
		output wire        avm_m0_read,        //         .read
		input  wire        avm_m0_waitrequest, //         .waitrequest
		input  wire [31:0] avm_m0_readdata,    //         .readdata
		output wire        avm_m0_write,       //         .write
		output wire [31:0] avm_m0_writedata    //         .writedata
	);

	// TODO: Auto-generated HDL template

//	assign avs_s0_readdata = 32'b00000000000000000000000000000000;
//
//	assign avs_s0_waitrequest = 1'b0;
//
//	assign ins_irq0_irq = 1'b0;
//
//	assign avm_m0_address = 8'b00000000;
//
//	assign avm_m0_read = 1'b0;
//
//	assign avm_m0_write = 1'b0;
//
//	assign avm_m0_writedata = 32'b00000000000000000000000000000000;


	assign ins_irq0_irq = 1'b0; // Disable interrupt
	//Disable master controller
	assign avm_m0_address = 8'b00000000;
	assign avm_m0_read = 1'b0;
	assign avm_m0_write = 1'b0;
	assign avm_m0_writedata = 32'b00000000000000000000000000000000;
	
	


endmodule
