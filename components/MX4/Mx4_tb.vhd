library ieee;
use ieee.std_logic_1164.all;

entity tb_Mx4 is
end tb_Mx4;

architecture tb of tb_Mx4 is

    component Mx4
    generic (
        N_bits : integer := 4
      );
        port ( clk : in std_logic;
              IN0    : in std_logic_vector ((N_bits-1) downto 0);
              IN1    : in std_logic_vector ((N_bits-1) downto 0);
              IN2    : in std_logic_vector ((N_bits-1) downto 0);
              IN3    : in std_logic_vector ((N_bits-1) downto 0);
              set    : in std_logic_vector (1 downto 0);
              en     : in std_logic;
              MX_out : out std_logic_vector ((N_bits-1) downto 0));
    end component;
    
    
    constant CN_bits : integer := 2 ;
    signal    clk : std_logic;
    signal IN0    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN1    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN2    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN3    : std_logic_vector ((CN_bits-1) downto 0);
    signal set    : std_logic_vector (1 downto 0);
    signal en     : std_logic;
    signal MX_out : std_logic_vector ((CN_bits-1) downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Mx4
    generic map 
    ( N_bits => CN_bits)
    port map (
              clk => clk,
              IN0    => IN0,
              IN1    => IN1,
              IN2    => IN2,
              IN3    => IN3,
              set    => set,
              en     => en,
              MX_out => MX_out);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        IN0 <= "00";
        IN1 <= "01";
        IN2 <= "10";
        IN3 <= "11";
        en <='0';
        set <="00";
        wait for 100ns;   
        en <='1';
        en <='1';
        set <= "00";
        wait for 100ns;
        set <= "01";
        wait for 100ns;
        set<="10";
        wait for 100ns;
        set<="11";
        wait for 100ns;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
configuration cfg_tb_Mx4 of tb_Mx4 is
    for tb
    end for;
end cfg_tb_Mx4;