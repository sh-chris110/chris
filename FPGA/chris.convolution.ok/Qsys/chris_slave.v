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
	
   reg			Reg_Status_Read;
   reg			Reg_Status_Write;
   reg [31:0] 		reg_value[8:0];
	reg 				led_out;
	
	reg [31:0] reg_status;
	reg [31:0] reg_res;
	
   //
   //
   //
   assign avs_s0_waitrequest = Reg_Status_Read&Reg_Status_Write;
	assign LEDR = led_out;
	
	
	reg reg_module_caculation_end;
	reg reg_modue_caculating_start;
	reg reg_module_end;
	reg reg_module_start;
   convolution_core instance_convolution(.clk(clock_clk),
	.reset(reset_reset),
	.value0(reg_value[0]),
	.value1(reg_value[1]),
	.value2(reg_value[2]),
	.value3(reg_value[3]),
	.value4(reg_value[4]),
	.value5(reg_value[5]),
	.value6(reg_value[6]),
	.value7(reg_value[7]),
	.value8(reg_value[8]),
	.caculating_start(reg_modue_caculating_start),
	.caculating_done(reg_module_caculation_end),
	.res_done(reg_module_end),
	.ret(reg_res)
	);

	
	 reg [3:0] reg_current_status, reg_next_status;
	 parameter IDLE = 4'b0001;
    parameter CALCULATING = 4'b0010;
    parameter WAITTING = 4'b0100;
    parameter FINISH = 4'b1000;
	
	// machine status
	 always@(posedge clock_clk)
    begin
        if(reset_reset)
            reg_current_status <= IDLE;
        else
            reg_current_status <= reg_next_status;
    end

	
	 // machine's next status
    always@(reg_current_status or reg_read_done or reg_module_caculation_end or reg_write_done or reset_reset)
    begin
        if(reset_reset)
            reg_next_status = IDLE;
        else
        begin
            case(reg_current_status)
                IDLE:reg_next_status = reg_read_done?CALCULATING:IDLE;
                CALCULATING:reg_next_status = reg_module_caculation_end?WAITTING:CALCULATING;
                WAITTING:reg_next_status = reg_write_done?FINISH:WAITTING;
                FINISH: reg_next_status = IDLE;
                default: reg_next_status = IDLE;
            endcase
        end
    end
	 
	 always@(posedge clock_clk) begin
		if (reset_reset) begin
			led_out <= 1'b0;
		end else begin
		case(reg_current_status)
			IDLE: begin
				reg_module_start<= 1'b0;
				reg_module_end	<= 1'b0;
				reg_modue_caculating_start <= 1'b0;
			end
			CALCULATING: begin
				led_out <= 1'b1;
				reg_module_start <= 1'b1;
				reg_modue_caculating_start <= 1'b1;
			end
			WAITTING:begin
				reg_modue_caculating_start <= 1'b0;
				reg_module_end <= 1'b1;
			end
		
			FINISH:begin
				reg_module_start <= 1'b0;
				reg_module_end	<= 1'b0;
				reg_modue_caculating_start <= 1'b0;
				led_out <= 1'b0;
			end
			default:begin
			end
		endcase
	 end 
	 end
	
   // WRITE LOGIC
   //
	
	reg reg_read_done;
	always @(posedge clock_clk)
	  if (reset_reset) begin
			Reg_Status_Write <= 1'b1;
			
			reg_value[0] <= 32'h00000000;
			reg_value[1] <= 32'h00000000;
			reg_value[2] <= 32'h00000000;
			reg_value[3] <= 32'h00000000;
			reg_value[4] <= 32'h00000000;
			reg_value[5] <= 32'h00000000;
			reg_value[6] <= 32'h00000000;
			reg_value[7] <= 32'h00000000;
			reg_value[8] <= 32'h00000000;			
			
			reg_read_done <= 1'b0;
	  end else if (!avs_s0_waitrequest && avs_s0_write) begin
			case (avs_s0_address[3:0])
				4'b0000: reg_value[0] <= avs_s0_writedata;
				4'b0001: reg_value[1] <= avs_s0_writedata;
				4'b0010: reg_value[2] <= avs_s0_writedata;
				
				4'b0011: reg_value[3] <= avs_s0_writedata;
				4'b0100: reg_value[4] <= avs_s0_writedata;
				4'b0101: reg_value[5] <= avs_s0_writedata;
				
				4'b0110: reg_value[6] <= avs_s0_writedata;
				4'b0111: reg_value[7] <= avs_s0_writedata;
				4'b1000:begin
					reg_value[8] <= avs_s0_writedata;
					reg_read_done <= 1'b1; // read done;
				end
			endcase		
			Reg_Status_Write <= 1'b1;
	  end else if (avs_s0_waitrequest && avs_s0_write && reg_module_start == 1'b0)begin
			Reg_Status_Write <= 1'b0;
	  end else begin
			//revert  reg_read_done to 0 at here when it's done /
			if(reg_module_end) begin
				reg_read_done <= 1'b0;
			end 
			Reg_Status_Write <= 1'b1;	
	  end
	
   //
	// x and z values are don't-care's 

   // READ LOGIC
	reg reg_write_done;
   always @(posedge clock_clk)
	if (reset_reset) begin
		Reg_Status_Read <= 1'b1;	
	end else if (!avs_s0_waitrequest && avs_s0_read) begin
		
		Reg_Status_Read <= 1'b1;
		reg_write_done <= 1'b1;	
	end else if(avs_s0_waitrequest && avs_s0_read && reg_module_caculation_end) begin
		case (avs_s0_address[3:0])
				4'b0000: reg_out <= reg_value[0];
				4'b0001: reg_out <= reg_value[1];
				4'b0010: reg_out <= reg_value[2];
				
				4'b0011: reg_out <= reg_value[3];
				4'b0100: reg_out <= reg_value[4];
				4'b0101: reg_out <= reg_value[5];
				
				4'b0110: reg_out <= reg_value[6];
				4'b0111: reg_out <= reg_value[7];
				4'b1000: reg_out <= reg_value[8];
				4'b1001: reg_out <= reg_res;
			default:reg_out <= 32'hffffffff;
		endcase
		Reg_Status_Read <= 1'b0;	
	end else begin
		
		Reg_Status_Read <= 1'b1;
		if (reg_module_end) begin
			reg_write_done <= 1'b0;
		end
	end

endmodule
