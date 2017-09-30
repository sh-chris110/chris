	component hps_design is
		port (
			clk_clk          : in    std_logic                     := 'X';             -- clk
			ddr3_mem_a       : out   std_logic_vector(12 downto 0);                    -- mem_a
			ddr3_mem_ba      : out   std_logic_vector(2 downto 0);                     -- mem_ba
			ddr3_mem_ck      : out   std_logic;                                        -- mem_ck
			ddr3_mem_ck_n    : out   std_logic;                                        -- mem_ck_n
			ddr3_mem_cke     : out   std_logic;                                        -- mem_cke
			ddr3_mem_cs_n    : out   std_logic;                                        -- mem_cs_n
			ddr3_mem_ras_n   : out   std_logic;                                        -- mem_ras_n
			ddr3_mem_cas_n   : out   std_logic;                                        -- mem_cas_n
			ddr3_mem_we_n    : out   std_logic;                                        -- mem_we_n
			ddr3_mem_reset_n : out   std_logic;                                        -- mem_reset_n
			ddr3_mem_dq      : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dq
			ddr3_mem_dqs     : inout std_logic                     := 'X';             -- mem_dqs
			ddr3_mem_dqs_n   : inout std_logic                     := 'X';             -- mem_dqs_n
			ddr3_mem_odt     : out   std_logic;                                        -- mem_odt
			ddr3_mem_dm      : out   std_logic;                                        -- mem_dm
			ddr3_oct_rzqin   : in    std_logic                     := 'X';             -- oct_rzqin
			ledr_export      : out   std_logic;                                        -- export
			ddr3_clk_clk     : out   std_logic                                         -- clk
		);
	end component hps_design;

	u0 : component hps_design
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --      clk.clk
			ddr3_mem_a       => CONNECTED_TO_ddr3_mem_a,       --     ddr3.mem_a
			ddr3_mem_ba      => CONNECTED_TO_ddr3_mem_ba,      --         .mem_ba
			ddr3_mem_ck      => CONNECTED_TO_ddr3_mem_ck,      --         .mem_ck
			ddr3_mem_ck_n    => CONNECTED_TO_ddr3_mem_ck_n,    --         .mem_ck_n
			ddr3_mem_cke     => CONNECTED_TO_ddr3_mem_cke,     --         .mem_cke
			ddr3_mem_cs_n    => CONNECTED_TO_ddr3_mem_cs_n,    --         .mem_cs_n
			ddr3_mem_ras_n   => CONNECTED_TO_ddr3_mem_ras_n,   --         .mem_ras_n
			ddr3_mem_cas_n   => CONNECTED_TO_ddr3_mem_cas_n,   --         .mem_cas_n
			ddr3_mem_we_n    => CONNECTED_TO_ddr3_mem_we_n,    --         .mem_we_n
			ddr3_mem_reset_n => CONNECTED_TO_ddr3_mem_reset_n, --         .mem_reset_n
			ddr3_mem_dq      => CONNECTED_TO_ddr3_mem_dq,      --         .mem_dq
			ddr3_mem_dqs     => CONNECTED_TO_ddr3_mem_dqs,     --         .mem_dqs
			ddr3_mem_dqs_n   => CONNECTED_TO_ddr3_mem_dqs_n,   --         .mem_dqs_n
			ddr3_mem_odt     => CONNECTED_TO_ddr3_mem_odt,     --         .mem_odt
			ddr3_mem_dm      => CONNECTED_TO_ddr3_mem_dm,      --         .mem_dm
			ddr3_oct_rzqin   => CONNECTED_TO_ddr3_oct_rzqin,   --         .oct_rzqin
			ledr_export      => CONNECTED_TO_ledr_export,      --     ledr.export
			ddr3_clk_clk     => CONNECTED_TO_ddr3_clk_clk      -- ddr3_clk.clk
		);

