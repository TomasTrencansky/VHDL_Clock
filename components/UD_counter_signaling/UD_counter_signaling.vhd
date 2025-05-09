library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity UD_counter_signaling is
    Generic (
    
                NBITS : integer := 4;
                Count_range: integer:=40
             );
    Port ( 
           --test: out integer range Count_range downto 0 :=0;
           Reset_value: std_logic_vector(NBITS-1 downto 0);
           en : in std_logic ;
           add : in STD_LOGIC;
           sub : in STD_LOGIC;
           clk : in std_logic;
           rst: in std_logic;
           add_out: out std_logic;
           sub_out: out std_logic;
           count : out STD_LOGIC_VECTOR (NBITS-1 downto 0));
           
         
end UD_counter_signaling;

architecture Behavioral of UD_counter_signaling is

signal sig_cnt: integer range Count_range downto 0 :=0;
signal sig_add_out: std_logic := '0';
signal sig_sub_out: std_logic :='0';

begin 

process (clk)
    begin
    if rising_edge(clk) then 
        if rst = '1' then
            sig_cnt <= TO_INTEGER(unsigned(Reset_value));
        elsif ((add='1') and (en = '1') and (sub='0')) then
            sig_cnt <= sig_cnt + 1;
        elsif  ((sub='1' )and (en = '1') and (add='0'))  then
            sig_cnt <= sig_cnt - 1;
        end if;
        if  ((sub='1' )and (sig_cnt <= 0 )) then
        sig_sub_out <= '1';
        sig_cnt<= Count_range;
        elsif  ((add='1' )and (sig_cnt >= Count_range )) then
        sig_add_out <= '1';
        sig_cnt <=0;
        else
        sig_add_out <= '0';
        sig_sub_out <= '0';
        end if;
    end if; 
    end process;
    
--test <= sig_cnt;
add_out <= sig_add_out;
sub_out <= sig_sub_out;    
count <= std_logic_vector(TO_UNSIGNED(sig_cnt,count'length));

end Behavioral;
