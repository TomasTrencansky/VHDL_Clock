library ieee;
use ieee.std_logic_1164.all;

entity tb_UD_counter_signaling is
end tb_UD_counter_signaling;

architecture tb of tb_UD_counter_signaling is

    component UD_counter_signaling
     Generic (
                NBITS : integer := 4;
                Count_range: integer:=40
             );
        port (
              --test: out integer range Count_range downto 0 :=0;
              add : in std_logic;
              sub : in std_logic;
              clk : in std_logic;
              rst : in std_logic;
              en  : in std_logic;
              add_out: out std_logic;
              sub_out: out std_logic;
              count   : out std_logic_vector (NBITS-1 downto 0));
    end component;
    
    --signal test: integer range 6 downto 0 :=0;
    signal add_out: std_logic;
    signal sub_out: std_logic;
    constant NBITS: integer := 4;
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

    dut : UD_counter_signaling
    generic map ( NBITS => 4,
                  Count_range =>6)
    port map (
              --test => test,
              sub_out => sub_out,
              add_out => add_out,
              add => add,
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
configuration cfg_tb_UD_counter_signaling of tb_UD_counter_signaling is
    for tb
    end for;
end cfg_tb_UD_counter_signaling;