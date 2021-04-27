# vga+tb.do 
vlib work 
vlog +acc  "vga_bitchange.v" 
vlog +acc  "vga_tb.v" 
vsim -t 1ps -lib work vga_tb_v
view objects 
view wave 
do {wave.do} 
log -r * 
run 5000ns