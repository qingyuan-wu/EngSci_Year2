# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog part2.v

#load simulation using mux as the top level simulation module
vsim part2

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {x} 0
force {y} 1
force {s} 0
#run simulation for a few ns
run 1ns

#second test case, change input values and run for another 10ns
# SW[0] should control LED[0]
force {x} 1
force {y} 1
force {s} 0
run 1ns

force {x} 1
force {y} 1
force {s} 1
run 1ns

force {x} 0
force {y} 1
force {s} 0
run 1ns

