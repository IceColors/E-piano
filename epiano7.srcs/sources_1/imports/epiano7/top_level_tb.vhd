library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_tb is
   -- Port ();
end top_level_tb;

architecture arch of top_level_tb is
constant clk_period : time := 10 ns;
constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us

constant rx_data_ascii_q: std_logic_vector(7 downto 0) := x"71"; -- receive q
constant rx_data_ascii_w: std_logic_vector(7 downto 0) := x"77"; -- receive w
constant rx_data_ascii_e: std_logic_vector(7 downto 0) := x"45"; -- receive e
constant rx_data_ascii_r: std_logic_vector(7 downto 0) := x"72"; -- receive r
constant rx_data_ascii_t: std_logic_vector(7 downto 0) := x"74"; -- receive t
constant rx_data_ascii_y: std_logic_vector(7 downto 0) := x"79"; -- receive y
constant rx_data_ascii_u: std_logic_vector(7 downto 0) := x"75"; -- receive u

constant rx_data_ascii_a: std_logic_vector(7 downto 0) := x"61"; -- receive a
constant rx_data_ascii_s: std_logic_vector(7 downto 0) := x"73"; -- receive s
constant rx_data_ascii_d: std_logic_vector(7 downto 0) := x"64"; -- receive d
constant rx_data_ascii_f: std_logic_vector(7 downto 0) := x"66"; -- receive f
constant rx_data_ascii_g: std_logic_vector(7 downto 0) := x"67"; -- receive g
constant rx_data_ascii_h: std_logic_vector(7 downto 0) := x"68"; -- receive h
constant rx_data_ascii_j: std_logic_vector(7 downto 0) := x"6A"; -- receive j

Component top_level
Port ( clk, rst: in std_logic;
       rxd, play: in std_logic;
       speaker: out std_logic
      );
end Component;

signal clk, rst: std_logic;
signal rxd, play, speaker: std_logic;

begin

    uut: top_level
    Port Map(clk => clk, rst => rst, 
             rxd => rxd, play => play, speaker => speaker);
    
    clk_process: process 
            begin
               clk <= '0';
               wait for clk_period/2;
               clk <= '1';
               wait for clk_period/2;
            end process; 
        
     stim: process
        begin
        rst <= '1';
        play <= '0';
        wait for clk_period*2;
        rst <= '0';
        wait for clk_period*2;
                
                -- Q
                rxd <= '0'; 
                wait for bit_period;
                for i in 0 to 7 loop
                    rxd <= rx_data_ascii_q(i);  
                    wait for bit_period;
                end loop;
                rxd <= '1'; 
                wait for 1ms;
                
                -- W
                rxd <= '0'; 
                wait for bit_period;
                for i in 0 to 7 loop
                    rxd <= rx_data_ascii_w(i);
                    wait for bit_period;
                end loop;
                rxd <= '1'; 
                wait for 1ms;
                
                -- A
                rxd <= '0'; 
                wait for bit_period;
                for i in 0 to 7 loop
                    rxd <= rx_data_ascii_a(i);
                    wait for bit_period;
                end loop;
                rxd <= '1';
                wait for 1ms;
                
                -- and then play for playback from ram
                play <= '1';
                wait;
       
        end process;
end arch;
