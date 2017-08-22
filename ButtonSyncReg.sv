/***********************************************************/
/*                                                         */
/*  NAME: Ramses Peter Madakson                            */
/*                                                         */
/*  SUBJECT: (ButtonSync)                                  */
/*                                                         */
/***********************************************************/

module ButtonSyncReg( Clk, Bis, Bo );
  input Bis;      // unregistered input button press
  input Clk;      // system clock
  
  output logic Bo;  // our output
  
  // State assignments
  localparam S_A = 2'h0, 
             S_B = 2'h1,
             S_C = 2'h2,
             S_D = 2'h3;
             
  logic [1:0] State = S_A, StateNext;
  logic Bi = 0;  // registered input
  
  // CombLogic
  always_comb begin
	  Bo = 0;  // default
		
    case ( State )
      
      S_A: begin
        if ( Bi )
          StateNext = S_B;  // button push detected
			  else
				  StateNext = S_A;
      end
      
      S_B: begin
        Bo = 1; // turn output ON
        if ( Bi )
          StateNext = S_C; 
				else
				  StateNext = S_A;
      end
      
      S_C: begin
        if ( Bi )
          StateNext = S_C;  // stay in this state
        else
          StateNext = S_A;  // otherwise, back to A
      end
      
      S_D: begin  // the only other possible value of State
        Bo = 0;
        StateNext = S_A;
      end
      
    endcase
  end // always
    
  // StateReg
  always @( posedge Clk ) begin
  	Bi <= Bis;
    State <= StateNext;   // otherwise go to the state we set
  end  // always
  
endmodule
  
//********************************************//
//                 Testbench	                //
//********************************************//
module ButtonSyncReg_testbench;

  logic Clock,
	      ButtonIn,
				ButtonOut;

  ButtonSyncReg DUT( Clock, ButtonIn, ButtonOut );
  
  // develop a clock (50 MHz)
  always begin
    	Clock <= 0;
    	#10;
    	Clock <= 1;
    	#10;
    end  
  
  initial	// Test stimulus
    begin
      ButtonIn = 0;
      #100 ButtonIn = 1;
      #110 ButtonIn = 0;
      #100 $stop;
    end
    
    // view waveforms

endmodule

                   