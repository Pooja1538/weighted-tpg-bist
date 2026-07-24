# Low-Power and Area-Efficient Weighted Pseudorandom TPG for Scan-Based BIST

Elective project report for **VLSI Circuit Testing and Testability (UE23EC343BB2)**, PES University.

## Overview
Conventional pseudorandom Test Pattern Generators (TPGs) used in Built-In Self-Test (BIST)
generate 0s and 1s with equal probability, causing high switching activity and power
consumption during test. This project implements a **weighted pseudorandom TPG** using a
Galois-based LFSR, a weight generator, and a MUX-based phase shifter to control the
0/1 distribution and reduce switching transitions — while keeping hardware overhead low.

## Architecture
Seed → Galois LFSR (TPG core) → Weight Generator → MUX (Phase Shifter) → Scan Chain (CUT) → MISR → Pass/Fail
## Repository Structure
- `src/` — RTL design files
  - `galois_lfsr.v` — Galois-style LFSR core
  - `weight_generator.v` — controls weighting factor
  - `weight_enable_ctrl.v` — enable window for weighting
  - `weighted_mux.v` — phase shifter / weighted pattern selector
  - `weighted_tpg.v` — top-level TPG combining the above
  - `actual_weight.v` — XOR-reduction weight check
  - `misr.v` — Multiple Input Signature Register (response analyzer)
  - `alu.v`, `scan_chain.v` — Circuit Under Test (CUT) implementations
  - `bist_controller.v`, `bist_top.v` — BIST control and top-level integration
- `tb/` — testbench (`tb_bist.v`) with switching-activity and opcode-coverage measurement

## Results
Using the ALU as CUT:

| Metric              | Normal Mode | Weighted Mode |
|---------------------|------------:|--------------:|
| Avg ones/cycle       | 3.83        | 2.88          |
| Avg transitions      | 4.29        | 3.81          |
| **Switching reduction** | —        | **~11.17%**   |

## Tools Used
Cadence Virtuoso / SimVision for simulation, schematic capture, and synthesis verification.

## Authors
Moka Jahnavi, Pooja M B, Sunita Basavaraj Yadvinaikar  
Guide: Dr. Nirmala Devi, Dept. of ECE, PES University

## Reference
V. Shivakumar, C. Senthilpari, and Z. Yusoff, "A low-power and area-efficient design of a
weighted pseudorandom test-pattern generator for a test-per-scan built-in self-test
architecture," *IEEE Access*, vol. 9, pp. 29366–29379, 2021.
