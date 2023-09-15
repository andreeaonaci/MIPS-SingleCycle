----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2023 10:08:06
-- Design Name: 
-- Module Name: Processor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Processor is
    Port ( clk : in  STD_LOGIC;
           btn : in  STD_LOGIC_VECTOR (4 downto 0);
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           cat : out  STD_LOGIC_VECTOR (6 downto 0);
           dp : out  STD_LOGIC);
end Processor;

architecture Behavioral of Processor is
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal en: std_logic;
signal Branch_input: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal EnableFetch: std_logic;
signal outOfPC: std_logic_vector(15 downto 0); 
--signal RegWrite: std_logic; --asta iese din main controller
signal RightAdder: std_logic_vector(15 downto 0);
signal LeftAdder: std_logic_vector(15 downto 0);
signal pcUp: std_logic_vector(15 downto 0);
signal func: std_logic_vector(2 downto 0);
signal Ext_IMM: std_logic_vector(15 downto 0);
signal WriteAddress: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal BranchAddress: std_logic_vector(15 downto 0);
signal WriteData: std_logic_vector(15 downto 0); --iese din muxu de jos dreapta
signal pcSrc: std_logic; --iese din Alu si intra in instr fetch
signal InstructionMemoryOutput: std_logic_vector(15 downto 0);
signal DataMemoryAlu: std_logic_vector(15 downto 0);
signal ReadData1: std_logic_vector(15 downto 0);
signal ReadData2: std_logic_vector(15 downto 0);
signal DataMemoryOutput: std_logic_vector(15 downto 0); 
signal ZeroAlu: std_logic;
signal RegEnable: std_logic;
signal SSDOutput: std_logic_vector(15 downto 0);
component debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end component;
component ssd is
    Port (
    sw: in std_logic_vector(15 downto 0);
    an: out std_logic_vector(3 downto 0);
    cat: out std_logic_vector (6 downto 0);
    clk: in std_logic
    );
end component;
component InstructionDecoder is
  Port (
      instruction: in std_logic_vector(15 downto 0);
      reg_enable: in std_logic;
      wd: in std_logic_vector(15 downto 0);
      --operation_code: in std_logic_vector(2 downto 0);
      rd1: out std_logic_vector(15 downto 0);
      rd2: out std_logic_vector(15 downto 0);
      ExtOP: in std_logic;
      func: out std_logic_vector(2 downto 0);
      Ext_Imm: out std_logic_vector(15 downto 0);
      sa: out std_logic;
      clk: in std_logic;
      RegDest: in std_logic 
   );
end component;
component Instruction_Fetch_Data_Path is
    Port ( jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           branch_address : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_plus_4 : out STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC);
end component;
component InstructionExecute is
    Port ( 
           pc_plus_4 : in STD_LOGIC_VECTOR (15 downto 0); --ala de sus
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(2 DOWNTO 0);
           ALUSrc : in STD_LOGIC;
           BranchAddress : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC
    );
end component;
component DataMemory is
    port ( clk : in std_logic;
           we : in std_logic;
           --en : in std_logic;
           addr : in std_logic_vector(15 downto 0);
           di : in std_logic_vector(15 downto 0);
           do : out std_logic_vector(15 downto 0));
end component;
component ControlUnit is
  Port ( 
       instruction: in std_logic_vector(2 downto 0);
       RegDst: out std_logic;
       ExtOp: out std_logic;
       ALUSrc: out std_logic;
       Branch: out std_logic;
       Jump: out std_logic;
       ALUOp: out std_logic_vector(2 downto 0);
       MemWrite: out std_logic;
       MemtoReg: out std_logic;
       RegWrite: out std_logic
  );
end component;
begin
    PcSrc <= ZeroAlu and Branch_input;
    Debouncer_label_Reg: debouncer port map (clk, btn(1), RegEnable);
    Debouncer_label: debouncer port map (clk, btn(0), en);
    InstructionFetch_label: Instruction_Fetch_Data_Path port map (LeftAdder, RightAdder, InstructionMemoryOutput, LeftAdder, RegEnable, clk, en, Jump, pcSrc);
    InstructionDecoder_label: InstructionDecoder port map (InstructionMemoryOutput, RegWrite, WriteData, ReadData1, ReadData2, ExtOp, func, Ext_IMM, sa, clk, RegDst);
    InstructionExecute_label: InstructionExecute port map (LeftAdder, ReadData1, ReadData2, Ext_IMM, sa, func, AluOp, AluSrc, BranchAddress, DataMemoryAlu, ZeroAlu);
    DataMemory_label: DataMemory port map (clk, MemWrite, DataMemoryAlu, ReadData2, DataMemoryOutput);
    ControlUnit_label: ControlUnit port map (InstructionMemoryOutput(15 downto 13), RegDst, ExtOp, AluSrc, Branch_input, Jump, AluOp, MemWrite, MemToReg, RegWrite);
    Ssd_label: ssd port map (SSDOutput, an, cat, clk);
    
    process(RegDst, ExtOp, ALUSrc, Branch_input, Jump, MemWrite, MemtoReg, RegWrite, sw, ALUOp)
    begin
	   if sw(0)='0' then		
		led(7)<=RegDst;
		led(6)<=ExtOp;
		led(5)<=ALUSrc;
		led(4)<=Branch_input;
		led(3)<=Jump;
		led(2)<=MemWrite;
		led(1)<=MemtoReg;
		led(0)<=RegWrite;     	
	   else
		led(2 downto 0)<=ALUOp(2 downto 0);
		led(7 downto 3)<="00000";
	   end if;
    end process;
    
    process(MemToReg, DataMemoryAlu, DataMemoryOutput)
    begin
        if (MemToReg = '0') then
            WriteData <= DataMemoryAlu;
        else
            WriteData <= DataMemoryOutput;
        end if;
    end process;
    
    process(InstructionMemoryOutput, LeftAdder, ReadData1, ReadData2, Ext_Imm, DataMemoryAlu, DataMemoryOutput, WriteData, sw)
    begin
	case(sw(7 downto 5)) is
		when "000"=>
				SSDOutput <= InstructionMemoryOutput;			-----AFISARE INSTROUT-----
		when "001"=>
				SSDOutput <= LeftAdder;				-----AFISARE PCOUT-----
		when "010"=>
				SSDOutput <= ReadData1;				-----AFISARE ReadData1-----
		when "011"=>
				SSDOutput <= ReadData2;				-----AFISARE ReadData2-----
		when "100"=>
				SSDOutput <= Ext_Imm;			-----AFISARE EXT_IMM-----
		when "101" =>
				SSDOutput <= DataMemoryAlu;			-----AFISARE ALUres-----		
		when "110"=>
				SSDOutput <= DataMemoryOutput;			-----AFISARE MemData-----
		when "111"=>
				SSDOutput <= WriteData;	-----AFISARE WriteData - RegisterFile-----
		when others=>
				SSDOutput <= x"AAAA";
	end case;
end process;
end Behavioral;
