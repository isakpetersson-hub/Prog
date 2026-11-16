library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity line_motor_tb is
end line_motor_tb;

architecture Behavioral of line_motor_tb is

    component line_motor
        port (
            clk         : in  std_logic;
            btnC        : in  std_logic;
            x0,x1,y0,y1 : in  signed(20 downto 0);
            x_p, y_p    : out signed(20 downto 0);
            start       : in  std_logic;
            done, plot  : out std_logic);
    end component;

    signal clk   : std_logic := '0';
    signal btnC  : std_logic := '0';
    signal x0_s, x1_s, y0_s, y1_s : signed(20 downto 0) := (others => '0');
    signal xp_s, yp_s              : signed(20 downto 0);
    signal start_s, done_s, plot_s : std_logic := '0';

    constant clk_period : time := 10 ns;

    -- define 16 test lines as (x0, y0, x1, y1)
    type coord_t is array (0 to 3) of integer;
    type lines_t is array (0 to 15) of coord_t;
    constant test_lines : lines_t := (
        (  0,   0, 319, 239),   -- diagonal
        (  0,   0, 319,   0),   -- horizontal
        (  0,   0,   0, 239),   -- vertical
        (319,   0,   0, 239),   -- diagonal other way
        (160,   0, 160, 239),   -- vertical center
        (  0, 120, 319, 120),   -- horizontal center
        ( 10,  10, 100,  50),   -- short diagonal
        (200, 200, 250, 100),   -- going up
        (  0, 239, 319,   0),   -- bottom left to top right
        ( 50,  50, 50,  200),   -- short vertical
        (100, 100, 200, 100),   -- short horizontal
        (  0,   0,   0,   0),   -- single point
        (150,  10, 300, 230),   -- steep
        ( 10, 150, 230, 300),   -- shallow  
        (319, 239,   0,   0),   -- reverse diagonal
        (100,   0, 200, 239)    -- near vertical
    );

begin

    uut : line_motor port map (
        clk  => clk,
        btnC => btnC,
        x0   => x0_s,
        x1   => x1_s,
        y0   => y0_s,
        y1   => y1_s,
        x_p  => xp_s,
        y_p  => yp_s,
        start => start_s,
        done  => done_s,
        plot  => plot_s);

    clk_process : process
    begin
        clk <= '0'; wait for clk_period / 2;
        clk <= '1'; wait for clk_period / 2;
    end process;

    stim : process
    begin
        -- reset
        btnC <= '1';
        wait for 50 ns;
        btnC <= '0';
        wait for 50 ns;

        -- loop through all 16 lines
        for i in 0 to 15 loop
            -- load coordinates
            x0_s <= to_signed(test_lines(i)(0), 21);
            y0_s <= to_signed(test_lines(i)(1), 21);
            x1_s <= to_signed(test_lines(i)(2), 21);
            y1_s <= to_signed(test_lines(i)(3), 21);

            wait for 20 ns;

            -- pulse start
            start_s <= '1';
            wait for 10 ns;
            start_s <= '0';

            -- wait for done
            wait until done_s = '1';
            wait for 20 ns;  -- small gap between lines
        end loop;

        wait;
    end process;

end Behavioral;