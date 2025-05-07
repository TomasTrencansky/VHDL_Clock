library ieee;
use ieee.std_logic_1164.all;

entity tb_Mx8 is
end tb_Mx8;

architecture tb of tb_Mx8 is

    component Mx8
    generic (
        N_bits : integer := 4
      );
    Port (
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            IN2 : in std_logic_vector ((N_bits-1) downto 0);
            IN3 : in std_logic_vector ((N_bits-1) downto 0);
            IN4 : in std_logic_vector ((N_bits-1) downto 0);
            IN5 : in std_logic_vector ((N_bits-1) downto 0);
            IN6 : in std_logic_vector ((N_bits-1) downto 0); 
            IN7 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic_vector (2 downto 0);
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0));
    end component;
    
    
    constant CN_bits : integer := 3 ;
    signal  clk: std_logic;
    signal IN0    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN1    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN2    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN3    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN4    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN5    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN6    : std_logic_vector ((CN_bits-1) downto 0);
    signal IN7    : std_logic_vector ((CN_bits-1) downto 0);
    signal set    : std_logic_vector (2 downto 0);
    signal en     : std_logic;
    signal MX_out : std_logic_vector ((CN_bits-1) downto 0);
    
     constant TbPeriod : time := 10 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
  
begin

    dut : Mx8
    generic map (N_bits => CN_bits)
    port map (
              clk => clk,
              IN0    => IN0,
              IN1    => IN1,
              IN2    => IN2,
              IN3    => IN3,
              IN4    => IN4,
              IN5    => IN5,
              IN6    => IN6,
              IN7    => IN7,
              set    => set,
              en     => en,
              MX_out => MX_out);
              
              TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
              clk <= TbClock;

    stimuli : process
    begin
      
      
      
      
        IN0 <= "000";
        IN1 <= "001";
        IN2 <= "010";
        IN3 <= "011";
        IN4 <= "100";
        IN5 <= "101";
        IN6 <= "110";
        IN7 <= "111";
        en <='0';
        set <="000";
        wait for 100ns;
        en <='1'; 
        set <= "000";
            wait for 100ns;
        set <= "001";
            wait for 100ns;
        set <= "010";
            wait for 100ns;
        set <= "011";
            wait for 100ns;
        set <= "100";
            wait for 100ns;
        set <= "101";
            wait for 100ns;
        set <= "110";
            wait for 100ns;
        set <= "111";
            wait for 100ns;
        TbSimEnded <= '1';
       
        wait;
    end process;

end tb;

configuration cfg_tb_Mx8 of tb_Mx8 is
    for tb
    end for;
end cfg_tb_Mx8;