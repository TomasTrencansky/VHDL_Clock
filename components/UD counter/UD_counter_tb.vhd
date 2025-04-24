-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 10 Apr 2025 15:36:30 GMT
-- Request id : cfwk-fed377c2-67f7e57e09fcb

library ieee;
use ieee.std_logic_1164.all;

entity tb_UD_counter is
end tb_UD_counter;

architecture tb of tb_UD_counter is

    component UD_counter
     Generic (
                NBITS : integer := 4
             );
        port (add : in std_logic;
              sub : in std_logic;
              clk : in std_logic;
              rst : in std_logic;
              en  : in std_logic;
              v   : out std_logic_vector (NBITS-1 downto 0));
    end component;
    constant NBITS: integer := 2;
    signal add : std_logic;
    signal sub : std_logic;
    signal clk : std_logic;
    signal rst : std_logic;
    signal en  : std_logic;
    signal v   : std_logic_vector (NBITS-1 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : UD_counter
    generic map ( NBITS => 2)
    port map (add => add,
              sub => sub,
              clk => clk,
              rst => rst,
              v   => v,
              en => en);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process 
    begin
        -- ***EDIT*** Adapt initialization as needed
        add <= '0';
        sub <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- ***EDIT*** Add stimuli here
        en <= '1';
        wait for 10 * TbPeriod;
        add <= '1';
        sub <= '0';
        wait for 10 * TbPeriod;
        add <= '0';
        sub <= '1';
        wait for 13 * TbPeriod;
        en <= '0';
        wait for 10 * TbPeriod;
        add <= '1';
        sub <= '0';
        wait for 10 * TbPeriod;
        add <= '0';
        sub <= '1';
        wait for 10 * TbPeriod;
        add<='0';
        sub<='0';

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_UD_counter of tb_UD_counter is
    for tb
    end for;
end cfg_tb_UD_counter;