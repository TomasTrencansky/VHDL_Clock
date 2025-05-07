library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Blink is
    Generic (
    Blink_N_periods: integer := 100_000_000
    );
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           blink_out : out STD_LOGIC);
end Blink;

architecture Behavioral of Blink is

component clock_enable
generic (
        N_PERIODS : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component; 

component Flip_Flop
 Port ( clk : in STD_LOGIC;
           rst : in std_logic; 
           en : in STD_LOGIC;
           Q_out: out std_logic := '0';
           Q_out_neg: out std_logic := '1'
           );
end component ;

signal sig_flip: std_logic:='0';
signal sig_reset: std_logic:='0';


begin

Pulse_1s: clock_enable
generic map(
        N_PERIODS => Blink_N_periods
    )
port map (
clk =>clk,
rst =>'0',
pulse=> sig_flip
);

Flip_flop_1: Flip_Flop
port map(
clk => clk,
rst => sig_reset,
en =>sig_flip,
Q_out=> open,
Q_out_neg => blink_out
);

sig_reset <= not(en);


end Behavioral;
