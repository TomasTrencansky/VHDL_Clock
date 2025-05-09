library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Stopwatch is
  Port (   clk : in STD_LOGIC;
           clk1ms : in STD_LOGIC;
           btn : in STD_LOGIC;
           long_btn : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0));
end Stopwatch;

architecture Behavioral of Stopwatch is
   
component UD_counter_signaling 
Generic (
    
                NBITS : integer := 4;
                Count_range: integer:=40
             );
Port ( 
           Reset_value: std_logic_vector(NBITS-1 downto 0);
           en : in std_logic ;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           clk : in std_logic; 
           rst: in std_logic;
           add_out: out std_logic;
           sub_out: out std_logic;
           count : out STD_LOGIC_VECTOR (NBITS-1 downto 0));
end component;

component Mx2 is
generic (
        N_bits : integer := 4
      );
    Port (
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic;
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0):=(others => '0'));
end component;

component Flip_Flop
 Port ( clk : in STD_LOGIC;
           rst : in std_logic; 
           en : in STD_LOGIC;
           Q_out: out std_logic := '0';
           Q_out_neg: out std_logic := '1'
           );
end component ;

signal sig_clk1ms:std_logic_vector(0 downto 0);
signal sig_clk1ms_in:std_logic_vector(0 downto 0);
signal sig_mx:std_logic;
signal sig_add_ums:std_logic;
signal sig_add_tms:std_logic;
signal sig_add_us:std_logic;
signal sig_add_ts:std_logic;
signal sig_add_ts_mx:std_logic_vector(0 downto 0);
signal sig_add_um:std_logic;
signal sig_add_tm:std_logic;
signal sig_add_uh_24: std_logic; 

begin

Flip_flop_1: Flip_Flop
port map(
clk => clk,
rst => long_btn,
en =>btn,
Q_out=> open,
Q_out_neg => sig_mx
);

sig_clk1ms_in(0) <= clk1ms;

 clk_ms: component Mx2
    generic map ( N_bits => 1)
    port map(
   clk => clk,
   IN0 => "0",
   IN1 => sig_clk1ms_in,
   set => sig_mx,
   en => '1',
   MX_out => sig_clk1ms
    );        







units_ms: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>9
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_clk1ms(0),
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_ums,
           sub_out => open, 
           count => time_out(3 downto 0));
           
tens_ms: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>9
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_ums,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_tms,
           sub_out => open, 
           count => time_out(7 downto 4));
    
units_s: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>9
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_tms,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_us,
           sub_out => open, 
           count => time_out(11 downto 8));
           
tens_s: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>6
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_us,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_ts,
           sub_out => open, 
           count => time_out(15 downto 12));               
    

            
 units_m: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>9
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_us,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_um,
           sub_out => open,
           count => time_out(19 downto 16));
                     
 tens_m: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>5
             )
Port map( 
           Reset_value => "0000", 
           en  => '1',
           add => sig_add_um,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_tm,
           sub_out => open,
           count => time_out(23 downto 20));
      
 units_h_24: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>4
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_tm,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => sig_add_uh_24,
           sub_out => open,
           count => time_out(27 downto 24));
                     
 tens_h_24: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>2
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_uh_24,
           sub => '0',
           clk => clk,
           rst => long_btn,
           add_out => open,
           sub_out => open,
           count => time_out(31 downto 28));    
           

sig_add_ts_mx(0) <= sig_add_ts;



end Behavioral;
