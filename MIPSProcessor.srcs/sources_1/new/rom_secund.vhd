----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2023 10:25:40
-- Design Name: 
-- Module Name: rom - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom_secund is
  Port (
  clk: in std_logic;
  btn: in std_logic;
  adr: in std_logic_vector(15 downto 0);
  led: out std_logic_vector(15 downto 0)
  );
end rom_secund;

architecture Behavioral of rom_secund is
signal en: std_logic;
signal do: std_logic_vector(15 downto 0);
type memorie is array (0 to 15) of std_logic_vector(15 downto 0);
signal stocare:memorie :=(0=>x"09C0",
			              1=>x"09C1",
		                  2=>x"09CA",
			              3=>x"09CB",	
			              4=>x"09C4",	
			              5=>x"09C5",	
			              6=>x"09C6",
		                  7=>x"09C7",
			              8=>x"2988",
		                  9=>x"4989",
			              10=>x"698A",	
			              11=>x"898B",	
			              12=>x"A980",	
			              13=>x"C980",
			              14=>x"E00E",
			              others=>x"FFFF");
begin
do <= stocare(conv_integer(unsigned(adr)));
 led <= do;
end Behavioral;