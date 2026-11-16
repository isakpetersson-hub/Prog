-- +---------------------+
-- | VGA main file       |
-- | G37 Harald Thorsson |
-- +---------------------+

-- ##### Skeleton from ##### 
-- VGA lab
-- Anders Nilsson
-- 16-dec-2015
-- Version 1.0


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                                        -- and various arithmetic operations

-- entity
entity vga_main is
	port (
		clk      : in std_logic;                         -- system clock
		btnC     : in std_logic;                         -- center button

		col_data : in std_logic_vector(2 downto 0); 
		pix_addr : in unsigned(16 downto 0);
		we       : in std_logic;
		swap 	 : out std_logic;

		Hsync    : out std_logic;                        -- horizontal sync
		Vsync    : out std_logic;                        -- vertical sync
		vgaRed   : out std_logic_vector(3 downto 0);     -- VGA red
		vgaGreen : out std_logic_vector(3 downto 0);     -- VGA green
		vgaBlue  : out std_logic_vector(3 downto 0));    -- VGA blue
end vga_main;


-- architecture
architecture Behavioral of vga_main is

	-- picture memory component
	component VIDEO_RAM
		port (
			clk       : in std_logic;
			swap      : in std_logic;
			-- port 1
			we1       : in std_logic;
			data_in1  : in std_logic_vector(2 downto 0);
			addr1     : in unsigned(16 downto 0);
			-- port 2
			we2       : in std_logic;
			data_in2  : in std_logic_vector(2 downto 0);
			data_out2 : out std_logic_vector(2 downto 0);
			addr2     : in unsigned(16 downto 0));
	end component;

	-- VGA motor component
	component VGA_MOTOR
		port (
			clk      	: in std_logic;
			swap	 	: out std_logic;
			VR_data  	: in std_logic_vector(2 downto 0);
			VR_addr  	: out unsigned(16 downto 0);
			clear    	: in std_logic;
			
			we2 	    : out std_logic;
			VR_data_out : out std_logic_vector(2 downto 0);
			
			vgaRed   	: out std_logic_vector(3 downto 0);
			vgaGreen 	: out std_logic_vector(3 downto 0);
			vgaBlue  	: out std_logic_vector(3 downto 0);
			Hsync    	: out std_logic;
			Vsync    	: out std_logic);
	end component;

	-- intermediate signals between VIDEO_RAM and VGA_MOTOR
	signal data_out2_s : std_logic_vector(2 downto 0); -- data
	signal addr2_s : unsigned(16 downto 0);            -- address
	signal data_in2_s : std_logic_vector(2 downto 0);
	signal we2_s : std_logic;
	signal we1_s : std_logic;
	signal swap_vram : std_logic;
	signal countertest : unsigned(10 downto 0);
	signal pixeltestaddr : unsigned(16 downto 0);
	signal pixeltestdata : unsigned(2 downto 0);

        -- synchronous clear
        signal clear : std_logic;
begin

	process (clk)
	begin
		if(rising_edge(clk)) then
			if ((pixeltestaddr >= 76799)) then
				pixeltestaddr <= (others => '0');
			elsif  swap_vram = '1' then
				pixeltestaddr <= pixeltestaddr + 241;
			end if;
		end if;
	end process;

	process (clk)
	begin
		if(rising_edge(clk)) then
			if (pixeltestdata = 7 or swap_vram = '1') then
				pixeltestdata <= (others => '0');
			else
				pixeltestdata <= pixeltestdata + 1;
			end if;
		end if;
	end process;

  clear <= btnC;
  we1_s <= '1' when pixeltestaddr < 76800 else '0';

	swap <= swap_vram;
  
	-- picture memory component connection
	U1 : VIDEO_RAM port map(clk=>clk, swap=>swap_vram, we1=>we1_s, data_in1=>col_data, addr1=>pix_addr, we2=>we2_s, data_in2=>data_in2_s, data_out2=>data_out2_s, addr2=>addr2_s);
	--U1 : VIDEO_RAM port map(clk=>clk, swap=>swap_vram, we1=>we1_s, data_in1=>"010", addr1=>pixeltestaddr, we2=>we2_s, data_in2=>data_in2_s, data_out2=>data_out2_s, addr2=>addr2_s);

	-- VGA motor component connection
	U2 : VGA_MOTOR port map(clk=>clk, swap=>swap_vram, clear=>clear, VR_data=>data_out2_s, VR_addr=>addr2_s, we2=>we2_s, VR_data_out=>data_in2_s, vgaRed=>vgaRed, vgaGreen=>vgaGreen, vgaBlue=>vgaBlue, Hsync=>Hsync, Vsync=>Vsync);

end Behavioral;

