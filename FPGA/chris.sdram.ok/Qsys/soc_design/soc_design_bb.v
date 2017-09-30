
module soc_design (
	dram_addr,
	dram_ba,
	dram_cas_n,
	dram_cke,
	dram_cs_n,
	dram_dq,
	dram_dqm,
	dram_ras_n,
	dram_we_n,
	dram_clk_clk,
	fpga_reset_n,
	ref_clk,
	uart_RXD,
	uart_TXD);	

	output	[12:0]	dram_addr;
	output	[1:0]	dram_ba;
	output		dram_cas_n;
	output		dram_cke;
	output		dram_cs_n;
	inout	[15:0]	dram_dq;
	output	[1:0]	dram_dqm;
	output		dram_ras_n;
	output		dram_we_n;
	output		dram_clk_clk;
	input		fpga_reset_n;
	input		ref_clk;
	input		uart_RXD;
	output		uart_TXD;
endmodule
