----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Created by Andreea Onaci
-- Create Date: 06.04.2023 10:53:24
-- Design Name: 
-- Module Name: InstructionDecoder - Behavioral
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

entity InstructionDecoder is
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
end InstructionDecoder;

architecture Behavioral of InstructionDecoder is
signal addr1: std_logic_vector(2 downto 0);
signal addr2: std_logic_vector(2 downto 0);
signal read1: std_logic_vector(15 downto 0);
signal read2: std_logic_vector(15 downto 0);
signal write_addr: std_logic_vector(2 downto 0) := "000";
signal Ext_Imm_aux: std_logic_vector(15 downto 0);
component RegFile is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end component;
begin
    process(instruction, RegDest)
    begin
        if (RegDest = '0') then
            write_addr <= instruction(9 downto 7); --aici a fost 12 downto 10
        else
            write_addr <= instruction(6 downto 4); --aici a fost 9 downto 7
        end if;
    end process;
    
    process(instruction)
    begin
        if (ExtOP = '1') then
            if (instruction(6) = '1') then
                Ext_Imm_aux <= "111111111" & instruction(6 downto 0);
            else
                Ext_Imm_aux <= "000000000" & instruction(6 downto 0);
            end if;
            else
                Ext_Imm_aux <= "000000000" & instruction(6 downto 0);
        end if;
    end process;
    
    Ext_Imm <= Ext_Imm_aux;
    func <= instruction(2 downto 0);
    sa <= instruction(3);
    
    addr1 <= instruction(12 downto 10);
    addr2 <= instruction(9 downto 7);
    
     label1: RegFile port map (clk, addr1, addr2, write_addr, wd, reg_enable, read1, read2);
     rd1 <= read1;
     rd2 <= read2;
end Behavioral;
