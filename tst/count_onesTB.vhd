-------------------------------------------------
--  File:          count_onesTB.vhd
--
--  Entity:        count_onesTB
--  Architecture:  Behavioral
--  Author:        Barak Binyamin
--  Created:       12/24/19
--  Modified:
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity count_onesTB is
end count_onesTB;

architecture Behavioral of count_onesTB is

--test1
type test_vector1 is record
		Xin	: std_logic_vector((2)-1 downto 0);
		count	: std_logic_vector((2)-1 downto 0);
     end record;
     
type test_array is array (natural range <>) of test_vector1;
constant test_vector_array1 : test_array := (
	(Xin => "00",count => "00"),
	(Xin => "10",count => "01"),
	(Xin => "11",count => "10")
	);
	
--test2
type test_vector2 is record
		Xin	: std_logic_vector((4)-1 downto 0);
		count	: std_logic_vector((4)-1 downto 0);
     end record;
     
--type test_array2 is array (natural range <>) of test_vector2;
--constant test_vector_array2 : test_array := (
--	(Xin => "0000",count => "0000"),
--	(Xin => "1000",count => "0001"),
--	(Xin => "1111",count => "0100")
--	);
	
----test2
--type test_vector3 is record
--		Xin	: std_logic_vector((32)-1 downto 0);
--		count	: std_logic_vector((32)-1 downto 0);
--     end record;
     
--type test_array3 is array (natural range <>) of test_vector3;
--constant test_vector_array3 : test_array := (
--	(Xin => x"00000000",count => x"00000000"),
--	(Xin => x"10000000",count => x"00000001"),
--	(Xin => x"11111111",count => x"00001000")
--	);

	SIGNAL Xone : std_logic_vector (2-1 DOWNTO 0);  
	SIGNAL Xtwo : std_logic_vector (4-1 DOWNTO 0);   
    SIGNAL Xthree : std_logic_vector (32-1 DOWNTO 0);  
    SIGNAL COUNTone : std_logic_vector (2-1 DOWNTO 0);  
	SIGNAL COUNTtwo : std_logic_vector (4-1 DOWNTO 0);   
    SIGNAL COUNTthree : std_logic_vector (32-1 DOWNTO 0); 

    signal clk	: std_logic := '0';
	CONSTANT clkDelay : TIME := 10 ns;
begin

    UUT1: entity work.count_ones
	GENERIC map( LOG_BIT_WIDTH => 1)
    Port map(
        CLK => clk,
        X => Xone,
        count => COUNTone
    );
    
    UUT2: entity work.count_ones
	GENERIC map( LOG_BIT_WIDTH => 2)
    Port map(
        CLK => clk,
        X => Xtwo,
        count => COUNTtwo
    );
    
    UUT3: entity work.count_ones
	GENERIC map( LOG_BIT_WIDTH => 5)
    Port map(
        CLK => clk,
        X => Xthree,
        count => COUNTthree
    );
		
clk_proc:process
begin
	clk <= '0';
	wait for clkDelay/2;
	clk <= '1';
	wait for clkDelay/2;
end process;

stim_proc:process
begin
    --test1
    for i in 0 to test_vector_array1'length-1 loop
		wait until clk='0';
		Xone   <= test_vector_array1(i).Xin;
        wait for 10ns;
        assert COUNTone = test_vector_array1(i).count
        report "COUNTone is not correct in test " & integer'image(i) severity error;
	end loop;
	wait until clk='0';
	
	 --test2
--    for i in 0 to test_vector_array2'length-1 loop
--		wait until clk='0';
--		Xtwo   <= test_vector_array2(i).Xin;
--        wait for 10ns;
--        assert COUNTtwo = test_vector_array2(i).count
--        report "COUNTtwo is not correct in test " & integer'image(i) severity error;
--	end loop;
--	wait until clk='0';
		wait until clk='0';
		Xtwo   <= "0000";
        wait for 10ns;
        assert COUNTtwo = "0000"
        report "COUNTtwo is not correct in test " & integer'image(0) severity error;
        wait until clk='0';
		Xtwo   <= "1000";
        wait for 10ns;
        assert COUNTtwo = "0001"
        report "COUNTtwo is not correct in test " & integer'image(1) severity error;
        wait until clk='0';
		Xtwo   <= "1111";
        wait for 10ns;
        assert COUNTtwo = "0100"
        report "COUNTtwo is not correct in test " & integer'image(2) severity error;
	wait until clk='0';
	
	 --test3
--    for i in 0 to test_vector_array3'length-1 loop
--		wait until clk='0';
--		Xthree   <= test_vector_array3(i).Xin;
--        wait for 10ns;
--        assert COUNTthree = test_vector_array3(i).count
--        report "COUNThree is not correct in test " & integer'image(i) severity error;
--	end loop;
--	wait until clk='0';
--(Xin => x"00000000",count => x"00000000"),
--	(Xin => x"10000000",count => x"00000001"),
--	(Xin => x"11111111",count => x"00001000")
		wait until clk='0';
		Xthree   <= x"00000000";
        wait for 10ns;
        assert COUNTthree = x"00000000"
        report "COUNTtwo is not correct in test " & integer'image(0) severity error;
        wait until clk='0';
		Xthree   <= x"10000000";
        wait for 10ns;
        assert COUNTthree = x"00000001"
        report "COUNTtwo is not correct in test " & integer'image(1) severity error;
        wait until clk='0';
		Xthree   <= x"11111111";
        wait for 10ns;
        assert COUNTthree = x"00001000"
        report "COUNTtwo is not correct in test " & integer'image(2) severity error;
	wait until clk='0';

    assert false
        report "Testbench Concluded"
        severity failure;
end process;

end Behavioral;