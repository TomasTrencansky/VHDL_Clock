library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Dx2 is
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
end Dx2;

architecture Behavioral of Dx2 is

begin

Dx_swtich: process (clk) is 
begin
  if rising_edge(clk) then
    
        if (en = '0') then
            dx_out0 <= (others => '0');
            dx_out1 <= (others => '0');
        else
            case set is
             when '0' =>
               Dx_out0<= IN0;
               Dx_out1<= (others => '0');
             when others =>
               Dx_out0 <= (others => '0');
               Dx_out1 <= IN0;
          end case;
        end if;
    end if;
end process Dx_swtich;

end Behavioral;
