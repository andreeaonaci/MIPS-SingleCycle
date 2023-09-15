----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2023 10:22:26
-- Design Name: 
-- Module Name: lab1 - Behavioral
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

entity debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
signal q1: std_logic;
signal q2: std_logic;
signal q3: std_logic;
signal counter: std_logic_vector (15 downto 0);
begin
process (clk, btn)
    begin
        if rising_edge(clk) then
                counter <= counter + '1';
        end if;
    end process;
    
process (clk, btn, counter)
    begin
        if rising_edge(clk) then
            if counter=x"ffff" then
                q1 <= btn;
            end if;
            q2 <= q1;
            q3 <= q2;
        end if;
    end process;
    enable <= not(q3) and q2;
end Behavioral;
