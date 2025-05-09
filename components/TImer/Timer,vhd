library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
Port ( clk1ms : in STD_LOGIC;
           clk : in STD_LOGIC;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           change : in STD_LOGIC;
           button : in STD_LOGIC;
           long_button: in std_logic;
           time_out : out STD_LOGIC_VECTOR (31 downto 0);
           timer_runout: out std_logic);
end Timer;

architecture Behavioral of Timer is

component Set_time_value 
Port (   change : in STD_LOGIC;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end component;

component Countdown 
  Port (   clk : in STD_LOGIC;
           clk1ms : in STD_LOGIC;
           change : in STD_LOGIC;
           btn : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0);
           set_time_in : in STD_LOGIC_VECTOR (31 downto 0);
           time_run_out: out std_logic;
           long_btn : in STD_LOGIC
           );
end component; 

signal sig_set_time_in: std_logic_vector(31 downto 0);
 
 
begin

Countdown_1: Countdown
Port map
(
clk => clk,
clk1ms => clk1ms,
change => change,
btn => button,
time_out => time_out,
set_time_in => sig_set_time_in,
time_run_out => timer_runout,
long_btn => long_button
);

Set_time_value_1: Set_time_value
Port map(   change => change,
           add => add,
           sub => sub,
           time_out => sig_set_time_in,
           clk => clk);



end Behavioral;
