-------------------------------------------------
--  File:          andN.vhd
--
--  Entity:        andN
--  Architecture:  Behavioral
--  Author:        Barak Binyamin
--  Created:       9/18/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY andN is
	GENERIC (N : INTEGER := 4);
	Port (
		A : IN std_logic_vector(N-1 downto 0);
		B : IN std_logic_vector(N-1 downto 0);
		Y : OUT std_logic_vector(N-1 downto 0)
	);
end andN;

architecture dataflow of andN is
begin
	Y <= A AND B;
end dataflow;