library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity On_For_N is 
    generic
    (
    N_Period: integer :=1000 ;
    N_Slow_wake_up: integer :=100_000_000
     );
    Port ( clk : in STD_LOGIC;
           rst : in std_logic;
           start_c : in STD_LOGIC; 
           mode : in STD_LOGIC;
           period : in STD_LOGIC_VECTOR (4 downto 0);
--         test_cur_s: out integer range 0 to 25 :=0;
--         test_if: out integer;
           duty_sig : out STD_LOGIC);
end On_For_N;

architecture Behavioral of On_For_N is

signal sig_cnt: integer range 0 to N_Period := 0; 
signal sig_start: std_logic:= '0';
signal current_speed: integer range 0 to 25 :=0;
signal speedup_timer:integer range 0 to N_Slow_wake_up:=0;
constant div_N_period: integer :=N_Period/25;
 
begin
  an_shift : process(clk) 

  begin 
    if rising_edge(clk) then
        if rst='1' then 
            sig_cnt <= 0;
            sig_start <= '0';
            current_speed <= 0;  
        else
            if start_c = '1' then
            sig_start <='1';
            end if;
        
            if mode ='1' then 
                speedup_timer <= speedup_timer+1;
                 if  ((speedup_timer >= N_Slow_wake_up)and (current_speed <24)) then
                    current_speed <= current_speed+1 ;  
                    speedup_timer <= 0;   
                 end if;
            else
                case period is
                    when "00000" =>
                    current_speed <= 1;
                    when "00001" =>       
                    current_speed <= 2;
                    when "00010" =>     
                    current_speed <= 3;
                    when "00011" =>     
                    current_speed <= 4;
                    when "00100" =>
                    current_speed <= 5;
                    when "00101" =>       
                    current_speed <= 6;
                    when "00110" =>     
                    current_speed <= 7;
                    when "00111" =>     
                    current_speed <= 8;
                    when "01000" =>
                    current_speed <= 9;
                    when "01001" =>       
                    current_speed <= 10;
                    when "01010" =>     
                    current_speed <= 11;
                    when "01011" =>     
                    current_speed <= 12;
                    when "01100" =>
                    current_speed <= 13;
                    when "01101" =>       
                    current_speed <= 14;
                    when "01110" =>     
                    current_speed <= 15;
                    when "01111" =>     
                    current_speed <= 16;
                    when "10000" =>
                    current_speed <= 17;
                    when "10001" =>       
                    current_speed <= 18;
                    when "10010" =>     
                    current_speed <= 19;
                    when "10011" =>     
                    current_speed <= 20;
                    when "10100" =>
                    current_speed <= 21;
                    when "10101" =>       
                    current_speed <= 22;
                    when "10110" =>     
                    current_speed <= 23;
                    when others =>
                    current_speed<=24;   
                end case;
            end if;           
            if sig_start='1' then 
                 sig_cnt <= sig_cnt+1;
                 if (sig_cnt >=  current_speed * div_N_period)AND(mode='0') then    
                    sig_start <= '0';
                    sig_cnt <= 0; 
                 end if;     
            end if;
         end if;
        
    end if;
    
  end process;
 duty_sig <=sig_start;
-- test_cur_s <= current_speed;
-- test_if <= div_N_period*current_speed ;

end Behavioral;
