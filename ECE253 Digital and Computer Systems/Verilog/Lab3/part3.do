# set the working dir, where all compiled verilog goes
vlib work_part3

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog part3.v

#load simulation using... as the top level simulation module
vsim part3

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {A[3:0]} 1111
force {B[3:0]} 1111
force {Function[2:0]} 100

#run simulation for a few ns
run 1ns

force {A[3:0]} 1101
force {B[3:0]} 1111
force {Function[2:0]} 100

#run simulation for a few ns
run 1ns

force {A[3:0]} 1010
force {B[3:0]} 0000
force {Function[2:0]} 011

#run simulation for a few ns
run 1ns

force {A[3:0]} 1010
force {B[3:0]} 1101
force {Function[2:0]} 000

#run simulation for a few ns
run 1ns

force {A[3:0]} 1010
force {B[3:0]} 1101
force {Function[2:0]} 001

#run simulation for a few ns
run 1ns

force {A[3:0]} 0101
force {B[3:0]} 0010
force {Function[2:0]} 010

#run simulation for a few ns
run 1ns

force {A[3:0]} 1101
force {B[3:0]} 0011
force {Function[2:0]} 001

#run simulation for a few ns
run 1ns

force {A[3:0]} 0101
force {B[3:0]} 0110
force {Function[2:0]} 001

#run simulation for a few ns
run 1ns

