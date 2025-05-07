library ieee;
use ieee.std_logic_1164.all;

entity tb_An_shifter is
end tb_An_shifter;

architecture tb of tb_An_shifter is

    component An_shifter
        port (clk : in std_logic;
              en  : in std_logic;
              rst : in std_logic;
              AN  : out std_logic_vector (7 downto 0);
              Digit: out std_logic_vector(2 downto 0)
              );
    end component;

    signal clk : std_logic;
    signal en  : std_logic;
    signal rst : std_logic;
    signal AN  : std_logic_vector (7 downto 0);
    signal Digit: std_logic_vector(2 downto 0);
    
    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : An_shifter
    port map (clk => clk,
              en  => en,
              rst => rst,
              AN  => AN,
              Digit =>Digit
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
        wait for 100 ns;
        en <= '0';
        rst <= '1';
        wait for 100 ns;
        rst <= '0'; 
        wait for 100 ns;
        en <= '1';
        wait for 100 ns;
        en <= '0';
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_An_shifter of tb_An_shifter is
    for tb
    end for;
end cfg_tb_An_shifter;