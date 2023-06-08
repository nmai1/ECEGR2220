library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	       clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component ProgramCounter;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

signal  PCout : std_logic_vector(31 downto 0);
signal  PCAdderOut : std_logic_vector(31 downto 0); 
signal  PCAddco : std_logic;  
signal  BNEout: std_logic; 
signal  BranchAddOut: std_logic_vector(31 downto 0);
signal  BranchAddCarry: std_logic;
signal  PcMuxOut : std_logic_vector(31 downto 0);  
signal ImmGenOut : std_logic_vector(31 downto 0);  
signal IMtoImmGen : std_logic_vector(31 downto 0);
signal IMOUT : std_logic_vector(31 downto 0);
signal RegDat1 : std_logic_vector(31 downto 0); 
signal RegDat2 : std_logic_vector(31 downto 0);  
signal Mux2ALU : std_logic_vector(31 downto 0); 
signal ALUOut  : std_logic_vector(31 downto 0); 
signal ALUzero : std_logic;  
signal MemReadOut : std_logic_vector(31 downto 0);
signal MeMuxOut   : std_logic_vector(31 downto 0);
signal Acct30bit  : std_logic_vector(29 downto 0);
signal BranchCTRL   : std_logic_vector(1 downto 0);
signal MemReadCTRL  : std_logic;
signal MemToRegCTRL : std_logic;
signal ALUCTRLCTRL  : std_logic_vector(4 downto 0);
signal MemWriteCTRL : std_logic;
signal ALUSrcCTRL   : std_logic;
signal RegWriteCTRL : std_logic;
signal ImmGenCTRL   : std_logic_vector(1 downto 0);

begin

	PC :         
		ProgramCounter   port map(reset, clock, PCMuxOut, PCout);

	PCAdder:     
		adder_subtracter  port map(PCout,  "00000000000000000000000000000100", '0', PCAdderOut, PCAddco);

	Branchadder: 
		adder_subtracter port map(PCout, ImmGenOut, '0', BranchAddOut, BranchAddCarry);

	PCmux:       
		BusMux2To1       port map(BNEout, PCAdderOut,  BranchAddOut, PCMuxOut);	

	IM :         
		InstructionRAM   port map(reset, clock, PCOut(31 downto 2), IMOUT);

	CTRL :       
		Control          port map(clock, IMOUT(6 downto 0), IMOUT(14 downto 12), IMOUT(31 downto 25), BranchCTRL, MemReadCTRL, MemToRegCTRL, ALUCTRLCTRL, MemWriteCTRL, ALUSrcCTRL, RegWriteCTRL, ImmGenCTRL);

	Reg32 :      
		Registers        port map(IMOUT(19 downto 15), IMOUT(24 downto 20), IMOUT(11 downto 7), MeMuxOut, RegWriteCTRL, RegDat1, RegDat2);

	RegMux:      
		BusMux2To1       port map(ALUSrcCTRL, RegDat2, ImmGenOut, Mux2ALU);

	TheALU :     
		ALU              port map(RegDat1, Mux2ALU, ALUCTRLCTRL, ALUZero, ALUOut);

	Acct30bit <= "0000" & ALUOUT(27 downto 2);
	
	DMEM :       
		RAM              port map(reset, clock, MemReadCTRL, MemWriteCTRL, Acct30bit, RegDat2, MemReadOut);

	MeMux :      
		BusMux2To1       port map(MemToRegCTRL, ALUOut, MemReadOut, MeMuxOut);

	with ImmGenCTRL & IMOUT(31) select
	ImmGenOut <=   "111111111111111111111" & IMOUT(30 downto 20) when "001",  
                       "000000000000000000000" & IMOUT(30 downto 20) when "000",  
		       "111111111111111111111" & IMOUT(30 downto 25) & IMOUT(11 downto 7) when "011",  
                       "000000000000000000000" & IMOUT(30 downto 25) & IMOUT(11 downto 7) when "010", 
		        "11111111111111111111" & IMOUT(7) & IMOUT(30 downto 25) & IMOUT(11 downto 8) & '0' when "101", 
                        "00000000000000000000" & IMOUT(7) & IMOUT(30 downto 25) & IMOUT(11 downto 8) & '0' when "100",
			"1" & IMOUT(30 downto 12) & "000000000000" when "111", 
                        "0" & IMOUT(30 downto 12) & "000000000000" when "110", 
          		"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;

	with BranchCTRL & ALUZero select
	BNEOut <=   '1' when "101",
                         '1' when "010",
		         '0' when others;
 

end holistic;



