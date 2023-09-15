----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2023 22:15:54
-- Design Name: 
-- Module Name: InstructionExecute - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionExecute is
    Port ( 
           pc_plus_4 : in STD_LOGIC_VECTOR (15 downto 0);
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
end InstructionExecute;

architecture Behavioral of InstructionExecute is
signal ALUControl: std_logic_vector(3 downto 0);
signal mux: std_logic_vector(15 downto 0);
signal AluAux: std_logic_vector(15 downto 0);
signal ZeroAux: std_logic;
signal jump: std_logic := '0';
signal branch: std_logic := '0';
begin
     BranchAddress <= pc_plus_4 + Ext_Imm;
     process(ALUSrc)
     begin
        if (ALUSrc = '0') then
            mux <= rd2;
        else
            mux <= Ext_Imm;
        end if;
     end process;
     process(ALUOp, func)
     begin
        case(ALUOp) is
            when "000" =>
                case(func) is
                    when "000" => ALUControl <= "0000"; --ADD --aici le-am inversat add cu sub
                    when "001" => ALUControl <= "0001"; --SUB
                    when "010" => ALUControl <= "0010"; --SLL
                    when "011" => ALUControl <= "0011"; --SRL
                    when "100" => ALUControl <= "0100"; --AND
                    when "101" => ALUControl <= "0101"; --OR
                    when "110" => ALUControl <= "0110"; --XOR
                    when "111" => ALUControl <= "0111"; --SLT
                    when others => ALUControl <= "0000"; --OTHERS
                 end case;
            when "001" => ALUControl <= "1000"; --ADDI
            when "010" => ALUControl <= "1101"; --LW
            when "011" => ALUControl <= "1100"; --SW
            when "100" => ALUControl <= "1011"; --ORI
            when "101" => ALUControl <= "1010"; --ANDI
            when "110" => ALUControl <= "1001"; --BEQ
            when "111" => ALUControl <= "1110"; --JUMP
            when others => ALUControl <= "1111";
            end case;
     end process;
     
     process(ALUControl, rd1, rd2, sa, mux)
     begin
        case(ALUControl) is
            when "0000" => AluAux<=rd1+mux;   -----ADD-----
					
		    when "0001" => AluAux<=rd1-mux;	  -----SUB-----
								
		    when "0010" => 				-----SLL-----
					case (sa) is
						when '1' => AluAux<=rd1(14 downto 0) & "0";
						when others => AluAux<=rd1;	
					end case;
			when "0011" => 
			 case (sa) is
			     when '1' =>AluAux <= '0' & rd1(15 downto 1);
			     when others => AluAux <= rd1;
			 end case;
			when "0100" => AluAux <= rd1 and mux;		-----AND-----
								
		    when "0101" => AluAux <= rd1 or mux;		-----OR-----
										
		    when "0110" => AluAux <= rd1 xor mux;		-----XOR-----
							
		    when "0111" =>   -----SET ON LESS THAN-----
					if rd1 < mux then
						AluAux <= x"0001";
					else AluAux <= x"0000";
					end if;
			when "1000" =>  AluAux <= rd1 + mux; ----ADDI----
		    
		    when "1001" => if rd1 = rd2 then --BEQ
                                 AluAux <= x"0001";
                            else
                                 AluAux <= x"0000";
                            end if;
		    
		    when "1010" => AluAux <= rd1 and mux;		-----ANDI-----
		    
			when "1011" =>AluAux <= rd1 or mux;    ----ORI----
					
		    when "1100" => AluAux <= rd1 + mux; ----SW----
		    
		    when "1101" => AluAux <= rd1 + mux; ----LW------
		    
            when "1110" => AluAux <= x"0000"; ----JUMP-----
					
		    when others => AluAux <= x"FFFF";		-----OTHERS-----
		end case;
		case (AluAux) is					-----ZERO SIGNAL-----
	   	      when x"0000" => ZeroAux <= '1';
		      when others =>  ZeroAux <= '0';
	    end case;
    end process; 
    Zero <= ZeroAux;
    AluRes <= AluAux;
end Behavioral;
