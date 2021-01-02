# PopulationCount
A Generic hardware solution to a PopulationCount algorithm, written in VHDL. Testbench and diagrams included.  
    
The funcition of this device is to count the number of "1"'s in a binary word. There are many mathmetical uses for this function, one such use is to [evaluate the mobility of chess pieces in given situations](https://www.chessprogramming.org/Population_Count)  
    
The structure of this design is derived from this [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547), from [Stack Overflow](https://stackoverflow.com)  

## Testing

While the following images show functionality, VHDL Assert statements were used to verify that all of the tests output matched expected output.  
  
[see the testbench](https://github.com/BarakBinyamin/PopulationCount/tree/main/tst), [download testbench](https://barakbinyamin.github.io/PopulationCount/tst/count_onesTB.vhd)  
[see the code](https://github.com/BarakBinyamin/PopulationCount/tree/main/srcs), download [Full_adder](https://barakbinyamin.github.io/PopulationCount/srcs/FullAdder.vhd), download [RippleCarryFA](https://barakbinyamin.github.io/PopulationCount/srcs/RippleCarryFA.vhd), download [andN.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/andN.vhd), download [
Reg.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/Reg.vhd), download [
aslrN.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/aslrN.vhd), download [
count_ones.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/count_ones.vhd), download [op.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/op.vhd)  

 
<p  align="center">
<img src=img/tests1-3.png>   
<br>Figure 1: Behavioral Simulation Waveform  
    
Figure 1 shows three scaled simulations of the design. The first simulation is a design for 2 bits, the second is a design for 4 bits, and the third simulation is a design for 32 bits.
</p>

## How it works
The structure of this design is derived from this [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547), which was written in C.  
```C
unsigned int count_bit(unsigned int x)
{
  x = (x & 0x55555555) + ((x >> 1) & 0x55555555);
  x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
  x = (x & 0x0F0F0F0F) + ((x >> 4) & 0x0F0F0F0F);
  x = (x & 0x00FF00FF) + ((x >> 8) & 0x00FF00FF);
  x = (x & 0x0000FFFF) + ((x >> 16)& 0x0000FFFF);
  return x;
}
``` 
<p  align="center">
Posted by user abcdabcd987 on Stack Overflow
</p>

To approach creating a scalable hardware equivelent, this algorithm can be broken up into 4 distinct problems
1. Generating the Bitmasks
2. Generating a circuit to AND two sets of bits
3. Generating a circuit to ADD two sets of bits
4. Generating a circuit to arithmetically SHIFT(keep the sign bit when shifting) two sets of bits

Only the generation of the bitmasks will be discussed in this README, see [this link](https://github.com/BarakBinyamin/RippleCarryFA#ripplecarryfa) for a project dedicated to the addition unit.  

Once a unit can be made for one set of these operations (one line), then these units can be sequenced together.
<p  align="center">
<img src=img/TwoBitSchematic2.png>
<br>Figure 2: Schematic For a Two-bit Population Count Circuit (equivelent to one line of c code)<br>
<img src=img/ThreeBitSchematic2.png>
<br>Figure 3: Schematic For a Four-bit Population Count Circuit (equivelent to three lines of c code)<br>
</p>  


### Generating the Bitmasks
A good apraoch to designing hardware is make a table of the information you know to more easily derive conclusions from:

|  Mask number  |   HEX MASK   |                BIT MASK              |
| :-----------: | :----------: |   :-------------------------------:  |   
|       1       |  0x55555555  |    01010101010101010101010101010101  |  
|       2       |  0x33333333  |    00110011001100110011001100110011  |
|       3       |  0x0F0F0F0F  |    00001111000011110000111100001111  |   
|       4       |  0x00FF00FF  |    00000000111111110000000011111111  |      
|       5       |  0x0000FFFF  |    00000000000000001111111111111111  |

What we know, and what we can gather from the table:  
i) The length of the mask is the length of the intended X input  
ii) The number of masks corresponds with the what power of 2 creates the length of the number, in this case 2^5 = 32   
iii) Each mask oscillates between 2^(MASK_NUMBER-1) 1's and 0's  

To programmatically assign all the arrays of the masks and their subsequent bits we can examine the generation of one mask.
Lets examine Mask number 4: 00001111000011110000111100001111, if we were to think of this bit string as an array of bits, we could look at the first 12 assignment of bits. We find that indeces 0,1,2,3,8,9,10,11 all contain '1' values. Now we can see that this sequence is equivelent to [numbers that are congruent to {0, 1, 2, 3} mod 8](https://oeis.org/A047476).

Now we can generate our 2d array of masks:
```vhdl
gen_masks: for MASK_NUMBER in 1 to LOG_BIT_WIDTH generate

    gen_bits: for BIT in (2**LOG_BIT_WIDTH)-1 downto 0 generate
        one_bits: if BIT mod 2**MASK_NUMBER <= 2**(MASK_NUMBER-1)-1 generate
                mask(MASK_NUMBER-1)(BIT) <= '1';
        end generate one_bits;

    zero_bits: if BIT mod 2**MASK_NUMBER > 2**(MASK_NUMBER-1)-1 generate
                mask(MASK_NUMBER-1)(BIT) <= '0';
        end generate zero_bits;
       
    end generate gen_bits;  
end generate gen_masks;
```

## References & Resources
[Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547)  
Xilinx Vivado  
VHDL  
  
