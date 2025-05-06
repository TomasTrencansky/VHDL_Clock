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
              count   : out std_logic_vector (NBITS-1 downto 0));
    end component;
    constant NBITS: integer := 2;
    signal add : std_logic;
    signal sub : std_logic;
    signal clk : std_logic;
    signal rst : std_logic;
    signal en  : std_logic;
    signal count   : std_logic_vector (NBITS-1 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : UD_counter
    generic map ( NBITS => 2)
    port map (add => add,
              sub => sub,
              clk => clk,
              rst => rst,
              count   => count,
              en => en);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process 
    begin
        add <= '0';
        sub <= '0';
        en <= '1';
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        
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
        wait for 10 * TbPeriod;
        en<='1';
        add<='1';
        sub<='1';
        wait for 10 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;
configuration cfg_tb_UD_counter of tb_UD_counter is
    for tb
    end for;
end cfg_tb_UD_counter;
