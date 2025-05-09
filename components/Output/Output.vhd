library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Output is
    Generic( Period: integer:= 1000; 
             N_blink_periods: integer:= 100_000_000;
             N_Slow_wake_up: integer:= 1000_000_000
             );

    Port ( 
    
          --test_cur_time: out std_logic_vector(31 downto 0);
          --test_cur_bin: out std_logic_vector(3 downto 0);
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
end Output;

architecture Behavioral of Output is

component clock_enable
generic (
        N_PERIODS : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component; 

component An_shifter
Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in std_logic;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           Digit: out std_logic_vector(2 downto 0)
           );
end component;

component bin2seg is
    port (
        clear : in    std_logic;
        bin   : in    std_logic_vector(3 downto 0);
        seg   : out   std_logic_vector(6 downto 0)
    );
end component;

component Mx8 is
generic (
        N_bits : integer := 4
      );
    Port (
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            IN2 : in std_logic_vector ((N_bits-1) downto 0);
            IN3 : in std_logic_vector ((N_bits-1) downto 0);
            IN4 : in std_logic_vector ((N_bits-1) downto 0);
            IN5 : in std_logic_vector ((N_bits-1) downto 0);
            IN6 : in std_logic_vector ((N_bits-1) downto 0);
            IN7 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic_vector (2 downto 0);
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0) :=(others => '0'));
end component; 

component Mx4 is 
generic (
        N_bits : integer := 4
      );
    Port (
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            IN2 : in std_logic_vector ((N_bits-1) downto 0);
            IN3 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic_vector (1 downto 0);
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0):=(others => '0'));
end component;

component Mx2 is
generic (
        N_bits : integer := 4
      );
    Port (
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic;
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0):=(others => '0'));
end component;

component Blink
  Generic (
    Blink_N_periods: integer := 100_000_000
    );
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           blink_out : out STD_LOGIC);
end component;

component On_For_N

generic
            (
            N_Period: integer :=1000 ;
            N_Slow_wake_up: integer :=100_000_000
             );
        port (clk      : in std_logic;
              rst      : in std_logic;
              start_c  : in std_logic;
              mode     : in std_logic;
              period   : in std_logic_vector (4 downto 0);
              duty_sig : out std_logic);
end component ;

signal sig_bin: std_logic_vector(3 downto 0);
signal sig_clock_alarm: std_logic_vector(31 downto 0);
signal current_time_disp: std_logic_vector(31 downto 0);
signal current_display_diget:std_logic_vector (2 downto 0);
signal neg_display_active: std_logic;
signal display_active: std_logic;
signal shift_pulse: std_logic;
signal sig_leds: std_logic;
signal sig_blink: std_logic;
signal sig_display_change_blink: std_logic;
signal pwm_active: std_logic;
signal sig_wake_res:std_logic; 

begin


    alarm_clock_mx: component Mx2
    generic map ( N_bits => 32)
    port map(
   clk => CLK100MHZ,
   IN0 => time_clock,
   IN1 => time_alarm,
   set => change_alarm,
   en => '1',
   MX_out => sig_clock_alarm
    );
    
    mode_mx: component Mx4
    generic map ( N_bits => 32)
    port map(
   clk => CLK100MHZ,
   IN0 => sig_clock_alarm , --00
   IN1 => time_stopwatch,   --01
   IN2 => time_timer,       --10
   IN3 => (others => '0'),
   set => current_mode,
   en => '1',
   MX_out => current_time_disp
    );
  display_mx: component Mx8
    generic map ( N_bits => 4)
    port map(
   clk => CLK100MHZ,
   IN0 => current_time_disp(3 downto 0),
   IN1 => current_time_disp(7 downto 4),
   IN2 => current_time_disp(11 downto 8),
   IN3 => current_time_disp(15 downto 12),
   IN4 => current_time_disp(19 downto 16),
   IN5 => current_time_disp(23 downto 20),
   IN6 => current_time_disp(27 downto 24),
   IN7 => current_time_disp(31 downto 28),
   set => current_display_diget,
   en => '1',
   MX_out => sig_bin
    );    


    display : component  bin2seg
        port map (
            clear  =>neg_display_active,
            bin    => sig_bin,
            seg(6) => CA,
            seg(5) => CB,
            seg(4) => CC,
            seg(3) => CD,
            seg(2) => CE,
            seg(1) => CF,
            seg(0) => CG
        );
        


Shift_period: clock_enable 
generic map
(  N_PERIODS => Period )
port map (
clk =>CLK100MHZ, 
rst => '0',
pulse => shift_pulse
);

An_shifter_for_display: An_shifter
Port map
( clk => CLK100MHZ,
  en  =>shift_pulse,
  rst =>'0',
  AN => AN,
  Digit => current_display_diget
           );
 
Blik_led: Blink 
generic map (Blink_N_periods => N_blink_periods)
port map(
clk => CLK100MHZ,
en => sig_blink,
blink_out => sig_leds
);     

 

Blik_time_change: Blink 
generic map (Blink_N_periods => N_blink_periods)
port map(
clk => CLK100MHZ,
en => change_active,
blink_out => sig_display_change_blink
);     

Dispal_turn_for_N: On_For_N
generic map
            (
            N_Period => Period,
            N_Slow_wake_up => N_Slow_wake_up 
             )
port map (clk => CLK100MHZ,
              rst => '0',    
              start_c => shift_pulse,
              mode => '0',   
              period =>SW,  
              duty_sig =>pwm_active );

Wakeup_turn_for_N: On_For_N
generic map
            (
            N_Period => Period,
            N_Slow_wake_up => N_Slow_wake_up 
             )
port map (clk => CLK100MHZ,
              rst => sig_wake_res,    
              start_c => shift_pulse,
              mode => '1',   
              period =>SW,  
              duty_sig =>RGB_led );
              
sig_wake_res <= not(alarm_active);
display_active <= sig_display_change_blink and pwm_active;
neg_display_active <= not(display_active);
sig_blink <= timer_runout or alarm_active;
Led(15 downto 3) <= (others =>sig_leds);
Led(2) <= '0';
Led(1 downto 0) <= current_mode;
DP <='1';

--test_cur_time <= current_time_disp;
--test_cur_bin <= sig_bin;
end Behavioral;
