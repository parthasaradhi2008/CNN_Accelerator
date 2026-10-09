# CNN Accelerator — MAC Unit Verification

## Overview

This project implements and verifies a parameterized Multiply-Accumulate (MAC) unit using Verilog. The MAC unit multiplies two signed 8-bit inputs and accumulates the product into a signed 32-bit register.

The project focuses on RTL design, testbench development, randomized verification, Python-based reference modeling, and waveform analysis.

## Features

* Parameterized and synthesizable Verilog RTL.
* Signed multiplication and accumulation.
* Synchronous enable and clear controls.
* Asynchronous active-low reset.
* Directed and randomized testbench verification.
* Python golden model and generated test vectors.
* File-based verification using `$fopen` and `$fscanf`.
* Waveform generation using VCD.
* Fault injection to verify that the testbench detects design errors.

## Project Structure

```text
CNN_Accelerator/
├── RTL/
│   └── mac.v
├── tb/
│   └── tb_mac.v
├── python/
│   └── golden_mac.py
├── data/
│   └── mac_vectors.txt
├── README.md
└── .gitignore
```

## MAC Unit Design

The MAC unit performs the following operation:

$$
acc_{\text{next}} = acc_{\text{current}} + (w \times a)
$$

Inputs:

* `clk` — Clock signal.
* `rst_n` — Active-low asynchronous reset.
* `en` — Enables accumulation.
* `clear` — Clears the accumulator.
* `w`, `a` — Signed input operands.

Output:

* `acc` — Signed accumulator output.

### Control Priority

1. When `rst_n = 0`, the accumulator resets to zero.
2. When `clear = 1`, the accumulator clears to zero.
3. When `en = 1`, the product is added to the accumulator.
4. Otherwise, the accumulator retains its previous value.

The clear operation takes priority over enable.

## Verification Methodology

The testbench verifies the RTL through three phases.

| Test phase                    | Number of tests |
| ----------------------------- | --------------: |
| Directed test cases           |               5 |
| Randomized test cases         |           2,000 |
| Python-generated test vectors |           1,000 |
| **Total**                     |       **3,005** |

### 1. Directed Testing

Tests specific input combinations to check basic functionality, signed multiplication, accumulation, and control behavior.

### 2. Randomized Testing

Uses `$urandom` to generate random signed input operands and control signals. An independent expected-value model checks the accumulator output after each clock edge.

### 3. Python Golden Model

A Python reference model generates 1,000 input vectors and their expected cumulative accumulator values. The Verilog testbench reads these vectors from `data/mac_vectors.txt` and compares the expected and actual outputs.

This provides a second reference implementation for cross-checking the RTL.

### 4. Fault Injection

The multiplication operation was deliberately modified to introduce an error. The testbench detected mismatches during simulation.

After restoring the correct RTL, the complete test suite passed again.

### 5. Waveform Analysis

VCD waveforms were generated and inspected to understand signal timing and sequential behavior.

Signals inspected include `clk`, `rst_n`, `en`, `clear`, `w`, `a`, and `acc`.

## Simulation Results

| Metric                    |               Result |
| ------------------------- | -------------------: |
| Total tests               |                3,005 |
| Errors with corrected RTL |                    0 |
| Fault-injection check     |      Detected errors |
| Final status              | **ALL TESTS PASSED** |

## Running the Simulation

Install Icarus Verilog and ensure `iverilog` and `vvp` are available in your terminal.

From the project root directory, compile the RTL and testbench:

```bash
iverilog -g2012 -o sim tb/tb_mac.v RTL/mac.v
```

Run the simulation:

```bash
vvp sim
```

The testbench prints a simulation summary and reports whether all tests passed.

## Viewing Waveforms

The testbench generates a VCD waveform file named `mac.vcd`.

Open it with GTKWave:

```bash
gtkwave mac.vcd
```

Inspect the clock, control signals, inputs, and accumulator to understand the design's behavior over time.

## Python Test Vector Generation

The Python reference model is located at:

```text
python/golden_mac.py
```

The generated test vectors are stored at:

```text
data/mac_vectors.txt
```

The Python script uses NumPy. Install it if necessary:

```bash
python -m pip install numpy
```

Run the script from the working directory expected by its relative file paths. Then run the Verilog simulation to verify the generated vectors.

## Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* Python
* NumPy
* Git and GitHub

## Learning Outcomes

* Writing parameterized, synthesizable RTL.
* Building directed and randomized testbenches.
* Modeling expected behavior independently of the DUT.
* Verifying RTL against Python-generated reference vectors.
* Detecting design errors through fault injection.
* Inspecting simulation waveforms.
* Managing source code with Git and GitHub.
