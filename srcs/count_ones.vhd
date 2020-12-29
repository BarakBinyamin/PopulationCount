-------------------------------------------------
--  File:          count_ones.vhd
--
--  Entity:        count_ones
--  Architecture:  Structural
--  Author:        Barak Binyamin
--  Created:       12/24/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity count_ones is
    --LOG_BIT_WIDTH must be at least 1
    GENERIC( LOG_BIT_WIDTH : Integer := 3);
    Port (
        CLK : in std_logic;
        X : in std_logic_vector((2**LOG_BIT_WIDTH)-1 downto 0);
        count : out std_logic_vector((2**LOG_BIT_WIDTH)-1 downto 0)
    );
end count_ones;

architecture Structural of count_ones is
    type mask_array is array(LOG_BIT_WIDTH-1 downto 0) of std_logic_vector((2**LOG_BIT_WIDTH)-1 downto 0);
	signal mask : mask_array;
	type Xout_array is array(LOG_BIT_WIDTH downto 0) of std_logic_vector((2**LOG_BIT_WIDTH)-1 downto 0);
	signal regIn : mask_array;
    signal regOut : Xout_array;

begin

gen_masks: for i in 1 to LOG_BIT_WIDTH generate

    gen_bits: for bitt in (2**LOG_BIT_WIDTH)-1 downto 0 generate
        one_bit: if bitt mod 2**i <= 2**(i-1)-1 generate
                mask(i-1)(bitt) <= '1';
        end generate one_bit;

    zero_bit: if bitt mod 2**i > 2**(i-1)-1 generate
                mask(i-1)(bitt) <= '0';
        end generate zero_bit;
       
    end generate gen_bits;  
end generate gen_masks;

--not a real register_output
regOut(0)<=X;

gen_ops: for i in 1 to LOG_BIT_WIDTH generate
    reg_comp: entity work.Reg
         Generic map (BIT_WIDTH => 2**LOG_BIT_WIDTH)
         Port map(clk => CLK,
           Xin => regIn(i-1),
           Xout => regOut(i)
        );
    op_comp: entity work.OP
    generic map(BIT_WIDTH => 2**LOG_BIT_WIDTH, SHAMT => 2**(i-1))
	Port map(
		X => regOut(i-1),
		mask => mask(i-1),
		Xout => regIn(i-1)
	);
end generate gen_ops;

--count is correct after LOG_BIT_WIDTH clk cycles
count<=regOut(regOut'length-1);

end Structural;
