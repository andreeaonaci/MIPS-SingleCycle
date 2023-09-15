----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2023 10:36:19
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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

entity DataMemory is
    port ( clk : in std_logic;
           we : in std_logic;
           addr : in std_logic_vector(15 downto 0);
           di : in std_logic_vector(15 downto 0);
           do : out std_logic_vector(15 downto 0));
end DataMemory;

architecture syn of DataMemory is
type ram_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal RAM: ram_type := (
0=>x"000A", 1=>x"0001", 2=>x"0002", 3=>x"0003", 4=>x"0004", 5=>x"0005", 6=>x"0006", 7=>x"0007", 8=>x"0008",
9=>x"0009", 10=>x"0010", 11=>x"0011", 12=>x"0012", 13=>x"0013", 14=>x"0014", others => x"00FF");
signal ALURes: std_logic_vector(15 downto 0);
begin
process (clk)
begin
if clk'event and clk = '1' then
if we = '1' then
RAM(conv_integer(addr)) <= di;
else
do <= RAM( conv_integer(addr));
end if;
end if;
end process;
end syn;
