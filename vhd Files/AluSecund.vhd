----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2023 11:30:06
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alusecund is
  Port ( 
    btn: in std_logic;
    sw: in std_logic_vector(15 downto 0);
    clk: in std_logic;
    led: out std_logic_vector(15 downto 0)
  );
end alusecund;

architecture Behavioral of alusecund is

signal en: std_logic;
signal anod: std_logic_vector(3 downto 0);
signal catod: std_logic_vector(6 downto 0);
signal sw0: std_logic_vector(15 downto 0);
signal sw1: std_logic_vector(15 downto 0);
signal sw2: std_logic_vector(15 downto 0);
signal sum: std_logic_vector(15 downto 0);
signal dif: std_logic_vector(15 downto 0);
signal sr: std_logic_vector(15 downto 0);
signal sl: std_logic_vector(15 downto 0);
signal number: std_logic_vector(1 downto 0);
signal output: std_logic_vector(15 downto 0);
signal zdet: std_logic;

begin

    process (clk, btn)
    begin
        if rising_edge(clk) then
            if btn='1' then
                number <= number + '1';
            end if;
        end if;
    end process;
    
    sw0 <= x"000" & sw(3 downto 0);
    sw1 <= x"000" & sw(7 downto 4);
    sw2 <= x"00" & sw(7 downto 0);
    sum <= sw0 + sw1;
    dif <= sw0 - sw1;
    sr <= "00" & sw2(15 downto 2);
    sl <= sw2(13 downto 0) & "00";
    
    process(sum, dif, sr, sl, number)
    begin
        case number is
            when "00" => output <= sum;
            when "01" => output <= dif;
            when "10" => output <= sl;
            when others => output <= sr;
        end case;
    end process;
    
    zdet <= '1' when output=x"0000" else '0';
    led(0) <= zdet;
end Behavioral;
