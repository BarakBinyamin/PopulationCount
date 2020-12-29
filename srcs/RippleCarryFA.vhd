-------------------------------------------------
--  File:          RippleCarryFA.vhd
--
--  Entity:        RippleCarryFA
--  Architecture:  Behavioral
--  Author:        Barak Binyamin
--  Created:       10/05/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity RippleCarryFA is
    GENERIC (N : INTEGER := 4);
	Port (
		A : IN std_logic_vector(N-1 downto 0);
		B : IN std_logic_vector(N-1 downto 0);
		OP : IN std_logic;
		Sum : OUT std_logic_vector(N-1 downto 0)
	);
end RippleCarryFA;

architecture structural of RippleCarryFA is
Component FullAdder  is
	Port( A : in std_logic;
          B : in std_logic;
          Cin : in std_logic;
          Sum  : out std_logic;
          Cout : out std_logic
		);
	end Component;
	
	signal Cout_result : std_logic_vector(N-1 downto 0) := (others=> '0');
	signal B_result    : std_logic_vector(N-1 downto 0) := (others=> '0');


begin

B_result(0)<= B(0) xor op;

FA0 : FullAdder
port map( 
            A => A(0), 
            B => B_result(0), 
            Cin => OP, 
            Sum => Sum(0),
            Cout => Cout_result(0)
            );

gen_RCFA: for i in N-1 downto 1 generate
           
            --invert bits when op is 1
            B_result(i) <= B(i) XOR OP;

            full_adder : FullAdder
            port map( 
            A => A(i), 
            B => B_result(i), 
            Cin => Cout_result(i-1), 
            Sum => Sum(i),
            Cout => Cout_result(i)
            );
        end generate gen_RCFA;


end structural;