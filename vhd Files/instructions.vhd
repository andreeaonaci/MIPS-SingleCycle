----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 10:50:09
-- Design Name: 
-- Module Name: instructions - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Fetch_Data_Path is
    Port ( jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           branch_address : in STD_LOGIC_VECTOR (15 downto 0);
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           pc_plus_4 : out STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC);
end Instruction_Fetch_Data_Path;

architecture Behavioral of Instruction_Fetch_Data_Path is
--component rom_secund is
 -- Port (
 -- clk: in std_logic;
 -- btn: in std_logic;
 -- adr: in std_logic_vector(15 downto 0);
 -- led: out std_logic_vector(15 downto 0)
 -- );
--end component;
signal counter: STD_LOGIC_VECTOR(15 downto 0);
signal counter_plus_1: STD_LOGIC_VECTOR(15 downto 0);
signal mux1_out: STD_LOGIC_VECTOR(15 downto 0);
signal mux2_out: STD_LOGIC_VECTOR(15 downto 0);
signal Q: STD_LOGIC_VECTOR(15 downto 0);
type memorie is array (0 to 15) of std_logic_vector(15 downto 0);

---     d   s   t   000 sss ttt ddd 0 000
--		B"000_001_000_010_0_000",   --X"0420"  	--add
--		B"000_011_010_010_0_001",   --X"0d21"		--sub
--		B"000_010_000_010_1_010",   --X"082A"		--sll
--		B"000_010_000_010_1_011",   --X"082b"		--srl
--		B"000_011_010_100_0_100",   --X"0d44"		--and
--		B"000_101_100_100_0_101",   --X"1645"		--or
--		B"000_100_100_100_0_110",   --X"1246"		--xor
--		B"000_010_011_100_0_111",   --X"09C7"		--slt
--		B"001_000_100_0000100",   --X"2204"			--addi
--		B"010_001_101_0000000",   --X"4680"			--lw
--		B"011_100_101_0000000",   --X"7280"			--sw
--		B"100_001_001_0000001",   --X"8481"			--beq
--		B"101_100_101_0000100",   --X"b284"			--andi
--		B"110_101_110_0000011",   --X"d703"			--ori
--		B"111_0000000000011",   --X"E003"			--j
signal stocare:memorie :=(
	    0=>B"000_010_001_0000000",  --X"0880"	--add $2,$1,0
		1=>B"000_011_010_0000001",	 --X"0D01"	--sub $3,$2,0	
		2=>B"000_011_001_0001010",	 --X"0C8A"	--sll $3,$1,0	
		3=>B"000_011_001_0001011",	 --X"0C8B"	--srl $3,$1,0
		4=>B"000_011_001_0000100", --X"0C84"   --and $3,$1,0
		5=>B"000_011_001_0000101", --X"0C85"   --or $3,$1,0
		6=>B"000_011_001_0000110", --X"0C86"   --xor $3,$1,0
		7=>B"000_011_001_0000111", --X"0C87"   --slt &3,&1,0
		
		8=>B"001_000_001_0000001", --X"2081" --addi 0,1,$1
		9=>B"010_000_011_0000000", --X"4083" --lw 0,1,&3
		10=>B"011_000_011_0000000", --X"6180" --sw 0,1,&3
		11=>B"100_001_011_0000011", --X"8583" --ori 1,3,0
		12=>B"101_001_011_0000011", --X"A583" --andi 1,3,0
		13=>B"110_001_000_0001110", --X"C400" --beq 1,0,0
		14=>B"111_001_000_0000000", --X"d400" --jump 1,0
	    others=>x"0000");

begin
    process(clk,reset, en) --PC
	begin
		if(reset='1') then 
		Q<=x"0000";
		elsif rising_edge(clk) then
		if (en='1') then 
		Q<= counter;
		end if;
		end if;
end process;

process(Q)
begin
instruction<=stocare(conv_integer(Q));
counter_plus_1<=Q+'1'; --adder
pc_plus_4 <= counter_plus_1;
end process;

process(pcsrc,branch_address,counter_plus_1) --mux1
begin
case pcsrc is
when '0'=> mux1_out<=counter_plus_1;
when others=> mux1_out<=branch_address;
end case;
end process;

process(jump,jump_address,mux1_out) --mux2
begin
case jump is
when '0'=> counter<=mux1_out;
when others=> counter<=jump_address;
end case;
end process;
end Behavioral;
