module rising_edge(input clk,
                         reset,
								 i,
						output reg out_switch );

localparam A=2'b00;
localparam B=2'b01;
localparam C=2'b10;

reg [1:0]p_s;
reg [1:0]n_s;


always@(posedge clk, negedge reset)
   if(!reset)
	    p_s<=A;
	else
	    p_s<=n_s;
		 
always@(*)
   begin
	   case(p_s)
		    A: if(i==1'b0)
			      n_s<=B;
				 else if(i==1)
				     n_s<=A;
		    B: if(i==1'b0)
			      n_s<=B;
				 else if(i==1)
				     n_s<=C;
		    C: if(i==1'b0)
			      n_s<=B;
				 else if(i==1)
				     n_s<=A;
			default: n_s<=A;
      endcase
   end

always@(*)
  if(n_s==C)
    out_switch<=1'b1;
  else
    out_switch<=0;					 

endmodule

