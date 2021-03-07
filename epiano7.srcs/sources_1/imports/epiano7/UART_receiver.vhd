----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2021 13:22:36
-- Design Name: 
-- Module Name: UART_receiver - Behavioral
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

entity UART_receiver is
generic (
        DBIT: integer := 8; -- data bits
        SB_TICK: integer := 16 ); -- ticks for stop bits

    Port ( 
        clk, rst, rx, from_s_tick: in std_logic;
        rx_done_tick : out std_logic;
        to_dout : out std_logic_vector(7 downto 0) );
end UART_receiver;

architecture Behavioral of UART_receiver is
type state is (idle, start, data, stop);
signal state_reg, state_next : state;
signal s_reg, s_next : unsigned(3 downto 0);
signal n_reg, n_next : unsigned(2 downto 0);
signal b_reg, b_next : unsigned(7 downto 0);
 

begin


-- State registers
    process(clk, rst) begin
        if rst = '1' then
            state_reg <= idle;
            s_reg <= (others => '0');
            n_reg <= (others => '0');
            b_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;

-- next-state logic
    process(state_reg, s_reg, n_reg, b_reg, from_s_tick, rx)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= '0';
        case state_reg is 
------------------------------------------------------------                
            when idle =>
                if rx='0' then
                    state_next <= start;
                    s_next <= (others=>'0');
                -- else stay idle
                end if;
------------------------------------------------------------                
            when start =>
                if (from_s_tick = '1') then
                    if s_reg=7 then -- restart counter
                        state_next <= data;
                        s_next <= (others=>'0');
                        n_next <= (others=>'0');
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------                
            when data =>
                if (from_s_tick = '1') then
                    if s_reg=15 then -- read RxD, feed its value to deserializer, restart counter
                        s_next <= (others => '0');
                        b_next <= rx & b_reg(7 downto 1); -- b = rx & (b >> 1)
                        if n_reg=(DBIT-1) then
                            state_next <= stop;
                        else
                            n_next <= n_reg+1;
                        end if;
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------
            when stop =>
                if (from_s_tick = '1') then
                    if s_reg=(SB_TICK-1) then
                        state_next <= idle;
                        rx_done_tick <= '1';
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
        end case;
    end process;
    
    -- Output
    to_dout <= std_logic_vector(b_reg);

end Behavioral;
