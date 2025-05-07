library ieee;
use ieee.std_logic_1164.all;

entity tb_Blink is
end tb_Blink;

architecture tb of tb_Blink is

    component Blink
        Generic (
    Blink_N_periods: integer := 100_000_000
    );
        port (clk   : in std_logic;
              en    : in std_logic;
              blink_out : out std_logic);
    end component;

    signal clk   : std_logic;
    signal en    : std_logic;
    signal blink_out : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Blink
    generic map ( Blink_N_periods =>5)
    port map (clk   => clk,
              en    => en,
              blink_out => blink_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        en <= '0';
        wait for 20 * TbPeriod;
        en<= '1';
        wait for 30 * TbPeriod;
        en<='0';
        wait for 10 * TbPeriod;
        en<= '1';
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_Blink of tb_Blink is
    for tb
    end for;
end cfg_tb_Blink;