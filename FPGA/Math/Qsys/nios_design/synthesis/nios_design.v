// nios_design.v

// Generated using ACDS version 15.0 145

`timescale 1 ps / 1 ps
module nios_design (
		input  wire  clk_clk,       //   clk.clk
		input  wire  reset_reset_n  // reset.reset_n
	);

	wire         pll_0_outclk0_clk;                                          // pll_0:outclk_0 -> [custom_math_0:clock_clk, irq_mapper:clk, mm_interconnect_0:pll_0_outclk0_clk, nios2_gen2_0:clk, onchip_memory2_0:clk, rst_controller:clk, sysid_qsys_0:clock, timer_0:clk]
	wire         custom_math_0_avm_m0_waitrequest;                           // mm_interconnect_0:custom_math_0_avm_m0_waitrequest -> custom_math_0:avm_m0_waitrequest
	wire  [31:0] custom_math_0_avm_m0_readdata;                              // mm_interconnect_0:custom_math_0_avm_m0_readdata -> custom_math_0:avm_m0_readdata
	wire  [31:0] custom_math_0_avm_m0_address;                               // custom_math_0:avm_m0_address -> mm_interconnect_0:custom_math_0_avm_m0_address
	wire         custom_math_0_avm_m0_read;                                  // custom_math_0:avm_m0_read -> mm_interconnect_0:custom_math_0_avm_m0_read
	wire         custom_math_0_avm_m0_write;                                 // custom_math_0:avm_m0_write -> mm_interconnect_0:custom_math_0_avm_m0_write
	wire  [31:0] custom_math_0_avm_m0_writedata;                             // custom_math_0:avm_m0_writedata -> mm_interconnect_0:custom_math_0_avm_m0_writedata
	wire  [31:0] nios2_gen2_0_data_master_readdata;                          // mm_interconnect_0:nios2_gen2_0_data_master_readdata -> nios2_gen2_0:d_readdata
	wire         nios2_gen2_0_data_master_waitrequest;                       // mm_interconnect_0:nios2_gen2_0_data_master_waitrequest -> nios2_gen2_0:d_waitrequest
	wire         nios2_gen2_0_data_master_debugaccess;                       // nios2_gen2_0:debug_mem_slave_debugaccess_to_roms -> mm_interconnect_0:nios2_gen2_0_data_master_debugaccess
	wire  [18:0] nios2_gen2_0_data_master_address;                           // nios2_gen2_0:d_address -> mm_interconnect_0:nios2_gen2_0_data_master_address
	wire   [3:0] nios2_gen2_0_data_master_byteenable;                        // nios2_gen2_0:d_byteenable -> mm_interconnect_0:nios2_gen2_0_data_master_byteenable
	wire         nios2_gen2_0_data_master_read;                              // nios2_gen2_0:d_read -> mm_interconnect_0:nios2_gen2_0_data_master_read
	wire         nios2_gen2_0_data_master_readdatavalid;                     // mm_interconnect_0:nios2_gen2_0_data_master_readdatavalid -> nios2_gen2_0:d_readdatavalid
	wire         nios2_gen2_0_data_master_write;                             // nios2_gen2_0:d_write -> mm_interconnect_0:nios2_gen2_0_data_master_write
	wire  [31:0] nios2_gen2_0_data_master_writedata;                         // nios2_gen2_0:d_writedata -> mm_interconnect_0:nios2_gen2_0_data_master_writedata
	wire  [31:0] nios2_gen2_0_instruction_master_readdata;                   // mm_interconnect_0:nios2_gen2_0_instruction_master_readdata -> nios2_gen2_0:i_readdata
	wire         nios2_gen2_0_instruction_master_waitrequest;                // mm_interconnect_0:nios2_gen2_0_instruction_master_waitrequest -> nios2_gen2_0:i_waitrequest
	wire  [18:0] nios2_gen2_0_instruction_master_address;                    // nios2_gen2_0:i_address -> mm_interconnect_0:nios2_gen2_0_instruction_master_address
	wire         nios2_gen2_0_instruction_master_read;                       // nios2_gen2_0:i_read -> mm_interconnect_0:nios2_gen2_0_instruction_master_read
	wire         nios2_gen2_0_instruction_master_readdatavalid;              // mm_interconnect_0:nios2_gen2_0_instruction_master_readdatavalid -> nios2_gen2_0:i_readdatavalid
	wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect;           // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;             // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
	wire  [15:0] mm_interconnect_0_onchip_memory2_0_s1_address;              // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
	wire   [3:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable;           // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
	wire         mm_interconnect_0_onchip_memory2_0_s1_write;                // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
	wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;            // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
	wire         mm_interconnect_0_onchip_memory2_0_s1_clken;                // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
	wire  [31:0] mm_interconnect_0_nios2_gen2_0_debug_mem_slave_readdata;    // nios2_gen2_0:debug_mem_slave_readdata -> mm_interconnect_0:nios2_gen2_0_debug_mem_slave_readdata
	wire         mm_interconnect_0_nios2_gen2_0_debug_mem_slave_waitrequest; // nios2_gen2_0:debug_mem_slave_waitrequest -> mm_interconnect_0:nios2_gen2_0_debug_mem_slave_waitrequest
	wire         mm_interconnect_0_nios2_gen2_0_debug_mem_slave_debugaccess; // mm_interconnect_0:nios2_gen2_0_debug_mem_slave_debugaccess -> nios2_gen2_0:debug_mem_slave_debugaccess
	wire   [8:0] mm_interconnect_0_nios2_gen2_0_debug_mem_slave_address;     // mm_interconnect_0:nios2_gen2_0_debug_mem_slave_address -> nios2_gen2_0:debug_mem_slave_address
	wire         mm_interconnect_0_nios2_gen2_0_debug_mem_slave_read;        // mm_interconnect_0:nios2_gen2_0_debug_mem_slave_read -> nios2_gen2_0:debug_mem_slave_read
	wire   [3:0] mm_interconnect_0_nios2_gen2_0_debug_mem_slave_byteenable;  // mm_interconnect_0:nios2_gen2_0_debug_mem_slave_byteenable -> nios2_gen2_0:debug_mem_slave_byteenable
	wire         mm_interconnect_0_nios2_gen2_0_debug_mem_slave_write;       // mm_interconnect_0:nios2_gen2_0_debug_mem_slave_write -> nios2_gen2_0:debug_mem_slave_write
	wire  [31:0] mm_interconnect_0_nios2_gen2_0_debug_mem_slave_writedata;   // mm_interconnect_0:nios2_gen2_0_debug_mem_slave_writedata -> nios2_gen2_0:debug_mem_slave_writedata
	wire  [31:0] mm_interconnect_0_custom_math_0_avs_s0_readdata;            // custom_math_0:avs_s0_readdata -> mm_interconnect_0:custom_math_0_avs_s0_readdata
	wire         mm_interconnect_0_custom_math_0_avs_s0_waitrequest;         // custom_math_0:avs_s0_waitrequest -> mm_interconnect_0:custom_math_0_avs_s0_waitrequest
	wire   [3:0] mm_interconnect_0_custom_math_0_avs_s0_address;             // mm_interconnect_0:custom_math_0_avs_s0_address -> custom_math_0:avs_s0_address
	wire         mm_interconnect_0_custom_math_0_avs_s0_read;                // mm_interconnect_0:custom_math_0_avs_s0_read -> custom_math_0:avs_s0_read
	wire         mm_interconnect_0_custom_math_0_avs_s0_write;               // mm_interconnect_0:custom_math_0_avs_s0_write -> custom_math_0:avs_s0_write
	wire  [31:0] mm_interconnect_0_custom_math_0_avs_s0_writedata;           // mm_interconnect_0:custom_math_0_avs_s0_writedata -> custom_math_0:avs_s0_writedata
	wire  [31:0] mm_interconnect_0_sysid_qsys_0_control_slave_readdata;      // sysid_qsys_0:readdata -> mm_interconnect_0:sysid_qsys_0_control_slave_readdata
	wire   [0:0] mm_interconnect_0_sysid_qsys_0_control_slave_address;       // mm_interconnect_0:sysid_qsys_0_control_slave_address -> sysid_qsys_0:address
	wire         mm_interconnect_0_timer_0_s1_chipselect;                    // mm_interconnect_0:timer_0_s1_chipselect -> timer_0:chipselect
	wire  [15:0] mm_interconnect_0_timer_0_s1_readdata;                      // timer_0:readdata -> mm_interconnect_0:timer_0_s1_readdata
	wire   [2:0] mm_interconnect_0_timer_0_s1_address;                       // mm_interconnect_0:timer_0_s1_address -> timer_0:address
	wire         mm_interconnect_0_timer_0_s1_write;                         // mm_interconnect_0:timer_0_s1_write -> timer_0:write_n
	wire  [15:0] mm_interconnect_0_timer_0_s1_writedata;                     // mm_interconnect_0:timer_0_s1_writedata -> timer_0:writedata
	wire         irq_mapper_receiver0_irq;                                   // custom_math_0:ins_irq0_irq -> irq_mapper:receiver0_irq
	wire         irq_mapper_receiver1_irq;                                   // timer_0:irq -> irq_mapper:receiver1_irq
	wire  [31:0] nios2_gen2_0_irq_irq;                                       // irq_mapper:sender_irq -> nios2_gen2_0:irq
	wire         rst_controller_reset_out_reset;                             // rst_controller:reset_out -> [custom_math_0:reset_reset, irq_mapper:reset, mm_interconnect_0:custom_math_0_reset_reset_bridge_in_reset_reset, nios2_gen2_0:reset_n, onchip_memory2_0:reset, rst_translator:in_reset, sysid_qsys_0:reset_n, timer_0:reset_n]
	wire         rst_controller_reset_out_reset_req;                         // rst_controller:reset_req -> [nios2_gen2_0:reset_req, onchip_memory2_0:reset_req, rst_translator:reset_req_in]

	custom_math custom_math_0 (
		.avs_s0_address     (mm_interconnect_0_custom_math_0_avs_s0_address),     //   avs_s0.address
		.avs_s0_read        (mm_interconnect_0_custom_math_0_avs_s0_read),        //         .read
		.avs_s0_readdata    (mm_interconnect_0_custom_math_0_avs_s0_readdata),    //         .readdata
		.avs_s0_write       (mm_interconnect_0_custom_math_0_avs_s0_write),       //         .write
		.avs_s0_writedata   (mm_interconnect_0_custom_math_0_avs_s0_writedata),   //         .writedata
		.avs_s0_waitrequest (mm_interconnect_0_custom_math_0_avs_s0_waitrequest), //         .waitrequest
		.clock_clk          (pll_0_outclk0_clk),                                  //    clock.clk
		.reset_reset        (rst_controller_reset_out_reset),                     //    reset.reset
		.ins_irq0_irq       (irq_mapper_receiver0_irq),                           // ins_irq0.irq
		.avm_m0_address     (custom_math_0_avm_m0_address),                       //   avm_m0.address
		.avm_m0_read        (custom_math_0_avm_m0_read),                          //         .read
		.avm_m0_waitrequest (custom_math_0_avm_m0_waitrequest),                   //         .waitrequest
		.avm_m0_readdata    (custom_math_0_avm_m0_readdata),                      //         .readdata
		.avm_m0_write       (custom_math_0_avm_m0_write),                         //         .write
		.avm_m0_writedata   (custom_math_0_avm_m0_writedata)                      //         .writedata
	);

	nios_design_nios2_gen2_0 nios2_gen2_0 (
		.clk                                 (pll_0_outclk0_clk),                                          //                       clk.clk
		.reset_n                             (~rst_controller_reset_out_reset),                            //                     reset.reset_n
		.reset_req                           (rst_controller_reset_out_reset_req),                         //                          .reset_req
		.d_address                           (nios2_gen2_0_data_master_address),                           //               data_master.address
		.d_byteenable                        (nios2_gen2_0_data_master_byteenable),                        //                          .byteenable
		.d_read                              (nios2_gen2_0_data_master_read),                              //                          .read
		.d_readdata                          (nios2_gen2_0_data_master_readdata),                          //                          .readdata
		.d_waitrequest                       (nios2_gen2_0_data_master_waitrequest),                       //                          .waitrequest
		.d_write                             (nios2_gen2_0_data_master_write),                             //                          .write
		.d_writedata                         (nios2_gen2_0_data_master_writedata),                         //                          .writedata
		.d_readdatavalid                     (nios2_gen2_0_data_master_readdatavalid),                     //                          .readdatavalid
		.debug_mem_slave_debugaccess_to_roms (nios2_gen2_0_data_master_debugaccess),                       //                          .debugaccess
		.i_address                           (nios2_gen2_0_instruction_master_address),                    //        instruction_master.address
		.i_read                              (nios2_gen2_0_instruction_master_read),                       //                          .read
		.i_readdata                          (nios2_gen2_0_instruction_master_readdata),                   //                          .readdata
		.i_waitrequest                       (nios2_gen2_0_instruction_master_waitrequest),                //                          .waitrequest
		.i_readdatavalid                     (nios2_gen2_0_instruction_master_readdatavalid),              //                          .readdatavalid
		.irq                                 (nios2_gen2_0_irq_irq),                                       //                       irq.irq
		.debug_reset_request                 (),                                                           //       debug_reset_request.reset
		.debug_mem_slave_address             (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_address),     //           debug_mem_slave.address
		.debug_mem_slave_byteenable          (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_byteenable),  //                          .byteenable
		.debug_mem_slave_debugaccess         (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_debugaccess), //                          .debugaccess
		.debug_mem_slave_read                (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_read),        //                          .read
		.debug_mem_slave_readdata            (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_readdata),    //                          .readdata
		.debug_mem_slave_waitrequest         (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_waitrequest), //                          .waitrequest
		.debug_mem_slave_write               (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_write),       //                          .write
		.debug_mem_slave_writedata           (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_writedata),   //                          .writedata
		.dummy_ci_port                       ()                                                            // custom_instruction_master.readra
	);

	nios_design_onchip_memory2_0 onchip_memory2_0 (
		.clk        (pll_0_outclk0_clk),                                //   clk1.clk
		.address    (mm_interconnect_0_onchip_memory2_0_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_onchip_memory2_0_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_onchip_memory2_0_s1_write),      //       .write
		.readdata   (mm_interconnect_0_onchip_memory2_0_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_onchip_memory2_0_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset),                   // reset1.reset
		.reset_req  (rst_controller_reset_out_reset_req)                //       .reset_req
	);

	nios_design_pll_0 pll_0 (
		.refclk   (clk_clk),           //  refclk.clk
		.rst      (~reset_reset_n),    //   reset.reset
		.outclk_0 (pll_0_outclk0_clk), // outclk0.clk
		.locked   ()                   // (terminated)
	);

	nios_design_sysid_qsys_0 sysid_qsys_0 (
		.clock    (pll_0_outclk0_clk),                                     //           clk.clk
		.reset_n  (~rst_controller_reset_out_reset),                       //         reset.reset_n
		.readdata (mm_interconnect_0_sysid_qsys_0_control_slave_readdata), // control_slave.readdata
		.address  (mm_interconnect_0_sysid_qsys_0_control_slave_address)   //              .address
	);

	nios_design_timer_0 timer_0 (
		.clk        (pll_0_outclk0_clk),                       //   clk.clk
		.reset_n    (~rst_controller_reset_out_reset),         // reset.reset_n
		.address    (mm_interconnect_0_timer_0_s1_address),    //    s1.address
		.writedata  (mm_interconnect_0_timer_0_s1_writedata),  //      .writedata
		.readdata   (mm_interconnect_0_timer_0_s1_readdata),   //      .readdata
		.chipselect (mm_interconnect_0_timer_0_s1_chipselect), //      .chipselect
		.write_n    (~mm_interconnect_0_timer_0_s1_write),     //      .write_n
		.irq        (irq_mapper_receiver1_irq)                 //   irq.irq
	);

	nios_design_mm_interconnect_0 mm_interconnect_0 (
		.pll_0_outclk0_clk                               (pll_0_outclk0_clk),                                          //                             pll_0_outclk0.clk
		.custom_math_0_reset_reset_bridge_in_reset_reset (rst_controller_reset_out_reset),                             // custom_math_0_reset_reset_bridge_in_reset.reset
		.custom_math_0_avm_m0_address                    (custom_math_0_avm_m0_address),                               //                      custom_math_0_avm_m0.address
		.custom_math_0_avm_m0_waitrequest                (custom_math_0_avm_m0_waitrequest),                           //                                          .waitrequest
		.custom_math_0_avm_m0_read                       (custom_math_0_avm_m0_read),                                  //                                          .read
		.custom_math_0_avm_m0_readdata                   (custom_math_0_avm_m0_readdata),                              //                                          .readdata
		.custom_math_0_avm_m0_write                      (custom_math_0_avm_m0_write),                                 //                                          .write
		.custom_math_0_avm_m0_writedata                  (custom_math_0_avm_m0_writedata),                             //                                          .writedata
		.nios2_gen2_0_data_master_address                (nios2_gen2_0_data_master_address),                           //                  nios2_gen2_0_data_master.address
		.nios2_gen2_0_data_master_waitrequest            (nios2_gen2_0_data_master_waitrequest),                       //                                          .waitrequest
		.nios2_gen2_0_data_master_byteenable             (nios2_gen2_0_data_master_byteenable),                        //                                          .byteenable
		.nios2_gen2_0_data_master_read                   (nios2_gen2_0_data_master_read),                              //                                          .read
		.nios2_gen2_0_data_master_readdata               (nios2_gen2_0_data_master_readdata),                          //                                          .readdata
		.nios2_gen2_0_data_master_readdatavalid          (nios2_gen2_0_data_master_readdatavalid),                     //                                          .readdatavalid
		.nios2_gen2_0_data_master_write                  (nios2_gen2_0_data_master_write),                             //                                          .write
		.nios2_gen2_0_data_master_writedata              (nios2_gen2_0_data_master_writedata),                         //                                          .writedata
		.nios2_gen2_0_data_master_debugaccess            (nios2_gen2_0_data_master_debugaccess),                       //                                          .debugaccess
		.nios2_gen2_0_instruction_master_address         (nios2_gen2_0_instruction_master_address),                    //           nios2_gen2_0_instruction_master.address
		.nios2_gen2_0_instruction_master_waitrequest     (nios2_gen2_0_instruction_master_waitrequest),                //                                          .waitrequest
		.nios2_gen2_0_instruction_master_read            (nios2_gen2_0_instruction_master_read),                       //                                          .read
		.nios2_gen2_0_instruction_master_readdata        (nios2_gen2_0_instruction_master_readdata),                   //                                          .readdata
		.nios2_gen2_0_instruction_master_readdatavalid   (nios2_gen2_0_instruction_master_readdatavalid),              //                                          .readdatavalid
		.custom_math_0_avs_s0_address                    (mm_interconnect_0_custom_math_0_avs_s0_address),             //                      custom_math_0_avs_s0.address
		.custom_math_0_avs_s0_write                      (mm_interconnect_0_custom_math_0_avs_s0_write),               //                                          .write
		.custom_math_0_avs_s0_read                       (mm_interconnect_0_custom_math_0_avs_s0_read),                //                                          .read
		.custom_math_0_avs_s0_readdata                   (mm_interconnect_0_custom_math_0_avs_s0_readdata),            //                                          .readdata
		.custom_math_0_avs_s0_writedata                  (mm_interconnect_0_custom_math_0_avs_s0_writedata),           //                                          .writedata
		.custom_math_0_avs_s0_waitrequest                (mm_interconnect_0_custom_math_0_avs_s0_waitrequest),         //                                          .waitrequest
		.nios2_gen2_0_debug_mem_slave_address            (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_address),     //              nios2_gen2_0_debug_mem_slave.address
		.nios2_gen2_0_debug_mem_slave_write              (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_write),       //                                          .write
		.nios2_gen2_0_debug_mem_slave_read               (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_read),        //                                          .read
		.nios2_gen2_0_debug_mem_slave_readdata           (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_readdata),    //                                          .readdata
		.nios2_gen2_0_debug_mem_slave_writedata          (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_writedata),   //                                          .writedata
		.nios2_gen2_0_debug_mem_slave_byteenable         (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_byteenable),  //                                          .byteenable
		.nios2_gen2_0_debug_mem_slave_waitrequest        (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_waitrequest), //                                          .waitrequest
		.nios2_gen2_0_debug_mem_slave_debugaccess        (mm_interconnect_0_nios2_gen2_0_debug_mem_slave_debugaccess), //                                          .debugaccess
		.onchip_memory2_0_s1_address                     (mm_interconnect_0_onchip_memory2_0_s1_address),              //                       onchip_memory2_0_s1.address
		.onchip_memory2_0_s1_write                       (mm_interconnect_0_onchip_memory2_0_s1_write),                //                                          .write
		.onchip_memory2_0_s1_readdata                    (mm_interconnect_0_onchip_memory2_0_s1_readdata),             //                                          .readdata
		.onchip_memory2_0_s1_writedata                   (mm_interconnect_0_onchip_memory2_0_s1_writedata),            //                                          .writedata
		.onchip_memory2_0_s1_byteenable                  (mm_interconnect_0_onchip_memory2_0_s1_byteenable),           //                                          .byteenable
		.onchip_memory2_0_s1_chipselect                  (mm_interconnect_0_onchip_memory2_0_s1_chipselect),           //                                          .chipselect
		.onchip_memory2_0_s1_clken                       (mm_interconnect_0_onchip_memory2_0_s1_clken),                //                                          .clken
		.sysid_qsys_0_control_slave_address              (mm_interconnect_0_sysid_qsys_0_control_slave_address),       //                sysid_qsys_0_control_slave.address
		.sysid_qsys_0_control_slave_readdata             (mm_interconnect_0_sysid_qsys_0_control_slave_readdata),      //                                          .readdata
		.timer_0_s1_address                              (mm_interconnect_0_timer_0_s1_address),                       //                                timer_0_s1.address
		.timer_0_s1_write                                (mm_interconnect_0_timer_0_s1_write),                         //                                          .write
		.timer_0_s1_readdata                             (mm_interconnect_0_timer_0_s1_readdata),                      //                                          .readdata
		.timer_0_s1_writedata                            (mm_interconnect_0_timer_0_s1_writedata),                     //                                          .writedata
		.timer_0_s1_chipselect                           (mm_interconnect_0_timer_0_s1_chipselect)                     //                                          .chipselect
	);

	nios_design_irq_mapper irq_mapper (
		.clk           (pll_0_outclk0_clk),              //       clk.clk
		.reset         (rst_controller_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),       // receiver0.irq
		.receiver1_irq (irq_mapper_receiver1_irq),       // receiver1.irq
		.sender_irq    (nios2_gen2_0_irq_irq)            //    sender.irq
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.clk            (pll_0_outclk0_clk),                  //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
