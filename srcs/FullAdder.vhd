-------------------------------------------------
--  File:          FullAdder.vhd
--
--  Entity:        FullAdder
--  Architecture:  Behavioral
--  Author:        Barak Binyamin
--  Created:       10/05/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    port( A : in std_logic;
          B : in std_logic;
          Cin : in std_logic;
          Sum  : out std_logic;
          Cout : out std_logic
          );
end FullAdder;

architecture Behavioral of FullAdder is
    
begin
    Sum <= A xor B xor Cin;
    Cout <= (A and B) or ((A xor B) and Cin);

end Behavioral;