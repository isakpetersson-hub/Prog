library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--CPU interface
entity uprogCPU is
  port(
	  	clk_in1 : in std_logic;
	  	--clk: in std_logic;
	  	btnC : in std_logic;     -- reset button (middle of the five), active high
	  	RsRx : in std_logic;
	  
		Hsync       : out std_logic;                        -- horizontal sync
        Vsync       : out std_logic;                        -- vertical sync
        vgaRed      : out std_logic_vector(3 downto 0);     -- VGA red
        vgaGreen    : out std_logic_vector(3 downto 0);     -- VGA green
        vgaBlue     : out std_logic_vector(3 downto 0);    -- VGA blue
		led 		: out std_logic_vector(15 downto 0));
end entity;

architecture func of uprogCPU is

	signal rst : std_logic;       -- synchronous clear
	signal clk_out1 : std_logic;   -- clock from clk_wiz
	signal clk : std_logic;         -- clock for original design


	component clk_wiz_0_clk_wiz is
		port (
		  clk_in1 : in std_logic;    -- 100 MHz
		  clk_out1 : out std_logic  -- 50 MHz
		);
	end component;

	-- micro Memory component
	component uMem
		port(
			clk		: in std_logic;
			uAddr	: in unsigned(9 downto 0);
			uData	: out unsigned(29 downto 0));
	end component;

	-- program Memory component
	component pMem
		port(
			clk 	: in std_logic;
			rst     : in std_logic;
			pAddr 	: in unsigned(9 downto 0); --maybe 9-0
			pData_in  : in unsigned(21 downto 0);
    		we        : in std_logic;
			pData 	: out unsigned(21 downto 0);
			boot_addr : in unsigned(9 downto 0));
			
	end component;

    component dMem
        port(
			clk 		: in std_logic;
			rst         : in std_logic;
			dAddr		: in unsigned(9 downto 0);
            dData_in	: in unsigned(21 downto 0);
            dData_out	: out unsigned(21 downto 0);
			we			: in std_logic); 		
    end component;

	-- Keyboard Decoder component
	component uprogKD
		port(
			clk      : in  std_logic;
			btnC     : in  std_logic;
			RsRx     : in  std_logic;
			data_out : out unsigned(21 downto 0)
		);
	end component;

	-- ALU component
	component uprogALU
		port(
			clk      : in  std_logic;
			btnC     : in  std_logic;

			--Bits må behöva ändras
			FromBuss : in  unsigned(21 downto 0); --fråga harald
			styr_alu     : in  unsigned(3 downto 0);
			AR_out       : out unsigned(21 downto 0);
			SR_out       : out unsigned(21 downto 0));
	end component;
 
    -- k1, k2 Mem component
    component k1k2Mem
        port(
			clk 		: in std_logic;
            instruction : in std_logic_vector(21 downto 0); -- from IR 
            k1_out      : out std_logic_vector(9 downto 0);
            k2_out      : out std_logic_vector(9 downto 0));          -- to uMem)
    end component;

	-- Line Engine
	component line_engine_main
		port (
			clk         : in std_logic;                         -- system clock
			btnC        : in std_logic;                         -- center button
			x0,x1,y0,y1 : in signed(21 downto 0);
			col         : in std_logic_vector(21 downto 0);
	
			busy        : out std_logic;
			new_frame	: out std_logic;
			Hsync       : out std_logic;                        -- horizontal sync
			Vsync       : out std_logic;                        -- vertical sync
			vgaRed      : out std_logic_vector(3 downto 0);     -- VGA red
			vgaGreen    : out std_logic_vector(3 downto 0);     -- VGA green
			vgaBlue     : out std_logic_vector(3 downto 0));    -- VGA blue
	end component;

	--bootLoader
	component bootLoader
		port(
			clk      : in  std_logic;
			btnC     : in  std_logic;
			RsRx     : in  std_logic;
			we		 : out std_logic;
			done     : out std_logic;
			data_out : out unsigned(21 downto 0);
			boot_pm_addr : out unsigned(9 downto 0)
		);
	end component;

	-- micro memory signals
	signal uM 	: unsigned(29 downto 0); -- micro Memory output
    alias ALU 	: unsigned(3 downto 0) is uM(29 downto 26);
	alias TB 	: unsigned(3 downto 0) is uM(25 downto 22);
	alias FB 	: unsigned(3 downto 0) is uM(21 downto 18);
	alias S 	: std_logic is uM(17); -- (GRx controll)   
	alias P		: std_logic is uM(16); -- (0:PC=PC, 1:PC++)
    alias uLC 	: unsigned(1 downto 0) is uM(15 downto 14);
    alias SEQ 	: unsigned(3 downto 0) is uM(13 downto 10);
	alias uAddr : unsigned(9 downto 0) is uM(9 downto 0);

	-- memory signals
	signal PM 	 		: unsigned(21 downto 0); -- Program Memory 
	signal pData_in_s 	: unsigned(21 downto 0); -- Program Memory 
	signal we_pm 		: std_logic; -- Write enable
	signal boot_done	: std_logic; 
	signal boot_addr_s	: unsigned (9 downto 0);
    signal DM_in		: unsigned(21 downto 0); -- Program Memory 
    signal DM_out		: unsigned(21 downto 0); -- Program Memory 
    signal DM_out_s		: unsigned(21 downto 0); -- Program Memory 
	signal we_dm 		: std_logic; -- Write enable

	signal x0_s			: signed(21 downto 0);
	signal y0_s			: signed(21 downto 0);
	signal x1_s			: signed(21 downto 0);
	signal y1_s			: signed(21 downto 0);
	signal col_s		: std_logic_vector(21 downto 0);
	signal busy_s		: std_logic;
	signal new_frame_s	: std_logic;
	signal new_frame_s2	: std_logic;
	signal frame_count	: unsigned(3 downto 0) := (others => '0');
	signal kdr_timeout 	: std_logic;
	--signal new_frame_latch : std_logic := '0';

	-- local registers
	signal uPC  : unsigned(9 downto 0); -- micro Program Counter, den matchar typ inte uAddr just nu så behövde göra de lika stora
	signal PC 	: unsigned(21 downto 0); -- Program Counter
	signal ASR  : unsigned(9 downto 0); -- Address Register
    

    -- Hela GR borde kanske flyttas till en komponent ig
	type reg_array is array(0 to 15) of unsigned(21 downto 0);
    signal GR : reg_array;
    
    signal IR : unsigned(21 downto 0); -- Instruction Register
    alias GRx : unsigned(3 downto 0) is IR (16 downto 13);
    alias M   : unsigned (2 downto 0) is IR (12 downto 10); -- OPA problem! Grx och M är inte lika stora längre... :(

    signal GR_select : unsigned(3 downto 0); -- har för tillfället förlängt M


	-- local combinatorials
	signal DATA_BUS : unsigned(21 downto 0); -- Data Bus

	-- Key Data Register
	signal KDR : unsigned(21 downto 0); 

	-- AR register
	signal AR : unsigned(21 downto 0);

    -- LC register
    signal LC : unsigned(21 downto 0); -- Borde vara samma storlek som bussen?

	-- ALU flags
	signal SR : unsigned(21 downto 0);
    -- Loop flag
    signal L : unsigned(0 downto 0);

    signal k1, k2 : std_logic_vector(9 downto 0);

	--boot

begin
	clknetwork : clk_wiz_0_clk_wiz
  	port map (clk_in1 => clk_in1, clk_out1 => clk_out1);
  
  	clk <= clk_out1;



	GR_select <= GRx when S = '0' else ("0" & M);

	process(clk)
	begin
		if rising_edge(clk) then
			rst <= btnC; -- syncronize the reset signal
		end if;
	end process;

	-- mPC : micro Program Counter
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				uPC <= (others => '0');
			elsif boot_done = '0' then --Freeze computer     (Commented now bc i need it to start in sim without bootloading)
				uPC <= (others => '0');
            else
                case SEQ is
                    when "0000" =>
                        uPC <= uPC + 1;
                    when "0001" =>
                        uPC <= unsigned(k1);
                    when "0010" =>
                        uPC <= unsigned(k2);
                    when "0011" =>
                        uPC <= (others => '0');
                    when "0100" =>
                        if SR(0) = '0' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "0101" =>
                        uPC <= uAddr;
                    when "1000" =>
                        if SR(0) = '1' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1001" =>
                        if SR(1) = '1' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1010" =>
                        if SR(3) = '1' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1011" =>
                        if SR(2) = '1' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1100" =>
                        if L = 1 then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1101" =>
                        if SR(3) = '0' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1110" =>
                        if SR(2) = '0' then
                            uPC <= uAddr;
                        else
                            uPC <= uPC + 1;
                        end if;
                    when "1111" =>
                        uPC <= uPC;
                    when others =>
                        uPC <= uPC;
                end case;
			end if;
		end if;
	end process;

	-- PC : Program Counter
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				PC <= (others => '0');
			elsif (FB = "0011") then
				PC <= DATA_BUS;
			elsif (P = '1') then
				PC <= PC + 1;
			end if;
		end if;
	end process;

	-- IR : Instruction Register
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				IR <= (others => '0');
			elsif (FB = "0001") then
				IR <= DATA_BUS;
			end if;
		end if;
	end process;

	-- ASR : Address Register
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				ASR <= (others => '0');
			elsif (FB = "0100") then
				ASR <= DATA_BUS(9 downto 0);
			end if;
		end if;
	end process;

	-- KDR : Keyboard Decoder Register
	--process(clk)
	--begin
	--	if rising_edge(clk) then
	--		if (rst = '1') then
	--			KDR <= (others => '0');
	--		--elsif (FB = "0101") then --Fel Kod måste fixas !!!!
	--		--	KDR <= DATA_BUS;
	--		end if;
	--	end if;
	--end process;

	-- AR : ALU Register
	--process(clk)
	--begin
	--	if rising_edge(clk) then
	--		--if (rst = '1') then
	--		--	AR <= (others => '0'); -- <-- This is a portmapped signal, cant be set in two places, reset in ALU instead. // Harald
	--		--elsif (FB = "0110") then --Fel Kod måste fixas !!!!
	--		--	AR <= DATA_BUS;
	--		end if;
	--	end if;
	--end process;

	-- SR : Serial Register
	--process(clk)
	--begin
	--	if rising_edge(clk) then
	--		if (rst = '1') then
	--			SR <= (others => '0');
	--		--elsif (FB = "0111") then
	--		--	SR <= DATA_BUS;
	--		end if;
	--	end if;
	--end process;

	-- DM : Data Memory
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				DM_in <= (others => '0');
			elsif (FB = "1001") then
				if ASR <= x"3E8" then -- reserved special adresses after 3E8 (reg 1000) 
					DM_in <= DATA_BUS;
					we_dm <= '1';
				else
					case ASR is
						when "1111101001" => x0_s <= signed(DATA_BUS); -- ASR 1001
						when "1111101010" => y0_s <= signed(DATA_BUS); -- ASR 1002
						when "1111101011" => x1_s <= signed(DATA_BUS); -- ASR 1003
						when "1111101100" => y1_s <= signed(DATA_BUS); -- ASR 1004
						when "1111101101" => col_s <= std_logic_vector(DATA_BUS); -- ASR 1005
						
						when others => null; -- no change
					end case;
				end if;
			elsif busy_s = '1' then
				x0_s <= (others => '0');
				y0_s <= (others => '0');
				x1_s <= (others => '0');
				y1_s <= (others => '0');
				col_s <= (others => '0');
			else
				we_dm <= '0';
				-- Set busy and new frame (DM addr) if it changes
			end if;
		end if;
	end process;

    -- LC
    process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                LC <= (others => '0');
            else
                case uLC is
                    when "00" => LC <= LC; --idk
                    when "01" => LC <= LC - 1;
                    when "10" => LC <= ("000000000000000000" & IR(3 downto 0));
                    when "11" => LC <= ("000000000000" & uAddr);
                    when others => LC <= LC;
                end case;
            end if;
        end if;
    end process;

    --GRx from BUSS
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                for i in 0 to 15 loop
					GR(i) <= (others => '0');
				end loop;
            else
                if FB = "1000" then
                    GR(to_integer(GR_select)) <= DATA_BUS;
                end if;
            end if;
        end if;
    end process;

	--process(clk)
	--begin
	--	if rising_edge(clk) then
	--		if rst = '1' then
	--			new_frame_s <= '1';
	--		elsif busy_s = '1' then
	--			new_frame_s <= '0';        -- capture the pulse
	--		--elsif TB = "1001" and ASR = "1111101111" then
	--		--	new_frame_latch <= '0';        -- clear when CPU reads DM(1007)
	--		end if;
	--	end if;
	--end process;

    L <= (others => '1') when LC = 0 else (others => '0');

	-- micro memory component connection
	U0 : uMem port map(clk=>clk, uAddr=>uPC, uData=>uM);

	-- program memory component connection
	U1 : pMem port map(clk=>clk, rst=>rst, pAddr=>ASR,pData_in => pData_in_s, we=>we_pm, pData=>PM, boot_addr=>boot_addr_s);

    U2 : dMem port map(clk=>clk, rst=>rst, dAddr=>ASR, dData_in=>DM_in, dData_out=>DM_out_s, we=>we_dm);

	process(clk) begin
		if rising_edge(clk) then		
			if (rst = '1') or frame_count = 10 then
				frame_count <= (others => '0');
			elsif KDR /= 0 then
				if new_frame_s = '1' and new_frame_s2 = '0' then
					frame_count <= frame_count + 1;
				end if;
			end if;

			new_frame_s2 <= new_frame_s;
		end if;
	end process;

	kdr_timeout <= '1' when frame_count = 10 or rst = '1' else '0';

	-- Keyboard Decoder connection
	U3 : uprogKD port map(	clk => clk, btnC => kdr_timeout, RsRx => RsRx, data_out => KDR); -- Olika storlekar :skullemoji:
	-- ALU connection
	U4 : uprogALU port map(	clk => clk, -- finns inga matchande signaler
							btnC => btnC,
							styr_alu => ALU, -- Fick en error när den pekade => styr_alu så provade att ändra den
							FromBuss => DATA_BUS,
							AR_out=>AR,
							SR_out => SR);

    
    U5: k1k2Mem port map (  clk=>clk, 
							instruction => std_logic_vector(IR),
                            k1_out => k1,
                            k2_out => k2);


	U6: line_engine_main port map (
		clk=>clk, btnC=>btnC, 
		x0=>x0_s,
		y0=>y0_s, 
		x1=>x1_s, 
		y1=>y1_s, 
		col=>col_s, 
		busy=>busy_s, 
		new_frame=>new_frame_s, 
		vgaRed=>vgaRed, vgaGreen=>vgaGreen, vgaBlue=>vgaBlue, Hsync=>Hsync, Vsync=>Vsync
		);

	U7 : bootLoader port map(	clk => clk, btnC => btnC, RsRx => RsRx, data_out => pData_in_s, we=>we_pm, done=>boot_done , boot_pm_addr => boot_addr_s);


	-- DM remap for special adresses 
	DM_out <= ("000000000000000000000" & busy_s) when ASR = "1111101110" else
		("000000000000000000000" & new_frame_s) when ASR = "1111101111" else
		KDR when ASR = "1111110010" else
		DM_out_s;
	
	-- data bus assignment
	DATA_BUS <= ("000000000000" & IR(9 downto 0)) when (TB = "0001") else
		PM when (TB = "0010") else
		PC when (TB = "0011") else
		("000000000000" & ASR) when (TB = "0100") else
		KDR when (TB = "0101") else
		AR when (TB = "0110") else
		SR when (TB = "0111") else
        GR(to_integer(GR_select)) when (TB = "1000") else
		DM_out when (TB = "1001") else
		(others => '0');

	led(0) <= boot_done;
	led(1) <= we_pm;
	led(2) <= new_frame_s;



end architecture;