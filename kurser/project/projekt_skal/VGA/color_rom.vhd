-- +-----------------------------+
-- | Color ROM - Gruvbox palette |
-- | G37 Harald Thorsson         |
-- +-----------------------------+

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type-- entity

-- entity
entity color_rom is
	port (
		clk      : in std_logic;
		addr     : in unsigned(2 downto 0);
		data     : out std_logic_vector(11 downto 0));
end color_rom;

-- architecture
architecture Behavioral of color_rom is
	type rom_t is array (0 to 7) of std_logic_vector(11 downto 0);
	signal rom_data : rom_t;

begin

	-- Read from the ROM:
	process(clk)
	begin
		if rising_edge(clk) then
			data <= rom_data(to_integer(addr));
		end if;
	end process;
	
    -- Gruvbox coloscheme 12 bit, 8 colors
	rom_data <= (
        0 => x"222", -- Black
        1 => x"554", -- Dark Grey
        2 => x"C22", -- Red
        3 => x"992", -- Green
        4 => x"DA2", -- Yellow
        5 => x"488", -- Blue
        6 => x"AA8", -- Light Grey
        7 => x"FEB"  -- White
    );
	
end Behavioral;