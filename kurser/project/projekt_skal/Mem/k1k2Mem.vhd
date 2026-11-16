library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity k1k2Mem is
    port (
        clk         : in std_logic;
        instruction : in std_logic_vector(21 downto 0); -- from IR                  
        k1_out      : out std_logic_vector(9 downto 0);
        k2_out      : out std_logic_vector(9 downto 0));
end k1k2Mem;

architecture behavioral of k1k2Mem is
-- K1: indexed by OP code (bits 21 downto 17, 5 bits → 32 entries)
    type rom_k1_t is array (0 to 31) of std_logic_vector(11 downto 0);
    constant k1 : rom_k1_t := (
        x"000", -- 0  00000 NOP
        x"014", -- 1  00001 LOAD PM
        x"015", -- 2  00010 LOAD DM
        x"016", -- 3  00011 STORE DM
        x"017", -- 4  00100 ADD 
        x"01A", -- 5  00101 SUB
        x"01D", -- 6  00110 AND
        x"020", -- 7  00111 OR
        x"023", -- 8  01000 XOR
        x"026", -- 9  01001 NOT
        x"029", -- A  01010 LSL
        x"02F", -- B  01011 LSR
        x"035", -- C  01100 ASR
        x"03B", -- D  01101 BRA  
        x"03E", -- E  01110 BNE
        x"041", -- F  01111 MULT
        x"044", -- 10 10000 COS  
        x"047", -- 11 10001 SIN 
        x"04A", -- 12 10010 HALT  
        x"04B", -- 13 10011 CMP  
        x"04D", -- 14 10100 ADD dm
        x"050", -- 15 10101 SUB dm
        x"053", -- 16 10110 AND dm
        x"056", -- 17 10111 OR  dm
        x"059", -- 18 11000 XOR dm
        x"05C", -- 19 11001 MULTdm
        x"000", -- 1A 11010 
        x"000", -- 1B 11011 
        x"000", -- 1C 11100 
        x"000", -- 1D 11101 
        x"000", -- 1E 11110 
        x"000"  -- 1F 11111 
    );

    -- K2: indexed by M (addressing mode), bits 15 downto 13, 3 bits → 8 entries
    type rom_k2_t is array (0 to 7) of std_logic_vector(11 downto 0);
    constant k2 : rom_k2_t := (
        x"003", -- 000 direct
        x"004", -- 001 immediate
        x"005", -- 010 indirect PM
        x"007", -- 011 indirect DM
        x"009", -- 100 indexed
        x"000", -- 101 (reserved)
        x"000", -- 110 (reserved)
        x"000"  -- 111 (reserved)
    );

    -- Extract fields from instruction
    -- Adjust these ranges to match your actual IR bit layout
    alias op_bits : std_logic_vector(4 downto 0) is instruction(21 downto 17);
    alias m_bits  : std_logic_vector(2 downto 0) is instruction(12 downto 10);

begin
  
  k1_out <= k1(to_integer(unsigned(op_bits)))(9 downto 0);
  k2_out <= k2(to_integer(unsigned(m_bits)))(9 downto 0);

end behavioral;
