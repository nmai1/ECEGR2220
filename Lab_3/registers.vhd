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

--------------------------------------------------------------------------------
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


--------------------------------------------------------------------------------
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
	signal bits : std_logic_vector(7 downto 0);
begin
	bit0 : bitstorage
		port map(
			bitin => datain(0),
			enout => enout,
			writein => writein,
			bitout => bits(0)
		);
	bit1 : bitstorage
		port map(
			bitin => datain(1),
			enout => enout,
			writein => writein,
			bitout => bits(1)
		);
	bit2 : bitstorage
		port map(
			bitin => datain(2),
			enout => enout,
			writein => writein,
			bitout => bits(2)
		);
	bit3 : bitstorage
		port map(
			bitin => datain(3),
			enout => enout,
			writein => writein,
			bitout => bits(3)
		);
	bit4 : bitstorage
		port map(
			bitin => datain(4),
			enout => enout,
			writein => writein,
			bitout => bits(4)
		);
	bit5 : bitstorage
		port map(
			bitin => datain(5),
			enout => enout,
			writein => writein,
			bitout => bits(5)
		);
	bit6 : bitstorage
		port map(
			bitin => datain(6),
			enout => enout,
			writein => writein,
			bitout => bits(6)
		);
	bit7 : bitstorage
		port map(
			bitin => datain(7),
			enout => enout,
			writein => writein,
			bitout => bits(7)
		);

	dataout <= bits;
end architecture memmy;

--------------------------------------------------------------------------------
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
	component register8
		port(
			datain : in std_logic_vector(7 downto 0);
			enout : in std_logic;
			writein : std_logic;
			dataout : out std_logic_vector(7 downto 0)
		);
	end component;

	signal data8_0 : std_logic_vector(7 downto 0);
	signal data8_1 : std_logic_vector(7 downto 0);
	signal data8_2 : std_logic_vector(7 downto 0);
	signal data8_3 : std_logic_vector(7 downto 0);

begin
	reg8_0 : register8
		port map(
			datain => datain(7 downto 0),
			enout => enout8,
			writein => writein8,
			dataout => data8_0
		);
	reg8_1 : register8
		port map(
			datain => datain(15 downto 8),
			enout => enout8,
			writein => writein8,
			dataout => data8_1
		);
	reg8_2 : register8
		port map(
			datain => datain(23 downto 16),
			enout => enout8,
			writein => writein8,
			dataout => data8_2
		);
	reg8_3 : register8
		port map(
			datain => datain(31 downto 24),
			enout => enout8,
			writein => writein8,
			dataout => data8_3
		);
	reg8_0_15 : register8
		port map(
			datain => data8_0,
			enout => enout16,
			writein => writein16,
			dataout => dataout(15 downto 8)
		);
	reg8_16_31 : register8
		port map(
			datain => data8_1,
			enout => enout16,
			writein => writein16,
			dataout => dataout(31 downto 24)
		);
	
	dataout(7 downto 0) <= data8_2 when enout32 = '0' else (others => 'Z');
	dataout(23 downto 16) <= data8_3 when enout32 = '0' else (others => 'Z');
end architecture biggermem;

--------------------------------------------------------------------------------
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

begin
	process(datain_a, datain_b, add_sub)
		variable temp : std_logic_vector(31 downto 0);
	begin
		if add_sub = '0' then
			temp := std_logic_vector(unsigned(datain_a) + unsigned(datain_b));
			co <= '0';
			dataout <= temp;
		else
			temp := std_logic_vector(unsigned(datain_a) - unsigned(datain_b));
			co <= '1';
			dataout <= temp;
		end if;
	end process;
end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	process(datain, dir, shamt)
	begin
		if dir = '0' then
			dataout <= std_logic_vector(shift_left(unsigned(datain), to_integer(unsigned(shamt(1 downto 0)))));
		else
			dataout <= std_logic_vector(shift_right(unsigned(datain), to_integer(unsigned(shamt(1 downto 0)))));
		end if;
	end process;
end architecture shifter;



