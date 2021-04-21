//////////////////////////////////////////////////////////////////////////////////
// Author:			Shideh Shahidi, Bilal Zafar, Gandhi Puvvada
// Create Date:   02/25/08, 10/13/08
// File Name:		ee354_GCD.v 
// Description: 
//
//
// Revision: 		2.1
// Additional Comments:  
// 10/13/2008 SCEN has been added by Gandhi
//  3/1/2010  Signal names are changed in line with the divider_verilog design
//           `define is replaced by localparam construct
//  02/24/2020 Nexys-3 to Nexys-4 conversion done by Yue (Julien) Niu and reviewed by Gandhi
//////////////////////////////////////////////////////////////////////////////////


module sindoku(Clk, R, L, U, D, C, Reset, CheckSolu, userIn, q_I, q_Solve, q_Check, q_Correct, q_Incorrect);

	/*  INPUTS */
	input	Clk, R, L, U, D, C
	input Reset, CheckSolu;
	input userIn;
	
	// i_count is a count of number of factors of 2	. We do not need an 8-bit counter. 
	// However, in-line with other variables, this has been made an 8-bit item.
	/*  OUTPUTS */
	// store the two inputs Ain and Bin in A and B . These (A, B) are also continuously output to the higher module. along with the AB_GCD
	output reg [4:0] puzzle [0:8][0:8];	// the result of the operation: GCD of the two numbers
	reg [4:0] solu [0:8][0:8];
	// store current state
	integer row, col;
	integer i, j;
	output q_I, q_Solve, q_Check, q_Correct, q_Incorrect;
	reg [3:0] state;	
	assign {q_Incorrect, q_Correct, q_Check, q_Solve, q_I} = state;
		
	localparam 	
	I = 5'b00001, SOLVE = 5'b00010, CHECK = 5'b00100, CORRECT = 5'b01000, INCORRECT = 5'b10000, UNK = 5'bXXXXX;

	assign{solu[0][0], solu[0][1], solu[0][2], solu[0][3], solu[0][4], solu[0][5], solu[0][6], solu[0][7], solu[0][8]}  ={2,5,9,3,1,4,7,6,8} ;
	assign{solu[1][0], solu[1][1], solu[1][2], solu[1][3], solu[1][4], solu[1][5], solu[1][6], solu[1][7], solu[1][8]}  ={8,7,1,6,2,9,4,5,3} ;
	assign{solu[2][0], solu[2][1], solu[2][2], solu[2][3], solu[2][4], solu[2][5], solu[2][6], solu[2][7], solu[2][8]}  ={6,4,3,5,8,7,1,9,2} ;
	assign{solu[3][0], solu[3][1], solu[3][2], solu[3][3], solu[3][4], solu[3][5], solu[3][6], solu[3][7], solu[3][8]}  ={9,6,7,8,3,5,2,1,4} ;
	assign{solu[4][0], solu[4][1], solu[4][2], solu[4][3], solu[4][4], solu[4][5], solu[4][6], solu[4][7], solu[4][8]}  ={4,1,8,9,7,2,5,3,6} ;
	assign{solu[5][0], solu[5][1], solu[5][2], solu[5][3], solu[5][4], solu[5][5], solu[5][6], solu[5][7], solu[5][8]}  ={3,2,5,4,6,1,9,8,7} ;
	assign{solu[6][0], solu[6][1], solu[6][2], solu[6][3], solu[6][4], solu[6][5], solu[6][6], solu[6][7], solu[6][8]}  ={7,9,6,2,5,3,8,4,1} ;
	assign{solu[7][0], solu[7][1], solu[7][2], solu[7][3], solu[7][4], solu[7][5], solu[7][6], solu[7][7], solu[7][8]}  ={1,8,4,7,9,6,3,2,5} ;
	assign{solu[8][0], solu[8][1], solu[8][2], solu[8][3], solu[8][4], solu[8][5], solu[8][6], solu[8][7], solu[8][8]}  ={5,3,2,1,4,8,6,7,9} ;

	
	// NSL AND SM
	always @ (posedge Clk, posedge Reset)
	begin : sindoku
		if(Reset) 
		  begin
			state <= I;
			row <= 4'bXXXX;  	// ****** TODO ******
			col <= 4'bXXXX;		  	// complete the 3 lines
			i<= 4'bXXXX;
			j<= 4'bXXXX;			
		  end
		else				// ****** TODO ****** complete several parts
				case(state)	
					I:
					begin
						// state transfers
						state <= SOLVE;
						// data transfers
						row <= 0;
						col <=0;
						i<=0;
						j<=0;
						assign{puzzle[0][0], puzzle[0][1], puzzle[0][2], puzzle[0][3], puzzle[0][4], puzzle[0][5], puzzle[0][6], puzzle[0][7], puzzle[0][8]}  <={0,5,0,3,1,4,0,6,0} ;
						assign{puzzle[1][0], puzzle[1][1], puzzle[1][2], puzzle[1][3], puzzle[1][4], puzzle[1][5], puzzle[1][6], puzzle[1][7], puzzle[1][8]}  <={8,7,0,0,0,9,4,0,3} ;
						assign{puzzle[2][0], puzzle[2][1], puzzle[2][2], puzzle[2][3], puzzle[2][4], puzzle[2][5], puzzle[2][6], puzzle[2][7], puzzle[2][8]}  <={6,4,3,5,0,7,1,9,2} ;
						assign{puzzle[3][0], puzzle[3][1], puzzle[3][2], puzzle[3][3], puzzle[3][4], puzzle[3][5], puzzle[3][6], puzzle[3][7], puzzle[3][8]}  <={0,0,7,8,0,5,2,1,0} ;
						assign{puzzle[4][0], puzzle[4][1], puzzle[4][2], puzzle[4][3], puzzle[4][4], puzzle[4][5], puzzle[4][6], puzzle[4][7], puzzle[4][8]}  <={4,1,0,9,0,0,0,0,0} ;
						assign{puzzle[5][0], puzzle[5][1], puzzle[5][2], puzzle[5][3], puzzle[5][4], puzzle[5][5], puzzle[5][6], puzzle[5][7], puzzle[5][8]}  <={0,2,5,0,6,1,9,0,7} ;
						assign{puzzle[6][0], puzzle[6][1], puzzle[6][2], puzzle[6][3], puzzle[6][4], puzzle[6][5], puzzle[6][6], puzzle[6][7], puzzle[6][8]}  <={7,9,0,2,5,0,8,4,0} ;
						assign{puzzle[7][0], puzzle[7][1], puzzle[7][2], puzzle[7][3], puzzle[7][4], puzzle[7][5], puzzle[7][6], puzzle[7][7], puzzle[7][8]}  <={0,0,4,0,9,6,0,0,5} ;
						assign{puzzle[8][0], puzzle[8][1], puzzle[8][2], puzzle[8][3], puzzle[8][4], puzzle[8][5], puzzle[8][6], puzzle[8][7], puzzle[8][8]}  <={0,3,0,1,0,8,6,7,0} ;


					end		
					SOLVE: 
						if(CheckSolu)
			               	state<= CHECK;
		               	if (R) //  This causes single-stepping the SUB state
		               		if(col != 8)
								col <= col +1;
						if (L) //  This causes single-stepping the SUB state
		               		if(col != 0)
								col <= col -1;
						if (U) //  This causes single-stepping the SUB state
		               		if(row != 0)
								row <= row -1;
						if (D) //  This causes single-stepping the SUB state
		               		if(row != 8)
								row <= row +1;
						if (C) //  This causes single-stepping the SUB state
		               		puzzle[row][col] <= userIn;
					CHECK:
						if( i==8 && j==8 && puzzle[i][j]==solu[i][j])
							state<= CORRECT;
						else
						begin
							if(puzzle[i][j]!=solu[i][j])
								state<=INCORRECT;
							else
							begin
								if(j==8)
								begin
									j<=0;
									i<=i+1;		
								end	
								else 
								begin
									j<= j+1;
								end
							end
						end
					CORRECT:
						if (Ack)	state <= I;

					INCORRECT:
						if (Ack)	state <= I;
						
					default:		
						state <= UNK;
				endcase
	end
		
	// OFL
	// no combinational output signals
	
endmodule
