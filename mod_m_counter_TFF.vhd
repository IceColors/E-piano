----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2021 16:42:48
-- Design Name: 
-- Module Name: mod_m_counter_TFF - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_m_counter_TFF is
generic (
        N: integer := 18 -- num of bits
        --M: integer := 326 ); -- mod-326 counter 
);
    port ( 
        clk, rst:   in std_logic;
        din : in std_logic_vector(N-1 downto 0);
        to_s_tick:  out std_logic );
end mod_m_counter_TFF;

architecture Behavioral of mod_m_counter_TFF is

signal r_reg:   unsigned(N-1 downto 0);
signal r_next:  unsigned(N-1 downto 0);
signal q:       std_logic_vector(N-1 downto 0);
     
----------------------------------------------------------------------------------
begin
    -- register
    process(clk, rst) begin
        if (rst = '1') then
            r_reg <= (others =>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next-state logic
    r_next <= (others => '0') when r_reg>=unsigned(din)- 1 else r_reg+1;
    
    -- output logic
    q <= std_logic_vector(r_reg);
    to_s_tick <= '1' when r_reg>=unsigned(din)- 1  else '0';

end Behavioral;
