-------------------------------------------------
--  File:          count_onesTB.vhd
--
--  Entity:        count_onesTB
--  Architecture:  Behavioral
--  Author:        Barak Binyamin
--  Created:       12/24/19
--  Modified:      04/10/23
--  VHDL'93
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Name the component we are making
entity count_onesTB is
end count_onesTB;

-- Note that there is no input/output declaration here

-- Name the method of we are using to define our component
architecture Behavioral of count_onesTB is

    -- Test 1 Answer Sheet
    type test_vector1 is record
            Xin	    : std_logic_vector((2)-1 downto 0);
            count	: std_logic_vector((2)-1 downto 0);
    end record;

    type test_array is array (natural range <>) of test_vector1;
    constant test_vector_array1 : test_array := (
        (Xin => "00",count => "00"), -- 0 should have no  ones
        (Xin => "10",count => "01"), -- 2 should have one ones
        (Xin => "11",count => "10")  -- 3 should have two ones
    );
	
    -- Test 2 Answer Sheet
    type test_vector2 is record
            Xin	   : std_logic_vector((4)-1 downto 0);
            count  : std_logic_vector((4)-1 downto 0);
    end record;

    type test_array2 is array (natural range <>) of test_vector2;
    constant test_vector_array2 : test_array2 := (
        (Xin => "0000",count => "0000"), -- 0  should have no    ones
        (Xin => "1010",count => "0010"), -- 10 should have one   ones
        (Xin => "1101",count => "0011")  -- 13 should have three ones
    );
    
    -- Test 3 Answer Sheet
    type test_vector3 is record
            Xin	   : std_logic_vector((32)-1 downto 0);
            count  : std_logic_vector((32)-1 downto 0);
    end record;

    type test_array3 is array (natural range <>) of test_vector3;
    constant test_vector_array3 : test_array3 := (
        (Xin => x"00000000",count => x"00000000"), 
        (Xin => x"00000001",count => x"00000001"), 
        (Xin => x"10101010",count => x"10101010")
    );
     
     
    -- Decalre internal signals used to drive the components we are testing
	SIGNAL Xone       : std_logic_vector (2-1  DOWNTO 0);  
	SIGNAL Xtwo       : std_logic_vector (4-1  DOWNTO 0);   
    SIGNAL Xthree     : std_logic_vector (32-1 DOWNTO 0);  
    SIGNAL COUNTone   : std_logic_vector (2-1  DOWNTO 0);  
	SIGNAL COUNTtwo   : std_logic_vector (4-1  DOWNTO 0);   
    SIGNAL COUNTthree : std_logic_vector (32-1 DOWNTO 0); 
	-- Constants used in our test logic
    signal   clk	  : std_logic := '0';
	CONSTANT clkDelay : TIME := 10 ns;
    
begin

	-- Unit under test (UUT), This is where we instantiate components to test and connect them to our test signals
    UUT1: entity work.count_ones
	GENERIC map( LOG_BIT_WIDTH => 1)
    Port map(
        CLK   => clk,
        X     => Xone,
        count => COUNTone
    );
    
    UUT2: entity work.count_ones
	GENERIC map( LOG_BIT_WIDTH => 2)
    Port map(
        CLK   => clk,
        X     => Xtwo,
        count => COUNTtwo
    );
    
    UUT3: entity work.count_ones
	GENERIC map( LOG_BIT_WIDTH => 5)
    Port map(
        CLK   => clk,
        X     => Xthree,
        count => COUNTthree
    );
		
-- This is a process, a way to program sequentially, best to leave this method of hardware declarion for testing and timing, rather than implementation
clk_proc:process
begin
	clk <= '0';
	wait for clkDelay/2;
	clk <= '1';
	wait for clkDelay/2;
end process;

stim_proc:process
begin
    -- Test 1: Check if the output matches the expected, if not raise an alarm
    for i in 0 to test_vector_array1'length-1 loop
		wait until clk='0';                         -- wait until falling edge
		Xone   <= test_vector_array1(i).Xin;
        wait for clkDelay;                          -- wait one clock cycle
        assert COUNTone = test_vector_array1(i).count
        report "COUNTone is not correct in test " & integer'image(i) severity error;
	end loop;
    
    -- Test 2: Note these tests are running sequentially
    for i in 0 to test_vector_array2'length-1 loop
		wait until clk='0';                        
		Xtwo  <= test_vector_array2(i).Xin;
        wait until clk='0';                         
        wait until clk='0';                         
		assert  COUNTtwo = test_vector_array2(i).count
        report "COUNTtwo is not correct in test " & integer'image(i) severity error;
	end loop;
    
     -- Test 3:
    for i in 0 to test_vector_array3'length-1 loop
		wait until clk='0';                        
		Xthree  <= test_vector_array3(i).Xin;
        wait until clk='0';                         
        wait until clk='0';
        wait until clk='0';
        wait until clk='0';
        wait until clk='0';
		assert  COUNTthree = test_vector_array3(i).count
        report "COUNTthree is not correct in test " & integer'image(i) severity error;
	end loop;
   
    -- End of tests
	wait until clk='0';

    assert false
        report "Testbench Concluded"
        severity failure;
end process;

end Behavioral;
