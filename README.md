# Project Deccan: Unified Open-Source FPGA Framework for Verilog-to-Bitstream Generation, Simulation and Debug Utilities

## Introduction
Project Deccan integrates together Yosys, nextpnr, Icestrom and Verilator tools into a seamless pipeline for FPGAs. It automates synthesis, place-&-route, bitstream generation, device programming and simulation flows. This project also aims to document open source FPGA design flow for easily of use and to enable learning of FPGA designs & their fundamentals. 

This project work is carried out at FutureG Networks Lab, Indian Institute of Technology, Dharwad. Supported by MEITY's C2S program and hardware donations by Lattice Semiconductor.

The project name [Deccan Plateau](https://en.wikipedia.org/wiki/Deccan_Plateau) is inspired by largest plateau in Indian peninsula.

## Features:
- End-to-end flow: Verilog → JSON → ASC → BIT
- Automatic build/ directory creation
- Multi-design support via a single Makefile
- **Multi-board support** with automatic package detection (upduino sg48, MDP uwg30)
- **Configurable board files** via `BOARD_FILE` parameter
- **Multi-file Verilog projects** with automatic dependency resolution
- **Smart PCF processing** with automatic cleanup for icetime compatibility
- Automated timing and resource utilization reporting integrated into build process
- Verilator-based simulation flow with waveform generation
- Customizable PCF injection, debug/release modes
- Colorized terminal output for better user experience
- Clean file naming without timestamps for consistent builds

## Getting Started:

### Directory Structure:
The project directories are organized as below
```
project_deccan
├── designs                 // Contains example designs, Makefile
│   ├── boards              // Contains board specific files (example: user guide, schematics, pinouts, etc...) 
│   │   └── lattice         // FPGA vendor name
│   │       ├── ice40-mdp   // Target board name
│   │       └── upduino2_v2 // UPduino board support
│   ├── build               // Build artifacts (JSON, ASC, BIN files)
│   ├── sim                 // Simulation artifacts (VCD, executable files)
│   ├── led_blink           // Example design directory: contains verilog sources, testbench
│   └── ping_pong_led       // Multi-LED example with timing control
└── tools                   // Contains open source tools and scripts that are reqiured for running the flow
    └── icestorm            // open source tools for ICE40 FPGA (Project IceStorm) 
```

### Target Devices:
1. iCE40-UP5K <br>
more devices support coming soon...

Target Platforms: 
1. ICE40 MDP (Mobile Development Platform) - uwg30 package
2. UPduino v2.x - sg48 package <br>
more platforms coming soon...

### Example Projects:
1. **led_blink** - Simple LED blinker demonstration
2. **ping_pong_led** - Alternating LED pattern for dual-LED boards
   - Demonstrates timing control with 1-second intervals
   - Shows multi-module Verilog project structure
   - Parameterized counter design for different clock frequencies

### Tools used:
* yosys [version: 0.33 (git sha1 2584903a060)]
* icestorm 
* nextpnr-ice40 [Version 0.6-3build5]
* verilator [Version 5.020]

## Tools Installation:

Operating System: Ubuntu 24.04 (tested on Window Subsystem for Linux - WSL)

To Install WSL refer: [How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

Pre-requisite:
```    
sudo apt-get install build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git mercurial graphviz xdot pkg-config python3 libftdi-dev python3-dev libboost-all-dev cmake libeigen3-dev
```

Install following tools using the commands given:

1. Icestorm
    ```
    git clone --recurse-submodules https://github.com/ritesh-belgudri/project_deccan.git
    cd project_deccan/tools/icestorm
    make -j$(nproc)
    sudo make install
    ```

2. Yosys
    ```
    sudo apt-get install yosys
    ```

3. nextpnr-ice40
    ```
    sudo apt-get install nextpnr-ice40
    ```

4. Verilator (for simulation)
    ```
    sudo apt-get install verilator
    ```

5. GTKWave (for waveform viewing - optional)
    ```
    sudo apt-get install gtkwave
    ```

## Tools Usage:
### Build Flow:
- Clone the repo and install dependencies.
- Place your .v (and optionally .pcf) files under designs/.
- Navigate to the designs directory: `cd designs`
- Run one of the available make targets
- Find .bin files in build/ directory (named as {project_name}.bin)
- Program your device using the prog (SRAM) or prog_flash (SPI Flash) targets


### Build Process:
The Makefile implements a comprehensive build flow with integrated reporting and simulation:

1. **Synthesis** (yosys): Converts Verilog to JSON netlist + generates utilization report
2. **Place & Route** (nextpnr-ice40): Maps design to FPGA resources, generates ASCII file
3. **Timing Analysis** (icetime): Analyzes timing performance, generates timing report
4. **Bitstream Generation** (icepack): Creates final bitstream file
5. **Simulation** (verilator): Compiles and runs functional simulation with waveform generation

All reports are automatically generated during the build process, ensuring you always have current analysis data.

### Available Make Targets:
- `make help` - Show available targets and usage examples
- `make info` - Display build configuration
- `make build` - Build the project (synthesis, place & route, bitstream)
- `make sim` - Run Verilator simulation
- `make sim_wave` - Run simulation and open waveform viewer
- `make reports` - Generate timing and utilization reports
- `make timing_report` - Generate timing analysis report
- `make util_report` - Generate resource utilization report
- `make prog` - Program bitstream to SRAM (volatile)
- `make prog_flash` - Flash bitstream to device (persistent)
- `make clean` - Remove build directory
- `make sim_clean` - Remove simulation directory
- `make all` - Run info, build, and prog targets

### Available Variables:
- `PROJ_NAME` - Project name (default: led_blink)
- `BOARD_FILE` - Board constraint file (default: boards/lattice/upduino2_v2/upduino_v2.pcf)
- `MODE` - Build mode: release or debug (default: release)

### Build Examples:
```bash
# Build default project (led_blink) for upduino board
make build

# Build a specific project
make build PROJ_NAME=ping_pong_led

# Build for MDP board
make build BOARD_FILE=boards/lattice/ice40-mdp/io_mdp_u3.pcf

# Build ping_pong_led for MDP board
make build PROJ_NAME=ping_pong_led BOARD_FILE=boards/lattice/ice40-mdp/io_mdp_u3.pcf

# Build in debug mode
make build MODE=debug

# Build specific project in debug mode
make build PROJ_NAME=ping_pong_led MODE=debug

# Complete workflow (info + build + program)
make all

# Generate design reports
make reports

# Generate only timing report
make timing_report

# Generate only utilization report  
make util_report

# Generate reports for specific project
make reports PROJ_NAME=ping_pong_led

# Simulation examples
make sim PROJ_NAME=led_blink
make sim PROJ_NAME=ping_pong_led

# Run simulation with waveform viewer
make sim_wave PROJ_NAME=ping_pong_led

# Clean build directory
make clean

# Clean simulation directory
make sim_clean
```

### Design Analysis & Reporting:
Project Deccan automatically generates comprehensive design reports during the build process to help you analyze timing performance and resource utilization.

#### Report Types:
1. **Timing Report** (`*_timing.rpt`):
   - Critical path analysis with detailed gate-level timing breakdown
   - Maximum achievable frequency calculation
   - Logic level count and path delay analysis
   - Detailed net-by-net timing information
   - Generated using `icetime` tool for accurate timing estimates

2. **Utilization Report** (`*_utilization.rpt`):
   - Logic cell usage (LUTs, flip-flops)
   - Memory block utilization (BRAM, SPRAM)
   - DSP block usage
   - I/O pin utilization
   - Carry chain analysis

#### Automatic Report Generation:
Reports are automatically generated during `make build` and stored in the `build/` directory:
- `build/{project_name}_timing.rpt` - Detailed timing analysis (generated using icetime)
- `build/{project_name}_utilization.rpt` - Resource usage statistics (generated using yosys)

The timing report is generated during the build process after place-and-route completion, ensuring you always have up-to-date timing information for your design.

#### Report Summary Output:
When generating reports, the Makefile displays key metrics in the terminal:

**Timing Summary Example:**
```
[REPORT] Timing report available at: build/led_blink_timing.rpt
[REPORT] Summary:
  Critical Path Analysis:
Total path delay: 16.51 ns (60.57 MHz)
  Logic Levels:
Total number of logic levels: 27
```

**Utilization Summary Example:**
```
[REPORT] Utilization report available at: build/led_blink_utilization.rpt
[REPORT] Summary:
     SB_CARRY                       24
     SB_DFFER                        1
     SB_DFFR                        26
     SB_LUT4                        63
```

#### Report Generation Examples:
```bash
# Generate all reports for current project
make reports

# Generate reports for specific project
make reports PROJ_NAME=uart_controller

# Generate only timing analysis
make timing_report

# Generate only resource utilization
make util_report

# Reports in debug mode (may show different utilization)
make reports MODE=debug
```

#### Understanding the Reports:
- **Timing Reports**: 
  - Generated using `icetime` tool for topological timing analysis during the build process
  - Provides detailed gate-level timing breakdown of critical paths
  - Shows logic delays, interconnect delays, and setup times
  - Identifies exact logic cells and nets in the critical path
  - Helps optimize design for better timing performance
  - Automatically generated when building to ensure timing constraints are met
- **Utilization Reports**: 
  - Generated using `yosys` statistics during synthesis
  - Show how efficiently your design uses FPGA resources
  - Include LUT, flip-flop, memory, and I/O utilization
- **Debug vs Release**: Debug mode may use additional resources due to different synthesis options

#### Detailed Timing Analysis:
The `icetime` tool provides comprehensive timing analysis including:
- Gate-level timing breakdown (LogicCell40, InMux, LocalMux delays)
- Carry chain timing analysis for arithmetic operations
- Net-by-net timing information with signal names
- Total logic levels in the critical path
- Accurate frequency calculations based on physical delays
- Integrated into the build process for automatic timing verification

### Simulation Flow:
Project Deccan includes a complete simulation flow using Verilator for functional verification of your designs.

#### Simulation Features:
- **Verilator-based simulation**: Fast, cycle-accurate simulation
- **Automatic testbench compilation**: Seamless integration with Makefile
- **Waveform generation**: VCD files for signal analysis
- **GTKWave integration**: Automatic waveform viewer launch
- **Project-specific simulation**: Support for multiple designs

#### Simulation Process:
1. **Testbench Creation**: Write `*_tb.v` testbench files in your design directory
2. **Compilation**: Verilator compiles the design and testbench
3. **Execution**: Simulation runs and generates VCD waveform files
4. **Analysis**: View waveforms in GTKWave or other VCD viewers

#### Simulation Examples:
```bash
# Run simulation for led_blink design
make sim PROJ_NAME=led_blink

# Run simulation and open waveform viewer
make sim_wave PROJ_NAME=led_blink

# Clean simulation artifacts
make sim_clean
```

#### Simulation Output:
- `sim/{project_name}_sim` - Compiled simulation executable
- `sim/{project_name}.vcd` - VCD waveform file
- `sim/obj_dir/` - Verilator compilation artifacts

#### Testbench Requirements:
- Design must include a C++ simulation wrapper: `{project_name}_sim.cpp`
- Wrapper handles clock generation, reset sequencing, and VCD generation
- VCD files can be viewed with GTKWave or other waveform viewers
- Simulation provides functional verification of the design logic

#### Verilator Installation:
Verilator is a fast cycle-accurate simulator that converts Verilog to C++ for high-performance simulation.

**Installation:**
```bash
sudo apt-get install verilator
```

**Optional - GTKWave for waveform viewing:**
```bash
sudo apt-get install gtkwave
```

### Complete Development Flow:
1. **Design**: Write your Verilog modules
2. **Simulate**: Verify functionality with `make sim`
3. **Synthesize**: Generate netlist with `make build`
4. **Analyze**: Review timing and utilization reports
5. **Program**: Flash to hardware with `make prog`

The simulation flow provides functional verification before committing to hardware synthesis and programming.

### Enhanced Makefile Features:

#### Multi-Board Support:
The Makefile now automatically detects the target board and configures the appropriate package:
- **UPduino boards**: Automatically uses `sg48` package
- **MDP boards**: Automatically uses `uwg30` package
- **Custom boards**: Specify via `BOARD_FILE` parameter

#### Smart PCF Processing:
The build system automatically processes PCF files for tool compatibility:
- **nextpnr**: Uses original PCF with all constraints and comments
- **icetime**: Uses auto-generated clean PCF without comments for timing analysis
- **Automatic cleanup**: Removes inline comments and formatting issues

#### Multi-File Verilog Support:
Projects can now contain multiple Verilog modules:
- Automatically includes `top.v` and `{project_name}.v`
- Excludes testbench files from synthesis
- Supports hierarchical module designs

#### Board File Examples:
```bash
# Default upduino build
make build PROJ_NAME=ping_pong_led

# MDP board build
make build PROJ_NAME=ping_pong_led BOARD_FILE=boards/lattice/ice40-mdp/io_mdp_u3.pcf

# Custom board
make build BOARD_FILE=path/to/custom.pcf
```

### Ping Pong LED Project:

The `ping_pong_led` project demonstrates advanced features including timing control, multi-module design, and board compatibility.

#### Features:
- **Alternating LED Pattern**: Two LEDs blink alternatively every 1 second
- **Parameterized Design**: Configurable counter for different clock frequencies
- **Multi-Module Structure**: Demonstrates hierarchical Verilog design
- **Board Compatibility**: Works on both MDP (dual LEDs) and upduino boards
- **Accurate Timing**: Uses 12 MHz clock for precise 1-second intervals

#### Hardware Requirements:
- **MDP Board**: Uses LED_1 (pin B1) and LED_2 (pin F2)
- **Clock**: 12 MHz oscillator (osc_clk on pin B3)
- **Power**: Standard FPGA power supply

#### Project Structure:
```
ping_pong_led/
├── top.v                    # Top-level module with I/O connections
├── ping_pong_led.v          # Main logic with parameterized counter
├── ping_pong_led_tb.v       # Verilog testbench
└── ping_pong_led_sim.cpp    # C++ simulation wrapper
```

#### Build and Program:
```bash
# Build for MDP board
make build PROJ_NAME=ping_pong_led BOARD_FILE=boards/lattice/ice40-mdp/io_mdp_u3.pcf

# Program to FPGA
make prog PROJ_NAME=ping_pong_led BOARD_FILE=boards/lattice/ice40-mdp/io_mdp_u3.pcf

# Run simulation
make sim PROJ_NAME=ping_pong_led
```

#### Performance Results:
- **Utilization**: 55/5280 LCs (1%), efficient resource usage
- **Timing**: 51.87 MHz maximum frequency (well above 12 MHz requirement)
- **Logic Levels**: 26 levels in critical path
- **Memory**: No BRAM usage, pure combinational and sequential logic

### Example Simulation Output:

#### LED Blink Simulation:
```
Starting LED blink simulation...
Reset released at cycle 20
Cycle 1000: led=0
Cycle 2000: led=0
...
Testing reset functionality...
Reset test PASSED: led=0
Simulation completed successfully
Total cycles: 11020
Final LED state: 0
```

#### Ping Pong LED Simulation:
```
Starting ping_pong_led simulation...
Time    CLK     LED1    LED2
1       1       1       0
21      1       1       0
41      1       1       0
...
Simulation completed. VCD file generated: ping_pong_led.vcd
Note: This simulation uses the full 12M counter, so LEDs won't toggle in this short sim.
To see LED toggling, check the hardware build or modify COUNTER_MAX parameter.
```

## References: 
[1] https://prjicestorm.readthedocs.io/en/latest/overview.html <br>
[2] https://yosyshq.readthedocs.io/projects/yosys/en/latest <br>
[3] https://github.com/YosysHQ/nextpnr <br>
[4] https://www.veripool.org/verilator/<br>

## Contact:
For any queries, feel free to reach us at: ritesh.belgudri@iitdh.ac.in
