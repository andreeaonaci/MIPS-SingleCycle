----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.05.2023 00:10:10
-- Design Name: 
-- Module Name: RegFile - Behavioral
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

entity RegFile is
Port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end RegFile;
architecture Behavioral of RegFile is
type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (
x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", x"0000", others => x"0000");
begin
process(clk)
begin
if rising_edge(clk) then
if wen = '1' and wa /= "000" then
reg_file(conv_integer(unsigned(wa))) <= wd;
end if;
end if;
end process;
rd1 <= "0000000000000" & ra1;
rd2 <= "0000000000000" & ra2;
end Behavioral;