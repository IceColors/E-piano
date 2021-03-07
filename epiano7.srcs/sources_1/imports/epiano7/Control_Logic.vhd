library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Path is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           play : in STD_LOGIC;
           uart_data : in STD_LOGIC_VECTOR(7 downto 0);
           rx_done_tick : in STD_LOGIC;
           clr : out STD_LOGIC;
           inc : out STD_LOGIC;
           timer_done : in STD_LOGIC;
           ram_data : in STD_LOGIC_VECTOR(7 downto 0);
           timer_on : out STD_LOGIC;
           wr : out STD_LOGIC;
           mute : out STD_LOGIC);
end Control_Path;

architecture Behavioral of Control_Path is

type state is (Initial, PlayState, MuteState, CheckForMuteAndPlay, WriteToRAM);

signal state_reg, state_nxt : state;

begin

process (rst, clk)
    begin
        if (rst = '1') then
            state_reg <= Initial;
        elsif (rising_edge(clk)) then
            state_reg <= state_nxt;
        end if;
    end process;
    
process (state_reg, play, uart_data, rx_done_tick, timer_done, ram_data)
    begin
        state_nxt <= state_reg;
        wr <= '0';
        mute <= '0';
        timer_on <= '0';
        clr <= '0';
        inc <= '0';
        case state_reg is
            when Initial =>
                clr <= '1';
                mute <= '1';
                if (rx_done_tick = '1' and 
                (uart_data = "01100001" or uart_data = "01110011" or uart_data = "01100100" or             -- a s d
                 uart_data = "01100110" or uart_data = "01100111" or uart_data = "01101000"                 -- f g h
                 or uart_data = "01101010" or uart_data = "01110001" or uart_data = "01110111"              -- j q w
                 or uart_data = "01100101" or uart_data = "01110010" or uart_data = "01110100"              -- e r t
                 or uart_data = "01111001" or uart_data = "01110101" or uart_data = "00001101")) then       -- y u CR
                    state_nxt <= WriteToRAM;
                else
                    state_nxt <= Initial;
                end if;          
            when WriteToRAM =>
                wr <= '1';
                state_nxt <= CheckForMuteAndPlay;
            when CheckForMuteAndPlay =>
                if (play = '1') then
                    clr <= '1';
                    state_nxt <= PlayState;
                elsif (uart_data = "00010000") then
                    state_nxt <= MuteState;
                elsif (rx_done_tick = '1' and 
                (uart_data = "01100001" or uart_data = "01110011" or uart_data = "01100100"                -- a s d
                 or uart_data = "01100110" or uart_data = "01100111" or uart_data = "01101000"              -- f g h
                 or uart_data = "01101010" or uart_data = "01110001" or uart_data = "01110111"              -- j q w
                 or uart_data = "01100101" or uart_data = "01110010" or uart_data = "01110100"              -- e r t
                 or uart_data = "01111001" or uart_data = "01110101")) then                                 -- y u
                    inc <= '1';
                    state_nxt <= WriteToRAM;
                else
                    state_nxt <= CheckForMuteAndPlay;
                end if;
            when MuteState =>
                mute <= '1';
                if (rx_done_tick = '1' and 
                (uart_data = "01100001" or uart_data = "01110011" or uart_data = "01100100"                -- a s d
                 or uart_data = "01100110" or uart_data = "01100111" or uart_data = "01101000"              -- f g h
                 or uart_data = "01101010" or uart_data = "01110001" or uart_data = "01110111"              -- j q w
                 or uart_data = "01100101" or uart_data = "01110010" or uart_data = "01110100"              -- e r t
                 or uart_data = "01111001" or uart_data = "01110101")) then                                 -- y u
                    inc <= '1';
                    state_nxt <= WriteToRAM;
                else
                    state_nxt <= MuteState;  
                end if;
            when PlayState =>
                timer_on <= '1';
                if (rx_done_tick = '1' and 
                (uart_data = "01100001" or uart_data = "01110011" or uart_data = "01100100"                -- a s d
                 or uart_data = "01100110" or uart_data = "01100111" or uart_data = "01101000"              -- f g h
                 or uart_data = "01101010" or uart_data = "01110001" or uart_data = "01110111"              -- j q w
                 or uart_data = "01100101" or uart_data = "01110010" or uart_data = "01110100"              -- e r t
                or uart_data = "01111001" or uart_data = "01110101")) then                                  -- y u
                    inc <= '1';
                    state_nxt <= WriteToRAM;
                elsif (play = '0') then
                    state_nxt <= CheckForMuteAndPlay;
                elsif (not (ram_data = "01100001" or ram_data = "01110011" or ram_data = "01100100"  -- a s d
                 or ram_data = "01100110" or ram_data = "01100111" or ram_data = "01101000"                  -- f g h
                 or ram_data = "01101010" or ram_data = "01110001" or ram_data = "01110111"              -- j q w
                 or ram_data = "01100101" or ram_data = "01110010" or ram_data = "01110100"              -- e r t
                 or ram_data = "01111001" or ram_data = "01110101")) then                                 -- y u
                     clr <= '1';
                     state_nxt <= CheckForMuteAndPlay;                              
                elsif (timer_done = '1') then
                    inc <= '1';
                    state_nxt <= PlayState;
                else 
                    state_nxt <= PlayState;
                end if;
        end case;        
    end process;

end Behavioral;