# PopulationCount
A Generic hardware solution to a PopulationCount algorithm, written in VHDL. Testbench and diagrams included.  

- [Description](#description)
- [Developers info](#developers)
    - [Quickstart](#quickstart)
    - [Project Directory](#project-directory)
    - [Theory](#theory)
    - [Testing](#testing)
- [Motivation](#motivation)
- [Resources](#resources)

# Description
This device counts the number of "1"'s in a binary word, it has [many applications](https://vaibhavsagar.com/blog/2019/09/08/popcount/#:~:text=Most%20CPU%20architectures%20in%20use,bits%20in%20a%20machine%20word) including crytography and error detection/correction
    
The structure of this design was inspired by a [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547) explained on stack overflow

Here is a waveform showing what it does:

<p  align="center">
    <img src=img/tests1-3.png>   
    <br>
    Figure 1: Behavioral Simulation Waveform  
</p>

You can find an explanation of this waveform in the [testing section](#testing)


# Developers
## Quickstart
The source is shared on [EDAplayground](https://edaplayground.com/x/PP6b), where it's ready for simulation (sign in and hit the run button). A waveform should pop up after the simulation

**Be sure to check the settings on the left panel**, they should look like:
- **Testbench + Design**: VHDL
- **Top entity**: count_onesTB
- **Tools and Simulators**
    - Aldec Rivera Pro
        -  **Compile Options**: 2019 -o
    - [ x ] Open EPWave after run


For more information on how to use EDAplayground please refer to the [EDAplayground documentation](https://eda-playground.readthedocs.io/en/latest/)

## Project Directory
| Name                                   | Purpose                                       | 
| :--                                    | :--                                           |
|[img](backend)                          | Screen captures showing design & functionality|
|[src](library)                          | The source code                               |
|[tst](shortcuts)                        | Tests                                         |

Components Available For Individual Download:
- [Testbench](https://barakbinyamin.github.io/PopulationCount/tst/count_onesTB.vhd)  
- [Full_adder](https://barakbinyamin.github.io/PopulationCount/srcs/FullAdder.vhd)
- [RippleCarryFA](https://barakbinyamin.github.io/PopulationCount/)
- [andN.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/andN.vhd)
- [Reg.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/Reg.vhd)
- [aslrN.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/aslrN.vhd)
- [count_ones.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/count_ones.vhd)
- [op.vhd](https://barakbinyamin.github.io/PopulationCount/srcs/op.vhd)  

## Theory 
The structure of this design was inspired by a [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547) explained on stack overflow, written in C 
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

To approach creating a scalable hardware equivalent, this algorithm can be broken up into 4 distinct problems:
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

This design uses registers between the OP units to synchronize the circuits signals and limit timing issues such as [propogation delay](https://en.wikipedia.org/wiki/Propagation_delay).

### Generating the Bitmasks
Let's inspect if there is a pattern in the bitmasks:

|  Mask number  |   HEX MASK   |                BIT MASK              |
| :-----------: | :----------: |   :-------------------------------:  |   
|       1       |  0x55555555  |    01010101010101010101010101010101  |  
|       2       |  0x33333333  |    00110011001100110011001100110011  |
|       3       |  0x0F0F0F0F  |    00001111000011110000111100001111  |   
|       4       |  0x00FF00FF  |    00000000111111110000000011111111  |      
|       5       |  0x0000FFFF  |    00000000000000001111111111111111  |

From the table, we can see:  
1. The length of the mask is the length of the intended X input  
2. The number of masks corresponds with the what power of 2 creates the length of the number, in this case 2^5 = 32   
3. Each mask oscillates between 2^(MASK_NUMBER-1) 1's and 0's

Lets examine Mask number 3:

    0000 1111 0000 1111 0000 1111 0000 1111     
    
For the first 12 bits (from right to left), we find that indeces 0,1,2,3,8,9,10,11 all contain '1' values.  

Searching this sequence on the Online Encyclopedia of Integer Sequences, we find that it is equivelent to [numbers that are congruent to {0, 1, 2, 3} mod 8](https://oeis.org/A047476).

With a little more inspection the general rule looks to be that the ones are every index in which **index MOD 2^(MASK_NUMBER) <= 2^(MASK_NUMBER-1)-1**

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

## Testing
Tests for VHDL designs are usually refered to as a "Testbench". It can be thought of as a wrapper component used to drive the inputs and tap the outputs of the Unit Under Test (UUT)

Then we can inspect the inputs and outputs using simulation tools available through Vivado or EDAPlayground

We can also automatically check if the outputs match expected values at the right time with VHDL assert statements

<p  align="center">
    <img src=img/tests1-3.png>   
    <br>
    Figure 1: Behavioral Simulation Waveform  
</p>

Figure 1 shows three scaled simulations of the design. 
- A 2 bit unit
- A 4 bit unit
- A 32 bit unit

The test **inputs**  are labeled Xone-Xthree  
The test **outputs** are labeled COUNTone-COUNTthree

# Motivation
I was looking for an hardware/software internship in 2018 and my brother [@ErezBinyamin](https://github.com/ErezBinyamin) offered to share my resume with his work on the condition I could pass two challanges. One was solving [the first crackme challange](https://crackmes.one/crackme/5c9126c033c5d46ecd37c8f4) using [Ghidra](https://ghidra-sre.org/), and the other was to devlop a harware equivalent of [the population count  algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547) from stack overflow

Both were actually really fun and I'm glad I got the chance to build something and learn along the way

## Resources
- [Divide and Conquer Algorithm](https://stackoverflow.com/questions/109023/how-to-count-the-number-of-set-bits-in-a-32-bit-integer/11816547#11816547)  
- [The Online Encyclopedia of Integer Sequences](https://oeis.org)   
- [Xilinx Vivado](https://www.xilinx.com/support/download.html)    
- [EDAplayground documentation](https://eda-playground.readthedocs.io/en/latest/)