library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clock is
  Port (   clk1ms : in STD_LOGIC;
           change : in STD_LOGIC;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           sw : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC);
end Clock;

architecture Behavioral of Clock is
   
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


component DX2
generic (
        N_bits : integer := 4
      );
    Port ( 
           clk      : in std_logic;
           IN0      : in  STD_LOGIC_VECTOR ((N_bits-1) downto 0);
           en       : in  STD_LOGIC ;
           set      : in  STD_LOGIC;
           Dx_out0  : out STD_LOGIC_VECTOR ((N_bits-1) downto 0):=  (others => '0');
           Dx_out1  : out STD_LOGIC_VECTOR ((N_bits-1) downto 0):=  (others => '0'));
end component;

signal neg_change: std_logic;
signal sig_add_ums:std_logic;
signal sig_add_tms:std_logic;
signal sig_add_us:std_logic;
signal sig_add_ts:std_logic;
signal selected_add:std_logic_vector(0 downto 0);
signal selected_sub:std_logic_vector(0 downto 0);
signal sig_add_ts_mx:std_logic_vector(0 downto 0);
signal sig_add_in:std_logic_vector(0 downto 0);
signal sig_sub_in:std_logic_vector(0 downto 0);
signal sig_add_um:std_logic;
signal sig_sub_um: std_logic;
signal sig_add_tm:std_logic;
signal sig_sub_tm: std_logic; 
signal sig_add_sub_tm: std_logic_vector(1 downto 0);  
signal sig_add_sub_tm_12: std_logic_vector(1 downto 0);  
signal sig_add_sub_tm_24: std_logic_vector(1 downto 0) ; 
signal sig_add_sub_uh_24: std_logic_vector(1 downto 0) ; 
signal sig_add_sub_uh_12: std_logic_vector(1 downto 0) ; 
signal time_24: std_logic_vector(7 downto 0);
signal time_12: std_logic_vector(7 downto 0);

begin

units_ms: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>9
             )
Port map( 
           Reset_value => "0000",
           en  => neg_change,
           add => clk1ms,
           sub => '0',
           clk => clk,
           rst => change,
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
           en  => neg_change,
           add => sig_add_ums,
           sub => '0',
           clk => clk,
           rst => change,
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
           en  => neg_change,
           add => sig_add_tms,
           sub => '0',
           clk => clk,
           rst => change,
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
           en  => neg_change,
           add => sig_add_us,
           sub => '0',
           clk => clk,
           rst => change,
           add_out => sig_add_ts,
           sub_out => open, 
           count => time_out(15 downto 12));               
    

   clock_mx_add: component Mx2
    generic map ( N_bits => 1)
    port map(
   clk => clk,
   IN0 => sig_add_ts_mx,
   IN1 => sig_add_in,
   set => change,
   en => '1',
   MX_out => selected_add
    );

    clock_mx_sub: component Mx2
    generic map ( N_bits => 1)
    port map(
   clk => clk,
   IN0 => "0",
   IN1 => sig_sub_in,
   set => change,
   en => '1',
   MX_out => selected_sub
    );

            
 units_m: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>9
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => selected_add(0),
           sub => selected_sub(0),
           clk => clk,
           rst => '0',
           add_out => sig_add_um,
           sub_out => sig_sub_um,
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
           sub => sig_sub_um,
           clk => clk,
           rst => '0',
           add_out => sig_add_sub_tm(1),
           sub_out => sig_add_sub_tm(0),
           count => time_out(23 downto 20));
          
          
          
          
  clpck_format: component Dx2
    generic map ( N_bits => 2)
    port map(
   clk => clk,
   Dx_Out0 => sig_add_sub_tm_24,
   Dx_Out1 => sig_add_sub_tm_12,
   set => sw,
   en => '1',
   IN0 => sig_add_sub_tm
    );         
          
          
          
          
           
 units_h_24: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>4
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_sub_tm_24(1),
           sub => sig_add_sub_tm_24(0),
           clk => clk,
           rst => '0',
           add_out => sig_add_sub_uh_24(1),
           sub_out => sig_add_sub_uh_24(0),
           count => time_24(3 downto 0));
                     
 tens_h_24: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>2
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_sub_uh_24(1),
           sub => sig_add_sub_uh_24(0),
           clk => clk,
           rst => '0',
           add_out => open,
           sub_out => open,
           count => time_24(7 downto 4));    
           
           
 units_h_12: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>2
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_sub_tm_12(1),
           sub => sig_add_sub_tm_12(0),
           clk => clk,
           rst => '0',
           add_out => sig_add_sub_uh_12(1),
           sub_out => sig_add_sub_uh_12(0),
           count => time_24(3 downto 0));
          
                     
tens_h_12: UD_counter_signaling
Generic map(
    
                NBITS => 4,
                Count_range =>1
             )
Port map( 
           Reset_value => "0000",
           en  => '1',
           add => sig_add_sub_uh_12(1),
           sub => sig_add_sub_uh_12(0),
           clk => clk,
           rst => '0',
           add_out => open,
           sub_out => open,
           count => time_12(7 downto 4));           
                                                  
 out_time_24_12: component Mx2
    generic map ( N_bits => 8)
    port map(
   clk => clk,
   IN0 => time_24,
   IN1 => time_12,
   set => sw,
   en => '1',
   MX_out => time_out(31 downto 24)
    );                                

neg_change <= not(change);
sig_add_ts_mx(0) <= sig_add_ts;
sig_add_in(0) <= add;
sig_sub_in(0) <= sub;


end Behavioral;
