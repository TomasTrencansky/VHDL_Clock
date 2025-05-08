library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_level is
    Port ( 
            LED: out  std_logic_vector (15 downto 0);
            RGB_led: out std_logic_vector (5 downto 0);
            CA: out   std_logic;
            CB: out   std_logic;
            CC: out   std_logic;
            CD: out   std_logic;
            CE: out   std_logic;
            CF: out   std_logic; 
            CG: out   std_logic;  
            DP: out   std_logic;   
            AN: out   std_logic_vector(7 downto 0);              
            SW: in std_logic_vector(6 downto 0);
            CLK100MHZ : in STD_LOGIC;
            BTNU : in STD_LOGIC;
            BTNC : in STD_LOGIC;
            BTND : in STD_LOGIC;
            BTNL : in STD_LOGIC;
            BTNR : in STD_LOGIC);
end Top_level;

architecture Behavioral of Top_level is

component Output 
    Generic( Period: integer:= 1000; 
             N_blink_periods: integer:= 100_000_000;
             N_Slow_wake_up: integer:= 1000_000_000
             );

    Port ( 
            CLK100MHZ : in STD_LOGIC;
            SW: in std_logic_vector(4 downto 0);
            time_clock: in std_logic_vector(31 downto 0);
            time_alarm: in std_logic_vector(31 downto 0);
            time_timer: in std_logic_vector(31 downto 0);
            time_stopwatch: in std_logic_vector(31 downto 0);
            timer_runout: in std_logic;
            alarm_active: in std_logic;
            change_alarm: in std_logic;
            current_mode: in std_logic_vector(1 downto 0);
            change_active:in std_logic;
            Led: out  std_logic_vector (15 downto 0);
            RGB_led: out std_logic;
            CA: out   std_logic;
            CB: out   std_logic;
            CC: out   std_logic;
            CD: out   std_logic;
            CE: out   std_logic;
            CF: out   std_logic; 
            CG: out   std_logic;  
            DP: out   std_logic;   
            AN: out   std_logic_vector(7 downto 0)
          );
end component;

component Input
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
end component;

component clock_enable
generic (
        N_PERIODS : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;

--- Dummy components
component Alarm
    Port ( clk1ms : in STD_LOGIC;
           clk: in std_logic ;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           change : in STD_LOGIC;
           sw : in STD_LOGIC;
           alarm_time : out STD_LOGIC_VECTOR (31 downto 0);
           alarm_aticve : out STD_LOGIC;
           time_in : in STD_LOGIC_VECTOR (31 downto 0));
end component;

component Clock
    Port ( clk1ms : in STD_LOGIC;
           change : in STD_LOGIC;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           sw : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end component;

component Stopwatch
   Port ( clk : in STD_LOGIC;                            
          clk1ms : in STD_LOGIC;                         
          btn : in STD_LOGIC;                            
          long_btn : in STD_LOGIC;                       
          time_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component Timer
    Port ( clk1ms : in STD_LOGIC;
           clk : in STD_LOGIC;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           change : in STD_LOGIC;
           button : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;


signal sig_change_en_timer: std_logic; 
signal sig_change_en_clock: std_logic; 
signal sig_change_en_alarm: std_logic;
signal sig_time_add: std_logic;
signal sig_time_sub: std_logic; 
signal sig_change_blink: std_logic;
signal sig_mode_out: std_logic_vector(1 downto 0);
signal sig_RGB_led: std_logic;
signal sig_time_clock: std_logic_vector(31 downto 0);
signal sig_time_alarm: std_logic_vector(31 downto 0);
signal sig_time_timer: std_logic_vector(31 downto 0);
signal sig_time_stopwatch: std_logic_vector(31 downto 0);
signal sig_timer_runout: std_logic;
signal sig_alarm_active: std_logic;
signal sig_cent: std_logic;
signal long_c: std_logic;
signal sig_clk1ms:std_logic;

begin 

In_comp: Input 
Generic map
    ( 
    Long_press_time => 100_000_000,
    -- Speed up variables
    NT_speed_up => 300_000_000,
    DF_speed => 100_000_000,
    S2_speed => 20_000_000,
    S3_speed => 5_000_000,
    S4_speed => 1_000_000
    )
    Port map( 
           CLK100MHZ  => CLK100MHZ, 
           BTNU  => BTNU,
           BTNC  => BTNC,
           BTND  => BTND,
           BTNL  => BTNL,
           BTNR  => BTNR,
           change_en_timer => sig_change_en_timer,
           change_en_clock => sig_change_en_clock,
           change_en_alarm => sig_change_en_alarm,
           mode_out => sig_mode_out,
           time_add => sig_time_add,
           time_sub => sig_time_sub,
           change_blink => sig_change_blink );
           
 Out_1: Output
   Generic map ( Period => 1000,
             N_blink_periods => 100_000_000,
             N_Slow_wake_up => 1000_000_000
             )

    Port map ( 
            CLK100MHZ  => CLK100MHZ,
            SW         => SW(4 downto 0),
            time_clock => sig_time_clock,
            time_alarm => sig_time_alarm,
            time_timer => sig_time_timer,
            time_stopwatch  => sig_time_stopwatch,
            timer_runout  => sig_timer_runout,
            alarm_active  => sig_alarm_active,
            change_alarm  => sig_change_en_alarm,
            current_mode  => sig_mode_out,
            change_active => sig_change_blink,
            Led           =>  LED,
            RGB_led => sig_RGB_led,
            CA => CA,
            CB => CB,
            CC => CC,
            CD => CD,
            CE => CE,
            CF => CF,
            CG => CG,
            DP => DP,
            AN => AN
          );
          
RGB_led <= (others =>sig_RGB_led);

Long_BTNC: clock_enable 
generic map
(  N_PERIODS => 100_000_000  )
port map (
clk =>CLK100MHZ, 
rst => sig_cent,
pulse => long_c  
);

clk_1ms: clock_enable 
generic map
(  N_PERIODS => 1_000_000  )
port map (
clk =>CLK100MHZ, 
rst => '0',
pulse => sig_clk1ms
);

sig_cent <= Not(BTNC);
  
alarm_1: Alarm
   Port map ( 
           clk1ms => sig_clk1ms,
           clk => CLK100MHZ,
           add => sig_time_add,
           sub => sig_time_sub,
           change => sig_change_en_alarm,
           sw => SW(5),
           alarm_time => sig_time_alarm,
           alarm_aticve => sig_alarm_active,
           time_in => sig_time_clock
           );
clock_1: Clock 
    Port map ( clk1ms  => sig_clk1ms,
           change => sig_change_en_clock,
           add => sig_time_add,
           sub => sig_time_sub,
           sw => SW(6),
           time_out => sig_time_clock,
           clk => CLK100MHZ);
stopwatch_1:Stopwatch        
   Port map(                         
          clk1ms => sig_clk1ms,
          clk => CLK100MHZ,              
          btn => BTNC,                         
          long_btn => long_c,                      
          time_out =>sig_time_stopwatch);   
           
Timer_1: Timer
    Port map ( clk1ms => sig_clk1ms,
           clk => CLK100MHZ,
           add => sig_time_add,
           sub => sig_time_sub,
           change => sig_change_en_timer,
           button => BTNC,
           time_out => sig_time_timer);
end Behavioral;
