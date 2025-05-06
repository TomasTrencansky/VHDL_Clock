library ieee;
use ieee.std_logic_1164.all;

entity tb_Change is
end tb_Change;

architecture tb of tb_Change is

    component Change
        port (clk           : in std_logic;
              Input_pulse_1       : in std_logic;
              Input_pulse_2         : in std_logic;
              rst           : in std_logic;
              current_mode: in std_logic_vector (1 downto 0);
              change_0      : out std_logic;
              change_1      : out std_logic;
              change_2      : out std_logic;
              change_active : out std_logic);
    end component;

    signal clk           : std_logic;
    signal Input_pulse_1         : std_logic;
    signal Input_pulse_2         : std_logic;
    signal rst           : std_logic;
    signal current_mode          : std_logic_vector(1 downto 0);
    signal change_0      : std_logic;
    signal change_1      : std_logic;
    signal change_2      : std_logic;
    signal change_active : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Change
    port map (clk           => clk,
              Input_pulse_1       => Input_pulse_1,
              Input_pulse_2         => Input_pulse_2,
              rst           => rst,
              current_mode          => current_mode,
              change_0      => change_0,
              change_1      => change_1,
              change_2      => change_2,
              change_active => change_active);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        Input_pulse_1 <= '0';
        Input_pulse_2 <= '0';
        current_mode  <= "00";
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        
        Input_pulse_1 <= '1';
        wait for 10 * TbPeriod;
        Input_pulse_1 <= '0';
        Input_pulse_2 <= '1';
        wait for 10 * TbPeriod;
        Input_pulse_2 <= '0';
        rst <= '1';
        wait for 10 * TbPeriod;
        rst <= '0';
        Input_pulse_2 <= '1';
        wait for 10 * TbPeriod;
        Input_pulse_2 <= '0';
        rst <= '1';
        Input_pulse_1 <= '1';
        wait for 10 * TbPeriod;
        rst<= '0';
        wait for 10 * TbPeriod;
        current_mode <= "01";
        wait for 10 * TbPeriod;
        current_mode <= "10";
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
