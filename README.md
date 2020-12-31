# PopulationCount
A Generic hardware solution to a PopulationCount algorithm, written in vhdl. Testbench and diagrams included.  
    
The funcition of this device is to count the number of "1"'s in a binary word. There are many mathmetical uses for this function, one such use is to [evaluate the mobility of chess pieces in given situations](https://www.chessprogramming.org/Population_Count)  
    
The structure of this design is derived from a [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547) from [Stack Overflow](https://stackoverflow.com)  

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
The structure of this design is derived from a [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547) which was written in C.  
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

### Generating the Bitmasks

## References & Resources
[Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547)  
Xilinx Vivado  
VHDL  
  
