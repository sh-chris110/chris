// chris_slave.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module chris_slave (
		input  wire [3:0]  avs_s0_address,     // avs_s0.address
		input  wire        avs_s0_read,        //       .read
		output wire [31:0] avs_s0_readdata,    //       .readdata
		input  wire        avs_s0_write,       //       .write
		input  wire [31:0] avs_s0_writedata,   //       .writedata
		output wire        avs_s0_waitrequest, //       .waitrequest
		input  wire        clock_clk,          //  clock.clk
		input  wire        reset_reset,        //  reset.reset
		output wire        LEDR                //   LEDR.ledr
	);

	// TODO: Auto-generated HDL template
 
	
	reg [31:0] reg_out;
	assign avs_s0_readdata = reg_out;
	//assign avs_s0_readdata = 32'b00000000000000000000000000000000;
	
   reg			Reg_Status_Read;
   reg			Reg_Status_Write;
   reg [31:0] 		data_in;
	reg 				led_out;

	reg [31:0] reg_kernel[8:0];
   //
   //
   //
   assign avs_s0_waitrequest = Reg_Status_Read&Reg_Status_Write;
	assign LEDR = led_out;
   
	
   // WRITE LOGIC
   //
	always @(posedge clock_clk)
	  if (reset_reset) begin
			data_in <= 32'b0;
			Reg_Status_Write <= 1'b1;	
			
	  end else if (!avs_s0_waitrequest && avs_s0_write) begin
			case (avs_s0_address[3:0])
				4'b1000: begin 
						led_out <= 1'b0;
						data_in <= avs_s0_writedata;
						end
				4'b1001: begin 
						led_out <= 1'b1;
						data_in <= avs_s0_writedata;
						end
				default:begin
					led_out <= avs_s0_writedata[0];
					end
				endcase
				
				Reg_Status_Write <= 1'b1;
	  end else if (avs_s0_waitrequest && avs_s0_write)begin
			Reg_Status_Write <= 1'b0;
	  end else begin
			Reg_Status_Write <= 1'b1;	
	  end
	
   //
	// x and z values are don't-care's 

   // READ LOGIC
   always @(posedge clock_clk)
	if (reset_reset) begin
		Reg_Status_Read <= 1'b1;	
	end else if (!avs_s0_waitrequest && avs_s0_read) begin
		
		Reg_Status_Read <= 1'b1;
			
	end else if(avs_s0_waitrequest && avs_s0_read) begin
		case (avs_s0_address[3:0])
			4'b0000:reg_out <= 32'h00000000;
			4'b0001:reg_out <= 32'h00000001;
			default:reg_out <= 32'hffffffff;
		endcase
		Reg_Status_Read <= 1'b0;	
	end else begin
		Reg_Status_Read <= 1'b1;	
	end

endmodule
