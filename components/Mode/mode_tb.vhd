library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_Mode is
end tb_Mode;

architecture tb of tb_Mode is

    component Mode
      Generic (
                Long_press_time : integer := 200_000_000
             );
        port (
              en    : in std_logic;
              btn_l : in std_logic;
              btn_r : in std_logic;
              CLK100MHZ : in STD_LOGIC;   
            --  p_test : out std_logic;
            --  p_test2 : out std_logic;
              current_mode  : out std_logic_vector (1 downto 0)
           );
              
    end component;
  
    signal en: std_logic;
    signal p_test :  std_logic;
    signal p_test2 :  std_logic;
    signal btn_l : std_logic;
    signal btn_r : std_logic;
    signal clk   : std_logic;
    signal current_mode  : std_logic_vector (1 downto 0);
    constant Ntime: integer := 5;
    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
   
begin

    dut : Mode
    generic map (
    Long_press_time => Ntime
    )
    port map (btn_l => btn_l,
              btn_r => btn_r,
              CLK100MHZ =>clk,
              en => en,
              --p_test => p_test,
             -- p_test2=> p_test2,
              current_mode  => current_mode
             );

    -- Clock generation
    TbClock <= not TbClock  after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
   
    stimuli : process
    begin
        en<='1';
        btn_l <= '1';
        btn_r <= '0';
        wait for 5*TbPeriod;
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        btn_l <= '1';
        btn_r <= '0';
        wait for 11*TbPeriod;
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        btn_l <= '0';
        btn_r <= '1';
        wait for 5*TbPeriod;
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        btn_l <= '0';
        btn_r <= '1';
        wait for 15*TbPeriod;
        en <= '1';
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        
        en<='0';
        btn_l <= '1';
        btn_r <= '0';
        wait for 5*TbPeriod;
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        btn_l <= '1';
        btn_r <= '0';
        wait for 11*TbPeriod;
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        btn_l <= '0';
        btn_r <= '1';
        wait for 5*TbPeriod;
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;
        btn_l <= '0';
        btn_r <= '1';
        wait for 15*TbPeriod;
        en <= '1';
        btn_l <= '0';
        btn_r <= '0';
        wait for 1*TbPeriod;


        wait for 100 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;


configuration cfg_tb_Mode of tb_Mode is
    for tb
    end for;
end cfg_tb_Mode;
