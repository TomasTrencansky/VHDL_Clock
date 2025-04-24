library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Change is
    Port ( clk : in std_logic;
           Btn_1 : in STD_LOGIC;  --  long UP / Down button
           Btn_2 : in STD_LOGIC;  -- long C button
           rst : in STD_LOGIC;    -- C button
           mode: in std_logic_vector (1 downto 0);
           change_0 : out STD_LOGIC;
           change_1 : out STD_LOGIC;
           change_2 : out std_logic;
           change_active : out STD_LOGIC);
end Change;

architecture Behavioral of Change is
 signal sig_ch1: std_logic := '0';
 signal sig_ch2: std_logic := '0';
 signal s_mode: std_logic_vector(1 downto 0);
begin

p_change: process (clk) is 
begin 

    if (rising_edge(clk)) then
        if rst='1' then
            sig_ch1 <= '0';
            sig_ch2 <= '0';
       elsif ((Btn_1 = '1')AND (sig_ch2 = '0')) then
            sig_ch1 <= '1';
        elsif ((Btn_2 = '1')AND (sig_ch1 = '0')) then
            sig_ch2 <= '1';
        end if;
        
        s_mode <= mode;
       
    end if;
end process;

change_0 <= '1' when ((mode="00") AND (sig_ch1 = '1')) else  '0'; -- clock change
change_1 <= '1' when ((mode="00") AND (sig_ch2= '1')) else  '0';  -- alarm change
change_2 <= '1' when ((mode="10") AND (sig_ch1 = '1')) else  '0'; -- timer change

change_active <= sig_ch2 OR sig_ch1;



end Behavioral;
