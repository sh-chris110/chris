
module soc_design (
	fpga_reset_n,
	ref_clk,
	uart_RXD,
	uart_TXD);	

	input		fpga_reset_n;
	input		ref_clk;
	input		uart_RXD;
	output		uart_TXD;
endmodule
