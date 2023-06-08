library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
		In0, In1: in std_logic_vector(31 downto 0);
		Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
          WITH selector SELECT
		      Result <= In0 when '0',
			        In1 when others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
begin
	ALUCtrl <= "00000" when opcode = "0110011" and funct3 = "000" and funct7 = "0000000" else       
	           "00000" when opcode = "0010011" and funct3 = "000"     else                         
	           "00100" when opcode = "0110011" and funct3 = "000" and funct7 = "0100000" else       
	           "00010" when opcode = "0110011" and funct3 = "111"     else                          
		   "00011" when opcode = "0110011" and funct3 = "110"     else                         
                   "00001" when opcode = "0110011" and funct3 = "001"     else                         
                   "01001" when opcode = "0110011" and funct3 = "101"     else                         
                   "00000" when opcode = "0000011"                        else                          
                   "00000" when opcode = "0100011"                        else                         
	           "00100" when opcode = "1100011" and funct3 = "000"     else                       
                   "00100" when opcode = "1100011" and funct3 = "001"     else                       
                   "00000" when opcode = "0110111"                        else                         
                   "00010" when opcode = "0010011" and funct3 = "111"     else                       
	           "00011" when opcode = "0010011" and funct3 = "110"     else                         
	           "00001" when opcode = "0010011" and funct3 = "001"     else                          
	           "01001" when opcode = "0010011" and funct3 = "101";                                  

	with opcode & funct3 select
	Branch <= "10" when "1100011000", 
		"01" when "1100011001", 
		"00" when others;
	MemRead <= '0'; 
	MemToReg <= '1' when opcode = "0000011" else
		    '0';
	MemWrite <= '1' when opcode = "0100011" and funct3 = "010" else
		    '0';
	ALUSrc <= '0' when opcode = "0110011" or opcode = "1100011" else
		  '1';
	RegWrite <='0' when opcode="0100011" AND funct3="010" else	  	
		   '0' when opcode="1100011" AND funct3="000" else	   
		   '0' when opcode="1100011" AND funct3="001" else	    
		   (not clk);
	ImmGen <= "00" when opcode = "0010011" or opcode = "0000011" or opcode = "0010011" else 
                  "01" when opcode = "0100011" else                                            
		  "10" when opcode = "1100011" else                                             
		  "11";                                                                       
end Boss;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is

begin
	Process(Reset,Clock)
	begin	
 		if Reset = '1' then
			PCout <= X"003FFFFC";
		elsif rising_edge(Clock) then 
			PCout <= PCin; 
		end if;
	end process; 
end executive;

--------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ImmGen is 
	Port(         instype : in std_logic_vector(1 downto 0);
		    immgen_in : in std_logic_vector(31 downto 0);
                   immgen_out : out std_logic_vector(31 downto 0) );
end ImmGen;

architecture SignExtender of Immgen is

SIGNAL immediate : STD_LOGIC_VECTOR(31 DOWNTO 0);


begin

  with instype&immgen_in(31) select
	      immgen_out <= "111111111111111111111" & immgen_in(30 downto 20) when "001",  
                    	 "000000000000000000000" & immgen_in(30 downto 20) when "000",  
		         "111111111111111111111" & immgen_in(30 downto 25) & immgen_in(11 downto 7) when "011",  
                         "000000000000000000000" & immgen_in(30 downto 25) & immgen_in(11 downto 7) when "010",  
	   		 "11111111111111111111" & immgen_in(7) & immgen_in(30 downto 25) & immgen_in(11 downto 8) & '0' when "101", 
                      	 "00000000000000000000" & immgen_in(7) & immgen_in(30 downto 25) & immgen_in(11 downto 8) & '0' when "100", 
			 "1" & immgen_in(30 downto 12) & "000000000000" when "111", 
                         "0" & immgen_in(30 downto 12) & "000000000000" when "110",
                         "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;					                                                                                                 
					 
END SignExtender;

  
  ---------------------------------------------------------
  
  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity branchlogic is
	PORT( ctrlinput : in std_logic_vector (1 downto 0);
	      zeroIn : in std_logic;
		  output : out std_logic);
		  
end branchlogic;

architecture brancher of branchlogic is
SIGNAL otpsig: std_logic;
begin
with ctrlinput & zeroIn select
			
			output<= '0' when "111",
                                  '0' when"010", 
		                  '1' when "110",
                                  '1' when "011",
	                          '0' when others;
end brancher;

