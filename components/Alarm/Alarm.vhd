library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Alarm is
   Port (  clk: in std_logic;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           change : in STD_LOGIC;
           sw : in STD_LOGIC;
           btn: in std_logic;
           alarm_time : out STD_LOGIC_VECTOR (31 downto 0);
           alarm_active : out STD_LOGIC;
           time_in : in STD_LOGIC_VECTOR (31 downto 0));
end Alarm;

architecture Behavioral of Alarm is

component Set_time_value 
Port (   change : in STD_LOGIC;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end component;

signal sig_set_time_in: std_logic_vector(31 downto 0);

begin

Set_time_value_1: Set_time_value
Port map(  change => change,
           add => add,
           sub => sub,
           time_out => sig_set_time_in,
           clk => clk);
           
 alarm_active <= '0' when btn = '1';  
 alarm_active <= '1' when (sig_set_time_in = time_in) and ( sw= '1');
 alarm_time <= sig_set_time_in;
         
           
end Behavioral;
