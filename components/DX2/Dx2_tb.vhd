-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 10 Apr 2025 13:18:05 GMT
-- Request id : cfwk-fed377c2-67f7c50da0e38

library ieee;
use ieee.std_logic_1164.all;

entity tb_Dx2 is
end tb_Dx2;

architecture tb of tb_Dx2 is

    component Dx2
    generic (
        N_bits : integer := 4
      );
    Port ( IN0      : in  STD_LOGIC_VECTOR ((N_bits-1) downto 0);
           en       : in  STD_LOGIC ;
           set      : in  STD_LOGIC;
           Dx_out1  : out STD_LOGIC_VECTOR ((N_bits-1) downto 0);
           Dx_out2  : out STD_LOGIC_VECTOR ((N_bits-1) downto 0));
    end component;
    
    
    constant CN_bits : integer := 4 ;
    signal IN0    : std_logic_vector ((CN_bits-1) downto 0);
    signal set    : std_logic;
    signal en     : std_logic;
    signal Dx_out1 : std_logic_vector ((CN_bits-1) downto 0);
    signal Dx_out2 : std_logic_vector ((CN_bits-1) downto 0);

begin

    dut : Dx2
    port map (IN0    => IN0,
              set    => set,
              en     => en,
              Dx_out1 => DX_out1,
              Dx_out2 => DX_out2);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
           -- ***EDIT*** Adapt initialization as needed
        IN0 <= "0001";
       en <='0';
        wait for 100ns;
       
       en <='1';
       
        set <= '0';
        wait for 100ns;
        set <= '1';

        -- ***EDIT*** Add stimuli here
        -- ***EDIT*** Add stimuli here

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Dx2 of tb_Dx2 is
    for tb
    end for;
end cfg_tb_Dx2;