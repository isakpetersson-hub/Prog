-- +---------------------+
-- | VGA motor           |
-- | G37 Harald Thorsson |
-- +---------------------+

-- ##### Skeleton from ##### 
-- VGA MOTOR
-- Version 1.1: 2016-02-16, Anders Nilsson
-- Version 1.2: 2023-01-11, Petter Kallstrom. Changelog: Corrected a pipeline mistake.
-- Version 2.0: 2023-09-29. Anders Nilsson. 12-bit VGA.


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity vga_motor is
	port (
		clk      	: in std_logic;
		swap	 	: out std_logic;
		VR_data  	: in std_logic_vector(2 downto 0);
		VR_addr  	: out unsigned(16 downto 0);
		clear    	: in std_logic;

		we2 		: out std_logic;
		VR_data_out : out std_logic_vector(2 downto 0);

		vgaRed   	: out std_logic_vector(3 downto 0);
		vgaGreen 	: out std_logic_vector(3 downto 0);
		vgaBlue  	: out std_logic_vector(3 downto 0);
		Hsync    	: out std_logic;
		Vsync    	: out std_logic);
end vga_motor;


-- architecture
architecture Behavioral of vga_motor is
	
	signal Xpixel2 : unsigned(9 downto 0) := (others => '0'); -- Horizontal pixel counter, and its pipelined version
	signal Ypixel2 : unsigned(9 downto 0) := (others => '0'); -- Vertical pixel counter
    signal Xpixel1 : unsigned(9 downto 0) := (others => '0'); -- Horizontal pixel counter, and its pipelined version
	signal Ypixel1 : unsigned(9 downto 0) := (others => '0'); -- Vertical pixel counter
	signal ClkDiv  : unsigned(0 downto 0);          -- Clock divisor, to generate 25 MHz signal
	signal Clk25   : std_logic;                     -- One pulse width 25 MHz signal

	signal col_fill, row_fill : std_logic; -- keeps track of what part of an upscaled pixel we are currently writing, 
										   -- imortant so that we dont clear it before we have read it all the times we need
	
	signal color_addr  : unsigned(2 downto 0);       -- address for COLOR_ROM
	signal color_data : std_logic_vector(11 downto 0); -- data from COLOR_ROM.
	
	signal blank1, blank2, blank3, blank : std_logic; -- pipeline for Xpixel1 → VR_addr → [RAM delay] → VR_data → [ROM delay] → color_data → VGA out
	signal Hsync1, Hsync2, Hsync3 : std_logic;
	signal Vsync1, Vsync2, Vsync3 : std_logic;
	--signal swap : std_logic;
	
	-- Color convery rom:
	component color_rom is
		port (
			clk      : in std_logic;
			addr     : in unsigned(2 downto 0);
			data     : out std_logic_vector(11 downto 0));
	end component;
	
begin
	
	-- Clock divisor
	-- Divide system clock (100 MHz) by CR_data
	process(clk)
	begin
		if rising_edge(clk) then
			if clear='1' then
				ClkDiv <= (others => '0');
			else
				ClkDiv <= ClkDiv + 1;
			end if;
		end if;
	end process;
	
	-- 25 MHz clock (one system clock pulse width)
	--Clk25 <= '1' when (ClkDiv = 3) else '0';
	-- 25 MHz clock (one system clock pulse width)
	Clk25 <= '1' when (ClkDiv = 1) else '0';


	-- Horizontal pixel counter
    process(clk)
    begin
        if rising_edge(clk) then
            if clear = '1' then
                Xpixel1 <= (others => '0');
            end if;
            
            if Clk25 = '1' then
                Xpixel1 <= Xpixel1 + 1;
            end if;

            if Xpixel1 = 801 then
                Xpixel1 <= (others => '0');
            end if;
        end if;
    end process;

    -- Horizontal sync
    Hsync1 <= '0' when (Xpixel1 >= 656 and Xpixel1 <= 751) else '1';


    -- Vertical pixel counter
    process(clk)
    begin
        if rising_edge(clk) then
            if clear = '1' then
                Ypixel1 <= (others => '0');
            end if;
            
            if Xpixel1 = 800 and Clk25 = '1' then
                Ypixel1 <= Ypixel1 + 1;
            end if;
            
            if Ypixel1 = 500 then
                Ypixel1 <= (others => '0');
            end if;
        end if;
    end process;

    -- Vertical Sync
    Vsync1 <= '0' when (Ypixel1 >= 489 and Ypixel1 <= 492) else '1';

    -- Video blanking signal
    blank1 <= '1' when Ypixel1 > 479 or Xpixel1 > 639 else '0';



	-- Video ram address composite
	VR_addr <= resize(resize(unsigned(Ypixel1(8 downto 1)), 17) * 320 + 
			   resize(unsigned(Xpixel1(9 downto 1)), 17), 17) when (Ypixel1 < 480 and Xpixel1 < 640) else (others => '0');
