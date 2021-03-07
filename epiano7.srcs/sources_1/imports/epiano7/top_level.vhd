----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2021 15:54:24
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
port( rxd : in std_logic;
      rst, clk : in std_logic;
      play : in std_logic;
      speaker : out std_logic;
      led : out std_logic_vector(7 downto 0)


);
end top_level;

architecture Behavioral of top_level is
signal uart_data : std_logic_vector(7 downto 0);
signal rx_done_tick : std_logic;
signal s_tick : std_logic;
signal inc, clr : std_logic;
signal wr : std_logic;
signal ram_data : std_logic_vector(7 downto 0);
signal addr : std_logic_vector(9 downto 0);
signal mute, tick : std_logic;
signal timer_done, timer_on : std_logic;
signal cnvt : std_logic_vector(17 downto 0);

signal led_next, led_reg : std_logic_vector(7 downto 0);

begin
-- BAUD GENERATOR
Buad_generator : entity work.mod_m
    port map( clk => clk, rst => rst, to_s_tick => s_tick );


-- UART
UART : entity work.UART_receiver
    port map( clk => clk, rst => rst, rx => rxd, to_dout => uart_data,
              rx_done_tick => rx_done_tick, from_s_tick => s_tick
    );

-- RAM COUNTER 
RAM_COUNTER : entity work.RAM_Counter
    port map( clk => clk, rst => rst, clr => clr, inc => inc, addr => addr
                
    );


-- RAM 
RAM : entity work.xilinx_one_port_ram_sync
    port map( clk => clk, rst => rst, din => uart_data, we => wr, addr => addr ,
              dout => ram_data            
    );

-- CODE CONVERTER
CODE_CONVERTER : entity work.Code_converter
port map( RAM_data => ram_data, cnvt => cnvt);


-- MOD M COUNTER
mod_m_counter : entity work.mod_m_counter_TFF
port map( clk => clk, rst => rst, din => cnvt, to_s_tick => tick);


-- TOGGLE FLIP FLOP
TFF : entity work.TFF
port map( clk => clk, rst => rst, mute => mute, tick => tick, speaker => speaker);


--TIMER 0.5s
TIMER : entity work.timer
port map(clk => clk, rst => rst, timer_done => timer_done, timer_on => timer_on );


-- CONTROL PATH
control_path : entity work.control_path
port map( clk => clk, rst => rst, play => play, rx_done_tick => rx_done_tick, 
           wr => wr, uart_data => uart_data, clr => clr, inc => inc, ram_data => ram_data,
           timer_on => timer_on, timer_done => timer_done, mute => mute);

--LED 
led <= ram_data;

end Behavioral;
