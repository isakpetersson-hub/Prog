
-- +---------------------+
-- | Line motor          |
-- | G37 Harald Thorsson |
-- +---------------------+

-- ###############################################################################
-- ##  Algorithm based on                                                       ##
-- ##  this: https://www.cs.columbia.edu/~sedwards/classes/2012/4840/lines.pdf  ##
-- ###############################################################################

-- Bresenham line algorithm (Wikipedia):
-- "Bresenham's line algorithm is a line drawing algorithm that determines the 
-- points of an n-dimensional raster that should be selected in order to form a 
-- close approximation to a straight line between two points. It is commonly used 
-- to draw line primitives in a bitmap image (e.g. on a computer screen), as it 
-- uses only integer addition, subtraction, and bit shifting, all of which are 
-- very cheap operations in historically common computer architectures."


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type

-- entity
entity line_motor is
	port (
		clk      	: in std_logic;
		btnC    	: in std_logic;
        x0,x1,y0,y1 : in signed(21 downto 0);
		x_p,y_p		: out signed(21 downto 0);
		start 		: in std_logic;
		done, plot	: out std_logic);
        --col      	: in std_logic_vector(2 downto 0);


end line_motor;


-- architecture
architecture Behavioral of line_motor is
	
	signal x1x0,y1y0,dx,dy 				 : signed(21 downto 0);
	signal down,right,e2_lt_dx,e2_gt_dy  : std_logic;
	signal in_loop,break 				 : std_logic;
	
	signal err,err1,err2,e2,err_next	 : signed(22 downto 0);
	signal x,y,x_next,y_next,xa,xb,ya,yb : signed(21 downto 0);
	type states is (IDLE_STATE, RUNNING_STATE, DONE_STATE);
	signal state : states;
	signal x0_r, x1_r, y0_r, y1_r : signed(21 downto 0);
begin


	process(clk)
	begin
		if rising_edge(clk) then
			if state = IDLE_STATE or start = '1' then
				x0_r <= x0;
				x1_r <= x1;
				y0_r <= y0;
				y1_r <= y1;
			end if;
		end if;
	end process;

	--in_loop <= '1';
	-- datapath for dx & dy
	x1x0 <= x1_r - x0_r;
	y1y0 <= y1_r - y0_r;
	right <= not x1x0(21);
	down <= not y1y0(21);
	dx <= x1x0 when right = '1' else -x1x0;
	dy <= -y1y0 when down = '1' else  y1y0;

	-- datapath for err
	err_next <= ("0" & dx) + ("0" & dy) when in_loop = '0' else err2;
	err2 <= err1 + dx when e2_lt_dx = '1' else err1;
	err1 <= err + dy when e2_gt_dy = '1' else err;
	e2 <= err(21 downto 0) & "0";
	e2_gt_dy <= '1' when e2 > dy else '0';
	e2_lt_dx <= '1' when e2 < dx else '0';

	-- datapath for x & y
	x_next <= x0_r when in_loop = '0' else xb;
	xb <= xa when e2_gt_dy = '1' else x;
	xa <= x + 1 when right = '1' else x - 1;
	y_next <= y0_r when in_loop = '0' else yb;
	yb <= ya when e2_lt_dx = '1' else y;
	ya <= y + 1 when down = '1' else y - 1;
	break <= '1' when x = x1_r and y = y1_r else '0';
	
	-- flipflop 
	process (clk)
	begin
		if rising_edge(clk) then
			err <= err_next;
			x <= x_next;
			y <= y_next;
	end if;
	end process;

	fsm : process (clk)
	begin
		if rising_edge(clk) then
			if btnC = '1' then
				state <= IDLE_STATE;
			else
				case state is
					when IDLE_STATE =>
						if start = '1' then state <= RUNNING_STATE; end if;
					when RUNNING_STATE =>
						if break = '1' then state <= DONE_STATE; end if;
					when DONE_STATE =>
						if start = '1' then state <= RUNNING_STATE;
						else state <= IDLE_STATE; end if;
				end case; 
			end if; 
		end if; 
	end process;
	
	in_loop <= '1' when state = RUNNING_STATE else '0';
	done <= '1' when state = DONE_STATE else '0';
	plot <= in_loop;

	-- Output
	x_p <= x;
	y_p <= y;
	

end behavioral;
