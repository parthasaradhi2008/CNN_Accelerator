# CNN Accelerator

A Verilog-based project to design and verify components of a Convolutional Neural Network (CNN) accelerator, developed module by module.

## Current Modules

- `RTL/mac.v` — Multiply-Accumulate (MAC) unit.
- `RTL/mac_m1.v` — MAC implementation variant 1.
- `RTL/mac_m2.v` — MAC implementation variant 2.

## MAC Unit Design

The MAC unit multiplies two signed 8-bit inputs and accumulates their product into a signed 32-bit register.

\[
acc_{\text{next}} = acc_{\text{current}} + (w \times a)
\]

**Inputs**
- `clk` — Clock signal.
- `rst_n` — Asynchronous active-low reset.
- `en` — Enables accumulation.
- `clear` — Clears the accumulator.
- `w`, `a` — Signed input operands.

**Output**
- `acc` — Signed accumulator output.

The `clear` signal takes priority over `en`.

## Verification

The testbench is located at `tb/tb_mac.v`.

Verification includes:

- Directed tests for signed arithmetic and edge cases.
- Randomized testing using `$urandom`.
- Checks for `clear`, `en`, and asynchronous reset.
- Python-generated test vectors.
- An independent expected-value model.
- VCD waveform generation for signal inspection.
- Fault injection to check whether the testbench detects design errors.

### Python Reference Model

The Python reference model is located at `python/golden_mac.py`.

Generated test vectors are stored in `data/mac_vectors.txt`. The Verilog testbench reads these vectors and compares the actual MAC output against the expected results.

Python and Verilog provide separate implementations for cross-checking the design.

## Running the Simulation

Install Icarus Verilog and run these commands from the project root:

```bash
iverilog -g2012 -o sim_mac tb/tb_mac.v RTL/mac.v
vvp sim_mac
```

The testbench prints a summary of the number of tests and errors.

## Viewing Waveforms

The testbench generates `mac.vcd`. Open the waveform using GTKWave:

```bash
gtkwave mac.vcd
```

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Python
- NumPy
- Git and GitHub

## Project Goal

Build and verify CNN accelerator components incrementally, improving RTL design, verification methodology, and hardware-design skills as the project develops.