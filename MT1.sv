/***********************************************************/
/*                                                         */
/*  NAME: Ramses Peter Madakson                            */
/*                                                         */
/*  SUBJECT: Module Transistion                            */
/*                                                         */
/***********************************************************/


module MT1(CLOCK_50, KEY, SW, LEDR, LEDG);
	
	/** Inputs and Outputs**/
	input [1:0] SW;
	input [0:0] KEY;
	input CLOCK_50;
	output [1:0] LEDR;
	output [1:0] LEDG;
	
	/** Logic **/
	logic Button;
	logic Clock;
	logic UpperLS;
	logic LowerLS;
	logic [1:0] M;
	
	/** Assignments **/
	assign Clock = CLOCK_50;
	assign Button = KEY[0];
	assign UpperLS = SW[0];
	assign LowerLS = SW[1];
	assign LEDR = SW;
	assign LEDG = M;
	
	/** Function Calls **/
	ButtonSyncReg ButtonCall (Clock, Button, Bo);
	
	DoorFSM (Clock, Bo, UpperLS, LowerLS, M);
	
endmodule 