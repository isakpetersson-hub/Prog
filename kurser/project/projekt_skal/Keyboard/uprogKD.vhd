library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uprogKD is
    Port ( clk  : in std_logic;     -- system clock
           btnC : in std_logic;     -- reset button
           RsRx : in std_logic;     -- UART RS2323 Rx
           data_out : out unsigned(21 downto 0));     --Register holding the last key press ? but should we switch if that has been read how do we know that a key press is complete
end uprogKD;

architecture behavioral of uprogKD is
    -- ============================================================
    -- UART-mottagning
    -- ============================================================
    signal sreg : std_logic_vector(9 downto 0) := B"0_00000000_0";  -- 10 bit shift register
    signal rx1,rx2 : std_logic;     -- synchronizing flip-flops
    signal sp : std_logic;          -- shift pulse
    signal lp : std_logic;          -- load pulse
    
    signal s1 : std_logic;          -- state of transmission
    signal start, stop : std_logic; -- start/stop transmission
    signal stop2 : std_logic;
    signal counter : unsigned(13 downto 0);    -- transmission length counter
    
    signal bitcount : unsigned(3 downto 0) := X"0";
    
    signal clear : std_logic;       -- synchronous clear
    
    signal data_out_s : std_logic_vector(7 downto 0);

    --signal reset_timer : std_logic_vector(24 downto 0);
    --constant TIMEOUT : std_logic_vector(24 downto 0) := "1000000000000000000000000";
    


begin
    clear <= btnC;

    -- ============================================================
    -- Två-stegs synkronisering av RsRx
    -- Skyddar mot metastabilitet eftersom UART-signalen är asynkron
    -- mot systemklockan.
    -- ============================================================
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

    -- ============================================================
    -- UART-tillståndsmaskin: 115200 baud vid 100 MHz
    --   100 000 000 / 115200 ≈ 868 cykler per bit
    --   När startbit detekteras laddar vi 434 (halv bittid) så att
    --   första samplingen hamnar mitt i startbiten. Därefter 868 för
    --   att hamna mitt i varje databit.
    -- ============================================================
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
                        --counter <= to_unsigned(868, 14);
                        counter <= to_unsigned(434, 14);
                    else
                        counter <= counter - 1;
                    end if;
                end if;
    
                if stop = '1' then
                    stop  <= '0';
                    stop2 <= '1';
                end if;
                if stop2 = '1' then
                    stop2 <= '0';
                    lp    <= '1';
                end if;
            end if;
        end if;
    end process;

    -- ============================================================
    -- 10-bitars skiftregister
    -- UART skickar LSB först. Vi skiftar in från MSB-änden, så efter
    -- 10 skift ligger:
    --   sreg(0)        = startbit
    --   sreg(8..1)     = databyten (MSB i sreg(8))
    --   sreg(9)        = stoppbit
    -- ============================================================
    process(clk) begin
        if rising_edge(clk) then
            if clear = '1' then
                sreg <= B"0_00000000_0";
            elsif sp = '1' then
                sreg <= rx2 & sreg(9 downto 1);
            end if;
        end if;
    end process;

    -- ============================================================
    -- Timer-process per tangent (icke-sticky logik)
    --
    -- Beteende per klockcykel:
    --   1) Räkna ner alla timers som inte redan är noll.
    --   2) Om en hel UART-ram precis tagits emot (lp = '1'), avkoda
    --      bytan och ladda om motsvarande timer till TIMEOUT_MAX.
    --      (Case-satsen körs efter loopen och "vinner" tilldelningen
    --      för den tangent som matchar.)
    --
    -- ============================================================
    process(clk) begin
        if rising_edge(clk) then   

            if clear = '1' then
                data_out <= (others => '0');
                --reset_timer <= (others => '0');


            elsif lp = '1' then
                --reset_timer <= (others => '0');
                --data_out <= (others => '0');  -- default
                case sreg(8 downto 1) is
                    when "01110111" => -- W  (0x77)
                        data_out <= to_unsigned(1,  22);  -- bit 0 (1)
                    when "01100001" => -- A  (0x61)
                        data_out <= to_unsigned(2,  22);  -- bit 1 (2)
                    when "01110011" => -- S  (0x73)
                        data_out <= to_unsigned(4,  22);  -- bit 2 (4)
                    when "01100100" => -- D  (0x64)
                        data_out <= to_unsigned(8,  22);  -- bit 3 (8)
                    when "01110001" => -- Q  (0x71)
                        data_out <= to_unsigned(16, 22);  -- bit 4 (16)
                    when "01100101" => -- E  (0x65)
                        data_out <= to_unsigned(32, 22);  -- bit 5 (32)
                    when others =>
                        null;  -- unrecognised key: leave register unchanged
                end case;

            --elsif reset_timer = TIMEOUT then  -- timer to wait 0.1 seconds and reset 
            --    data_out    <= (others => '0');
            --    reset_timer <= (others => '0');
            --else
            --    reset_timer <= reset_timer + "0000000000000000000000001";
            end if;

        end if;
    end process;

    --component som när den får lp = 1 tar det som står i sreg jämför den med sin lut för att hitta vilken bokstav det var av wasdqe och sedan utifrån det sätter 1
    --på rätt ställe i ett register som kan läsas av andra komponenter

end Behavioral;
