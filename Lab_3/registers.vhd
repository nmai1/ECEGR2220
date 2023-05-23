--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

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
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;



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

	-- insert your code here.
    s1: bitstorage port map (
        bitin => datain(0),
        enout => enout,
        writein => writein,
        bitout => dataout(0)
    );
    
    s2: bitstorage port map (
        bitin => datain(1),
        enout => enout,
        writein => writein,
        bitout => dataout(1)
    );
    
    s3: bitstorage port map (
        bitin => datain(2),
        enout => enout,
        writein => writein,
        bitout => dataout(2)
    );
    
    s4: bitstorage port map (
        bitin => datain(3),
        enout => enout,
        writein => writein,
        bitout => dataout(3)
    );
    
    s5: bitstorage port map (
        bitin => datain(4),
        enout => enout,
        writein => writein,
        bitout => dataout(4)
    );
    
    s6: bitstorage port map (
        bitin => datain(5),
        enout => enout,
        writein => writein,
        bitout => dataout(5)
    );
    
    s7: bitstorage port map (
        bitin => datain(6),
        enout => enout,
        writein => writein,
        bitout => dataout(6)
    );
    
    s8: bitstorage port map (
        bitin => datain(7),
        enout => enout,
        writein => writein,
        bitout => dataout(7)
    );
end architecture memmy;
  


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity register32 is
    port (
        datain : in std_logic_vector(31 downto 0);
        enout32, enout16, enout8 : in std_logic;
        writein32, writein16, writein8 : in std_logic;
        dataout : out std_logic_vector(31 downto 0)
    );
end entity register32;

architecture biggermem of register32 is
    component register8
        port (
            datain : in std_logic_vector(7 downto 0);
            enout : in std_logic;
            writein : in std_logic;
            dataout : out std_logic_vector(7 downto 0)
        );
    end component;

signal enableo, wrtin: std_logic_vector (3 downto 0);
signal a,b: std_logic_vector (2 downto 0);

begin

	a <= enout32 & enout16 & enout8;
	b <= writein32& writein16 & writein8;

	with a select
		enableo <= "1110" when "110",
			   "1100" when "101",
			   "0000" when "011",
			   "1111" when others;

	with b select
		wrtin <= "0001" when "001",
			 "0011" when "010",
			 "1111" when "100",
			 "0000" when others;

	s1: register8 port map (datain (7 downto 0), enableo(0), wrtin(0), dataout (7 downto  0));
	s2: register8 port map (datain (15 downto 8), enableo(1), wrtin(1), dataout (15 downto  8));
	s3: register8 port map (datain (23 downto 16), enableo(2), wrtin(2), dataout (23 downto  16));
	s4: register8 port map (datain (31 downto 24), enableo(3), wrtin(3), dataout (31 downto  24));

end architecture biggermem;


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
    port(	datain_a: in std_logic_vector(31 downto 0);
            datain_b: in std_logic_vector(31 downto 0);
            add_sub: in std_logic;
            dataout: out std_logic_vector(31 downto 0);
            co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
component fulladder
    port (a, b, cin: in std_logic;
            sum, carry: out std_logic);
end component;

    signal temp: std_logic_vector (31 downto 0);
    signal addersub: std_logic_vector (32 downto 0);
begin

    addersub(0) <= add_sub;
    co <= addersub(32);

    with add_sub select
        temp <= datain_b when '0',
                not datain_b when others;

    adderloop: for i in 31 downto 0 generate
    addi: fulladder port map (datain_a(i), temp(i), addersub(i), dataout(i), addersub(i+1));
    end generate;
end architecture calc;



Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
    port(    datain: in std_logic_vector(31 downto 0);
            dir: in std_logic;
            shamt:    in std_logic_vector(4 downto 0);
            dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is

signal x: std_logic_vector (2 downto 0);
begin

    x <= dir & shamt (1 downto 0);

    with x select
        dataout <= datain (30 downto 0) & '0' when "001",
                   '0' & datain (31 downto 1) when "101",
                   datain (29 downto 0) & "00" when "010",
                   "00" & datain (31 downto 2) when "110",
                   datain (28 downto 0) & "000" when "011",
                   "000" & datain (31 downto 3) when "111",
                   datain when others;

end architecture shifter;

