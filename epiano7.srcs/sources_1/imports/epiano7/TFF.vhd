library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TFF is
    Port (
    clk : in std_logic;
    tick : in std_logic;
    mute : in std_logic;
    rst : in std_logic;
    speaker : out std_logic
    );
end TFF;

architecture Behavioral of TFF is

begin

process(clk, rst) 
variable output : std_logic := '0';
begin
    
    if(rst = '1') then
        output := '0';
    elsif (rising_edge(clk)) then
        if(mute = '1') then
            output := '0';
        elsif(tick = '1') then
            output := not output;
        end if;
    end if;
   
    speaker <= output;
end process;

end Behavioral;
