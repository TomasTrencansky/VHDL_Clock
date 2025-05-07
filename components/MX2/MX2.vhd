library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mx2 is
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
            
end Mx2;

architecture Behavioral of Mx2 is
            
begin

Mx_swtich: process (clk) is 
    begin
     if rising_edge(clk) then
        if (en = '0') then
            MX_out <= (others => '0');
        else
            case set is
              when '0' =>
                 MX_out<=IN0;
              when others =>
                 MX_out<=IN1;
            end case;
        end if;
  end if;
end process Mx_swtich;

end Behavioral;

