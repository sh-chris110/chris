
module hps_design (
	clk_clk,
	ddr3_mem_a,
	ddr3_mem_ba,
	ddr3_mem_ck,
	ddr3_mem_ck_n,
	ddr3_mem_cke,
	ddr3_mem_cs_n,
	ddr3_mem_ras_n,
	ddr3_mem_cas_n,
	ddr3_mem_we_n,
	ddr3_mem_reset_n,
	ddr3_mem_dq,
	ddr3_mem_dqs,
	ddr3_mem_dqs_n,
	ddr3_mem_odt,
	ddr3_mem_dm,
	ddr3_oct_rzqin,
	ledr_export,
	ddr3_clk_clk);	

	input		clk_clk;
	output	[12:0]	ddr3_mem_a;
	output	[2:0]	ddr3_mem_ba;
	output		ddr3_mem_ck;
	output		ddr3_mem_ck_n;
	output		ddr3_mem_cke;
	output		ddr3_mem_cs_n;
	output		ddr3_mem_ras_n;
	output		ddr3_mem_cas_n;
	output		ddr3_mem_we_n;
	output		ddr3_mem_reset_n;
	inout	[7:0]	ddr3_mem_dq;
	inout		ddr3_mem_dqs;
	inout		ddr3_mem_dqs_n;
	output		ddr3_mem_odt;
	output		ddr3_mem_dm;
	input		ddr3_oct_rzqin;
	output		ledr_export;
	output		ddr3_clk_clk;
endmodule
