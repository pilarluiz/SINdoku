//////////////////////////////////////////////////////////////////////////////////
// Author:			Shideh Shahidi, Bilal Zafar, Gandhi Puvvada
// Create Date:		02/25/08
// File Name:		ee354_GCD_top.v 
// Description: 
//
//
// Revision: 		2.2
// Additional Comments: 
// 10/13/2008 debouncing and single_clock_wide pulse_generation modules are added by Gandhi
// 10/13/2008 Clock Enable (CEN) has been added by Gandhi
//  3/ 1/2010 The Spring 2009 debounce design is replaced by the Spring 2010 debounce design
//            Now, in part 2 of the GCD lab, we do single-stepping 
//  2/19/2012 Nexys-2 to Nexys-3 conversion done by Gandhi
//  02/20/2020 Nexys-3 to Nexys-4 conversion done by Yue (Julien) Niu
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ee354_GCD_top
		(MemOE, MemWR, RamCS, QuadSpiFlashCS, // Disable the three memory chips

        ClkPort,                           // the 100 MHz incoming clock signal
		
		BtnL, BtnU, BtnD, BtnR,            // the Left, Up, Down, and the Right buttons BtnL, BtnR,
		BtnC,                              // the center button take the number
		
		Sw15, Sw14, Sw13, //reset&ack&check switch
		Sw3, Sw2, Sw1, Sw0, // 4 switches for number 
		Ld7, Ld6, Ld5, Ld4, Ld3,
		An3, An2, An1, An0,			       // 4 anodes
		An7, An6, An5, An4,                // another 4 anodes which are not used
		Ca, Cb, Cc, Cd, Ce, Cf, Cg,        // 7 cathodes
		Dp,                                 // Dot Point Cathode on SSDs

		//VGA signal
		hSync, vSync,
		vgaR, vgaG, vgaB
	  );

	/*  INPUTS */
	// Clock & Reset I/O
	input		ClkPort;	
	// Project Specific Inputs
	input		BtnL, BtnU, BtnD, BtnR, BtnC;	
	input		Sw15, Sw14, Sw13, Sw3, Sw2, Sw1, Sw0;
	
	
	/*  OUTPUTS */
	// Control signals on Memory chips 	(to disable them)
	output 	MemOE, MemWR, RamCS, QuadSpiFlashCS;
	// Project Specific Outputs
	// LEDs
	output Ld7, Ld6, Ld5, Ld4, Ld3;
	// SSD Outputs
	output 	Cg, Cf, Ce, Cd, Cc, Cb, Ca, Dp;
	output 	An0, An1, An2, An3;	
	output 	An4, An5, An6, An7;	
	
	output hSync, vSync;
	output [3:0] vgaR, vgaG, vgaB;

	
	/*  LOCAL SIGNALS */
	wire		Reset, ClkPort;
	wire		board_clk, sys_clk;
	wire [1:0] 	ssdscan_clk;
	reg [26:0]	DIV_CLK;
	
	wire Start_Ack_Pulse;
	wire BtnR_Pulse, BtnL_Pulse, BtnU_Pulse, BtnD_Pulse, BtnC_Pulse;
	// Changed userIn to a reg
	reg [3:0] userIn;
	
	reg [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  SSD_CATHODES;

	// VGA
	wire bright;
	wire[9:0] hc, vc;
	// wire[15:0] score;
	// wire [6:0] ssdOut;
	// wire [3:0] anode;
	wire [11:0] rgb;
	
//------------	
// Disable the three memories so that they do not interfere with the rest of the design.
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	
	
//------------
// CLOCK DIVISION

	// The clock division circuitary works like this:
	//
	// ClkPort ---> [BUFGP2] ---> board_clk
	// board_clk ---> [clock dividing counter] ---> DIV_CLK
	// DIV_CLK ---> [constant assignment] ---> sys_clk;
	
	BUFGP BUFGP1 (board_clk, ClkPort); 	

// As the ClkPort signal travels throughout our design,
// it is necessary to provide global routing to this signal. 
// The BUFGPs buffer these input ports and connect them to the global 
// routing resources in the FPGA.

	assign Reset = Sw15;
	assign CheckSolu = Sw13;
	assign Ack = Sw14;
	
//------------
	// Our clock is too fast (100MHz) for SSD scanning
	// create a series of slower "divided" clocks
	// each successive bit is 1/2 frequency
  always @(posedge board_clk, posedge Reset) 	
    begin							
        if (Reset)
		DIV_CLK <= 0;
        else
		DIV_CLK <= DIV_CLK + 1'b1;
    end
//-------------------	
	// In this design, we run the core design at full 100MHz clock!
	assign	sys_clk = board_clk;
	// assign	sys_clk = DIV_CLK[25];

//------------
// INPUT: SWITCHES & BUTTONS
	// BtnL is used as both Start and Acknowledge. 
	// Is the debouncing of the start/ack signal necessary? Discuss with your TA

ee354_debouncer #(.N_dc(28)) ee354_debouncer_4 
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnL), .DPB( ), 
		.SCEN(BtnL_Pulse), .MCEN( ), .CCEN( ));

ee354_debouncer #(.N_dc(28)) ee354_debouncer_3 
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnR), .DPB( ), 
		.SCEN(BtnR_Pulse), .MCEN( ), .CCEN( ));
