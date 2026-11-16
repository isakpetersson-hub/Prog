LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uprogALU_tb IS
END uprogALU_tb;

ARCHITECTURE behavior OF uprogALU_tb IS

    component uprogALU
        port(
            clk      : in  std_logic;
            btnC     : in  std_logic;
            FromBuss : in  unsigned(21 downto 0);
            styr_alu : in  unsigned(3 downto 0);
            AR_out   : out unsigned(21 downto 0);
            SR_out   : out unsigned(3 downto 0)
        );
    end component;

    signal clk      : std_logic := '0';
    signal btnC     : std_logic := '0';
    signal FromBuss : unsigned(21 downto 0) := (others => '0');
    signal styr_alu : unsigned(3 downto 0)  := (others => '0');
    signal AR_out   : unsigned(21 downto 0);
    signal SR_out   : unsigned(3 downto 0);

    signal tb_running : boolean := true;
    constant CLK_PERIOD : time := 10 ns;

BEGIN

    uut: uprogALU PORT MAP(
        clk      => clk,
        btnC     => btnC,
        FromBuss => FromBuss,
        styr_alu => styr_alu,
        AR_out   => AR_out,
        SR_out   => SR_out
    );

    clk_gen: process
    begin
        while tb_running loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    

    stimuli: process
    begin
        -- Reset
        btnC <= '1';
        wait for 5 * CLK_PERIOD;
        wait until rising_edge(clk);
        btnC <= '0';
        report "Reset released" severity note;
        wait for CLK_PERIOD;

        -- Test NOP (0000): AR should stay 0
        report "Testing NOP";
        styr_alu <= "0000";
        FromBuss <= to_unsigned(42, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(0, 22)
            report "FAIL: NOP" severity error;

        -- Test LOAD FROM BUSS (0111): AR <= FromBuss
        report "Testing LOAD";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(100, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        -- AR_out updates one cycle later (AR <= res_full is registered)
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(100, 22)
            report "FAIL: LOAD" severity error;


        -- Test ADD (0001): AR=100 + FromBuss=50 = 150
        report "Testing ADD";
        styr_alu <= "0001";
        FromBuss <= to_unsigned(50, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(150, 22)
            report "FAIL: ADD" severity error;
        styr_alu <= "0001";
        FromBuss <= to_unsigned(50, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(200, 22)
            report "FAIL: ADD" severity error;

        -- Test SUB (0010): AR=200 - FromBuss=100 = 100
        report "Testing SUB";
        styr_alu <= "0010";
        FromBuss <= to_unsigned(100, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(100, 22)
            report "FAIL: SUB" severity error;

        -- Test ZERO FLAG: AR=100 - FromBuss=100 = 0
        report "Testing ZERO FLAG";
        styr_alu <= "0010";
        FromBuss <= to_unsigned(100, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(0, 22)
            report "FAIL: SUB" severity error;
        assert SR_out = to_unsigned(1, 4)
            report "FAIL: ZERO FLAG" severity error;

        -- Test SIGN FLAG: AR=0 - FromBuss=100 = -100
        report "Testing SIGN and CARRY FLAG";
        styr_alu <= "0010";
        FromBuss <= to_unsigned(100, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = unsigned(to_signed(-100, 22))
            report "FAIL: SUB" severity error;
        assert SR_out = to_unsigned(10, 4)
            report "FAIL: SIGN or CARRY FLAG" severity error;

        -- Test AND (0011): AR=100 (1100100) AND FromBuss=120 (1111000) = 96 (1100000)
        report "Testing AND";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(100, 22);   -- reload AR=100
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        styr_alu <= "0011";
        FromBuss <= to_unsigned(120, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(96, 22)
            report "FAIL: AND" severity error;

        -- Test OR (0100): AR=96 OR FromBuss=27 = 123
        report "Testing OR";
        styr_alu <= "0100";
        FromBuss <= to_unsigned(27, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(123, 22)
            report "FAIL: OR" severity error;

        -- Test XOR (0101): AR=123 XOR FromBuss=123 = 0
        report "Testing XOR";
        styr_alu <= "0101";
        FromBuss <= to_unsigned(123, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(0, 22)
            report "FAIL: XOR" severity error;

        -- Test ZERO (1000): AR should be 0
        report "Testing ZERO";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(999, 22);   -- load something nonzero
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        styr_alu <= "1000";
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(0, 22)
            report "FAIL: ZERO" severity error;

        -- Test LEFT SHIFT (1001): load AR=1 then shift, expect 2
        report "Testing LEFT SHIFT";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(1, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        styr_alu <= "1001";
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(2, 22)
            report "FAIL: LEFT SHIFT" severity error;

        -- Test LOGIC RIGHT SHIFT (1010): AR=2 >> 1 = 1
        report "Testing LOGIC RIGHT SHIFT";
        styr_alu <= "1010";
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(1, 22)
            report "FAIL: LOGIC RIGHT SHIFT" severity error;
        --
        ---- Test LEFT SHIFT OVERFLOW (1001): load AR=2097152 (bit 20 set), shift left -> sign flips
        --report "Testing LEFT SHIFT OVERFLOW";
        --styr_alu <= "0111";
        --FromBuss <= to_unsigned(2097152, 22);   -- = 01 0000 0000 0000 0000 0000 (bit 20 set)
        --wait until rising_edge(clk);
        --wait for 1 ns;
        --wait until rising_edge(clk);
        --wait for 1 ns;
        --styr_alu <= "1001";
        --wait until rising_edge(clk);
        --wait for 1 ns;
        --wait until rising_edge(clk);
        --wait for 1 ns;
        ---- result = 10 0000 0000 0000 0000 0000 (bit 21 set, sign flipped)
        ---- carry = 0 (bit 22 of res_full = 0)
        ---- overflow = 1 (AR(21)=0 xor AR(20)=1 = 1)
        --assert SR_out(2) = '1'
        --    report "FAIL: LEFT SHIFT OVERFLOW flag not set" severity error;
        --assert SR_out(1) = '1'
        --    report "FAIL: LEFT SHIFT OVERFLOW sign not set" severity error;

        -- Test COS (1100): AR=0 -> cos(0°) = 511
        report "Testing COS";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(0, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        styr_alu <= "1100";
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(511, 22)
            report "FAIL: COS(0)" severity error;

       -- Test COS (1100): AR=180 -> cos(180°) = -511 (as unsigned wraps)
        report "Testing COS 180";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(180, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        styr_alu <= "1100";
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(4193793, 22)
            report "FAIL: COS(180)" severity error;
        
        -- Test SIN (1101): AR=90 -> sin(90°) = 511
        report "Testing SIN 90";
        styr_alu <= "0111";
        FromBuss <= to_unsigned(90, 22);
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        styr_alu <= "1101";
        wait until rising_edge(clk);
        wait for 1 ns;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert AR_out = to_unsigned(511, 22)
            report "FAIL: SIN(90)" severity error;

       -- report "All tests done!";
       -- tb_running <= false;
       -- wait;



    end process;

END behavior;
    --BUGs that need to be fixed maybe
        --SR always sets the zero flag on the first instruction as AR start on 0000


    --NOP, good
    --LOAD, good
    --ADD, good
    --SUB, good
    --AND, good
    --OR, good
    --XOR, good
    --ZERO, good
    --LS, good
    --LRS, good
    --ZERO FLAG, good
    --SIGN FLAG, good
    --CARRY FLAG, good

