library ieee;
use ieee.std_logic_1164.all;

entity tb_Mx2 is
end tb_Mx2;

architecture tb of tb_Mx2 is

    component Mx2
    generic (
        N_bits : integer := 4
      );
    Port (  
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic;
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0));
    end component;
    
    
    constant CN_bits : integer := 1 ;
    signal IN0    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN1    : std_logic_vector ((CN_bits-1) downto 0);
    signal set    : std_logic;
    signal en     : std_logic;
    signal MX_out : std_logic_vector ((CN_bits-1) downto 0);
    signal  clk :  std_logic;
    
    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Mx2
    generic map ( N_bits => CN_bits)
    port map (
              clk => clk, 
              IN0    => IN0,
              IN1    => IN1,
              set    => set,
              en     => en,
              MX_out => MX_out);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;
    
    stimuli : process
    begin
        set <='1';
        IN0 <= "0";
        IN1 <= "1";
        en <='0';
        wait for 100ns;
        en <='1';
        set <= '0';
        wait for 100ns;
        set <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_Mx2 of tb_Mx2 is
    for tb
    end for;
end cfg_tb_Mx2;