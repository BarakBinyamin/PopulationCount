-------------------------------------------------
--  File:          OP.vhd
--
--  Entity:        OP
--  Architecture:  dataflow
--  Author:        Barak Binyamin
--  Created:       12/23/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


ENTITY OP is
	GENERIC (BIT_WIDTH : INTEGER:= 2; SHAMT : INTEGER:= 1);
	Port (
		X : IN std_logic_vector((BIT_WIDTH)-1 downto 0);
		mask : IN std_logic_vector((BIT_WIDTH)-1 downto 0);
		Xout : OUT std_logic_vector((BIT_WIDTH)-1 downto 0)
	);
end OP;

architecture dataflow of OP is
    signal andX   : std_logic_vector((BIT_WIDTH)-1 downto 0);
    signal shiftandMask   : std_logic_vector((BIT_WIDTH)-1 downto 0);
    signal shiftX : std_logic_vector((BIT_WIDTH)-1 downto 0);
begin

andN_comp1 : entity work.andN
    GENERIC map(N => (BIT_WIDTH))
	Port map(
		A => X,
		B => mask,
		Y => andX
	);

aslrN_comp : entity work.aslrN
	GENERIC map(N => (BIT_WIDTH))
    Port map(
		A => X,
		SHIFT_AMT => std_logic_vector(to_unsigned(SHAMT, BIT_WIDTH)),
		Y => shiftX
	);
	
andN_comp2 : entity work.andN
    GENERIC map(N => (BIT_WIDTH))
	Port map(
		A => shiftX,
		B => mask,
		Y => shiftandMask
	);

full_adder : entity work.RippleCarryFA
    GENERIC map (N => (BIT_WIDTH))
	Port map(
		A => andX,
		B => shiftandMask,
		OP => '0',
		Sum => Xout
	);
end dataflow;