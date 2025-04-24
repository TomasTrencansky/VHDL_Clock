-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Mon, 21 Apr 2025 15:06:52 GMT
-- Request id : cfwk-fed377c2-68065f0cdd9ed

library ieee;
use ieee.std_logic_1164.all;

entity tb_Change is
end tb_Change;

architecture tb of tb_Change is

    component Change
        port (clk           : in std_logic;
              Btn_1       : in std_logic;
              Btn_2         : in std_logic;
              rst           : in std_logic;
              mode: in std_logic_vector (1 downto 0);
              change_0      : out std_logic;
              change_1      : out std_logic;
              change_2      : out std_logic;
              change_active : out std_logic);
    end component;

    signal clk           : std_logic;
    signal Btn_1         : std_logic;
    signal Btn_2         : std_logic;
    signal rst           : std_logic;
    signal mode          : std_logic_vector(1 downto 0);
    signal change_0      : std_logic;
    signal change_1      : std_logic;
    signal change_2      : std_logic;
    signal change_active : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Change
    port map (clk           => clk,
              Btn_1       => Btn_1,
              Btn_2         => Btn_2,
              rst           => rst,
              mode          => mode,
              change_0      => change_0,
              change_1      => change_1,
              change_2      => change_2,
              change_active => change_active);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        Btn_1 <= '0';
        Btn_2 <= '0';
        mode  <= "00";
        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        
        Btn_1 <= '1';
        wait for 10 * TbPeriod;
        Btn_1 <= '0';
        Btn_2 <= '1';
        wait for 10 * TbPeriod;
        Btn_2 <= '0';
        rst <= '1';
        wait for 10 * TbPeriod;
        rst <= '0';
        Btn_2 <= '1';
        wait for 10 * TbPeriod;
        Btn_2 <= '0';
        rst <= '1';
        Btn_1 <= '1';
        wait for 10 * TbPeriod;
        rst<= '0';
        wait for 10 * TbPeriod;
        mode <= "01";
        wait for 10 * TbPeriod;
        mode <= "10";
        
        wait for 10 * TbPeriod;  
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
