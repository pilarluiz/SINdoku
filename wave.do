onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_tb_v/Clk
add wave -noupdate -radix unsigned /vga_tb_v/h
add wave -noupdate -radix unsigned /vga_tb_v/v


add wave -noupdate -radix hex /vga_tb_v/rgb
add wave -noupdate -radix hex /vga_tb_v/disp_i
add wave -noupdate -radix hex /vga_tb_v/disp_j
add wave -noupdate /vga_bitchange/state

add wave -noupdate /sindoku_tb_v/Clk
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/clk_cnt
add wave -noupdate /sindoku_tb_v/Reset
add wave -noupdate /sindoku_tb_v/BtnR_Pulse
add wave -noupdate /sindoku_tb_v/BtnL_Pulse
add wave -noupdate /sindoku_tb_v/BtnD_Pulse
add wave -noupdate /sindoku_tb_v/BtnU_Pulse
add wave -noupdate /sindoku_tb_v/BtnC_Pulse

add wave -noupdate -radix ascii -radixshowbase 0 /sindoku_tb_v/state_string
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/userIn
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/start_clock_cnt
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/clocks_taken
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/i
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/j
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/row
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/col
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/puzzle_ij
add wave -noupdate -radix unsigned -radixshowbase 0 /sindoku_tb_v/solu_ij

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5100 ns}
