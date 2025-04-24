
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mode is
    Generic (
                Long_press_time : integer := 200_000_000 
             );
    Port (
           en:  in std_logic;
           btn_l : in STD_LOGIC;
           btn_r : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           
           --p_test : out std_logic;
           --p_test2 : out std_logic;
           
           m : out std_logic_vector(1 downto 0)
            );
end Mode;




architecture Behavioral of Mode is

component UD_counter 
    Generic (
                NBITS : integer := 2
             );
    Port ( 
           en  : in std_logic ;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           clk : in std_logic;
           rst: in std_logic;
           v : out STD_LOGIC_VECTOR (NBITS-1 downto 0)
          
           
           );
           
       
         
end component;

component clock_enable
generic (
        N_PERIODS : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;

signal padd: std_logic;
signal psub: std_logic;
signal srst: std_logic;
signal smode: std_logic_vector(1 downto 0);
signal btn_in_l:std_logic;
signal btn_in_r:std_logic; 

begin

BTNL: clock_enable 
generic map
(  N_PERIODS => Long_press_time  )
port map (
clk =>CLK100MHZ, 
rst => btn_in_l,
pulse =>  padd
);

BTNR: clock_enable 
generic map
(  N_PERIODS => Long_press_time )
port map (
clk =>CLK100MHZ, 
rst => btn_in_r,
pulse =>  psub
);

Switcher : UD_counter
  Generic map
  ( NBITS => 2  )
    Port map( 
           en => en,
           add => padd, 
           sub => psub,
           clk =>CLK100MHZ,
           rst => '0',
           v =>smode
  );
m <= smode; 
srst <= (smode(1) AND smode(0)); 

btn_in_l <= Not(btn_l);
btn_in_r <= Not(btn_r); 
--p_test <= padd;
--p_test2 <= psub;
 
end Behavioral;
