	component soc_design is
		port (
			dram_addr    : out   std_logic_vector(12 downto 0);                    -- addr
			dram_ba      : out   std_logic_vector(1 downto 0);                     -- ba
			dram_cas_n   : out   std_logic;                                        -- cas_n
			dram_cke     : out   std_logic;                                        -- cke
			dram_cs_n    : out   std_logic;                                        -- cs_n
			dram_dq      : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			dram_dqm     : out   std_logic_vector(1 downto 0);                     -- dqm
			dram_ras_n   : out   std_logic;                                        -- ras_n
			dram_we_n    : out   std_logic;                                        -- we_n
			dram_clk_clk : out   std_logic;                                        -- clk
			fpga_reset_n : in    std_logic                     := 'X';             -- reset_n
			ledr0_ledr   : out   std_logic;                                        -- ledr
			ref_clk      : in    std_logic                     := 'X';             -- clk
			uart_RXD     : in    std_logic                     := 'X';             -- RXD
			uart_TXD     : out   std_logic                                         -- TXD
		);
	end component soc_design;

	u0 : component soc_design
		port map (
			dram_addr    => CONNECTED_TO_dram_addr,    --     dram.addr
			dram_ba      => CONNECTED_TO_dram_ba,      --         .ba
			dram_cas_n   => CONNECTED_TO_dram_cas_n,   --         .cas_n
			dram_cke     => CONNECTED_TO_dram_cke,     --         .cke
			dram_cs_n    => CONNECTED_TO_dram_cs_n,    --         .cs_n
			dram_dq      => CONNECTED_TO_dram_dq,      --         .dq
			dram_dqm     => CONNECTED_TO_dram_dqm,     --         .dqm
			dram_ras_n   => CONNECTED_TO_dram_ras_n,   --         .ras_n
			dram_we_n    => CONNECTED_TO_dram_we_n,    --         .we_n
			dram_clk_clk => CONNECTED_TO_dram_clk_clk, -- dram_clk.clk
			fpga_reset_n => CONNECTED_TO_fpga_reset_n, --     fpga.reset_n
			ledr0_ledr   => CONNECTED_TO_ledr0_ledr,   --    ledr0.ledr
			ref_clk      => CONNECTED_TO_ref_clk,      --      ref.clk
			uart_RXD     => CONNECTED_TO_uart_RXD,     --     uart.RXD
			uart_TXD     => CONNECTED_TO_uart_TXD      --         .TXD
		);

