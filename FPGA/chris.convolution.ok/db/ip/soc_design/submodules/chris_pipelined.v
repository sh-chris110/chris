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
		input  wire [7:0]  avs_s0_address,       //   avs_s0.address
		input  wire        avs_s0_read,          //         .read
		output wire [31:0] avs_s0_readdata,      //         .readdata
		input  wire        avs_s0_write,         //         .write
		input  wire [31:0] avs_s0_writedata,     //         .writedata
		output wire        avs_s0_waitrequest,   //         .waitrequest
		input  wire        clock_clk,            //    clock.clk
		input  wire        reset_reset,          //    reset.reset
		output wire        ins_irq0_irq,         // ins_irq0.irq
		output wire [31:0] avm_m0_address,       //   avm_m0.address
		output wire        avm_m0_read,          //         .read
		input  wire        avm_m0_waitrequest,   //         .waitrequest
		input  wire [31:0] avm_m0_readdata,      //         .readdata
		input  wire        avm_m0_readdatavalid, //         .readdatavalid
		output wire        avm_m0_write,         //         .write
		output wire [31:0] avm_m0_writedata,     //         .writedata
		output wire [7:0]  avm_m0_burstcount     //         .burstcount
	);

	// TODO: Auto-generated HDL template
	/* system template generated
	assign avs_s0_readdata = 32'b00000000000000000000000000000000;

	assign avs_s0_waitrequest = 1'b0;

	assign ins_irq0_irq = 1'b0;

	assign avm_m0_address = 32'b00000000000000000000000000000000;

	assign avm_m0_read = 1'b0;

	assign avm_m0_write = 1'b0;

	assign avm_m0_writedata = 32'b00000000000000000000000000000000;

	assign avm_m0_burstcount = 8'b00000000;
	*/
	
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
	
	
	reg			reg_status_read;
   reg			reg_status_write;

	//data out
	reg [31:0] 	reg_data_out;
	assign avs_s0_readdata = reg_data_out;
	
	//logic connect;
	assign avs_s0_waitrequest = reg_status_read || reg_status_write;
	
	// begin register map;
	wire [8:0] s_kernel_parameter;
	
	wire s_input_image_addr; //input image address
	wire s_output_image_addr; // output image address
	wire s_module_control; // system control address
	wire s_module_status; // system status address
	
	
	reg [31:0] reg_kernel[8:0];
	reg [31:0] reg_source_addr;
	reg [31:0] reg_destination_addr;
	reg [31:0] reg_control;
	reg [31:0] reg_status;
	
	assign s_kernel_parameter[0] = (avs_s0_address[3:0] == 4'b0000) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[1] = (avs_s0_address[3:0] == 4'b0001) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[2] = (avs_s0_address[3:0] == 4'b0010) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[3] = (avs_s0_address[3:0] == 4'b0011) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[4] = (avs_s0_address[3:0] == 4'b0100) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[5] = (avs_s0_address[3:0] == 4'b0101) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[6] = (avs_s0_address[3:0] == 4'b0110) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[7] = (avs_s0_address[3:0] == 4'b0111) & (avs_s0_write | avs_s0_read);
	assign s_kernel_parameter[8] = (avs_s0_address[3:0] == 4'b1000) & (avs_s0_write | avs_s0_read);
	
	assign s_input_image_addr = (avs_s0_address[3:0] == 4'b1001) & (avs_s0_write | avs_s0_read);
	assign s_output_image_addr= (avs_s0_address[3:0] == 4'b1010) & (avs_s0_write | avs_s0_read);
	assign s_module_control =  (avs_s0_address[3:0] == 4'b1011) & (avs_s0_write | avs_s0_read);
	assign s_module_status =  (avs_s0_address[3:0] == 4'b1100) & (avs_s0_write | avs_s0_read);
	// end register map
	
	
	//Get data form master
	always @(posedge clock_clk)
		if (reset_reset) begin
			reg_kernel[0] <= 32'h000;
			reg_kernel[1] <= 32'h000;
			reg_kernel[2] <= 32'h000;
			reg_kernel[3] <= 32'h000;
			reg_kernel[4] <= 32'h000;
			reg_kernel[5] <= 32'h000;
			reg_kernel[6] <= 32'h000;
			reg_kernel[7] <= 32'h000;
			reg_kernel[8] <= 32'h000;
			reg_source_addr <= 32'h0000;
			reg_destination_addr <= 32'h0000;
			reg_control <= 32'h0000;
			reg_status <= 32'h0000;	
			reg_status_write <= 1'b0;
	  end else if (!avs_s0_waitrequest && avs_s0_write) begin
			reg_status_write <= 1'b1;
			if (s_kernel_parameter[0]) begin
				reg_kernel[0] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[1]) begin
				reg_kernel[1] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[2]) begin
				reg_kernel[2] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[3]) begin
				reg_kernel[3] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[4]) begin
				reg_kernel[4] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[5]) begin
				reg_kernel[5] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[6]) begin
				reg_kernel[6] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[7]) begin
				reg_kernel[7] <= avs_s0_writedata;
			end
			
			if (s_kernel_parameter[8]) begin
				reg_kernel[8] <= avs_s0_writedata;
			end
			
			if (s_input_image_addr) begin
				reg_source_addr <= avs_s0_writedata;
			end
			
			if (s_output_image_addr) begin
				reg_destination_addr <= avs_s0_writedata;
			end
			
			if (s_module_control) begin
				reg_control <= avs_s0_writedata;
			end
			
			if (s_module_status) begin
				reg_status <= avs_s0_writedata;
			end
	  end 
	  
	//return data to master
	 always @(posedge clock_clk) begin	
		if (reset_reset) begin
			reg_data_out <= 32'h0000;
			reg_status_read <= 1'b0;
		end else if (!avs_s0_waitrequest && avs_s0_read) begin
			reg_status_read <= 1'b1;
			if (s_kernel_parameter[0]) begin
				reg_data_out <= reg_kernel[0];
			end
			
			if (s_kernel_parameter[1]) begin
				reg_data_out <= reg_kernel[1];
			end
			
			if (s_kernel_parameter[2]) begin
				reg_data_out <= reg_kernel[2];
			end
			
			if (s_kernel_parameter[3]) begin
				reg_data_out <= reg_kernel[3];
			end
			
			if (s_kernel_parameter[4]) begin
				reg_data_out <= reg_kernel[4];
			end
			
			if (s_kernel_parameter[5]) begin
				reg_data_out <= reg_kernel[5];
			end
			
			if (s_kernel_parameter[6]) begin
				reg_data_out <= reg_kernel[6];
			end
			
			if (s_kernel_parameter[7]) begin
				reg_data_out <= reg_kernel[7];
			end
			
			if (s_kernel_parameter[8]) begin
				reg_data_out <= reg_kernel[8];
			end
			
			if (s_input_image_addr) begin
				reg_data_out <= reg_source_addr;
			end
			
			if (s_output_image_addr) begin
				reg_data_out <= reg_destination_addr;
			end
			
			if (s_module_control) begin
				reg_data_out <= reg_control;
			end
			
			if (s_module_status) begin
				reg_data_out <= reg_status;
			end
		end
	end
	
	// rest the master;
	always @(posedge clock_clk) begin
		if (reset_reset) begin
			
		end
	end
	
	
endmodule
