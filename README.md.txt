CNN Accelerator
A Verilog-based project to design and verify components of a CNN accelerator, developed module by module.
Current Modules
- RTL/mac.v — MAC unit with signed multiplication and accumulation.
- RTL/mac_m1.v — MAC implementation variant 1.
- RTL/mac_m2.v — MAC implementation variant 2.
MAC Unit Verification
The current MAC testbench is tb/tb_mac.v. Verification includes:
- Directed edge-case tests for signed inputs and accumulation.
- Dedicated checks for clear, en, and asynchronous active-low reset (rst_n).
- 2,000 randomized test cases generated in Verilog.
- 1,000 Python-generated test vectors checked by the Verilog testbench.
- VCD waveform output for signal inspection.
The MAC uses signed 8-bit operands and a signed 32-bit accumulator. The clear signal takes priority over en.
Run the MAC Simulation
Run these commands from the project root:
iverilog -g2012 -o sim_mac tb/tb_mac.v RTL/mac.v
vvp sim_mac
The testbench prints a simulation summary with the total number of tests and errors.
Waveforms
The simulation generates mac.vcd. To inspect it with GTKWave:
gtkwave mac.vcd
Tools
- Verilog HDL
- Icarus Verilog
- GTKWave
- Python / NumPy for test-vector generation
- Git
More modules and their verification tests will be documented here as the CNN accelerator develops.