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

module sindoku_tb_v;

	// Inputs
	reg Clk, CEN;
	reg Reset;
	reg Start;
	reg Ack;
	reg [7:0] Ain;
	reg [7:0] Bin;

	// Outputs
	wire [7:0] A, B, AB_GCD, i_count;
	wire q_I;
	wire q_Sub;
	wire q_Mult;
	wire q_Done;
	reg [6*8:0] state_string; // 6-character string for symbolic display of state
	integer clk_cnt, start_clock_cnt,clocks_taken;
	// Instantiate the Unit Under Test (UUT)
	sindoku uut(.Clk(sys_clk), .R(BtnR_Pulse), .L(BtnL_Pulse), .U(BtnU_Pulse), .D(BtnD_Pulse), .C(BtnC_Pulse), .Reset(Reset),
						  .CheckSolu(CheckSolu), .userIn(userIn), .q_I(q_I), .q_Solve(q_Solve), .q_Check(q_Check), .q_Correct(q_Correct), .q_Incorrect(q_Incorrect));
		
		
		always  begin #5; Clk = ~ Clk; end
		always@(posedge Clk) clk_cnt=clk_cnt+1; //don't want to use reset to clear the clk_cnt or initialize
		initial begin
		// Initialize Inputs
		clk_cnt=0;
		Clk = 0;
		CEN = 1; // ****** in Part 2 ******
				 // Here, in Part 1, we are enabling clock permanently by making CEN a '1' constantly.
				 // In Part 2, your TOP design provides single-stepping through SCEN control.
				 // We are not planning to write a testbench for the part 2 design. However, if we were 
				 // to write one, we will remove this line, and make CEN enabled and disabled to test 
				 // single stepping.
				 // One of the things you make sure in your core design (DUT) is that when state 
				 // transitions are stopped by making CEN = 0,
				 // the data transformations are also stopped.
		Reset = 0;
		Start = 0;
		Ack = 0;
		Ain = 0;
		Bin = 0;


		//generate Reset, Start, Ack, Ain, Bin signals according to the waveform on page 14/19
		//add start_clock_cnt and clocks_taken code in the correct areas
		//add $display statements per 6.10 on page 13/19
		
		
		//reset control
		@(posedge Clk); //wait until we get a posedge in the Clk signal
		@(posedge Clk);
		#1;
		Reset=1;
		@(posedge Clk);
		#1;
		Reset=0;
		
		
		//First stimulus (36,24)
		Ain=36;
		Bin=24;
		//make start signal active for one clock
		@(posedge Clk);
		#1;
		Start=1;
		@(posedge Clk);
		#1;
		Start=0;
		//leaving the q_I state, so start keeping track of the clocks taken
		start_clock_cnt=clk_cnt;
		wait(q_Done); //wait until q_Done signal is a 1
		clocks_taken = clk_cnt - start_clock_cnt;
		#1;
		$display("Ain: %d Bin: %d, GCD: %d", Ain, Bin, AB_GCD);
		$display("It took %d clock(s) to compute the GCD", clocks_taken);
		//keep Ack signal high for one clock
		Ack=1;
		@(posedge Clk);
		#1;
		Ack=0;
		
		
		//Second stimulus (5,15)
		Ain = 5;
		Bin = 15;
		@(posedge Clk);										
		
		// generate a Start pulse
		Start = 1;
		@(posedge Clk);
		Start = 0;

		wait(q_Sub)
		start_clock_cnt = clk_cnt;
			
		wait(q_Done);
		clocks_taken = clk_cnt - start_clock_cnt;
		// generate and Ack pulse
		#1;
		$display("Ain: %d Bin: %d, GCD: %d", Ain, Bin, AB_GCD);
		$display("It took %d clock(s) to compute the GCD", clocks_taken);
		Ack = 1;
		@(posedge Clk);
		Ack = 0;
		
		#20;					
		

	end
	
	always @(*)
		begin
			case ({q_I, q_Sub, q_Mult, q_Done})    // Note the concatenation operator {}
				4'b1000: state_string = "q_I   ";  // ****** TODO ******
				4'b0100: state_string = "q_Sub ";  // Fill-in the three lines
				4'b0010: state_string = "q_Mult";
				4'b0001: state_string = "q_Done";
							
			endcase
		end
 
      
endmodule

