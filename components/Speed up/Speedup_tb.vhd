library ieee;
use ieee.std_logic_1164.all;

entity tb_Speedup is
end tb_Speedup;

architecture tb of tb_Speedup is

    component Speedup
    Generic (
                NT_speed_up : integer := 300_000_000;
                DF_speed : integer := 100_000_000;
                S2_speed : integer := 20_000_000;
                S3_speed : integer := 5_000_000;
                S4_speed : integer := 1_000_000
                
                
              );
        port (clk   : in std_logic;
              Btn   : in std_logic;
   --           TEST1: out  integer ;
   --           TEST2: out  integer ;
   --           TEST3:  out integer ;
              rst   : in std_logic;
              pulse : out std_logic);
    end component;

    signal clk   : std_logic;
    signal Btn   : std_logic;
    signal rst   : std_logic;
    signal pulse : std_logic;
   -- signal TEST1: integer ;
   --signal TEST2:  integer ;
   -- signal TEST3:  integer ;
    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Speedup
    generic map (
    NT_speed_up => 25,
    DF_speed =>12,
    S2_speed =>8,
    S3_speed =>4,
    S4_speed =>2)
    
    port map (clk   => clk,
              Btn   => Btn,
              rst   => rst,
              --TEST1 => TEST1,
              --TEST2 => TEST2,
              --TEST3 => TEST3,
              pulse => pulse);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        Btn <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        Btn <= '1';
        wait for 30 * TbPeriod;
        Btn <= '0';
        wait for 3 * TbPeriod;
        Btn <= '1';
        wait for 200 * TbPeriod;
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Speedup of tb_Speedup is
    for tb
    end for;
end cfg_tb_Speedup;
