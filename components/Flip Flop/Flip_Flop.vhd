library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity Flip_Flop is
    Port ( clk : in STD_LOGIC;
           rst : in std_logic;
           en : in STD_LOGIC;
           Q_out: out std_logic := '0';
           Q_out_neg: out std_logic := '1'
           );
end Flip_Flop;

architecture Behavioral of Flip_Flop is

signal sig_Q_out:std_logic := '0';

begin

flip_flop: process (clk)
begin 
   if rising_edge(clk) then
      if rst='1' then
         sig_Q_out <= '0';
      elsif en ='1' then
         sig_Q_out <= not(sig_Q_out);
      end if;
   end if;
end process;

Q_out <= sig_Q_out;
Q_out_neg <= not(sig_Q_out);

end Behavioral;
