	component hps_design is
		port (
			clk_clk             : in    std_logic                     := 'X';             -- clk
			pll_0_sdram_clk     : out   std_logic;                                        -- clk
			ledr_export         : out   std_logic;                                        -- export
			hps_ddr_mem_a       : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_ddr_mem_ba      : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_ddr_mem_ck      : out   std_logic;                                        -- mem_ck
			hps_ddr_mem_ck_n    : out   std_logic;                                        -- mem_ck_n
			hps_ddr_mem_cke     : out   std_logic;                                        -- mem_cke
			hps_ddr_mem_cs_n    : out   std_logic;                                        -- mem_cs_n
			hps_ddr_mem_ras_n   : out   std_logic;                                        -- mem_ras_n
			hps_ddr_mem_cas_n   : out   std_logic;                                        -- mem_cas_n
			hps_ddr_mem_we_n    : out   std_logic;                                        -- mem_we_n
			hps_ddr_mem_reset_n : out   std_logic;                                        -- mem_reset_n
			hps_ddr_mem_dq      : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_ddr_mem_dqs     : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_ddr_mem_dqs_n   : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_ddr_mem_odt     : out   std_logic;                                        -- mem_odt
			hps_ddr_mem_dm      : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_ddr_oct_rzqin   : in    std_logic                     := 'X'              -- oct_rzqin
		);
	end component hps_design;

	u0 : component hps_design
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --         clk.clk
			pll_0_sdram_clk     => CONNECTED_TO_pll_0_sdram_clk,     -- pll_0_sdram.clk
			ledr_export         => CONNECTED_TO_ledr_export,         --        ledr.export
			hps_ddr_mem_a       => CONNECTED_TO_hps_ddr_mem_a,       --     hps_ddr.mem_a
			hps_ddr_mem_ba      => CONNECTED_TO_hps_ddr_mem_ba,      --            .mem_ba
			hps_ddr_mem_ck      => CONNECTED_TO_hps_ddr_mem_ck,      --            .mem_ck
			hps_ddr_mem_ck_n    => CONNECTED_TO_hps_ddr_mem_ck_n,    --            .mem_ck_n
			hps_ddr_mem_cke     => CONNECTED_TO_hps_ddr_mem_cke,     --            .mem_cke
			hps_ddr_mem_cs_n    => CONNECTED_TO_hps_ddr_mem_cs_n,    --            .mem_cs_n
			hps_ddr_mem_ras_n   => CONNECTED_TO_hps_ddr_mem_ras_n,   --            .mem_ras_n
			hps_ddr_mem_cas_n   => CONNECTED_TO_hps_ddr_mem_cas_n,   --            .mem_cas_n
			hps_ddr_mem_we_n    => CONNECTED_TO_hps_ddr_mem_we_n,    --            .mem_we_n
			hps_ddr_mem_reset_n => CONNECTED_TO_hps_ddr_mem_reset_n, --            .mem_reset_n
			hps_ddr_mem_dq      => CONNECTED_TO_hps_ddr_mem_dq,      --            .mem_dq
			hps_ddr_mem_dqs     => CONNECTED_TO_hps_ddr_mem_dqs,     --            .mem_dqs
			hps_ddr_mem_dqs_n   => CONNECTED_TO_hps_ddr_mem_dqs_n,   --            .mem_dqs_n
			hps_ddr_mem_odt     => CONNECTED_TO_hps_ddr_mem_odt,     --            .mem_odt
			hps_ddr_mem_dm      => CONNECTED_TO_hps_ddr_mem_dm,      --            .mem_dm
			hps_ddr_oct_rzqin   => CONNECTED_TO_hps_ddr_oct_rzqin    --            .oct_rzqin
		);

