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
	reg Clk;
	reg BtnR_Pulse, BtnL_Pulse, BtnU_Pulse, BtnD_Pulse, BtnC_Pulse;
	reg Reset;
	reg CheckSolu;
	reg Ack;
	reg [4:0] userIn;

	wire q_I;
	wire q_Solve;
	wire q_Check;
	wire q_Correct;
	wire q_Incorrect;
	reg [9*8:0] state_string; // 6-character string for symbolic display of state
	integer clk_cnt, start_clock_cnt,clocks_taken;
	// Instantiate the Unit Under Test (UUT)
	sindoku uut(.Clk(Clk), 
		.R(BtnR_Pulse), 
		.L(BtnL_Pulse), 
		.U(BtnU_Pulse), 
		.D(BtnD_Pulse), 
		.C(BtnC_Pulse), 
		.Reset(Reset),
		.CheckSolu(CheckSolu), 
		.userIn(userIn), 
		.q_I(q_I), 
		.q_Solve(q_Solve), 
		.q_Check(q_Check), 
		.q_Correct(q_Correct), 
		.q_Incorrect(q_Incorrect));
		
		
		always  begin #5; Clk = ~ Clk; end
		always@(posedge Clk) clk_cnt=clk_cnt+1; //don't want to use reset to clear the clk_cnt or initialize
		initial begin
		// Initialize Inputs
		clk_cnt=0;
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
		BtnR_Pulse = 0;
		BtnL_Pulse = 0;
		BtnU_Pulse = 0;
		BtnD_Pulse = 0;
		BtnC_Pulse = 0;
		userIn = 0;
		Reset = 0;
		CheckSolu =0;

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
		
		start_clock_cnt=clk_cnt;
		
		//First stimulus (36,24)
		userIn =2;
		//make start signal active for one clock
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn =9;
		//make start signal active for one clock
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		
		userIn =7;
		//make start signal active for one clock
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;


		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=8;

		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;

		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=5;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=2;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=6;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=8;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;

		userIn=4;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=3;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=6;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=9;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=8;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=7;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=2;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=5;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=3;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=6;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;

		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=8;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=4;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=3;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=6;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=3;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=2;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=3;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=7;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=8;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnL_Pulse=1;
		@(posedge Clk);
		#1;
		BtnL_Pulse=0;

		userIn=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;
		@(posedge Clk);
		#1;
		BtnD_Pulse=1;
		@(posedge Clk);
		#1;
		BtnD_Pulse=0;

		userIn=5;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=2;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=4;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;
		@(posedge Clk);
		#1;
		BtnR_Pulse=1;
		@(posedge Clk);
		#1;
		BtnR_Pulse=0;

		userIn=9;
		@(posedge Clk);
		#1;
		BtnC_Pulse=1;
		@(posedge Clk);
		#1;
		BtnC_Pulse=0;

		@(posedge Clk);
		#1;
		CheckSolu=1;
		@(posedge Clk);
		#1;
		CheckSolu=0;


		//leaving the q_I state, so start keeping track of the clocks taken
		
		wait(q_Correct | q_Incorrect); //wait until q_Done signal is a 1
		clocks_taken = clk_cnt - start_clock_cnt;
		#1;

		if(q_Correct)
			$display("CORRECT");
		else begin
			$display("INCORRECT");
		end
		$display("It took %d clock(s) to compute the GCD", clocks_taken);
		//keep Ack signal high for one clock

	end
	
	always @(*)
		begin
			case ({q_I, q_Sub, q_Mult, q_Done})    // Note the concatenation operator {}
				4'b1000: state_string = "q_I        ";  // ****** TODO ******
				4'b0100: state_string = "q_Solve    ";  // Fill-in the three lines
				4'b0010: state_string = "q_Correct  ";
				4'b0001: state_string = "q_Incorrect";
							
			endcase
		end
 
      
endmodule

