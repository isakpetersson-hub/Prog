LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY uprogCPU_tb IS
END uprogCPU_tb;

ARCHITECTURE func OF uprogCPU_tb IS

  --Component Declaration for the Unit Under Test (UUT)
  COMPONENT uprogCPU
  PORT(
    clk_in1 : in std_logic;
    btnC : in std_logic; -- reset, active high
    RsRx : in std_logic);

  END COMPONENT;

  --Inputs
  signal clk_in1 : std_logic:= '0';
  signal rst : std_logic:= '0';
  signal RsRx : std_logic:= '0';

  --Clock period definitions
  constant clk_period : time:= 10 ns; -- 100 MHz

BEGIN
  -- Instantiate the Unit Under Test (UUT)
  uut: uprogCPU PORT MAP (
    clk_in1 => clk_in1,
    btnC => rst,
    RsRx => RsRx
  );
		
  -- Clock process definitions
  clk_process :process
  begin
    clk_in1 <= '0';
    wait for clk_period/2;
    clk_in1 <= '1';
    wait for clk_period/2;
  end process;

	rst <= '1', '0' after 17 ns;
END;

