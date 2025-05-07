
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mx4 is
generic (
        N_bits : integer := 4
      );
    Port (
            clk : in std_logic;
            IN0 : in std_logic_vector ((N_bits-1) downto 0);
            IN1 : in std_logic_vector ((N_bits-1) downto 0);
            IN2 : in std_logic_vector ((N_bits-1) downto 0);
            IN3 : in std_logic_vector ((N_bits-1) downto 0);
            set   : in std_logic_vector (1 downto 0);
            en : in std_logic ;
            MX_out   : out std_logic_vector ((N_bits-1) downto 0):=(others => '0'));
            
            
end Mx4;

architecture Behavioral of Mx4 is
         
begin


    Mx_swtich: process (clk) is 
    begin
     if rising_edge(clk) then
        if (en = '0') then
            MX_out <= (others => '0');
        else
            case set is
               when "00" =>
                  MX_out<=IN0;
               when "01" =>
                  MX_out<=IN1;
               when "10" =>
                  MX_out<=IN2;
               when others =>
                  MX_out<=IN3;
             end case;
        end if;
    end if;
    
end process Mx_swtich;

end Behavioral;
