library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UD_counter is
    Generic (
                NBITS : integer := 4
             );
    Port ( 
           en : in std_logic ;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           clk : in std_logic;
           rst: in std_logic;
           v : out STD_LOGIC_VECTOR (NBITS-1 downto 0));
           
         
end UD_counter;

architecture Behavioral of UD_counter is
signal sig_cnt: std_logic_vector (NBITS-1 downto 0):=(others => '0');
begin

process (clk)
    begin
    if rising_edge(clk) then
        if rst='1' then
            sig_cnt <= (others => '0');
        elsif ((add='1') and (en = '1')) then
            sig_cnt <= sig_cnt + 1;
        elsif  ((sub='1' )and (en = '1'))  then
            sig_cnt <= sig_cnt - 1;
        end if;
    end if;
    end process;
v <= sig_cnt;

end Behavioral;
