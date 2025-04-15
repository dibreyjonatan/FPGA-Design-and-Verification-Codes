# HARDWARE VERIFICATION WITH COCOTB 


*Overview*


`Here is a series of folders concerning hardware verification with cocotb and python under icarus verilog software.`


> Writing testbench in system verilog or VHDL is sometimes complicated 
as the complexity of the design increases.So, writing testbench in 
python is much more simplier as python is a much simple programming language.

# What is COCOTB ?

Cocotb is a CO-routine based CO-simulation Testbench environment for verifying VHDL/Verilog RTL using python. It is an open-source environment.Cocotb can use Rivera-PRO  simulator to simulate the RTL.\

## Why COCOTB ?
Cocotb doesnot require any additional RTL code. The design under test (DUT) is instantiated as the top level in the simulator.Stimulus is applied onto the inputs to the DUT and outputs are monitored using Python.

With cocotb you write testbenches and verification code in `python`.
In addition to all the goodies of the Python programming language and its ecosystem, cocotb provides [a lean framework to efficiently write verification code](https://docs.cocotb.org)

### Requirements for Writing Testbench using COCOTB
- Linux environment 
- Python 3.6+
- GCC and associated development packages
- GNU Make 3+
- gnu compiler 
- VHDL/Verilog simulator e.g icarus verilator 
- Pytest

#### Installing Cocotb 
```
pip install cocotb
```
#### Installing Pytest 
```
pip install pytest 
```
### Installing icarus verilator

On ubuntu :
```
sudo apt-get install verilator
```
### Checking GCC version
```
gcc --version
```
## Running a Testbench 

```
cd single_port_ram
make clear 
make 
```
