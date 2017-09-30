	component soc_design is
		port (
			fpga_reset_n : in  std_logic := 'X'; -- reset_n
			ref_clk      : in  std_logic := 'X'; -- clk
			uart_RXD     : in  std_logic := 'X'; -- RXD
			uart_TXD     : out std_logic         -- TXD
		);
	end component soc_design;

	u0 : component soc_design
		port map (
			fpga_reset_n => CONNECTED_TO_fpga_reset_n, -- fpga.reset_n
			ref_clk      => CONNECTED_TO_ref_clk,      --  ref.clk
			uart_RXD     => CONNECTED_TO_uart_RXD,     -- uart.RXD
			uart_TXD     => CONNECTED_TO_uart_TXD      --     .TXD
		);

