library ieee;
use ieee.std_logic_1164.all;

entity tb_Edge_detector is
end tb_Edge_detector;

architecture tb of tb_Edge_detector is

    component Edge_detector
        port (Input         : in std_logic;
              clk           : in std_logic;
              --previous_input_test: out std_logic; 
              Edge_detected : out std_logic);
    end component;

    signal Input         : std_logic;
    signal clk           : std_logic;
    signal Edge_detected : std_logic;
    --signal previous_input_test: std_logic;
    
     
    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Edge_detector
    port map (Input         => Input,
              clk           => clk,
              --previous_input_test => previous_input_test,
              Edge_detected => Edge_detected
              );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin

        Input <= '0';
        wait for 10 * TbPeriod;
        Input <= '1'; 
        wait for 10 * TbPeriod;
        Input <= '0';
        wait for 10 * TbPeriod;
        Input <= '1' ;
        wait for 10 * TbPeriod;
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_Edge_detector of tb_Edge_detector is
    for tb
    end for;
end cfg_tb_Edge_detector;