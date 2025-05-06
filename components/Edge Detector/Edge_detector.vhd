library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;

entity Edge_detector is
Port (
        Input: in std_logic;
        clk : in std_logic;
        --previous_input_test: out std_logic; 
        Edge_detected: out std_logic
        
     );
end Edge_detector;

architecture Behavioral of Edge_detector is

signal previous_input: std_logic;

begin
 
  edge_deteckt : process(clk)
  begin 
    if rising_edge(clk) then
             previous_input <= Input;
    end if;
  end process;
  
  Edge_detected <= '1' when ((Input ='1') and (previous_input = '0')) else '0';
 -- previous_input_test <= previous_input;
end Behavioral;
