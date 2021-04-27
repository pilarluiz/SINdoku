`timescale 1ns / 1ps

/*
vga_bitchange module acts as the center role to deliver video data. In this module, you can define the size/color of boxes; how to move these boxes; how to use buttons/time counter to control these boxes. You can even define more complex shapes. Some previous groups even read pictures from memory and output the data to the monitor. 
*/

module vga_bitchange(
	input clk,
	input bright,
    // TODO: read in more buttons and switches? or do we only care about current num based on state
	input button,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	// output reg [15:0] score
    // TODO: take in puzzle
	output reg[4:0] disp_i, disp_j,
	input [4:0] disp_value,
	input [4:0] i, j
   );

	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;

	wire whiteZone;
    wire thickBorderHorizontal;
	wire thickBorderVertical;
    wire thinBorder;
	wire thinHorizontal;
	wire thinVertical;
	// wire greenMiddleSquare;
	reg reset;
	
	// Numbers
	reg zero[2:0][2:0];
	reg one[2:0][2:0];
	reg two[2:0][2:0];
	reg three[2:0][2:0];
	reg four[2:0][2:0];
	reg five[2:0][2:0];
	reg six[2:0][2:0];
	reg seven[2:0][2:0];
	reg eight[2:0][2:0];
	reg nine[2:0][2:0];
	reg [5:0] state;
	assign {q_THICKBORDER, q_BACKGROUND, q_THINBORDER, q_WHITESPACE, q_NUMBER, q_RED} = state;

	initial begin
		// Init zero
		{zero[0][0], zero[0][1], zero[0][2], zero[0][3], zero[0][4], zero[0][5], zero[0][6], zero[0][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[1][0], zero[1][1], zero[1][2], zero[1][3], zero[1][4], zero[1][5], zero[1][6], zero[1][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[2][0], zero[2][1], zero[2][2], zero[2][3], zero[2][4], zero[2][5], zero[2][6], zero[2][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[3][0], zero[3][1], zero[3][2], zero[3][3], zero[3][4], zero[3][5], zero[3][6], zero[3][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[4][0], zero[4][1], zero[4][2], zero[4][3], zero[4][4], zero[4][5], zero[4][6], zero[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[5][0], zero[5][1], zero[5][2], zero[5][3], zero[5][4], zero[5][5], zero[5][6], zero[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[6][0], zero[6][1], zero[6][2], zero[6][3], zero[6][4], zero[6][5], zero[6][6], zero[6][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{zero[7][0], zero[7][1], zero[7][2], zero[7][3], zero[7][4], zero[7][5], zero[7][6], zero[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init one
		{one[0][0], one[0][1], one[0][2], one[0][3], one[0][4], one[0][5], one[0][6], one[0][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[1][0], one[1][1], one[1][2], one[1][3], one[1][4], one[1][5], one[1][6], one[1][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[2][0], one[2][1], one[2][2], one[2][3], one[2][4], one[2][5], one[2][6], one[2][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[3][0], one[3][1], one[3][2], one[3][3], one[3][4], one[3][5], one[3][6], one[3][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[4][0], one[4][1], one[4][2], one[4][3], one[4][4], one[4][5], one[4][6], one[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[5][0], one[5][1], one[5][2], one[5][3], one[5][4], one[5][5], one[5][6], one[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[6][0], one[6][1], one[6][2], one[6][3], one[6][4], one[6][5], one[6][6], one[6][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{one[7][0], one[7][1], one[7][2], one[7][3], one[7][4], one[7][5], one[7][6], one[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		one[6][0] = 1; one[6][1] = 1;
		
		// init two
		{two[0][0], two[0][1], two[0][2], two[0][3], two[0][4], two[0][5], two[0][6], two[0][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{two[1][0], two[1][1], two[1][2], two[1][3], two[1][4], two[1][5], two[1][6], two[1][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{two[2][0], two[2][1], two[2][2], two[2][3], two[2][4], two[2][5], two[2][6], two[2][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{two[3][0], two[3][1], two[3][2], two[3][3], two[3][4], two[3][5], two[3][6], two[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{two[4][0], two[4][1], two[4][2], two[4][3], two[4][4], two[4][5], two[4][6], two[4][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{two[5][0], two[5][1], two[5][2], two[5][3], two[5][4], two[5][5], two[5][6], two[5][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{two[6][0], two[6][1], two[6][2], two[6][3], two[6][4], two[6][5], two[6][6], two[6][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{two[7][0], two[7][1], two[7][2], two[7][3], two[7][4], two[7][5], two[7][6], two[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init three
		{three[0][0], three[0][1], three[0][2], three[0][3], three[0][4], three[0][5], three[0][6], three[0][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{three[1][0], three[1][1], three[1][2], three[1][3], three[1][4], three[1][5], three[1][6], three[1][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{three[2][0], three[2][1], three[2][2], three[2][3], three[2][4], three[2][5], three[2][6], three[2][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{three[3][0], three[3][1], three[3][2], three[3][3], three[3][4], three[3][5], three[3][6], three[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{three[4][0], three[4][1], three[4][2], three[4][3], three[4][4], three[4][5], three[4][6], three[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{three[5][0], three[5][1], three[5][2], three[5][3], three[5][4], three[5][5], three[5][6], three[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{three[6][0], three[6][1], three[6][2], three[6][3], three[6][4], three[6][5], three[6][6], three[6][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{three[7][0], three[7][1], three[7][2], three[7][3], three[7][4], three[7][5], three[7][6], three[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init four
		{four[0][0], four[0][1], four[0][2], four[0][3], four[0][4], four[0][5], four[0][6], four[0][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{four[1][0], four[1][1], four[1][2], four[1][3], four[1][4], four[1][5], four[1][6], four[1][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{four[2][0], four[2][1], four[2][2], four[2][3], four[2][4], four[2][5], four[2][6], four[2][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{four[3][0], four[3][1], four[3][2], four[3][3], four[3][4], four[3][5], four[3][6], four[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{four[4][0], four[4][1], four[4][2], four[4][3], four[4][4], four[4][5], four[4][6], four[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{four[5][0], four[5][1], four[5][2], four[5][3], four[5][4], four[5][5], four[5][6], four[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{four[6][0], four[6][1], four[6][2], four[6][3], four[6][4], four[6][5], four[6][6], four[6][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{four[7][0], four[7][1], four[7][2], four[7][3], four[7][4], four[7][5], four[7][6], four[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init five
		{five[0][0], five[0][1], five[0][2], five[0][3], five[0][4], five[0][5], five[0][6], five[0][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{five[1][0], five[1][1], five[1][2], five[1][3], five[1][4], five[1][5], five[1][6], five[1][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{five[2][0], five[2][1], five[2][2], five[2][3], five[2][4], five[2][5], five[2][6], one[2][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{five[3][0], five[3][1], five[3][2], five[3][3], five[3][4], five[3][5], five[3][6], five[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{five[4][0], five[4][1], five[4][2], five[4][3], five[4][4], five[4][5], five[4][6], five[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{five[5][0], five[5][1], five[5][2], five[5][3], five[5][4], five[5][5], five[5][6], five[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{five[6][0], five[6][1], five[6][2], five[6][3], five[6][4], five[6][5], five[6][6], five[6][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{five[7][0], five[7][1], five[7][2], five[7][3], five[7][4], five[7][5], five[7][6], five[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init six
		{six[0][0], six[0][1], six[0][2], six[0][3], six[0][4], six[0][5], six[0][6], six[0][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{six[1][0], six[1][1], six[1][2], six[1][3], six[1][4], six[1][5], six[1][6], six[1][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{six[2][0], six[2][1], six[2][2], six[2][3], six[2][4], six[2][5], six[2][6], six[2][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0 };
		{six[3][0], six[3][1], six[3][2], six[3][3], six[3][4], six[3][5], six[3][6], six[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{six[4][0], six[4][1], six[4][2], six[4][3], six[4][4], six[4][5], six[4][6], six[4][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{six[5][0], six[5][1], six[5][2], six[5][3], six[5][4], six[5][5], six[5][6], six[5][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{six[6][0], six[6][1], six[6][2], six[6][3], six[6][4], six[6][5], six[6][6], six[6][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{six[7][0], six[7][1], six[7][2], six[7][3], six[7][4], six[7][5], six[7][6], six[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init seven
		{seven[0][0], seven[0][1], seven[0][2], seven[0][3], seven[0][4], seven[0][5], seven[0][6], seven[0][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{seven[1][0], seven[1][1], seven[1][2], seven[1][3], seven[1][4], seven[1][5], seven[1][6], seven[1][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{seven[2][0], seven[2][1], seven[2][2], seven[2][3], seven[2][4], seven[2][5], seven[2][6], seven[2][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{seven[3][0], seven[3][1], seven[3][2], seven[3][3], seven[3][4], seven[3][5], seven[3][6], seven[3][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{seven[4][0], seven[4][1], seven[4][2], seven[4][3], seven[4][4], seven[4][5], seven[4][6], seven[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{seven[5][0], seven[5][1], seven[5][2], seven[5][3], seven[5][4], seven[5][5], seven[5][6], seven[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{seven[6][0], seven[6][1], seven[6][2], seven[6][3], seven[6][4], seven[6][5], seven[6][6], seven[6][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{seven[7][0], seven[7][1], seven[7][2], seven[7][3], seven[7][4], seven[7][5], seven[7][6], seven[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init eight
		{eight[0][0], eight[0][1], eight[0][2], eight[0][3], eight[0][4], eight[0][5], eight[0][6], eight[0][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{eight[1][0], eight[1][1], eight[1][2], eight[1][3], eight[1][4], eight[1][5], eight[1][6], eight[1][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{eight[2][0], eight[2][1], eight[2][2], eight[2][3], eight[2][4], eight[2][5], eight[2][6], eight[2][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{eight[3][0], eight[3][1], eight[3][2], eight[3][3], eight[3][4], eight[3][5], eight[3][6], eight[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{eight[4][0], eight[4][1], eight[4][2], eight[4][3], eight[4][4], eight[4][5], eight[4][6], eight[4][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{eight[5][0], eight[5][1], eight[5][2], eight[5][3], eight[5][4], eight[5][5], eight[5][6], eight[5][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{eight[6][0], eight[6][1], eight[6][2], eight[6][3], eight[6][4], eight[6][5], eight[6][6], eight[6][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{eight[7][0], eight[7][1], eight[7][2], eight[7][3], eight[7][4], eight[7][5], eight[7][6], eight[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		// init nine
		{nine[0][0], nine[0][1], nine[0][2], nine[0][3], nine[0][4], nine[0][5], nine[0][6], nine[0][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{nine[1][0], nine[1][1], nine[1][2], nine[1][3], nine[1][4], nine[1][5], nine[1][6], nine[1][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{nine[2][0], nine[2][1], nine[2][2], nine[2][3], nine[2][4], nine[2][5], nine[2][6], nine[2][7]} = { 1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{nine[3][0], nine[3][1], nine[3][2], nine[3][3], nine[3][4], nine[3][5], nine[3][6], nine[3][7]} = { 1'b0,1'b0,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0 };
		{nine[4][0], nine[4][1], nine[4][2], nine[4][3], nine[4][4], nine[4][5], nine[4][6], nine[4][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{nine[5][0], nine[5][1], nine[5][2], nine[5][3], nine[5][4], nine[5][5], nine[5][6], nine[5][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{nine[6][0], nine[6][1], nine[6][2], nine[6][3], nine[6][4], nine[6][5], nine[6][6], nine[6][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0 };
		{nine[7][0], nine[7][1], nine[7][2], nine[7][3], nine[7][4], nine[7][5], nine[7][6], nine[7][7]} = { 1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0 };
		
		
		reset = 1'b0;
		disp_i = 5'b0;
		disp_j = 5'b0;
		state = q_BACKGROUND;
	end


    // Logic for drawing a number
	parameter V_OFFSET = 80;
	parameter H_OFFSET = 260;
	parameter DIM = 42;
	// temporary variables
	reg[11:0] x, y, xf, yf;// not sure bout the width from memory..
	reg[2:0] col, row;
	reg raster;
	
	integer row_in_padding;
	integer col_in_padding;
	
	always@ ( * ) 
	begin
		rgb = BLUE;
    	if (~bright)
		    rgb = BLACK; // force black if not bright
		if((thickBorderHorizontal == 1) || (thickBorderVertical == 1))
			rgb = BLACK;
		else if((thinHorizontal == 1) || (thinVertical == 1))
			rgb = BLACK;
		else if(whiteZone == 1)
		begin
			rgb = WHITE;
			x = 9;
			y = 9;
			xf = 0;
			yf = 0;
			// determine x value
			if((hCount >= 10'd260) && (hCount < 10'd302))
			begin
				x = 0;
				xf = hCount - 10'd260;
			end
			else if((hCount >= 10'd304) && (hCount < 10'd346))
			begin
				x = 1;
				xf = hCount - 10'd304;
			end
			else if((hCount >= 10'd348) && (hCount < 10'd390))
			begin
				x = 2;
				xf = hCount - 10'd348;
			end
			else if((hCount >= 10'd395) && (hCount < 10'd437))
			begin
				x = 3;
				xf = hCount - 10'd395;
			end
			else if((hCount >= 10'd439) && (hCount < 10'd481))
			begin
				x = 4;
				xf = hCount - 10'd439;
			end
			else if((hCount >= 10'd483) && (hCount < 10'd525))
			begin
				x = 5;
				xf = hCount - 10'd483;
			end
			else if((hCount >= 10'd530) && (hCount < 10'd572))
			begin
				x = 6;
				xf = hCount - 10'd530;
			end
			else if ((hCount >= 10'd574) && (hCount < 10'd616))
			begin
				x =7;
				xf = hCount - 10'd574;
			end
			else if ((hCount >= 10'd618) && (hCount < 10'd660))
			begin
				x = 8;
				xf = hCount - 10'd618;
			end
				
			if((vCount >= 10'd80) && (vCount < 10'd122))
			begin
				y = 0;
				yf = vCount - 10'd80;
			end
			else if((vCount >= 10'd124) && (vCount < 10'd166))
			begin
				y = 1;
				yf = vCount - 10'd124;
			end
			else if((vCount >= 10'd168) && (vCount < 10'd210))
			begin
				y = 2;
				yf = vCount - 10'd168;
			end
			else if((vCount >= 10'd215) && (vCount < 10'd257))
			begin
				y = 3;
				yf = vCount - 10'd215;
			end
			else if ((vCount >= 10'd259) && (vCount < 10'd301))
			begin
				y = 4;
				yf = vCount - 10'd259;
			end
			else if((vCount >= 10'd303) && (vCount < 10'd345))
			begin
				y = 5;
				yf = vCount - 10'd303;
			end
			else if ((vCount >= 10'd350) && (vCount < 10'd392))
			begin
				y = 6;
				yf = vCount - 10'd350;
			end
			else if((vCount >= 10'd394) && (vCount < 10'd436))
			begin
				y = 7;
				yf = vCount - 10'd394;
			end
			else if((vCount >= 10'd438) && (vCount < 10'd480))
			begin
				y = 8;
				yf = vCount - 10'd438;
			end
			disp_i = y;
			disp_j = x;
			
			if(x==i && y == j)
				rgb = RED;
			
			
			if (xf > 10 && xf < 26 && yf > 10 && yf < 26)
			begin
			    col = (xf - 10) >> 1;
			    row = (yf - 10) >> 1;

			    if (disp_value == 5'b1)
				    raster = (col == 6) ? 1 : 0;
			    else if (disp_value == 2)
				begin
					if((row == 0 || row == 3 || row == 7) && (col >= 1 && col < 7))
						raster = 1;
					else if(col == 6 && (row <= 3))
						 raster = 1;
					else if(col == 1 && (row >= 4))
						raster = 1;
					else	
						raster = 0;
				end
			    else if (disp_value == 3)
				begin
					if(col == 6)
						raster = 1;
					else if((row == 0 || row == 3 || row == 7) && (col >= 1 && col < 7))
						raster = 1;
					else
						raster = 0;
				end
			    else if (disp_value == 4)
			        begin
					if(col == 6)
						raster = 1;
					else if(col == 1 && (row <= 3))
						raster = 1;
					else if(row == 3 && (col >= 1 && col < 7))
						raster = 1;
					else	
						raster = 0;
				    end
			    else if (disp_value == 5)
			        begin
				    if((row == 0 || row == 3 || row == 7) && (col > 0 && col < 7))
						raster = 1;
					else if(col == 1 && (row <= 3))
						raster = 1;
					else if(col == 6 && row >= 3)
						raster = 1;
					else
						raster = 0;
				    end
			    else if (disp_value == 6)
			        begin
					if(col == 1)
						raster = 1;
					else if((row == 7 || row == 4) && (col >= 1 && col < 7))
						raster = 1;
					else if(col == 6 && row >= 4)
						raster = 1;
					else 
						raster = 0;
				    end
			    else if (disp_value == 7)
				begin
					if (col == 6)
						raster = 1;
					else if(row == 0 && col >= 1 && col <= 6)
						raster = 1;
					else
						raster = 0;
				end
			    else if (disp_value == 8)
				begin
					if(col == 1 || col == 6)
						raster = 1;
					else if(row == 0 || row == 3 || row == 7 && (col >= 1 && col < 7))
						raster = 1;
					else
						raster = 0;
				end
			    else if (disp_value == 9)
					begin
					if(col == 6)
						raster = 1;
					else if (col == 1 && row <= 3)
						raster = 1;
					else if(row == 0 || row == 3 || row == 7 && (col >= 1 && col < 7))
						raster = 1;
					else
						raster = 0;
					end
				else
					raster = 0;
				
				if (raster == 1'b1)
					rgb = BLACK;
				else if(i == x && j == y)
					rgb = RED;
				else
					rgb = WHITE;
	        end
			/*if((col ==0) && ((hCount < 10'd273) || (hCount >= 10'd289)))
				begin
				if((hCount < 10'd260 + 10'd5) || (hCount >= 10'd302 - 10'd5))
					col_in_padding = 1;
				end
				

			if((row == 4) && ( (vCount < 10'd259 + 10'd13) || (vCount >= 10'd301 - 10'd13)))
				begin
				if((vCount < 10'd259 + 10'd5) || (vCount >= 10'd301 - 10'd5))
					row_in_padding = 1;
				end
				
			if((row_in_padding == 1 || col_in_padding == 1) && i == row && j == col)
				rgb = RED; */
			
		end
			
	end
        /*else if(thickBorderHorizontal == 1) 
            rgb = BLACK;
		else if(thickBorderVertical == 1)
			rgb = BLACK;
		else if(thinHorizontal == 1)
			rgb = BLACK;
		else if(thinVertical == 1)
			rgb = BLACK;
        /*else if(thinBorder == 1) 
            rgb = BLACK;
        else if(whiteZone == 1) 
            rgb = WHITE;
        else
            rgb = BLUE;*/
			
	always @ (posedge clk)
	begin
		if(thickBorderHorizontal == 1)
			state <= q_THICKBORDER;
		else if(thickBorderVertical == 1)
			state <= q_THICKBORDER;
		else if(thinHorizontal == 1)
			state <= q_THINBORDER;
		else if(thinVertical == 1)
			state <= q_THINBORDER;
		else if(whiteZone == 1)
			state <= q_WHITESPACE;
		else
			state <= q_BACKGROUND;
	end

	
	/*always@ (*) 
	begin
	    if(thickBorderHorizontal == 1) 
		begin
		    state = q_THICKBORDER;
		end
		else if(thickBorderVertical == 1)
		begin
		    state = q_THICKBORDER;
		end
		else if(thinHorizontal == 1)
		begin
			state = q_THINBORDER;
		end
		else if(thinVertical == 1)
		begin
			state = q_THINBORDER;
        end
        /*else if(whiteZone == 1) 
		begin
			// determine x value
			if((hCount >= 10'd260) && (hCount < 10'd302))
				x = 1;
			else if((hCount >= 10'd304) && (hCount < 10'd346))
				x = 2;
			else if((hCount >= 10'd348) && (hCount < 10'd390))
				x = 3;
			else if((hCount >= 10'd395) && (hCount < 10'd437))
				x = 4;
			else if((hCount >= 10'd439) && (hCount < 10'd481))
				x = 5;
			else if((hCount >= 10'd483) && (hCount < 10'd525))
				x = 6;
			else if((hCount >= 10'd530) && (hCount < 10'd572))
				x = 7;
			else if ((hCount >= 10'd574) && (hCount < 10'd616))
				x = 8;
			else if ((hCount >= 10'd618) && (hCount < 10'd660))
				x = 9;
				
			if((vCount >= 10'd80) && (vCount < 10'd122))
				y = 1;
			else if((vCount >= 10'd124) && (vCount < 10'd166))
				y = 2;
			else if((vCount >= 10'd168) && (vCount < 10'd210))
				y = 3;
			else if((vCount >= 10'd215) && (vCount < 10'd257))
				y = 4;
			else if ((vCount >= 10'd259) && (vCount < 10'd301))
				y = 5;
			else if((vCount >= 10'd303) && (vCount < 10'd345))
				y = 6;
			else if ((vCount >= 10'd350) && (vCount < 10'd392))
				y = 7;
			else if((vCount >= 10'd394) && (vCount < 10'd436))
				y = 8;
			else if((vCount >= 10'd438) && (vCount < 10'd480))
				y = 9;
				
			disp_i = x;
			disp_j = y;
			col = y;
			row = x;
			col_in_padding = 0;
			row_in_padding = 0;
			
			// If in padding
			if((col == 1) && ((hCount < 10'd273) || (hCount >= 10'd289)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd260 + 10'd5) || (hCount >= 10'd302 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 2) && ( (hCount < 10'd304 + 10'd13) || (hCount >= 10'd346 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd304 + 10'd5) || (hCount >= 10'd346 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 3) && ( (hCount < 10'd348 + 10'd13) || (hCount >= 10'd390 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd348 + 10'd5) || (hCount >= 10'd390 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 4) && ( (hCount < 10'd395 + 10'd13) || (hCount >= 10'd437 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd395 + 10'd5) || (hCount >= 10'd437 - 10'd5))
					col_in_padding = 1;
				end
			else if((col ==5) && ( (hCount < 10'd439 + 10'd13) || (hCount >= 10'd481 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd439 + 10'd5) || (hCount >= 10'd481 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 6) && ( (hCount < 10'd483 + 10'd13) || (hCount >= 10'd525 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd483 + 10'd5) || (hCount >= 10'd525 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 7) && ( (hCount < 10'd530 + 10'd13) || (hCount >= 10'd572 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd530 + 10'd5) || (hCount >= 10'd572 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 8) && ( (hCount < 10'd574 + 10'd13) || (hCount >= 10'd616 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd574 + 10'd5) || (hCount >= 10'd616 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 9) && ( (hCount < 10'd618 + 10'd13) || (hCount >= 10'd660 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((hCount < 10'd618 + 10'd5) || (hCount >= 10'd660 - 10'd5))
					col_in_padding = 1;
				end
				
			else if((row == 1) && ( (vCount < 10'd80 + 10'd13) || (vCount >= 10'd122 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd80 + 10'd5) || (vCount >= 10'd122 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 2) && ( (vCount < 10'd124 + 10'd13) || (vCount >= 10'd166 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd124 + 10'd5) || (vCount >= 10'd166 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 3) && ( (vCount < 10'd168 + 10'd13) || (vCount >= 10'd210 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd168 + 10'd5) || (vCount >= 10'd210 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 4) && ( (vCount < 10'd215 + 10'd13) || (vCount >= 10'd257 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd215 + 10'd5) || (vCount >= 10'd257 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 5) && ( (vCount < 10'd259 + 10'd13) || (vCount >= 10'd301 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd259 + 10'd5) || (vCount >= 10'd301 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 6) && ( (vCount < 10'd303 + 10'd13) || (vCount >= 10'd345 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd303 + 10'd5) || (vCount >= 10'd345 - 10'd5))
					row_in_padding = 1;
				end
			else if((row ==7) && ( (vCount < 10'd350 + 10'd13) || (vCount >= 10'd392 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd350 + 10'd5) || (vCount >= 10'd392 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 8) && ( (vCount < 10'd394 + 10'd13) || (vCount >= 10'd436 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd394 + 10'd5) || (vCount >= 10'd436 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 9) && ( (vCount < 10'd438 + 10'd13) || (vCount >= 10'd480 - 10'd13)))
				begin
				state = q_WHITESPACE;
				if((vCount < 10'd438 + 10'd5) || (vCount >= 10'd480 - 10'd5))
					row_in_padding = 1;
				end
			else 
			begin
			
			
				row = (row - 13) >> 2;
				col = (col - 13) >> 2;
			
				if(disp_value == 0)
					begin
					state = q_WHITESPACE;
					end
				else if(disp_value == 1)
					begin
					state = one[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 2)
					begin
					state = two[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 3)
					begin
					state = three[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 4)
					begin
					state <= four[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 5)
					begin
					state = five[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 6)
					begin
					state = six[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 7)
					begin
					state = seven[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 8)
					begin
					state = eight[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 9)
					begin
					state = nine[row][col] ? q_NUMBER : q_WHITESPACE;
					end
			end
			if((row_in_padding == 1) && (col_in_padding == 1) && (i == row) && (j == col))
				state = q_RED;
		end*/
        /*else
		    begin
                state = q_BACKGROUND;
		    end
			
	    /*if (~bright)
		    rgb = BLUE; // force black if not bright
        else if(state == q_THICKBORDER) 
            rgb = BLACK;
		/*else if(state == q_THINBORDER)
			rgb = 12'b1000_1000_1000;
		else if(state == q_RED)
			rgb = RED;
		else if(state == q_NUMBER)
			rgb = 12'b1111_0000_1111;
        else if(state == q_WHITESPACE) 
            rgb = WHITE;
        else
            rgb = BLUE;*/
			
			
    	/*if (~bright)
		    rgb = BLACK; // force black if not bright
        else if(state == q_THICKBORDER) 
            rgb = BLACK;
		else if(state == q_THINBORDER)
			rgb = BLACK;
		else if(state == q_RED)
			rgb = RED;
		else if(state == q_NUMBER)
			rgb = BLACK;
        else if(state == q_WHITESPACE) 
            rgb = WHITE;
        else
            rgb = BLUE;*/
	
	/*end*/
	
	// Convert above code to always block below
	/*
	always @ (posedge clk)
	begin
		if(~bright)
			rgb = BLACK;
		else if(thickBorderHorizontal == 1) 
			begin
			state <= q_THICKBORDER;
			end
		else if(thickBorderVertical == 1)
			begin
			state <= q_THICKBORDER;
			end
		else if(thinHorizontal == 1)
		begin
			state <= q_THINBORDER;
		end
		else if(thinVertical == 1)
		begin
			state <= q_THINBORDER;
        end
        else if(whiteZone == 1) 
		begin
			// determine x value
			if((hCount >= 10'd260) && (hCount < 10'd302))
				x = 1;
			else if((hCount >= 10'd304) && (hCount < 10'd346))
				x = 2;
			else if((hCount >= 10'd348) && (hCount < 10'd390))
				x = 3;
			else if((hCount >= 10'd395) && (hCount < 10'd437))
				x = 4;
			else if((hCount >= 10'd439) && (hCount < 10'd481))
				x = 5;
			else if((hCount >= 10'd483) && (hCount < 10'd525))
				x = 6;
			else if((hCount >= 10'd530) && (hCount < 10'd572))
				x = 7;
			else if ((hCount >= 10'd574) && (hCount < 10'd616))
				x = 8;
			else if ((hCount >= 10'd618) && (hCount < 10'd660))
				x = 9;
				
			if((vCount >= 10'd80) && (vCount < 10'd122))
				y = 1;
			else if((vCount >= 10'd124) && (vCount < 10'd166))
				y = 2;
			else if((vCount >= 10'd168) && (vCount < 10'd210))
				y = 3;
			else if((vCount >= 10'd215) && (vCount < 10'd257))
				y = 4;
			else if ((vCount >= 10'd259) && (vCount < 10'd301))
				y = 5;
			else if((vCount >= 10'd303) && (vCount < 10'd345))
				y = 6;
			else if ((vCount >= 10'd350) && (vCount < 10'd392))
				y = 7;
			else if((vCount >= 10'd394) && (vCount < 10'd436))
				y = 8;
			else if((vCount >= 10'd438) && (vCount < 10'd480))
				y = 9;
				
			disp_i = x;
			disp_j = y;
			col = y;
			row = x;
			col_in_padding = 0;
			row_in_padding = 0;
			
			// If in padding
			if((col == 1) && ((hCount < 10'd273) || (hCount >= 10'd289)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd260 + 10'd5) || (hCount >= 10'd302 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 2) && ( (hCount < 10'd304 + 10'd13) || (hCount >= 10'd346 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd304 + 10'd5) || (hCount >= 10'd346 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 3) && ( (hCount < 10'd348 + 10'd13) || (hCount >= 10'd390 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd348 + 10'd5) || (hCount >= 10'd390 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 4) && ( (hCount < 10'd395 + 10'd13) || (hCount >= 10'd437 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd395 + 10'd5) || (hCount >= 10'd437 - 10'd5))
					col_in_padding = 1;
				end
			else if((col ==5) && ( (hCount < 10'd439 + 10'd13) || (hCount >= 10'd481 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd439 + 10'd5) || (hCount >= 10'd481 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 6) && ( (hCount < 10'd483 + 10'd13) || (hCount >= 10'd525 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd483 + 10'd5) || (hCount >= 10'd525 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 7) && ( (hCount < 10'd530 + 10'd13) || (hCount >= 10'd572 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd530 + 10'd5) || (hCount >= 10'd572 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 8) && ( (hCount < 10'd574 + 10'd13) || (hCount >= 10'd616 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd574 + 10'd5) || (hCount >= 10'd616 - 10'd5))
					col_in_padding = 1;
				end
			else if((col == 9) && ( (hCount < 10'd618 + 10'd13) || (hCount >= 10'd660 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((hCount < 10'd618 + 10'd5) || (hCount >= 10'd660 - 10'd5))
					col_in_padding = 1;
				end
				
			else if((row == 1) && ( (vCount < 10'd80 + 10'd13) || (vCount >= 10'd122 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd80 + 10'd5) || (vCount >= 10'd122 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 2) && ( (vCount < 10'd124 + 10'd13) || (vCount >= 10'd166 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd124 + 10'd5) || (vCount >= 10'd166 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 3) && ( (vCount < 10'd168 + 10'd13) || (vCount >= 10'd210 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd168 + 10'd5) || (vCount >= 10'd210 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 4) && ( (vCount < 10'd215 + 10'd13) || (vCount >= 10'd257 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd215 + 10'd5) || (vCount >= 10'd257 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 5) && ( (vCount < 10'd259 + 10'd13) || (vCount >= 10'd301 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd259 + 10'd5) || (vCount >= 10'd301 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 6) && ( (vCount < 10'd303 + 10'd13) || (vCount >= 10'd345 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd303 + 10'd5) || (vCount >= 10'd345 - 10'd5))
					row_in_padding = 1;
				end
			else if((row ==7) && ( (vCount < 10'd350 + 10'd13) || (vCount >= 10'd392 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd350 + 10'd5) || (vCount >= 10'd392 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 8) && ( (vCount < 10'd394 + 10'd13) || (vCount >= 10'd436 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd394 + 10'd5) || (vCount >= 10'd436 - 10'd5))
					row_in_padding = 1;
				end
			else if((row == 9) && ( (vCount < 10'd438 + 10'd13) || (vCount >= 10'd480 - 10'd13)))
				begin
				state <= q_WHITESPACE;
				if((vCount < 10'd438 + 10'd5) || (vCount >= 10'd480 - 10'd5))
					row_in_padding = 1;
				end
			else 
			begin
			
			
				row = (row - 13) >> 2;
				col = (col - 13) >> 2;
			
				if(disp_value == 0)
					begin
					state <= q_WHITESPACE;
					end
				else if(disp_value == 1)
					begin
					state <= one[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 2)
					begin
					state <= two[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 3)
					begin
					state <= three[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 4)
					begin
					state <= four[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 5)
					begin
					state <= five[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 6)
					begin
					state <= six[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 7)
					begin
					state <= seven[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 8)
					begin
					state <= eight[row][col] ? q_NUMBER : q_WHITESPACE;
					end
				else if(disp_value == 9)
					begin
					state <= nine[row][col] ? q_NUMBER : q_WHITESPACE;
					end
			end
			if((row_in_padding == 1) && (col_in_padding == 1) && (i == row) && (j == col))
				state <= q_RED;
		end
        else
		begin
            state <= q_BACKGROUND;
		end
		
	end*/
	

    // general white area of board (includes borders)
    // 470 x 47
	assign whiteZone = ((hCount >= 10'd260) && (hCount < 10'd660) && (vCount >= 10'd80) && (vCount < 10'd480)) ? 1 : 0;
	
	assign thinHorizontal = ((hCount >= 10'd260 - 10'd5) && (hCount < 10'd660 + 10'd5) && (( (vCount >= 10'd122) && (vCount < 10'd124)) || ((vCount >= 10'd166) && (vCount < 10'd168)) || ( (vCount >= 10'd257) && (vCount < 10'd259) ) || ( (vCount >= 10'd301) && (vCount < 10'd303)) || ( (vCount >= 10'd392) && (vCount < 10'd394)) || ( (vCount >= 10'd436) && (vCount < 10'd438) ))) ? 1 : 0;
	
	assign thickBorderHorizontal = ( (hCount >= 10'd260 - 10'd5) && (hCount < 10'd660 + 10'd5) && (((vCount >= 10'd80 - 10'd5) && (vCount < 10'd80)) || ( (vCount >= 10'd210) && (vCount < 10'd210 + 10'd5) ) || ( (vCount >= 10'd345) && (vCount < 10'd350) ) || ( (vCount >= 10'd480) && (vCount < 10'd485) ) ) ) ? 1 : 0;
	
	// 42 pixels whitespace, 2 pixels thick
	assign thinVertical = ( (vCount >= 10'd80 - 10'd5) && (vCount < 10'd480 + 10'd5) && ( ( (hCount >= 10'd302) && (hCount < 10'd304) ) || ((hCount >= 10'd346) && (hCount < 10'd348)) || ((hCount >= 10'd437) && (hCount < 10'd439)) || ((hCount >= 10'd481) && (hCount < 10'd 483)) || ((hCount >= 10'd572) && (hCount < 10'd574)) || ((hCount >= 10'd616) && (hCount < 10'd618)) )) ? 1 : 0;
	
	assign thickBorderVertical = ( (vCount >= 10'd80 - 10'd5) && (vCount < 10'd480 + 10'd5) && ( ( (hCount >= 10'd260 - 10'd5) && (hCount < 10'd260) ) || ( (hCount >= 10'd390) && (hCount < 10'd390 + 10'd5) ) || ( ( hCount >= 10'd525) && (hCount < 10'd525 + 10'd5) ) || ( (hCount >= 10'd660) && (hCount < 10'd660 + 10'd5) ) ) ) ? 1 : 0;
	
	
endmodule