--	VR_addr <= resize(resize(unsigned(Ypixel1(8 downto 1)), 17) * 320 + 
--			   resize(unsigned(Xpixel1(9 downto 1)), 17), 17) 
--			   when (Ypixel1 < 480 and Xpixel1 < 640) 
--			   else to_unsigned(76799, 17);  -- point to last addr, not 0

	-- reset VRAM during scanline, but only during last pixel in the upscaled block
	row_fill <= Ypixel1(0);
	col_fill <= Xpixel1(0);

	we2 <= '1' when (col_fill = '1' and row_fill = '1' and Xpixel1 < 640 and Ypixel1 < 480 and Clk25 = '1') else '0';
	VR_data_out <= "000";
	
	process(clk)
	begin
		if rising_edge(clk) then
			blank2 <= blank1;
			blank3 <= blank2;
			Hsync2 <= Hsync1;
			Hsync3 <= Hsync2;
			Vsync2 <= Vsync1;
			Vsync3 <= Vsync2;
			Xpixel2 <= Xpixel1;
			Ypixel2 <= Ypixel1;
		end if;
	end process;
	
	
	-- Character rom address:
	--color_addr <= unsigned(VR_data(4 downto 0)) & Ypixel2(4 downto 2) & Xpixel2(4 downto 2);
	
	-- color adress = full res / 2
	color_addr <= unsigned(VR_data);
	
	U0b : color_rom port map (clk=>clk, addr=>color_addr, data=>color_data); -- one clock cycle delay.

	swap <= '1' when (Xpixel1 = 801 and Ypixel1 = 500) else '0';

	process(clk)
	begin
		if rising_edge(clk) then
			Hsync <= Hsync3;
			Vsync <= Vsync3;
			blank <= blank3;
		end if;
	end process;
	
	
	-- VGA generation : 4 bit red, 4 bit green ,4 bit blue
	vgaRed(3)   <= Color_data(11) when blank = '0' else '0';
	vgaRed(2)   <= Color_data(10) when blank = '0' else '0';
	vgaRed(1)   <= Color_data(9) when blank = '0' else '0';
	vgaRed(0)   <= Color_data(8) when blank = '0' else '0';
	vgaGreen(3) <= Color_data(7) when blank = '0' else '0';
	vgaGreen(2) <= Color_data(6) when blank = '0' else '0';
	vgaGreen(1) <= Color_data(5) when blank = '0' else '0';
	vgaGreen(0) <= Color_data(4) when blank = '0' else '0';
	vgaBlue(3)  <= Color_data(3) when blank = '0' else '0';
	vgaBlue(2)  <= Color_data(2) when blank = '0' else '0';
	vgaBlue(1)  <= Color_data(1) when blank = '0' else '0';
	vgaBlue(0)  <= Color_data(0) when blank = '0' else '0';
	
end Behavioral;

