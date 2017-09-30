	component soc_design is
		port (
			clock_clk    : in std_logic := 'X'; -- clk
			fpga_reset_n : in std_logic := 'X'  -- reset_n
		);
	end component soc_design;

	u0 : component soc_design
		port map (
			clock_clk    => CONNECTED_TO_clock_clk,    -- clock.clk
			fpga_reset_n => CONNECTED_TO_fpga_reset_n  --  fpga.reset_n
		);

