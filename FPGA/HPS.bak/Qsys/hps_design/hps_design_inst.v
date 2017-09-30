	hps_design u0 (
		.clk_clk             (<connected-to-clk_clk>),             //         clk.clk
		.pll_0_sdram_clk     (<connected-to-pll_0_sdram_clk>),     // pll_0_sdram.clk
		.ledr_export         (<connected-to-ledr_export>),         //        ledr.export
		.hps_ddr_mem_a       (<connected-to-hps_ddr_mem_a>),       //     hps_ddr.mem_a
		.hps_ddr_mem_ba      (<connected-to-hps_ddr_mem_ba>),      //            .mem_ba
		.hps_ddr_mem_ck      (<connected-to-hps_ddr_mem_ck>),      //            .mem_ck
		.hps_ddr_mem_ck_n    (<connected-to-hps_ddr_mem_ck_n>),    //            .mem_ck_n
		.hps_ddr_mem_cke     (<connected-to-hps_ddr_mem_cke>),     //            .mem_cke
		.hps_ddr_mem_cs_n    (<connected-to-hps_ddr_mem_cs_n>),    //            .mem_cs_n
		.hps_ddr_mem_ras_n   (<connected-to-hps_ddr_mem_ras_n>),   //            .mem_ras_n
		.hps_ddr_mem_cas_n   (<connected-to-hps_ddr_mem_cas_n>),   //            .mem_cas_n
		.hps_ddr_mem_we_n    (<connected-to-hps_ddr_mem_we_n>),    //            .mem_we_n
		.hps_ddr_mem_reset_n (<connected-to-hps_ddr_mem_reset_n>), //            .mem_reset_n
		.hps_ddr_mem_dq      (<connected-to-hps_ddr_mem_dq>),      //            .mem_dq
		.hps_ddr_mem_dqs     (<connected-to-hps_ddr_mem_dqs>),     //            .mem_dqs
		.hps_ddr_mem_dqs_n   (<connected-to-hps_ddr_mem_dqs_n>),   //            .mem_dqs_n
		.hps_ddr_mem_odt     (<connected-to-hps_ddr_mem_odt>),     //            .mem_odt
		.hps_ddr_mem_dm      (<connected-to-hps_ddr_mem_dm>),      //            .mem_dm
		.hps_ddr_oct_rzqin   (<connected-to-hps_ddr_oct_rzqin>)    //            .oct_rzqin
	);