ee354_debouncer #(.N_dc(28)) ee354_debouncer_2 
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnU), .DPB( ), 
		.SCEN(BtnU_Pulse), .MCEN( ), .CCEN( ));
ee354_debouncer #(.N_dc(28)) ee354_debouncer_1 
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnD), .DPB( ), 
		.SCEN(BtnD_Pulse), .MCEN( ), .CCEN( ));

ee354_debouncer #(.N_dc(28)) ee354_debouncer_0 // ****** TODO  in Part 2 ******
        (.CLK(sys_clk), .RESET(Reset), .PB(BtnC), .DPB( ), // complete this instantiation
		.SCEN(BtnC_Pulse), .MCEN( ), .CCEN( )); // to produce BtnU_Pulse from BtnU
		
//------------
// DESIGN
	// On two pushes of BtnR, numbers A and B are recorded in Ain and Bin
    // (registers of the TOP) respectively
	always @ (posedge sys_clk, posedge Reset)
	begin
		if(Reset)
		begin
			userIn<= 4'bXXXX;
		end
		else
		begin
			userIn <= {Sw3, Sw2, Sw1, Sw0};
		end
	end
	
	wire [4:0] disp_i, disp_j, disp_value;
	wire [4:0] i, j;
	
	// the state machine module
	sindoku sindoku_1(.Clk(sys_clk), .R(BtnR_Pulse), .L(BtnL_Pulse), .U(BtnU_Pulse), .D(BtnD_Pulse), .C(BtnC_Pulse), .Reset(Reset), .Ack(Ack),
						  .CheckSolu(CheckSolu), .userIn(userIn), .q_I(q_I), .q_Solve(q_Solve), .q_Check(q_Check), .q_Correct(q_Correct), .q_Incorrect(q_Incorrect),
						  .i(i), .j(j), .row(row), .col(col), .puzzle_ij(puzzle_ij), .solu_ij(solu_ij),
						  .disp_i(disp_i), .disp_j(disp_j), .disp_value(disp_value));

	// VGA DISPLAY
	display_controller dc(.clk(board_clk), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));

	vga_bitchange vbc(.clk(board_clk), .bright(bright), .button(BtnU), .hCount(hc), .vCount(vc), .rgb(rgb), .disp_i(disp_i), .disp_j(disp_j), .disp_value(disp_value), .i(i), .j(j));

//------------
// OUTPUT: LEDS
	
	assign {Ld7, Ld6, Ld5, Ld4, Ld3} = {q_I, q_Solve, q_Check, q_Correct, q_Incorrect};
	
	
//------------
// SSD (Seven Segment Display)
	
	//SSDs show Ain and Bin in initial state, A and B in subtract state, and GCD and i_count in multiply and done states.
	// ****** TODO  in Part 2 ******
	// assign y = s ? i1 : i0;  // an example of a 2-to-1 mux coding
	// assign y = s1 ? (s0 ? i3: i2): (s0 ? i1: i0); // an example of a 4-to-1 mux coding
	
	assign SSD0 = userIn;


	// need a scan clk for the seven segment display 
	// 191Hz (100 MHz / 2^19) works well	
	
	assign An0	=  1'b0;  // when ssdscan_clk = 11
	// close another four anodes
	assign An7 = 1'b1;
	assign An6 = 1'b1;
	assign An5 = 1'b1;
	assign An4 = 1'b1;
	assign An3 = 1'b1;
	assign An2 = 1'b1;
	assign An1 = 1'b1;

	// VGA 
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];

	
	// and finally convert SSD_num to ssd
	// We convert the output of our 4-bit 4x1 mux

	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

	// Following is Hex-to-SSD conversion
	always @ (SSD0) 
	begin : HEX_TO_SSD
		case (SSD0) // in this solution file the dot points are made to glow by making Dp = 0
		    //                                                                abcdefg,Dp
			4'b0000: SSD_CATHODES = 8'b00000011; // 0
			4'b0001: SSD_CATHODES = 8'b10011111; // 1
			4'b0010: SSD_CATHODES = 8'b00100101; // 2
			4'b0011: SSD_CATHODES = 8'b00001101; // 3
			4'b0100: SSD_CATHODES = 8'b10011001; // 4
			4'b0101: SSD_CATHODES = 8'b01001001; // 5
			4'b0110: SSD_CATHODES = 8'b01000001; // 6
			4'b0111: SSD_CATHODES = 8'b00011111; // 7
			4'b1000: SSD_CATHODES = 8'b00000001; // 8
			4'b1001: SSD_CATHODES = 8'b00001001; // 9
			4'b1010: SSD_CATHODES = 8'b00010001; // A
			4'b1011: SSD_CATHODES = 8'b11000001; // B
			4'b1100: SSD_CATHODES = 8'b01100011; // C
			4'b1101: SSD_CATHODES = 8'b10000101; // D
			4'b1110: SSD_CATHODES = 8'b01100001; // E
			4'b1111: SSD_CATHODES = 8'b01110001; // F    
			default: SSD_CATHODES = 8'bXXXXXXXX; // default is not needed as we covered all cases
		endcase
	end	
	
endmodule

