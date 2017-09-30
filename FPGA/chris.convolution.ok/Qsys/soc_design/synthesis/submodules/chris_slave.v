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
   /*
	assign avs_s0_readdata = 32'b00000000000000000000000000000000;

	assign avs_s0_waitrequest = 1'b0;

	assign LEDR = 1'b0;
	*/
	
	/*
	scfifo	scfifo_component (
				.clock (clock),
				.data (data),
				.rdreq (rdreq),
				.wrreq (wrreq),
				.empty (sub_wire0),
				.full (sub_wire1),
				.q (sub_wire2),
				.usedw (sub_wire3),
				.aclr (),
				.almost_empty (),
				.almost_full (),
				.eccstatus (),
				.sclr ());
	defparam
		scfifo_component.add_ram_output_register = "OFF",
		scfifo_component.intended_device_family = "Cyclone V",
		scfifo_component.lpm_numwords = 256,
		scfifo_component.lpm_showahead = "OFF",
		scfifo_component.lpm_type = "scfifo",
		scfifo_component.lpm_width = 8,
		scfifo_component.lpm_widthu = 8,
		scfifo_component.overflow_checking = "ON",
		scfifo_component.underflow_checking = "ON",
		scfifo_component.use_eab = "ON";
	*/
	
	
	assign avs_s0_readdata = 32'b00000000000000000000000000000000;
	
   reg			Reg_Status_Read;
   reg			Reg_Status_Write;
   reg [31:0] 		data_in;
   reg [31:0] 		data_out;
	reg 				led_out;


   //
   //
   //
   assign avs_s0_waitrequest = Reg_Status_Read || Reg_Status_Write;
	assign LEDR = led_out;
   
	wire [8:0] kernel_parameter;
	wire [2:0] image_paramete;
	
   //register map
	// kernel parametes
	assign kernel_parameter[0] = (avs_s0_address[3:0] == 4'b0000) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[1] = (avs_s0_address[3:0] == 4'b0001) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[2] = (avs_s0_address[3:0] == 4'b0010) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[3] = (avs_s0_address[3:0] == 4'b0011) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[4] = (avs_s0_address[3:0] == 4'b0100) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[5] = (avs_s0_address[3:0] == 4'b0101) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[6] = (avs_s0_address[3:0] == 4'b0110) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[7] = (avs_s0_address[3:0] == 4'b0111) & (avs_s0_write | avs_s0_read);
	assign kernel_parameter[8] = (avs_s0_address[3:0] == 4'b1000) & (avs_s0_write | avs_s0_read);

	//image data;
	assign image_paramete[0] = (avs_s0_address[3:0] == 4'b10001) & (avs_s0_write | avs_s0_read); // 4 image pixels, only three pixeles are valid
	assign image_paramete[1] = (avs_s0_address[3:0] == 4'b10010) & (avs_s0_write | avs_s0_read); // 4 image pixels,  only three pixeles are valid
	assign image_paramete[2] = (avs_s0_address[3:0] == 4'b10011) & (avs_s0_write | avs_s0_read); // 4 image pixels,  only three pixeles are valid
	
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
