# UART Design in Verilog

## Overview

A UART (Universal Asynchronous Receiver Transmitter)
implemented in Verilog HDL.

Features:
- Baud Rate Generator
- UART Transmitter
- UART Receiver
- Verification Testbenches

## Project Structure

rtl/      RTL source code
tb/       Testbenches
docs/     Design documentation
results/  Simulation results

## Tools

- Icarus Verilog
- GTKWave
- Git

## Quick Start

```bash
git clone <https://github.com/swaberry-tech/uart-verilog-design>
cd uart-verilog-design

make tx
```
## Build and Simulation

### Run Baud Rate Generator Testbench

```bash
make baud
```

Compiles and runs the baud rate generator testbench.

---

### Run UART Transmitter Testbench

```bash
make tx
```

Compiles and runs the UART transmitter testbench.

---

### Run UART Receiver Testbench

```bash
make rx
```

Compiles and runs the UART receiver testbench.

---

### Run Complete UART Loopback Test

```bash
make top
```

Compiles and runs the complete UART design with TX connected to RX.

---

### View Baud Generator Waveforms

```bash
make wave_baud
```

Runs the simulation and opens the baud generator waveform in GTKWave.

---

### View UART TX Waveforms

```bash
make wave_tx
```

Runs the UART transmitter simulation and opens GTKWave.

---

### View UART RX Waveforms

```bash
make wave_rx
```

Runs the UART receiver simulation and opens GTKWave.

---

### View Top-Level UART Waveforms

```bash
make wave_top
```

Runs the complete UART simulation and opens GTKWave.

---

### Run All Testbenches

```bash
make all
```

Compiles and executes all available testbenches.

---

### Clean Simulation Files

```bash
make clean
```

Removes generated simulation executables, logs, and waveform files.

---

### Check Available Commands

```bash
make help
```

Displays all supported Makefile targets.
## Status

🚧 Under Development

## Milestones

- [x] Repository Setup
- [x] Baud Generator
- [x] UART TX
- [x] UART RX
- [x] Loopback Test
- [ ] Parity Support
- [ ] FIFO Support