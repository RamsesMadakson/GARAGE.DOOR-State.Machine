/***********************************************************/
/*                                                         */
/*  NAME: Ramses Peter Madakson                            */
/*                                                         */
/*  SUBJECT: DoorFSM                                       */
/*                                                         */
/***********************************************************/


module DoorFSM (Clock, Button, UpperLS, LowerLS, M);
	
	/** Inputs and Outputs **/
	
	input Clock;
	input Button;
	input UpperLS;
	input LowerLS;
	output logic [1:0] M;
	
	/** Local Parameters for the 2 bits of M **/
	
	localparam MotorOff = 2'd0, RaisingDoor = 2'd1, DoorOpen = 2'd2, LoweringDoor = 2'd3;
	
	/** Logic for States **/
	
	logic [1:0] State = MotorOff, NextState; 
	
	/** Always_Comb for State Transistion **/
	
	always_comb 
		
		begin 
			/** Start with M = 00 **/
			M = 2'b0;
			
			NextState = State;
			
			/** Cases for State Transition **/
			case (State)
				
				/** Motor Off / Door Closed State **/
				MotorOff: begin
				
					M = 2'b0;
					if (Button == 1'b1) //If Button is Pressed
						
						begin 
							
							NextState = RaisingDoor;
							
						end
				end
				
				/** Raising Door State **/
				RaisingDoor: begin
						
					M = 2'b1;
					if (UpperLS == 1'b1 || Button == 1'b1) //If UpperLS is On
						
						begin
							
							NextState = DoorOpen;
						
						end
						
				end
				
				/** Door Open State **/	
				DoorOpen: begin
				
					M = 2'b0;
					
					if (Button == 1'b1) //If Button is Pressed
						
						begin 
							
							NextState = LoweringDoor;
							
						end
				end
				
				/** Lowering Door State**/
				LoweringDoor: begin
				
					M = 2'b10;
					if (LowerLS == 1'b1) //If UpperLS is On
						
						begin
							
							NextState = MotorOff;
						
						end
						
					if (Button == 1'b1) //If Botton is Pressed
						
						begin
							
							NextState = RaisingDoor;
						
						end
			
				end
						
				default: begin //Default
				
					M = 2'b0;
					NextState = DoorOpen;
					
					end
			
			endcase
	end
	
	
	always_ff @ (posedge Clock) 
		
		begin
		
			State = NextState;
			
		end
			

endmodule	


/***********************************************************/
/*                                                         */
/*                       TEST BENCH	                       */
/*                                                         */
/***********************************************************/

					
module DoorFSM_testbench;
  logic Clock;  // the system clock
	logic Button; // the door control button
	logic UpperLS, LowerLS;  // the limit switches
	logic [1:0] M; // the motor control
	
	DoorFSM DUT( .Clock, .Button, .UpperLS, .LowerLS, .M );
	
	always begin
	  Clock = 0;
		#10;
		Clock = 1'b1;
		#10;
	end
	
	initial begin
	  Button = 0;     // door closed 
		LowerLS = 1'b1;
		UpperLS = 0;
		#55;
		Button = 1'b1;  // command door open
		#20;
		LowerLS = 0;    // door opening
		Button = 0;
		#100;
		UpperLS = 1'b1;  // door open
		#100
		Button = 1'b1;   // command door closed
		#20;
		UpperLS = 0;     // door closing
		Button = 0;
		#100;
		LowerLS = 1'b1;   // door closed
		#100;
		Button = 1'b1;    // command door open
		#20;
		LowerLS = 0;      // door opening
		Button = 0;
		#100;
		Button = 1'b1;    // button pressed while door opening
		#20;
		Button = 0;
		#100;
		UpperLS = 1'b1;   // door open
		#100
		Button = 1'b1;    // command door closed
		#20;
		UpperLS = 0;      // door closing
		Button = 0;
		#100;
		Button = 1'b1;    // button pressed while door closing
		#20;
		Button = 0;
		#100;
		UpperLS = 1'b1;
		#100;
		$stop;
	end
	
	initial begin
	  $display( "Time    Button   UpperLS   LowerLS   Motor   State" );
	  $monitor( " %5t     %b       %b        %b        %2b        %d", $stime, Button, UpperLS, LowerLS, M, DUT.State );
	end
	
endmodule
  

	
				