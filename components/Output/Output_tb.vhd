library ieee;
use ieee.std_logic_1164.all;

entity tb_Output is
end tb_Output;

architecture tb of tb_Output is

    component Output 
     Generic( Period: integer:= 1000; 
             N_blink_periods: integer:= 100_000_000;
             N_Slow_wake_up: integer:= 1000_000_000
             );
        port (
           -- test_cur_time: out std_logic_vector(31 downto 0);
           -- test_cur_bin: out std_logic_vector(3 downto 0);
              CLK100MHZ      : in std_logic;
              SW             : in std_logic_vector (4 downto 0);
              time_clock     : in std_logic_vector (31 downto 0);
              time_alarm     : in std_logic_vector (31 downto 0);
              time_timer     : in std_logic_vector (31 downto 0);
              time_stopwatch : in std_logic_vector (31 downto 0);
              timer_runout   : in std_logic;
              alarm_active   : in std_logic;
              change_alarm   : in std_logic;
              current_mode   : in std_logic_vector (1 downto 0);
              change_active  : in std_logic;
              Led            : out std_logic_vector (15 downto 0);
              RGB_led        : out std_logic;
              CA             : out std_logic;
              CB             : out std_logic;
              CC             : out std_logic;
              CD             : out std_logic;
              CE             : out std_logic;
              CF             : out std_logic;
              CG             : out std_logic;
              DP             : out std_logic;
              AN             : out std_logic_vector (7 downto 0));
    end component;
            

  --signal test_cur_time:  std_logic_vector(31 downto 0);
  --signal test_cur_bin:  std_logic_vector(3 downto 0);
    signal CLK100MHZ      : std_logic;
    signal SW             : std_logic_vector (4 downto 0);
    signal time_clock     : std_logic_vector (31 downto 0);
    signal time_alarm     : std_logic_vector (31 downto 0);
    signal time_timer     : std_logic_vector (31 downto 0);
    signal time_stopwatch : std_logic_vector (31 downto 0);
    signal timer_runout   : std_logic;
    signal alarm_active   : std_logic;
    signal change_alarm   : std_logic;
    signal current_mode   : std_logic_vector (1 downto 0);
    signal change_active  : std_logic;
    signal Led            : std_logic_vector (15 downto 0);
    signal RGB_led        : std_logic;
    signal CA             : std_logic;
    signal CB             : std_logic;
    signal CC             : std_logic;
    signal CD             : std_logic;
    signal CE             : std_logic;
    signal CF             : std_logic;
    signal CG             : std_logic;
    signal DP             : std_logic;
    signal AN             : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Output
     Generic map ( Period => 25,
             N_blink_periods =>5,
             N_Slow_wake_up => 5
             )
    port map (
            --test_cur_time  => test_cur_time,
            --test_cur_bin   => test_cur_bin,
              CLK100MHZ      => CLK100MHZ,
              SW             => SW,
              time_clock     => time_clock,
              time_alarm     => time_alarm,
              time_timer     => time_timer,
              time_stopwatch => time_stopwatch,
              timer_runout   => timer_runout,
              alarm_active   => alarm_active, 
              change_alarm   => change_alarm,
              current_mode   => current_mode,
              change_active  => change_active,
              Led            => Led,
              RGB_led        => RGB_led,
              CA             => CA,
              CB             => CB,
              CC             => CC,
              CD             => CD,
              CE             => CE,
              CF             => CF,
              CG             => CG,
              DP             => DP,
              AN             => AN);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        SW <= (others => '0');
        time_clock <= b"0000_0000_0000_0000_0000_0000_0000_0000";
        time_alarm <= b"0000_0000_0000_0000_0000_0000_0000_0001";
        time_timer <= b"0000_0000_0000_0000_0000_0000_0000_0010";
        time_stopwatch <=  b"0000_0000_0000_0000_0000_0000_0000_0011";
        timer_runout <= '0';
        alarm_active <= '0';
        change_alarm <= '0';
        current_mode <= "00";
        change_active <= '0';
        wait for 5 * TbPeriod;
        alarm_active <='1';
        SW <="00111";
        wait for 20 * TbPeriod;
        
        change_alarm <= '1';
        alarm_active <='0';
        wait for 20 * TbPeriod;
        current_mode <= "10";
        wait for 20 * TbPeriod;
        current_mode <= "01";
        wait for 20 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
configuration cfg_tb_Output of tb_Output is
    for tb
    end for;
end cfg_tb_Output;