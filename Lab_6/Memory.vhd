LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

--RAM MODULE INTERFACE
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
  -- signal addInt: integer RANGE 0 to 127;
   SIGNAL highz: STD_LOGIC_VECTOR(31 DOWNTO 0) := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    IF falling_edge(Clock) THEN
	
	IF (WE = '1') THEN 
		IF (to_integer(unsigned(Address)) <= 127) THEN
			i_ram (to_integer(unsigned(Address))) <= DataIn;
		END IF;
	END IF;
    END IF;
    
    
   IF (OE='0' AND (to_integer(unsigned(Address)) <=127)) THEN
	DataOut <=  i_ram (to_integer(unsigned(Address)));
   ELSE
	Dataout <= highz;
   END IF;


  end process RamProc;

end staticRAM;	


---------------------------------------------------------------------
------- START OF REGISTER BANK ENTITY
---------------------------------------------------------------------
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

	signal enable: std_logic; 
	signal ZeroReg: std_logic_vector(31 downto 0); -- 
	signal ZeroOut: std_logic_vector(31 downto 0);
	signal Zero_write: std_logic;
	signal a0_write, a1_write, a2_write, a3_write, a4_write, a5_write, a6_write, a7_write: std_logic;
	signal a0_out, a1_out, a2_out, a3_out, a4_out, a5_out, a6_out, a7_out: std_logic_vector(31 downto 0);
	signal Fail_read: std_logic_vector(31 downto 0);
begin
	Zero_write <= '1';
	enable <= '0'; 
	ZeroReg <= X"00000000"; 
	Fail_read(31 downto 0) <= (others => 'Z');

	a0_write <= '1' when ((WriteCmd = '1') and (WriteReg = "01010")) else '0';
	a1_write <= '1' when ((WriteCmd = '1') and (WriteReg = "01011")) else '0';
	a2_write <= '1' when ((WriteCmd = '1') and (WriteReg = "01100")) else '0';
	a3_write <= '1' when ((WriteCmd = '1') and (WriteReg = "01101")) else '0';
	a4_write <= '1' when ((WriteCmd = '1') and (WriteReg = "01110")) else '0';
	a5_write <= '1' when ((WriteCmd = '1') and (WriteReg = "01111")) else '0';
	a6_write <= '1' when ((WriteCmd = '1') and (WriteReg = "10000")) else '0';
	a7_write <= '1' when ((WriteCmd = '1') and (WriteReg = "10001")) else '0';
	

	Zero: register32 port map(ZeroReg, enable, enable, enable, Zero_write, Zero_write, Zero_write, ZeroOut);
	a0: register32 port map(WriteData, enable, enable, enable, a0_write, a0_write, a0_write, a0_out);
	a1: register32 port map(WriteData, enable, enable, enable, a1_write, a1_write, a1_write, a1_out);
	a2: register32 port map(WriteData, enable, enable, enable, a2_write, a2_write, a2_write, a2_out);
	a3: register32 port map(WriteData, enable, enable, enable, a3_write, a3_write, a3_write, a3_out);
	a4: register32 port map(WriteData, enable, enable, enable, a4_write, a4_write, a4_write, a4_out);
	a5: register32 port map(WriteData, enable, enable, enable, a5_write, a5_write, a5_write, a5_out);
	a6: register32 port map(WriteData, enable, enable, enable, a6_write, a6_write, a6_write, a6_out);
	a7: register32 port map(WriteData, enable, enable, enable, a7_write, a7_write, a7_write, a7_out);

	with ReadReg1 select
		ReadData1 <= ZeroOut when "00000",
			     	a0_out when "01010",  
				a1_out when "01011",  
				a2_out when "01100",  
				a3_out when "01101",  
				a4_out when "01110", 
				a5_out when "01111", 
				a6_out when "10000", 
				a7_out when "10001",  
				Fail_read when others;
	with ReadReg2 select
		ReadData2 <=   ZeroOut when "00000", 
			     	a0_out when "01010",  
				a1_out when "01011",  
				a2_out when "01100",  
				a3_out when "01101",  
				a4_out when "01110",  
				a5_out when "01111",  
				a6_out when "10000",  
				a7_out when "10001",  
				Fail_read when others;

end remember;


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;

	bitout <= q when enout = '0' else 'Z';

end architecture memlike;


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;


architecture memmy of register8 is

	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);

	end component;
begin


	m0: bitstorage port map(datain(0),enout,writein, dataout(0));
	m1: bitstorage port map(datain(1),enout,writein, dataout(1));
	m2: bitstorage port map(datain(2),enout,writein, dataout(2));
	m3: bitstorage port map(datain(3),enout,writein, dataout(3));
	m4: bitstorage port map(datain(4),enout,writein, dataout(4));
	m5: bitstorage port map(datain(5),enout,writein, dataout(5));
	m6: bitstorage port map(datain(6),enout,writein, dataout(6));
	m7: bitstorage port map(datain(7),enout,writein, dataout(7));
end architecture memmy;


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is

        signal w32, w16, w8 : STD_LOGIC :='0';
        signal out32, out16, out8 : STD_LOGIC :='1';

	component register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
	end component;
begin
  
        w8 <= writein8  OR writein16 OR writein32;
        w16 <= writein16 OR writein32;            
        w32 <= writein32;                       

	out8 <= enout8 AND enout16 AND enout32;     
        out16 <= enout16 AND enout32;
        out32 <= enout32;



	m0: register8 port map(datain(7 downto 0),   out8,   w8,  dataout(7 downto 0));
	m1: register8 port map(datain(15 downto 8),  out16,  w16, dataout(15 downto 8));
	m2: register8 port map(datain(23 downto 16), out32,  w32, dataout(23 downto 16));
	m3: register8 port map(datain(31 downto 24), out32,  w32, dataout(31 downto 24));

end architecture biggermem;

