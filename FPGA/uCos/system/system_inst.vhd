	component system is
		port (
			ref_clk      : in    std_logic                     := 'X';             -- clk
			fpga_reset_n : in    std_logic                     := 'X';             -- reset_n
			dram_addr    : out   std_logic_vector(12 downto 0);                    -- addr
			dram_ba      : out   std_logic_vector(1 downto 0);                     -- ba
			dram_cas_n   : out   std_logic;                                        -- cas_n
			dram_cke     : out   std_logic;                                        -- cke
			dram_cs_n    : out   std_logic;                                        -- cs_n
			dram_dq      : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			dram_dqm     : out   std_logic_vector(1 downto 0);                     -- dqm
			dram_ras_n   : out   std_logic;                                        -- ras_n
			dram_we_n    : out   std_logic;                                        -- we_n
			dram_clk_clk : out   std_logic                                         -- clk
		);
	end component system;

	u0 : component system
		port map (
			ref_clk      => CONNECTED_TO_ref_clk,      --      ref.clk
			fpga_reset_n => CONNECTED_TO_fpga_reset_n, --     fpga.reset_n
			dram_addr    => CONNECTED_TO_dram_addr,    --     dram.addr
			dram_ba      => CONNECTED_TO_dram_ba,      --         .ba
			dram_cas_n   => CONNECTED_TO_dram_cas_n,   --         .cas_n
			dram_cke     => CONNECTED_TO_dram_cke,     --         .cke
			dram_cs_n    => CONNECTED_TO_dram_cs_n,    --         .cs_n
			dram_dq      => CONNECTED_TO_dram_dq,      --         .dq
			dram_dqm     => CONNECTED_TO_dram_dqm,     --         .dqm
			dram_ras_n   => CONNECTED_TO_dram_ras_n,   --         .ras_n
			dram_we_n    => CONNECTED_TO_dram_we_n,    --         .we_n
			dram_clk_clk => CONNECTED_TO_dram_clk_clk  -- dram_clk.clk
		);

