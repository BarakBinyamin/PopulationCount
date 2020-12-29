-------------------------------------------------
--  File:          reg.vhd
--
--  Entity:        reg
--  Architecture:  dataflow
--  Author:        Barak Binyamin
--  Created:       09/18/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Reg is
     Generic (BIT_WIDTH : integer := 2);
     Port (clk : in std_logic;
           Xin : in std_logic_vector(BIT_WIDTH-1 downto 0);
           Xout : out std_logic_vector(BIT_WIDTH-1 downto 0)
     );
end Reg;

architecture dataflow of reg is
    signal regg : std_logic_vector(BIT_WIDTH-1 downto 0);

begin

   regg <= Xin when rising_edge(clk);
   Xout<=regg;
           
end dataflow;