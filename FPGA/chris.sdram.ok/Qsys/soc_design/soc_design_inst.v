	soc_design u0 (
		.dram_addr    (<connected-to-dram_addr>),    //     dram.addr
		.dram_ba      (<connected-to-dram_ba>),      //         .ba
		.dram_cas_n   (<connected-to-dram_cas_n>),   //         .cas_n
		.dram_cke     (<connected-to-dram_cke>),     //         .cke
		.dram_cs_n    (<connected-to-dram_cs_n>),    //         .cs_n
		.dram_dq      (<connected-to-dram_dq>),      //         .dq
		.dram_dqm     (<connected-to-dram_dqm>),     //         .dqm
		.dram_ras_n   (<connected-to-dram_ras_n>),   //         .ras_n
		.dram_we_n    (<connected-to-dram_we_n>),    //         .we_n
		.dram_clk_clk (<connected-to-dram_clk_clk>), // dram_clk.clk
		.fpga_reset_n (<connected-to-fpga_reset_n>), //     fpga.reset_n
		.ref_clk      (<connected-to-ref_clk>),      //      ref.clk
		.uart_RXD     (<connected-to-uart_RXD>),     //     uart.RXD
		.uart_TXD     (<connected-to-uart_TXD>)      //         .TXD
	);

