--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	if (WE = '1' and (to_integer(unsigned(Address))) >= 0 and (to_integer(unsigned(Address))) <= 127) then
		i_ram((to_integer(unsigned(Address)))) <= DataIn;
	end if;
    end if;

    if (OE = '1' and (to_integer(unsigned(Address))) >= 0 and (to_integer(unsigned(Address))) <= 127) then
	DataOut <= i_ram((to_integer(unsigned(Address))));
    else
	DataOut <= ( others => 'Z' );
    end if;

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;

	signal dataIn: std_logic_vector(31 downto 0);
	signal dataOut1: std_logic_vector(31 downto 0);
	signal dataOut2: std_logic_vector(31 downto 0);
	signal dataOut3: std_logic_vector(31 downto 0);
	signal dataOut4: std_logic_vector(31 downto 0);
	signal dataOut5: std_logic_vector(31 downto 0);
	signal dataOut6: std_logic_vector(31 downto 0);
	signal dataOut7: std_logic_vector(31 downto 0);
	signal dataOut8: std_logic_vector(31 downto 0);

	signal writeout: std_logic_vector(7 downto 0);
begin
    register1: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(0), '0', '0',
		dataOut1
		);

    register2: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(1), '0', '0',
		dataOut2
		);

    register3: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(2), '0', '0',
		dataOut3
		);

    register4: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(3), '0', '0',
		dataOut4
		);

    register5: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(4), '0', '0',
		dataOut5
		);

    register6: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(5), '0', '0',
		dataOut6
		);

    register7: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(6), '0', '0',
		dataOut7
		);

    register8: register32 PORT MAP (
		WriteData, '0', '0', '0',
		writeout(7), '0', '0',
		dataOut8
		);

	with ReadReg1 select
		ReadData1 <= dataOut1 when "01010",
			     dataOut2 when "01011",
			     dataOut3 when "01100",
			     dataOut4 when "01101",
			     dataOut5 when "01110",
			     dataOut6 when "01111",
			     dataOut7 when "10000",
			     dataOut8 when "10001",
			     (others => '0') when "00000",
			     (others => 'Z') when others;

	with ReadReg2 select
		ReadData2 <= dataOut1 when "01010",
			     dataOut2 when "01011",
			     dataOut3 when "01100",
			     dataOut4 when "01101",
			     dataOut5 when "01110",
			     dataOut6 when "01111",
			     dataOut7 when "10000",
			     dataOut8 when "10001",
			     (others => '0') when "00000",
			     (others => 'Z') when others;

	process (WriteCmd) is
	begin
		if (WriteCmd='1') then

			case WriteReg is
				when "01010" =>
					writeout <= "00000001";
				when "01011" =>
					writeout <= "00000010";
				when "01100" =>
					writeout <= "00000100";
				when "01101" =>
					writeout <= "00001000";
				when "01110" =>
					writeout <= "00010000";
				when "01111" =>
					writeout <= "00100000";
				when "10000" =>
					writeout <= "01000000";
				when "10001" =>
					writeout <= "10000000";
				when others =>
					writeout <= "00000000";
			end case;
		end if;
	end process;
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
