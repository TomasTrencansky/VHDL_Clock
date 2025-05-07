library ieee;
use ieee.std_logic_1164.all;

entity tb_Flip_Flop is
end tb_Flip_Flop;

architecture tb of tb_Flip_Flop is

    component Flip_Flop
        port (clk   : in std_logic;
              rst   : in std_logic;
              en    : in std_logic;
              Q_out: out std_logic := '0';
              Q_out_neg: out std_logic := '1');
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal en    : std_logic;
    signal Q_out : std_logic;
    signal Q_out_neg: std_logic;
    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Flip_Flop
    port map (clk   => clk,
              rst   => rst,
              en    => en,
              Q_out => Q_out,
              Q_out_neg => Q_out_neg
              );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
     
        en <= '0';
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        en <= '1';
        wait for 1 * TbPeriod;
        en <= '0';
        wait for 10 * TbPeriod;
        en <= '1';
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_Flip_Flop of tb_Flip_Flop is
    for tb
    end for;
end cfg_tb_Flip_Flop;