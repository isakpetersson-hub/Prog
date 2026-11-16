library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity uprogKD_tb is
end uprogKD_tb;
 
architecture behavioral of uprogKD_tb is
 
    component uprogKD
        Port ( clk      : in  std_logic;
               btnC     : in  std_logic;
               PS2Clk   : in  std_logic;
               PS2Data  : in  std_logic;
               data_out : out unsigned(21 downto 0));
    end component;
 
    signal clk      : std_logic := '0';
    signal btnC     : std_logic := '0';
    signal PS2Clk   : std_logic := '1';   -- idle high
    signal PS2Data  : std_logic := '1';   -- idle high
    signal data_out : unsigned(21 downto 0);
 
    constant CLK_PERIOD  : time := 10 ns;   -- 100 MHz
    -- PS/2 clock half-period: ~40 us (approx 12.5 kHz)
    constant PS2_HALF    : time := 40 us;
 
    -- Send one PS/2 byte (11 bits: start, d0..d7, parity, stop)
    procedure ps2_send(
        constant byte   : in std_logic_vector(7 downto 0);
        signal   sclk   : out std_logic;
        signal   sdata  : out std_logic
    ) is
        variable parity : std_logic := '1';  -- odd parity
    begin
        -- Start bit (0)
        sdata <= '0';
        wait for PS2_HALF;
        sclk  <= '0';
        wait for PS2_HALF;
        sclk  <= '1';
 
        -- Data bits LSB first
        for i in 0 to 7 loop
            sdata <= byte(i);
            parity := parity xor byte(i);
            wait for PS2_HALF;
            sclk <= '0';
            wait for PS2_HALF;
            sclk <= '1';
        end loop;
 
        -- Parity bit
        sdata <= parity;
        wait for PS2_HALF;
        sclk  <= '0';
        wait for PS2_HALF;
        sclk  <= '1';
 
        -- Stop bit (1)
        sdata <= '1';
        wait for PS2_HALF;
        sclk  <= '0';
        wait for PS2_HALF;
        sclk  <= '1';
 
        wait for PS2_HALF;  -- inter-byte gap
    end procedure;
 
begin
 
    DUT: uprogKD
        port map (
            clk      => clk,
            btnC     => btnC,
            PS2Clk   => PS2Clk,
            PS2Data  => PS2Data,
            data_out => data_out
        );
 
    -- Clock
    clk_process: process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;
 
    -- Stimulus
    stim: process
    begin
        -- Reset
        btnC <= '1';
        wait for 200 ns;
        btnC <= '0';
        wait for 200 ns;
 
        -- Press W (scan code 0x1D)
        ps2_send(x"1D", PS2Clk, PS2Data);
        wait for 100 us;
 
        -- Release W: send F0 then 1D
        ps2_send(x"F0", PS2Clk, PS2Data);
        wait for 100 us;
        ps2_send(x"1D", PS2Clk, PS2Data);
        wait for 100 us;
 
        -- Press A (scan code 0x1C)
        ps2_send(x"1C", PS2Clk, PS2Data);
        wait for 100 us;
 
        wait;
    end process;
 
end behavioral;
