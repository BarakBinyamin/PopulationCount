-------------------------------------------------
--  File:          aslrN.vhd
--
--  Entity:        aslrN
--  Architecture:  Behavioral
--  Author:        Barak Binyamin
--  Created:       09/18/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY aslrN is
	GENERIC (N : INTEGER := 4);
	Port (
		A : IN std_logic_vector(N-1 downto 0);
		SHIFT_AMT : IN std_logic_vector(N-1 downto 0);
		Y : OUT std_logic_vector(N-1 downto 0)
	);
end aslrN;

architecture behavioral of aslrN is
	type shifty_array is array(N-1 downto 0) of std_logic_vector(N-1 downto 0);
	signal aSLR : shifty_array;

begin
    --logic for shift Arithmatic right
    aSLR(0)<=A(N-1 downto 0); --no shift
    --generate array of all possible shifts
	generateSLR: for i in 1 to N-1 generate 
		--include the sign
		aSLR(i)(N-1 downto N-i) <= (others => A(N-1));
		--the rest get
		aSLR(i)(N-1-i downto 0) <= A(N-1 downto i);
		      
	end generate generateSLR;
    --the index of the aslr array is a reference to the std_logic_vector with that shamt
	Y <= aSLR(to_integer(unsigned(SHIFT_AMT(N-1 downto 0))));
end behavioral;