# Lab 3: Thunderbird Turn Signal

VHDL for ECE 281 [Lab 3](https://usafa-ece.github.io/ece281-book/lab/lab3.html)

Targeted toward Digilent Basys3. Make sure to install the [board files](https://github.com/Xilinx/XilinxBoardStore/tree/2018.2/boards/Digilent/basys3).

Tested on Windows 11.

---

## Build the project

You can simply open `thunderbird.xpr` and Vivado will do the rest!

## GitHub Actions Testbench

The workflow uses the [setup-ghdl-ci](https://github.com/ghdl/setup-ghdl-ci) GitHub action
to run a *nightly* build of [GHDL](https://ghdl.github.io/ghdl/).

The workflow uses GHDL to analyze, elaborate, and run the entity specified in the `.github/workflows/testbench.yml`.

```yaml
env:
  TESTBENCH_ENTITY: myfile
```

If successful then GHDL will quietly exit with a `0` code.
If any of the `assert` statements fail **with** `severity error` then GHDL will cease the simulation and exit with non-zero code; this will also cause the workflow to fail.
## Documentation
I referenced ICE 4 code and previous labs. All work is my own.

## Testbench Waveform

We first test the hazard functionality, then right blinkers, then left blinkers. We then test the asynchronous reset in between clock periods, where we see that all lights reset to 0. The end state is no input to the FSM, resulting in no output on any of the lights.
![alt text](<Thunderbird TB v2-1.png>)