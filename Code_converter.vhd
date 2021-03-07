----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2021 16:49:55
-- Design Name: 
-- Module Name: Code_converter - Behavioral
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

entity Code_converter is
    Port ( RAM_data : in STD_LOGIC_VECTOR (7 downto 0);
           cnvt : out STD_LOGIC_VECTOR (17 downto 0));
end Code_converter;

architecture Behavioral of Code_converter is

begin
    process(RAM_data)
        begin   
            case RAM_data is
                when "01110001" =>   cnvt <= "101110101010001001"; -- C4: 71H (q)
			    when "01110111" =>   cnvt <= "101001100100010110"; -- D4: 77H (w) 
			    when "01100101" =>   cnvt <= "100101000010000110"; -- E4: 65H (e) 
			    when "01110010" =>   cnvt <= "100010111101000101"; -- F4: 72H (r) 
			    when "01110100" =>   cnvt <= "011111001001000001"; -- G4: 74H (t) 
			    when "01111001" =>   cnvt <= "011011101111100100"; -- A4: 79H (y) 
			    when "01110101" =>   cnvt <= "011000101101110111"; -- B4: 75H (u) 
			    
			    when "01100001" =>   cnvt <= "010111010101000100"; -- c5: 61H (a) 
			    when "01110011" =>   cnvt <= "010100110010001011"; -- d5: 73H (s) 
			    when "01100100" =>   cnvt <= "010010100001000011"; -- e5: 64H (d) 
			    when "01100110" =>   cnvt <= "010001011110100010"; -- f5: 66H (f) 
			    when "01100111" =>   cnvt <= "001111100100100000"; -- g5: 67H (g) 
			    when "01101000" =>   cnvt <= "001101110111110010"; -- a5: 68H (h) 
			    when "01101010" =>   cnvt <= "001100010110111011"; -- b5: 6AH (j) 
			    when others 	=>   cnvt <= "000000000000000001";   
			end case; 
        end process;
end Behavioral;
