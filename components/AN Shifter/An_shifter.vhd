library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;


entity An_shifter is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in std_logic;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           Digit: out std_logic_vector(2 downto 0)
           );
end An_shifter;

architecture Behavioral of An_shifter is
signal sig_an: std_logic_vector(7 downto 0):= "11111110";
signal   sig_digit:std_logic_vector(2 downto 0) := "000";

begin
  an_shift : process(clk) 

  begin 
    if rising_edge(clk) then
        if rst='1' then 
        sig_an <= "11111110";
        elsif en='1' then
         sig_an <= sig_an(6 downto 0) & sig_an(7);
         case sig_an(6 downto 0) & sig_an(7) is
                when "11111110" =>
                    sig_digit <="000";
                when "11111101" =>
                    sig_digit <="001";
                when "11111011" =>
                    sig_digit <="010";
                when "11110111" =>
                    sig_digit <="011";
                when "11101111" =>
                    sig_digit <="100";
                when "11011111" =>
                    sig_digit <="101";
                when "10111111" =>
                    sig_digit <="110";  
                when "01111111" =>
                    sig_digit <="111"; 
                when others =>  
                sig_digit <="000";   
                end case;
        end if;
  end if;
  end process;
  
Digit <= sig_digit;
AN <= sig_an;
end Behavioral;
