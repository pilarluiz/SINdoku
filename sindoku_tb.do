# sindoku_tb.do 
vlib work 
vlog +acc  "sindoku.v" 
vlog +acc  "sindoku_tb.v" 
vsim -t 1ps -lib work sindoku_tb_v
view objects 
view wave 
do {wave.do} 
log -r * 
run 5000ns