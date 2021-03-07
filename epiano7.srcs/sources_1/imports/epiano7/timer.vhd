-- Timer delay counter (simply a down counter with parallel load)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
   generic(
       N: integer := 26;
	   M: std_logic_vector := "10111110101111000010000000" 
    );
    
   port(
        clk, rst: in std_logic;
		timer_on: in std_logic;
        timer_done: out std_logic
       );
       
end timer;

architecture arch of timer is
signal r_next, r_reg: unsigned(N-1 downto 0);

begin

   -- register
   process(clk,rst)
   begin
      if (rst='1') then
         r_reg <= (others=>'0');
      elsif rising_edge(clk) then
         r_reg <= r_next;
      end if;
   end process;
	
   -- next-state logic
	process(r_reg, timer_on)
   begin
		r_next <= r_reg;
      if (timer_on = '1') then
			if (r_reg /= 0) then
				r_next <= r_reg - 1;
			else
				r_next <= unsigned(M);
			end if;
      end if;
   end process;
	
   timer_done <= '1' when r_reg=1 else '0';
	
end arch;