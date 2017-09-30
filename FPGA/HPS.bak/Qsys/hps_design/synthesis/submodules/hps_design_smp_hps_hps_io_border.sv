// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module hps_design_smp_hps_hps_io_border(
// memory
  output wire [15 - 1 : 0 ] mem_a
 ,output wire [3 - 1 : 0 ] mem_ba
 ,output wire [1 - 1 : 0 ] mem_ck
 ,output wire [1 - 1 : 0 ] mem_ck_n
 ,output wire [1 - 1 : 0 ] mem_cke
 ,output wire [1 - 1 : 0 ] mem_cs_n
 ,output wire [1 - 1 : 0 ] mem_ras_n
 ,output wire [1 - 1 : 0 ] mem_cas_n
 ,output wire [1 - 1 : 0 ] mem_we_n
 ,output wire [1 - 1 : 0 ] mem_reset_n
 ,inout wire [32 - 1 : 0 ] mem_dq
 ,inout wire [4 - 1 : 0 ] mem_dqs
 ,inout wire [4 - 1 : 0 ] mem_dqs_n
 ,output wire [1 - 1 : 0 ] mem_odt
 ,output wire [4 - 1 : 0 ] mem_dm
 ,input wire [1 - 1 : 0 ] oct_rzqin
// hps_io
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO09
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO35
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO40
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO48
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO53
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO54
 ,inout wire [1 - 1 : 0 ] hps_io_gpio_inst_GPIO61
);

assign hps_io_gpio_inst_GPIO09 = intermediate[1] ? intermediate[0] : 'z;
assign hps_io_gpio_inst_GPIO35 = intermediate[3] ? intermediate[2] : 'z;
assign hps_io_gpio_inst_GPIO40 = intermediate[5] ? intermediate[4] : 'z;
assign hps_io_gpio_inst_GPIO48 = intermediate[7] ? intermediate[6] : 'z;
assign hps_io_gpio_inst_GPIO53 = intermediate[9] ? intermediate[8] : 'z;
assign hps_io_gpio_inst_GPIO54 = intermediate[11] ? intermediate[10] : 'z;
assign hps_io_gpio_inst_GPIO61 = intermediate[13] ? intermediate[12] : 'z;

wire [14 - 1 : 0] intermediate;

wire [99 - 1 : 0] floating;

cyclonev_hps_peripheral_gpio gpio_inst(
 .GPIO1_PORTA_I({
    hps_io_gpio_inst_GPIO54[0:0] // 25:25
   ,hps_io_gpio_inst_GPIO53[0:0] // 24:24
   ,floating[3:0] // 23:20
   ,hps_io_gpio_inst_GPIO48[0:0] // 19:19
   ,floating[10:4] // 18:12
   ,hps_io_gpio_inst_GPIO40[0:0] // 11:11
   ,floating[14:11] // 10:7
   ,hps_io_gpio_inst_GPIO35[0:0] // 6:6
   ,floating[20:15] // 5:0
  })
,.GPIO1_PORTA_OE({
    intermediate[11:11] // 25:25
   ,intermediate[9:9] // 24:24
   ,floating[24:21] // 23:20
   ,intermediate[7:7] // 19:19
   ,floating[31:25] // 18:12
   ,intermediate[5:5] // 11:11
   ,floating[35:32] // 10:7
   ,intermediate[3:3] // 6:6
   ,floating[41:36] // 5:0
  })
,.GPIO2_PORTA_O({
    intermediate[12:12] // 3:3
   ,floating[44:42] // 2:0
  })
,.GPIO0_PORTA_O({
    intermediate[0:0] // 9:9
   ,floating[53:45] // 8:0
  })
,.GPIO2_PORTA_I({
    hps_io_gpio_inst_GPIO61[0:0] // 3:3
   ,floating[56:54] // 2:0
  })
,.GPIO2_PORTA_OE({
    intermediate[13:13] // 3:3
   ,floating[59:57] // 2:0
  })
,.GPIO0_PORTA_I({
    hps_io_gpio_inst_GPIO09[0:0] // 9:9
   ,floating[68:60] // 8:0
  })
,.GPIO0_PORTA_OE({
    intermediate[1:1] // 9:9
   ,floating[77:69] // 8:0
  })
,.GPIO1_PORTA_O({
    intermediate[10:10] // 25:25
   ,intermediate[8:8] // 24:24
   ,floating[81:78] // 23:20
   ,intermediate[6:6] // 19:19
   ,floating[88:82] // 18:12
   ,intermediate[4:4] // 11:11
   ,floating[92:89] // 10:7
   ,intermediate[2:2] // 6:6
   ,floating[98:93] // 5:0
  })
);


hps_sdram hps_sdram_inst(
 .mem_dq({
    mem_dq[31:0] // 31:0
  })
,.mem_odt({
    mem_odt[0:0] // 0:0
  })
,.mem_ras_n({
    mem_ras_n[0:0] // 0:0
  })
,.mem_dqs_n({
    mem_dqs_n[3:0] // 3:0
  })
,.mem_dqs({
    mem_dqs[3:0] // 3:0
  })
,.mem_dm({
    mem_dm[3:0] // 3:0
  })
,.mem_we_n({
    mem_we_n[0:0] // 0:0
  })
,.mem_cas_n({
    mem_cas_n[0:0] // 0:0
  })
,.mem_ba({
    mem_ba[2:0] // 2:0
  })
,.mem_a({
    mem_a[14:0] // 14:0
  })
,.mem_cs_n({
    mem_cs_n[0:0] // 0:0
  })
,.mem_ck({
    mem_ck[0:0] // 0:0
  })
,.mem_cke({
    mem_cke[0:0] // 0:0
  })
,.oct_rzqin({
    oct_rzqin[0:0] // 0:0
  })
,.mem_reset_n({
    mem_reset_n[0:0] // 0:0
  })
,.mem_ck_n({
    mem_ck_n[0:0] // 0:0
  })
);

endmodule

