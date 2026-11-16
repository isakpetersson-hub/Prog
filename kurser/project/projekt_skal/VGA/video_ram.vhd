-- +---------------------+
-- | Video memory        |
-- | G37 Harald Thorsson |
-- +---------------------+

-- ##### Skeleton from ##### 
-- PICT MEM
-- Anders Nilsson
-- 16-feb-2016
-- Version 1.1
-- Version 2.0: 2023-09-29. Anders Nilsson. Separate processes for ports in VideoRAM (block RAM).
-- * Separate processes is necessary when buiding dual port block RAMs (Vivado design user guide)
-- * https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Simple-Dual-Port-Block-RAM-with-Single-Clock-VHDL
-- * The design guide also states the use of shared variables when accessing the same
-- * "signal" from several processes, such as the case with dual port block RAMs.
-- * Shared variables should further be protected:
-- * https://fpgatutorial.com/vhdl-shared-variable-protected-type/#protected-type-example
-- * https://www.linkedin.com/pulse/vhdl-shared-variables-protected-types-memory-modeling-jim-lewis

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity VIDEO_RAM is
	port (
		clk       : in std_logic;
    swap      : in std_logic; -- Pulse with swap VRAM 
		-- port 1 - Line Engine side (fill buffer)
		we1       : in std_logic;
		data_in1  : in std_logic_vector(2 downto 0); -- 3 bit color codes
		addr1     : in unsigned(16 downto 0); -- 2^17 > 76800
		-- port 2 - VGA motor side (draw and clear buffer)
		we2       : in std_logic; -- Acts as a clr
		data_in2  : in std_logic_vector(2 downto 0); -- Currently unused
		data_out2 : out std_logic_vector(2 downto 0); -- Draw to screen
		addr2     : in unsigned(16 downto 0)); -- 2^17 > 76800
end VIDEO_RAM;


-- architecture
architecture Behavioral of VIDEO_RAM is
	-- video RAM type
	--type ram_t is array (0 to 2047) of std_logic_vector(7 downto 0);
  
  -- (640/2) * (480/2) with 3 bit color code = 76800 bits per frame
  type ram_t is array (0 to 76799) of std_logic_vector(2 downto 0);
	-- initiate video RAM to one cursor ("1F") followed by spaces ("00")
	--signal VideoRAM : ram_t := (0 => x"1F", others => (others => '0'));
  signal VRAM_A : ram_t := (others => "000");
  signal VRAM_B : ram_t := (others => "000");

  signal active_vram : std_logic := '0'; -- 0: VGA motor reads A, LineEngine Writes to B
                                         -- 1: VGA motor reads B, LineEngine Writes to A 

  signal addr_a, addr_b         : unsigned(16 downto 0) := (others => '0');
  signal we_a, we_b             : std_logic := '0';
  signal data_in_a, data_in_b   : std_logic_vector(2 downto 0) := (others => '0');
  signal data_out_a, data_out_b : std_logic_vector(2 downto 0) := (others => '0');

begin
  process(clk)
  begin
    if rising_edge(clk) then
      if swap = '1' then
        active_vram <= not active_vram;
      end if;
    end if;
  end process;

  -- Muxxing addr, we and data
  addr_a      <= addr1    when active_vram = '0' else addr2;
  data_in_a   <= data_in1 when active_vram = '0' else data_in2;
  we_a        <= we1      when active_vram = '0' else we2;
  
  addr_b      <= addr2    when active_vram = '0' else addr1;
  data_in_b   <= data_in2 when active_vram = '0' else data_in1;
  we_b        <= we2      when active_vram = '0' else we1;


  -- VRAM_A 
  process(clk)
  begin
    if rising_edge(clk) then
      data_out_a <= VRAM_A(to_integer(addr_a));
      if we_a = '1' then
        VRAM_A(to_integer(addr_a)) <= data_in_a;
      end if;
    end if;
  end process;

  -- VRAM_B
  process(clk)
  begin
    if rising_edge(clk) then
      data_out_b <= VRAM_B(to_integer(addr_b));
      if we_b = '1' then
        VRAM_B(to_integer(addr_b)) <= data_in_b;
      end if;
    end if;
  end process;

  --signal active_vram_r : std_logic := '0';  -- registered version for output
--
  --process(clk)
  --begin
  --    if rising_edge(clk) then
  --        active_vram_r <= active_vram;  -- delay by one cycle to match RAM output
  --    end if;
  --end process;
--
  ---- use delayed version for output mux to stay in sync with RAM read latency
  --data_out2 <= data_out_b when active_vram_r = '0' else data_out_a;


  data_out2 <= data_out_b when active_vram = '0' else data_out_a;


-- OLD CODE apparently vivado no like multiple RAM in one process 🤨🤨🤨☠️☠️
--  -- port 1 line engine side
--  process(clk)
--  begin
--    if rising_edge(clk) then
--      if we1 = '1' then
--        if active_vram = '0' then
--          VRAM_B(to_integer(addr1)) <= data_in1;
--        else
--          VRAM_A(to_integer(addr1)) <= data_in1;
--        end if;
--      end if;
--    end if;
--  end process;
--	
--  -- port 2 vga motor side
--  process(clk)
--  begin
--    if rising_edge(clk) then
--      if active_vram = '0' then
--        data_out2 <= VRAM_A(to_integer(addr2));
--        if we2 = '1' then
--          VRAM_A(to_integer(addr2)) <= data_in2;
--        end if;
--      else
--        data_out2 <= VRAM_B(to_integer(addr2));
--        if we2 = '1' then
--          VRAM_B(to_integer(addr2)) <= data_in2;
--        end if;
--      end if;
--    end if;
--  end process;


end Behavioral;
