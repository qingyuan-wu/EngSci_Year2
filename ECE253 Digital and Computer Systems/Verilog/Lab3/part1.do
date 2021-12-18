# set the working dir, where all compiled verilog goes
vlib work_part1

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files

vlog part1.v

#load simulation using... as the top level simulation module
vsim part1

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

# first test case
#set input values using the force command, signal names need to be in {} brackets
force {MuxSelect[0]} 0
force {MuxSelect[1]} 0
force {MuxSelect[2]} 0

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 0
force {MuxSelect[1]} 0
force {MuxSelect[2]} 1

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 0
force {MuxSelect[1]} 1
force {MuxSelect[2]} 0

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 0
force {MuxSelect[1]} 1
force {MuxSelect[2]} 1

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 1
force {MuxSelect[1]} 0
force {MuxSelect[2]} 0

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 1
force {MuxSelect[1]} 0
force {MuxSelect[2]} 1

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 1
force {MuxSelect[1]} 1
force {MuxSelect[2]} 0

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns

force {MuxSelect[0]} 1
force {MuxSelect[1]} 1
force {MuxSelect[2]} 1

force {Input[6]} 1
force {Input[5]} 0
force {Input[4]} 1
force {Input[3]} 0
force {Input[2]} 1
force {Input[1]} 0
force {Input[0]} 1

#run simulation for one ns
run 1ns