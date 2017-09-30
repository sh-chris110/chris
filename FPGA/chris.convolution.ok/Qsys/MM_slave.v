// MM_slave.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module MM_slave (
		input  wire [7:0]  avs_s0_address,     //     avs_s0.address
		input  wire        avs_s0_read,        //           .read
		output wire [31:0] avs_s0_readdata,    //           .readdata
		input  wire        avs_s0_write,       //           .write
		input  wire [31:0] avs_s0_writedata,   //           .writedata
		output wire        avs_s0_waitrequest, //           .waitrequest
		input  wire        clock_clk,          //      clock.clk
		input  wire        reset_reset,        //      reset.reset
		output wire        LED_OUT             // LED_output.led_out
	);

	// TODO: Auto-generated HDL template

	assign avs_s0_readdata = 32'b00000000000000000000000000000000;

//	assign avs_s0_waitrequest = 1'b0;

//	assign LED_OUT = 1'b0;
	
   reg			Reg_Status_Read;
   reg			Reg_Status_Write;
   reg [31:0] 		data_in;
   reg [31:0] 		data_out;
	reg 				led_out;


   //
   //
   //
   assign avs_s0_waitrequest = Reg_Status_Read || Reg_Status_Write;
	assign LED_OUT = led_out;
   
   //
   // WRITE LOGIC
   //
	always @(posedge clock_clk)
	  if (reset_reset) begin
			data_in <= 32'b0;
			data_out <= 32'b0;
			Reg_Status_Write <= 1'b0;	
	  end else if (!avs_s0_waitrequest && avs_s0_write) begin
			Reg_Status_Write <= 1'b0;	
			led_out <= avs_s0_writedata[0];
			data_in <= avs_s0_writedata;
	  end else begin
			Reg_Status_Write <= 1'b0;	
	  end
	
   //
   // READ LOGIC
   //
   always @(posedge clock_clk)
	if (reset_reset) begin
		Reg_Status_Read <= 1'b0;	
	end else if (!avs_s0_waitrequest && avs_s0_read) begin
		Reg_Status_Read <= 1'b0;	
	end else begin
		Reg_Status_Read <= 1'b0;	
	end
	

endmodule
