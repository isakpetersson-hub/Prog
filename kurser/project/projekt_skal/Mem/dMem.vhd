library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- dMem interface
entity dMem is
  port(
    clk       : in std_logic;
    rst       : in std_logic;
    dAddr     : in unsigned(9 downto 0);
    dData_in  : in unsigned(21 downto 0);
    dData_out : out unsigned(21 downto 0);
    we        : in std_logic);
end dMem;

architecture Behavioral of dMem is

-- data Memory
type d_mem_t is array (0 to 1023) of unsigned(23 downto 0);
constant d_mem_c : d_mem_t :=
  (x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   others => x"000000");

  signal d_mem : d_mem_t := d_mem_c;


begin

  dData_out <= d_mem(to_integer(dAddr))(21 downto 0);
  
  process(clk) begin
    if rising_edge(clk) then
        if we = '1' then
            d_mem(to_integer(dAddr))(21 downto 0) <= dData_in;
        end if;
    end if;
  end process;
  
end Behavioral;
