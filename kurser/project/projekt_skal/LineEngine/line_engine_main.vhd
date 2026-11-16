-- +----------------------+
-- | LineEngine main file |
-- | G37 Harald Thorsson  |
-- +----------------------+

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                                        -- and various arithmetic operations

-- entity
entity line_engine_main is
	port (
		clk         : in std_logic;                         -- system clock
		btnC        : in std_logic;                         -- center button
        x0,x1,y0,y1 : in signed(21 downto 0);
        col         : in std_logic_vector(21 downto 0);

        busy        : out std_logic;
        new_frame   : out std_logic;
        Hsync       : out std_logic;                        -- horizontal sync
        Vsync       : out std_logic;                        -- vertical sync
        vgaRed      : out std_logic_vector(3 downto 0);     -- VGA red
        vgaGreen    : out std_logic_vector(3 downto 0);     -- VGA green
        vgaBlue     : out std_logic_vector(3 downto 0));    -- VGA blue

end line_engine_main;


-- architecture
architecture Behavioral of line_engine_main is    
    
    component vga_main
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
    end component;
   


	-- Algorithm that draws the lines
	component line_motor
		port (
            clk      	: in std_logic;
            btnC    	: in std_logic;
            x0,x1,y0,y1 : in signed(21 downto 0);
            x_p,y_p		: out signed(21 downto 0);
            start 		: in std_logic;
		    done, plot	: out std_logic);
	end component;
	
    signal clear        : std_logic;
    signal addr_s       : unsigned(16 downto 0);
    signal xp_s, yp_s   : signed(21 downto 0);
    signal pixel_valid  : std_logic;
    signal swap_s       : std_logic;
    signal col_data_s   : std_logic_vector(2 downto 0);
    signal busy_s       : std_logic;
    signal new_frame_s  : std_logic;
    signal start_s      : std_logic := '0';
    signal start_s2      : std_logic := '0';

    signal done_s   : std_logic := '0';


    signal pix_s       : signed(21 downto 0);

    signal started : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if btnC = '1' then
                new_frame <= '0';
            end if;

            start_s <= start_s2;

            if busy_s = '1' then
                new_frame <= '0';
            elsif swap_s = '1' then 
                new_frame <= '1';
            end if;

            if busy_s = '0' then
                col_data_s  <= col(2 downto 0);	
            end if;
            --new_frame <= swap_s;
            --if btnC = '1' then
            --    pix_s <= (others => '0');
            --end if;
            --
            --if swap_s = '1' then
            --    pix_s <= pix_s + 1;
            --end if;
--
            --if pix_s = 240 then
            --    pix_s <= (others => '0');
            --end if;
        end if;
    end process;

	-- Pass through color
	--col_data_s  <= col(2 downto 0);		
    -- Start it when it is not
    -- This is bad becuase draw line from (0,0) good
    --start_s2 <= '1' when (
    --    x0 /= 0 and not is_x(std_logic_vector(x0)) and
    --    x1 /= 0 and not is_x(std_logic_vector(x1)) and
    --    y0 /= 0 and not is_x(std_logic_vector(y0)) and
    --    y1 /= 0 and not is_x(std_logic_vector(y1)) and
    --    col /= std_logic_vector(to_unsigned(0, col'length))
    --    and busy_s = '0'
    --) else '0';

    -- starts the Line Engine when color is input:ed
    start_s2 <= '1' when (
        col /= std_logic_vector(to_unsigned(0, col'length))
        and busy_s = '0'
    ) else '0';

    busy <= busy_s;
    --new_frame <= swap_s;

    U0 : line_motor port map (
        clk     => clk, 
        btnC    => btnC, 
        x0      => x0, 
        x1      => x1, 
        y0      => y0, 
        y1      => y1,
        x_p     => xp_s, 
        y_p     => yp_s, 
        start   => start_s,
        done    => done_s, 
        plot    => busy_s);

    -- TESTING VERSION
    --U0 : line_motor port map (
    --    clk     => clk, 
    --    btnC    => btnC, 
    --    x0      => to_signed(150, 21), 
    --    x1      => pix_s, 
    --    y0      => to_signed(100, 21), 
    --    y1      => pix_s,
    --    x_p     => xp_s, 
    --    y_p     => yp_s, 
    --    start   => swap_s,
    --    done    => done_s, 
    --    plot    => busy_s);
    
    -- check if coordinates are on screen
    pixel_valid <= '1' when (xp_s >= 0 and xp_s < 320 and yp_s >= 0 and yp_s < 240) else '0';    
    -- Calculate addr (not verified)
    addr_s <= to_unsigned(to_integer(yp_s) * 320 + to_integer(xp_s), 17) when (pixel_valid = '1' and busy_s = '1') else (others => '0');
    
    U1 : vga_main port map (clk=>clk, btnC=>btnC, col_data=>col_data_s, pix_addr=>addr_s, we=>busy_s, swap=>swap_s, vgaRed=>vgaRed, vgaGreen=>vgaGreen, vgaBlue=>vgaBlue, Hsync=>Hsync, Vsync=>Vsync);


end Behavioral;
