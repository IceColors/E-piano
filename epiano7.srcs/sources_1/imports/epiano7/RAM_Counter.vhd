library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_Counter is 
   generic(ADDR_WIDTH: integer := 10);
   port( 
     clk, rst: in std_logic;
 	 inc, clr: in std_logic;
 	 addr: out std_logic_vector(ADDR_WIDTH-1 downto 0));
end RAM_Counter;
 
architecture arch of RAM_Counter is

signal r_reg, r_nxt: unsigned(ADDR_WIDTH-1 downto 0);
   
begin process(clk,rst)
   begin
      if rst='1' then
         r_reg <= (others=>'0');
      elsif(rising_edge(clk)) then
         r_reg <= r_nxt;
      end if;
end process;
   
   r_nxt <= (others=>'0') when clr='1' else
			r_reg+1		  when inc='1' else
			r_reg;
   addr <= std_logic_vector(r_reg);
end arch;