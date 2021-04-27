//////////////////////////////////////////////////////////////////////////////////
// Author:			Shideh Shahidi, Bilal Zafar, Gandhi Puvvada
// Create Date:   02/25/08, 10/13/08
// File Name:		ee354_GCD_tb.v 
// Description: 
//
//
// Revision: 		2.1
// Additional Comments:  
// 10/13/2008 Clock Enable (CEN) has been added by Gandhi
// 3/1/2010 Signal names are changed in line with the divider_verilog design
//  02/20/2020 Nexys-3 to Nexys-4 conversion done by Yue (Julien) Niu
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module vga_tb_v;

    reg Clk;
	reg bright;
	reg button;
	reg [9:0] h, v;

	wire [11:0] rgb;
	// output reg [15:0] score
    // TODO: take in puzzle
	wire [4:0] disp_i, disp_j;
	reg [4:0] disp_value;
	reg [4:0] i, j;
	
	vga_bitchange vbc(.clk(Clk), .bright(bright), .button(button), .hCount(h), .vCount(v), .rgb(rgb), .disp_i(disp_i), .disp_j(disp_j), .disp_value(disp_value), .i(i), .j(j));


	
	
		always  begin #5; Clk = ~ Clk; end
		always@(posedge Clk) h = h + 1;
		initial begin
		// Initialize Inputs
		Clk = 0;
		// ****** in Part 2 ******
				 // Here, in Part 1, we are enabling clock permanently by making CEN a '1' constantly.
				 // In Part 2, your TOP design provides single-stepping through SCEN control.
				 // We are not planning to write a testbench for the part 2 design. However, if we were 
				 // to write one, we will remove this line, and make CEN enabled and disabled to test 
				 // single stepping.
				 // One of the things you make sure in your core design (DUT) is that when state 
				 // transitions are stopped by making CEN = 0,
				 // the data transformations are also stopped.
		bright = 1;
		v = 10'd280;
		h = 10'd200;
		i = 2;
		j = 4;
		disp_value = 5'd1;

		//generate Reset, Start, Ack, Ain, Bin signals according to the waveform on page 14/19
		//add start_clock_cnt and clocks_taken code in the correct areas
		//add $display statements per 6.10 on page 13/19
		
		
		//reset control
		@(posedge Clk); //wait until we get a posedge in the Clk signal
		@(posedge Clk);
	
		
		end
		

 
      
endmodule

