library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 115200 baudrate

entity bootLoader is
    Port ( clk      : in std_logic;     -- system clock
           btnC     : in std_logic;     -- reset button
           RsRx     : in std_logic;     -- UART RS2323 Rx --instruktioner från pm
           we		: out std_logic;
           done     : out std_logic;
           data_out : out unsigned(21 downto 0);     --Register holding the last key press ? but should we switch if that has been read how do we know that a key press is complete
           boot_pm_addr : out unsigned(9 downto 0));
        end bootLoader;

architecture behavioral of bootLoader is
    signal sreg : std_logic_vector(9 downto 0) := B"0_00000000_0";  -- 22 bit shift register
    signal rx1,rx2 : std_logic;     -- synchronizing flip-flops
    signal sp : std_logic;          -- shift pulse
    signal lp : std_logic;          -- load pulse

    signal s1 : std_logic;          -- state of transmission
    signal start, stop : std_logic; -- start/stop transmission
    signal counter : unsigned(13 downto 0);    -- transmission length counter
    signal nop_counter: unsigned(2 downto 0) := to_unsigned(7, 3);  --count back to back nops if we should cut of the pm
    signal istr_counter: unsigned(1 downto 0) := (others => '0');
    signal pm_addr_counter: unsigned(9 downto 0) := (others => '0');

    signal bitcount : unsigned(3 downto 0) := X"0";

    signal clear : std_logic;       -- synchronous clear

    signal istr0 : std_logic_vector(7 downto 0);
    signal istr1 : std_logic_vector(7 downto 0);
    

begin

    clear <= btnC;

    process(clk) begin
        if rising_edge(clk) then
          if clear = '1' then
            rx1 <= '1';
            rx2 <= '1';
          else
            rx1 <= RsRx;
            rx2 <= rx1;
          end if;
        end if;
      end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if clear = '1' then
                counter  <= (others => '0');
                s1       <= '0';
                sp       <= '0';
                lp       <= '0';
                stop     <= '0';
            else
                sp <= '0';
                lp <= '0';
                
                -- Vänta på startbit
                if s1 = '0' then
                    if rx2 = '0' then
                        s1      <= '1';
                        --counter <= to_unsigned(434, 14);
                        counter <= to_unsigned(217, 14);
                    end if;
                    
                else
                    if counter = 0 then
                        sp <= '1';
                        if bitcount = 9 then
                            s1       <= '0';
                            stop     <= '1';
                            bitcount <= (others => '0');
                        else
                            bitcount <= bitcount + 1;
                        end if;
                        --counter <= to_unsigned(848, 14);
                        counter <= to_unsigned(434, 14);
                    else
                        counter <= counter - 1;
                    end if;
                end if;
    
                if stop = '1' then
                    stop <= '0';
                    lp   <= '1';
                end if;
            end if;
        end if;
    end process;


    -- *****************************
    -- *   10 bit skiftregister    *
    -- *****************************
    process(clk) begin
        if rising_edge(clk) then
            if clear = '1' then
                sreg <= B"0_00000000_0";
            elsif sp = '1' then
                sreg <= rx2 & sreg(9 downto 1);
            end if;
        end if;
    end process;

    process(clk) 
    begin
        if rising_edge(clk) then  
            we <= '0';
            if clear = '1' then
                done <= '0';

                data_out <= (others => '0');  -- default
                nop_counter <= to_unsigned(7, 3);
                istr_counter <= to_unsigned(0, 2);
                pm_addr_counter <= to_unsigned(0, 10);
            end if;
            if lp = '1' then
                if istr_counter = 0 then
                    istr0 <= sreg(8 downto 1);
                    istr_counter <= istr_counter +1;
                elsif istr_counter = 1 then
                    istr1 <= sreg(8 downto 1);
                    istr_counter <= istr_counter +1;
                elsif istr_counter = 2 then
                    data_out <= unsigned(sreg(6 downto 1) & istr1 & istr0);
                    boot_pm_addr <= pm_addr_counter;
                    pm_addr_counter <= pm_addr_counter + 1;

                    if nop_counter /= 0 then
                        we <= '1';
                        if sreg(6 downto 1) = "000000" and istr1 = X"00" and istr0 = X"00" then
                            nop_counter <= nop_counter - 1;
                        end if;
                    else
                        we <= '0';
                        done <= '1';
                    end if;



                    istr_counter <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    --led(4 downto 2) <= std_logic_vector(nop_counter);

    --we needs solving to stop =)

end Behavioral;