library ieee;
use ieee.std_logic_1164.all;

entity tb_On_For_N is
end tb_On_For_N;

architecture tb of tb_On_For_N is

    component On_For_N
      generic
            (
            N_Period: integer :=1000 ;
            N_Slow_wake_up: integer :=100_000_000
             );
        port (clk      : in std_logic;
--            test_cur_s: out integer range 0 to 25 :=0;
--            test_if: out integer range 0 to 25 ;
              rst      : in std_logic;
              start_c  : in std_logic;
              mode     : in std_logic;
              period   : in std_logic_vector (4 downto 0);
              duty_sig : out std_logic);
    end component;

--  signal test_cur_s:  integer range 0 to 25 :=0;
--  signal test_if:  integer range 0 to 650;
    signal clk      : std_logic;
    signal rst      : std_logic;
    signal start_c  : std_logic;
    signal mode     : std_logic;
    signal period   : std_logic_vector (4 downto 0);
    signal duty_sig : std_logic;

    constant TbPeriod : time := 10 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : On_For_N
    generic map (
                 N_Period => 25,
                 N_Slow_wake_up =>15
     
                )
    port map (
--            test_cur_s => test_cur_s,
--            test_if => test_if,
              clk      => clk,
              rst      => rst,
              start_c  => start_c,
              mode     => mode,
              period   => period,
              duty_sig => duty_sig);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        start_c <= '0';
        mode <= '0';
        period <= (others => '0');
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        start_c <= '1';
        wait for 1* TbPeriod;
        start_c <= '0';
        wait for 25* TbPeriod;
        start_c <= '1';
        wait for 1* TbPeriod;
        start_c <= '0';
        wait for 25* TbPeriod;
        start_c <= '1';
        period <= "00110";
        wait for 1* TbPeriod;
        start_c <= '0';
        wait for 25* TbPeriod;
        start_c <= '1';
        wait for 1* TbPeriod;
        start_c <= '0';
        wait for 25* TbPeriod;
        
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
configuration cfg_tb_On_For_N of tb_On_For_N is
    for tb
    end for;
end cfg_tb_On_For_N;