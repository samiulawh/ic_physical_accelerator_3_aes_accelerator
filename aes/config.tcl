# config.tcl

# Design Name (Top Module)
set ::env(DESIGN_NAME) "main_aes"

# RTL Files Path
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/rtl/*.v]

# Clock Constraints (5.0ns = 200 MHz)
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) 10.0

# Floorplan aur Placement Constraints
set ::env(FP_CORE_UTIL) 30
set ::env(PL_TARGET_DENSITY) 0.50

# routing/metal layers
set ::env(RT_MAX_LAYER) "met5"

set ::env(GLB_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 1
set ::env(SYNTH_MAX_FANOUT) 10
set ::env(SYNTH_MAX_TRAN) 1.0

# System Settings
set ::env(ROUTING_CORES) 2