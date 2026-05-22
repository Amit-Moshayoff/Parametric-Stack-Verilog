# Parametric Verilog Stack (LIFO) with Corner-Case Verification

A fully synthesizable, parametric Last-In-First-Out (LIFO) Stack memory architecture implemented in Verilog. This project includes a robust testbench designed to verify core LIFO operations alongside critical hardware protection mechanisms (Overflow & Underflow).

## Features
- **Parametric Architecture:** Data width (`DATA_WIDTH`) and memory depth (`STACK_DEPTH`) are fully configurable via Verilog parameters.
- **Hardware Protection:** Built-in logic to prevent data corruption during invalid operations (ignores writes when full, ignores reads when empty).
- **Synchronous Design:** Synchronous read/write operations controlled by a single clock cycle, with an active-high asynchronous reset.

## Project Structure
- `stack.v` - Main RTL design implementing the parametric stack logic.
- `stack_tb.v` - Comprehensive testbench validating standard operations and edge cases.

## Verification Phases
The testbench validates the design through a structured sequence, as clearly captured in the simulation waveform:
1. **Phase 1: System Reset** - Initializes the Stack Pointer (SP) to `0` and clears outputs.
2. **Phase 2: Filling Stack** - Drives sequential `push` operations (Data: 24, 81, 09, 63) until the stack reaches maximum capacity (`full = 1`, `sp = 4`).
3. **Phase 3: Overflow Protection Check** - Attempts to `push` an extra byte (`8'hFF`) into the already full stack. The waveform proves that the SP remains locked at 4 and internal data is safe.
4. **Phase 4: Emptying Stack** - Executes sequential `pop` operations, recovering the data in perfect reverse order (63, 09, 81, 24).
5. **Phase 5: Underflow Protection Check** - Attempts to `pop` from an empty stack, verifying the SP safely holds at `0` without underflowing.

## Simulation Waveform

The following waveform from EPWave captures the complete verification suite, demonstrating perfect LIFO execution and robust corner-case handling:

<img width="1862" height="331" alt="צילום מסך 2026-05-19 152446" src="https://github.com/user-attachments/assets/800469c2-9e0d-4412-97d6-2e33af656b62" />
