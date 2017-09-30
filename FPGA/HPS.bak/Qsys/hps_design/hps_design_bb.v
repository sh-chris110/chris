
module hps_design (
	clk_clk,
	pll_0_sdram_clk,
	ledr_export,
	hps_ddr_mem_a,
	hps_ddr_mem_ba,
	hps_ddr_mem_ck,
	hps_ddr_mem_ck_n,
	hps_ddr_mem_cke,
	hps_ddr_mem_cs_n,
	hps_ddr_mem_ras_n,
	hps_ddr_mem_cas_n,
	hps_ddr_mem_we_n,
	hps_ddr_mem_reset_n,
	hps_ddr_mem_dq,
	hps_ddr_mem_dqs,
	hps_ddr_mem_dqs_n,
	hps_ddr_mem_odt,
	hps_ddr_mem_dm,
	hps_ddr_oct_rzqin);	

	input		clk_clk;
	output		pll_0_sdram_clk;
	output		ledr_export;
	output	[14:0]	hps_ddr_mem_a;
	output	[2:0]	hps_ddr_mem_ba;
	output		hps_ddr_mem_ck;
	output		hps_ddr_mem_ck_n;
	output		hps_ddr_mem_cke;
	output		hps_ddr_mem_cs_n;
	output		hps_ddr_mem_ras_n;
	output		hps_ddr_mem_cas_n;
	output		hps_ddr_mem_we_n;
	output		hps_ddr_mem_reset_n;
	inout	[31:0]	hps_ddr_mem_dq;
	inout	[3:0]	hps_ddr_mem_dqs;
	inout	[3:0]	hps_ddr_mem_dqs_n;
	output		hps_ddr_mem_odt;
	output	[3:0]	hps_ddr_mem_dm;
	input		hps_ddr_oct_rzqin;
endmodule
