--------------------------------------------------------------------------------
-- VGA lab testbench
-- Anders Nilsson
-- 26-feb-2020
-- Version 1.0


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                          -- and various arithmetic operations
entity vga_main_tb is
end entity;

architecture func of vga_main_tb is
	component vga_main
		port (
			clk      : in std_logic;                         -- system clock
			btnC     : in std_logic;                         -- center button
	
			--col_data : in std_logic_vector(2 downto 0); 
			--pix_addr : in std_logic_vector(16 downto 0);
			--we       : in std_logic;
	
			Hsync    : out std_logic;                        -- horizontal sync
			Vsync    : out std_logic;                        -- vertical sync
			vgaRed   : out std_logic_vector(3 downto 0);     -- VGA red
			vgaGreen : out std_logic_vector(3 downto 0);     -- VGA green
			vgaBlue  : out std_logic_vector(3 downto 0));    -- VGA blue
	end component;

	signal clk : std_logic;
	signal clear : std_logic;

	constant clk_period : time := 10 ns;

begin

	uut: vga_main port map(
		clk => clk,
		btnC => clear
	); -- möt mig i handikappstoan kl 03:37 utan byxor xoxo

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	--we <= '1';
	clear <= '1', '0' after 25 ns;
end architecture;

