library ieee;
use ieee.std_logic_1164.all;

entity tb_Input is
end tb_Input;

architecture tb of tb_Input is

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
        port (
              CLK100MHZ       : in std_logic;
              BTNU            : in std_logic;
              BTNC            : in std_logic;
              BTND            : in std_logic;
              BTNL            : in std_logic;
              BTNR            : in std_logic;
              change_en_timer : out std_logic;
              change_en_clock : out std_logic;
              change_en_alarm : out std_logic;
              mode_out        : out std_logic_vector (1 downto 0);
              time_add        : out std_logic;
              time_sub        : out std_logic;
              change_blink    : out std_logic);
    end component;

    signal CLK100MHZ       : std_logic;
    signal BTNU            : std_logic;
    signal BTNC            : std_logic;
    signal BTND            : std_logic;
    signal BTNL            : std_logic;
    signal BTNR            : std_logic;
    signal change_en_timer : std_logic;
    signal change_en_clock : std_logic;
    signal change_en_alarm : std_logic;
    signal mode_out        : std_logic_vector (1 downto 0);
    signal time_add        : std_logic;
    signal time_sub        : std_logic;
    signal change_blink    : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Input
    generic map
    (Long_press_time => 10,
     NT_speed_up => 15,
     DF_speed => 8,
     S2_speed =>4,
     S3_speed =>2,
     S4_speed =>1
     
    )
    port map (CLK100MHZ       => CLK100MHZ,
              BTNU            => BTNU,
              BTNC            => BTNC,
              BTND            => BTND,
              BTNL            => BTNL,
              BTNR            => BTNR,
              change_en_timer => change_en_timer,
              change_en_clock => change_en_clock,
              change_en_alarm => change_en_alarm,
              mode_out        => mode_out,
              time_add        => time_add,
              time_sub        => time_sub,
              change_blink    => change_blink);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        BTNU <= '0';
        BTNC <= '0';
        BTND <= '0';
        BTNL <= '0';
        BTNR <= '0';
        wait for 1 * TbPeriod;
        BTNU<='1';
        wait for 25 * TbPeriod;
        BTNU<='0';
        wait for 2 * TbPeriod;
        BTNU<='1';
        BTNL<='1';
        wait for 7 * TbPeriod;
        BTNU<='0';
        BTNL<='0';
        BTNC<='1';
        wait for 25 * TbPeriod;        
        BTNC<='0';
        BTNL<='1';
        wait for 25 * TbPeriod;  
        BTNL<='0';
        BTNU<='1';
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_Input of tb_Input is
    for tb
    end for;
end cfg_tb_Input;

