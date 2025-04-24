----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2025 05:48:29 PM
-- Design Name: 
-- Module Name: Speedup - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Speedup is
    Generic (
                NT_speed_up : integer := 300_000_000;
                DF_speed : integer := 100_000_000;
                S2_speed : integer := 20_000_000;
                S3_speed : integer := 5_000_000;
                S4_speed : integer := 1_000_000
                
                
              );
    Port ( clk : in STD_LOGIC;
           Btn : in STD_LOGIC;
           rst : in STD_LOGIC;
--           TEST1: out integer ;
--           TEST2: out integer ;
--           TEST3: out integer ;
           pulse : out STD_LOGIC);
end Speedup;

architecture Behavioral of Speedup is

signal sig_mode: integer range 0 to 4 :=1;
signal sig_count_mode : integer range 0 to NT_speed_up-1;
signal sig_cnt : integer range 0 to DF_speed-1;

begin

set_periods: process(clk)
begin
  if (rising_edge(clk)) then
            -- if high-active reset then
              if ((rst='1')OR (Btn ='0')) then
                sig_count_mode<= 1;
                sig_cnt<= 0;
              else            
                  if ((sig_cnt >= DF_speed-1)AND( sig_mode = 1)) then
                      sig_cnt <=0; 
                  elsif ((sig_cnt >= S2_speed-1)AND( sig_mode = 2)) then
                      sig_cnt <=0; 
                  elsif ((sig_cnt >= S3_speed-1)AND( sig_mode = 3)) then
                      sig_cnt <=0;                
                  elsif ((sig_cnt >= S4_speed)AND( sig_mode = 4)) then
                      sig_cnt <= 0;
                  else
                      sig_cnt <= sig_cnt +1; 
                  end if;
                  if ((sig_count_mode < NT_speed_up -1) AND (sig_mode /= 4)) then
                  sig_count_mode <= sig_count_mode +1;
                  end if;
             end if;
             
             if sig_count_mode =  NT_speed_up -1 then
                 sig_count_mode <= 0;
                 sig_cnt<=0;
                 sig_mode <= sig_mode +1;
             end if;
             
        end if;
end process set_periods;

pulse <= '1' when sig_cnt = 1 else '0';
--TEST1 <= sig_mode;
--TEST2 <= sig_cnt;
--TEST3 <= sig_count_mode;
end Behavioral;
