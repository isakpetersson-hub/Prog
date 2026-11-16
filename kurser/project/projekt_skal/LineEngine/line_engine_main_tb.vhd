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
entity line_engine_main_tb is
end entity;

architecture func of line_engine_main_tb is
	component line_engine_main
		port (
			clk      : in std_logic;                         -- system clock
			btnC     : in std_logic;                         -- center button
			--x0,x1,y0,y1 : in signed(20 downto 0);
			--col      : in std_logic_vector(20 downto 0);
	
			--qfull    : out std_logic;
			Hsync    : out std_logic;                        -- horizontal sync
            Vsync    : out std_logic;                        -- vertical sync
            vgaRed   : out std_logic_vector(3 downto 0);     -- VGA red
            vgaGreen : out std_logic_vector(3 downto 0);     -- VGA green
            vgaBlue  : out std_logic_vector(3 downto 0));    -- VGA blue
	end component;

	signal clk : std_logic;
	signal clear : std_logic;
	signal x0,x1,y0,y1 : signed(20 downto 0);
	signal col      : std_logic_vector(20 downto 0);

	constant clk_period : time := 10 ns;

begin

	uut: line_engine_main port map(
		clk => clk,
		btnC => clear
		--x0=>x0,
		--x1=>x1,
		--y0=>y0,
		--y1=>y1,
		--col=>col
	); -- möt mig i handikappstoan kl 03:37 utan byxor xoxo

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	--x0 <= to_signed(100,21);
	--x1 <= to_signed(200,21);
	--y0 <= to_signed(100,21);
	--y1 <= to_signed(200,21);
	--col <= "000000000000000000010";

	clear <= '1', '0' after 25 ns;
end architecture;

