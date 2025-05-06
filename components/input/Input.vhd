library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Input is
    Generic
    ( 
    Long_press_time : integer := 100_000_000;
    -- Speed up variables
    NT_speed_up : integer := 300_000_000;
    DF_speed : integer := 100_000_000;
    S2_speed : integer := 20_000_000;
    S3_speed : integer := 5_000_000;
    S4_speed : integer := 1_000_000
    );
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           change_en_timer : out STD_LOGIC;
           change_en_clock : out STD_LOGIC;
           change_en_alarm : out STD_LOGIC;
           mode_out : out STD_LOGIC_VECTOR (1 downto 0);
           time_add : out std_logic;
           time_sub : out std_logic;
           change_blink : out STD_LOGIC);
end Input;

architecture Behavioral of Input is

component Edge_detector 
Port (
        Sig_in: in std_logic;
        clk : in std_logic; 
        Edge_detected: out std_logic
        
     );
     end component;

component Change
Port ( clk : in std_logic;
           Input_pulse_1  : in STD_LOGIC;  --  long UP / Down button
           Input_pulse_2 : in STD_LOGIC;  -- long C button
           rst : in STD_LOGIC;    -- C button
           current_mode: in std_logic_vector (1 downto 0);
           change_0 : out STD_LOGIC;
           change_1 : out STD_LOGIC;
           change_2 : out std_logic;
           change_active : out STD_LOGIC);
end component;

component clock_enable
generic (
        N_PERIODS : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;

component Mode 
Generic (
                Long_press_time : integer := 200_000_000
             );
    Port (
           en : in std_logic ;
           btn_l : in STD_LOGIC;
           btn_r : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           current_mode : out std_logic_vector(1 downto 0)
           
            );
 end component;
 
component Speedup 
Generic (
                NT_speed_up : integer := 300_000_000;
                DF_speed : integer := 100_000_000;
                S2_speed : integer := 20_000_000;
                S3_speed : integer := 5_000_000;
                S4_speed : integer := 1_000_000
              );
    Port ( clk : in STD_LOGIC;
           Btn : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;

signal long_u: std_logic ;
signal long_d: std_logic ;
signal long_c: std_logic ;
signal sig_up: std_logic ;
signal sig_down: std_logic ;
signal sig_cent: std_logic ;
signal change_active: std_logic;
signal sig_mode: std_logic_vector (1 downto 0);
signal up_down_or: std_logic;
signal en_mode:std_logic ;
signal speedup_reset: std_logic;

begin
en_mode <= not(change_active);
sig_up <= Not(BTNU);
sig_down <= Not(BTND);
sig_cent <= Not(BTNC);
up_down_or <= long_u OR long_d;
 
-- Long press 
Long_BTNU: clock_enable 
generic map
(  N_PERIODS => Long_press_time  )
port map (
clk =>CLK100MHZ, 
rst => sig_up,
pulse => long_u 
);

Long_BTND: clock_enable 
generic map
(  N_PERIODS => Long_press_time  )
port map (
clk =>CLK100MHZ, 
rst => sig_down ,
pulse =>  long_d
);

Long_BTNC: clock_enable 
generic map
(  N_PERIODS => Long_press_time  )
port map (
clk =>CLK100MHZ, 
rst => sig_cent,
pulse => long_c  
);

-- Speed up 
Speed_up_u: Speedup
generic map
(
NT_speed_up => NT_speed_up,
DF_speed => DF_speed,
S2_speed => S2_speed,
S3_speed => S3_speed,
S4_speed => S3_speed
)
Port map
( clk =>CLK100MHZ,
  Btn =>BTNU,
  rst =>speedup_reset,
  pulse =>time_add);

Speed_up_d: Speedup
generic map
(
NT_speed_up => NT_speed_up,
DF_speed => DF_speed,
S2_speed => S2_speed,
S3_speed => S3_speed,
S4_speed => S3_speed
)
Port map
( clk =>CLK100MHZ,
  Btn =>BTND,
  rst =>speedup_reset,
  pulse =>time_sub);
  
-- Mode switch 
Switch_mode: Mode  
Generic map (
                Long_press_time => Long_press_time
                )
    Port map (
            en => en_mode,
           btn_l => BTNL,
           btn_r => BTNR,
           CLK100MHZ => CLK100MHZ,
           current_mode => sig_mode  
            );
            
 mode_out <= sig_mode;
-- change 
change_processor: Change 
Port map 
( clk => CLK100MHZ,
  Input_pulse_1  => up_down_or,
  Input_pulse_2 => long_c,  -- long C button
  rst => BTNC,  -- C button
  current_mode => sig_mode,
  change_0 => change_en_clock,
  change_1 =>change_en_alarm,
  change_2 =>change_en_timer,
  change_active => change_active);

change_active_edge_detect: Edge_detector
port map   
(
Sig_in =>change_active,
clk => CLK100MHZ,
Edge_detected => speedup_reset

);

 change_blink <= change_active;
 
end Behavioral;
 
