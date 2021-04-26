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
   );
	
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;

	wire whiteZone;
    wire thickBorder;
    wire thinBorder;
	// wire greenMiddleSquare;
	reg reset;
	// reg[9:0] greenMiddleSquareY;
	// reg[49:0] greenMiddleSquareSpeed; 

	initial begin
		// greenMiddleSquareY = 10'd320;
		// score = 15'd0;
		reset = 1'b0;
	end
	
	
	always@ (*) 
    	if (~bright)
		    rgb = BLACK; // force black if not bright
        else if(thickBorder == 1) 
            rgb = BLACK;
        else if(thinBorder == 1) 
            rgb = BLACK;
        else if(whiteZone == 1) 
            rgb = WHITE;
        else
            rgb = BLUE;


        // TODO: figure out how to draw a number

	
	// always@ (posedge clk)
	// 	begin
	// 	greenMiddleSquareSpeed = greenMiddleSquareSpeed + 50'd1;
	// 	if (greenMiddleSquareSpeed >= 50'd500000) //500 thousand
	// 		begin
	// 		greenMiddleSquareY = greenMiddleSquareY + 10'd1;
	// 		greenMiddleSquareSpeed = 50'd0;
	// 		if (greenMiddleSquareY == 10'd779)
	// 			begin
	// 			greenMiddleSquareY = 10'd0;
	// 			end
	// 		end
	// 	end

	// always@ (posedge clk)
	// 	if ((reset == 1'b0) && (button == 1'b1) && (hCount >= 10'd144) && (hCount <= 10'd784) && (greenMiddleSquareY >= 10'd400) && (greenMiddleSquareY <= 10'd475))
	// 		begin
	// 		score = score + 16'd1;
	// 		reset = 1'b1;
	// 		end
	// 	else if (greenMiddleSquareY <= 10'd20)
	// 		begin
	// 		reset = 1'b0;
	// 		end

    // general white area of board (includes borders)
    // 470 x 470
    assign whiteZone = ((hCount >= 10'd85) && (hCount < 10'd555) && (vCount >= 10'd5) && (vCount < 10'd475)) ? 1 : 0;

    // this is the black border that is along the outside edges and separates major squares
    // horizontal borders, vertical borders 
    assign thickBorder = ( ( (hCount >= 10'd85) && (hCount < 10'd555) && ( ( (vCount >= 10'd5) && (vCount < 10'd10) ) || ( (vCount >= 10'd470) && (vCount < 10'd475) ) || ( (vCount >= 10'd160) && (vCount < 10'd165) ) || ( (vCount >= 10'd315) && (vCount < 10'd320) ) ) ) || ( (vCount >= 10'd5) && (vCount < 10'd475) && ( ( (hCount >= 10'd85) && (hCount < 10'd90) ) || ( (hCount >= 10'd240) && (hCount < 10'd245) ) ||  ( (hCount >= 10'd395) && (hCount < 10'd400) ) || ( (hCount >= 10'd550) && (hCount < 10'd555) ) ) ) ? 1 : 0;

    // dividing lines within each 3x3 square
    assign thinBorder = (((vCount >= 10'd10) && (vCount < 10'd470) && ( ( (hCount >= 10'd138) && (hCount < 141) ) || ( (hCount >= 10'd189) && (hCount < 10'd192) ) || ( (hCount >= 10'd293) && (hCount < 10'd296) ) || ( (hCount >= 10'd344) && (hCount < 10'd347) ) || ( (hCount >= 10'd448) && (hCount < 10'd451) ) || ( (hCount >= 10'd499) && (hCount < 10'd502) ) ) ) || ( (hCount >= 10'd90) && (hCount < 10'd550) && ( ( (vCount >= 10'd58) && (vCount < 10'd61) ) || ( (vCount >= 10'd109) && (vCount < 10'd112) ) || ( (vCount >= 10'd213) && (vCount < 10'd216) ) || ( (vCount >= 10'd264) && (vCount < 10'd267) ) || ( (vCount >= 10'd363) && (vCount < 10'd366) ) || ( (vCount >= 10'd414) && (vCount < 10'd417) ) ) )) ? 1 : 0;

    // // vertical lines
    // ((vCount >= 10'd10) && (vCount < 10'd470) && ( ( (hCount >= 10'd138) && (hCount < 141) ) || ( (hCount >= 10'd189) && (hCount < 10'd192) ) || ( (hCount >= 10'd293) && (hCount < 10'd296) ) || ( (hCount >= 10'd344) && (hCount < 10'd347) ) || ( (hCount >= 10'd448) && (hCount < 10'd451) ) || ( (hCount >= 10'd499) && (hCount < 10'd502) ) ) )

    // // horizontal lines
    // ( (hCount >= 10'd90) && (hCount < 10'd550) && ( ( (vCount >= 10'd58) && (vCount < 10'd61) ) || ( (vCount >= 10'd109) && (vCount < 10'd112) ) || ( (vCount >= 10'd213) && (vCount < 10'd216) ) || ( (vCount >= 10'd264) && (vCount < 10'd267) ) || ( (vCount >= 10'd363) && (vCount < 10'd366) ) || ( (vCount >= 10'd414) && (vCount < 10'd417) ) ) )

    // Priority: thick border, thin border, number, white, else
	
endmodule
