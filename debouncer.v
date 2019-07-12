module debouncer(input switch,
                       clk,
                       reset,
                output reg out_debounce );
					 
localparam wait_for_press   = 3'b000;
localparam pressed_chk_10   = 3'b001;
localparam pressed_chk_20   = 3'b010;
localparam pressed          = 3'b011;
localparam wait_for_release = 3'b100;
localparam released_chk_10  = 3'b101;
localparam released_chk_20  = 3'b110;
localparam released         = 3'b111;

reg [2:0]p_s,
         n_s;
reg [18:0]count;
reg count_enable;

always@(posedge clk, negedge reset)
  begin
    if(!reset)
	   begin
		  p_s<=wait_for_press;
		end
	else 
	   p_s<=n_s;
  end
  
always@(posedge clk, negedge reset)
  begin
    if(!reset)
	   count<=0;
	 else if(count_enable)
	         begin
	            if(count==500000)
	                count<=0;
			      else 
			          count<=count+1;
				end
			else
			   count<=0;
  end
  
always@(*)
  begin
    case(p_s)
	      
		  	wait_for_press   :begin 
			                    count_enable<=0;
			                   if(switch)
									   begin
									    n_s<=pressed_chk_10;
										 //count<=0;
										end
									 else 
									    n_s<=wait_for_press;
									end
			pressed_chk_10   :begin 
			                    count_enable<=1;
			                   if(count==500000)
									    n_s<=pressed_chk_20;
									 else if(!switch)
									         n_s<=wait_for_press;
											else 
											   n_s<=pressed_chk_10;
									end
			pressed_chk_20   :begin 
			                    count_enable<=1;
			                   if(count==500000)
									    n_s<=pressed;
									 else if(!switch)
									         n_s<=wait_for_press;
											else 
											   n_s<=pressed_chk_20;
									end
			pressed          :begin 
			                    count_enable<=1;
			                   if(count==500000)
									    n_s<=wait_for_release;
									 else if(!switch)
									         n_s<=wait_for_press;
											else 
											   n_s<=pressed;
									end
			wait_for_release :begin 
			                    count_enable<=0;
			                   if(!switch)
									   begin
									    n_s<=released_chk_10;
										 //count<=0;
										end
									 else 
									    n_s<=wait_for_release;
									end
			released_chk_10  :begin 
			                    count_enable<=1;
			                   if(count==500000)
									    n_s<=released_chk_20;
									 else if(switch)
									         n_s<=wait_for_release;
											else 
											   n_s<=released_chk_10;
									end
			released_chk_20  :begin 
			                    count_enable<=1;
			                   if(count==500000)
									    n_s<=released;
									 else if(switch)
									         n_s<=wait_for_release;
											else 
											   n_s<=released_chk_20;
									end
			released         :begin 
			                    count_enable<=1;
			                   if(count==500000)
									    n_s<=wait_for_press;
									 else if(switch)
									         n_s<=wait_for_release;
											else 
											   n_s<=released;
									end
			default          :n_s<=wait_for_press;
			
	 endcase
	  
  end
  
always@(*)
  begin
    case(p_s)
	 
	   wait_for_press   :out_debounce<=0;
		pressed_chk_10   :out_debounce<=0;
		pressed_chk_20   :out_debounce<=0;
		pressed          :out_debounce<=0;
		wait_for_release :out_debounce<=1;
		released_chk_10  :out_debounce<=1;
		released_chk_20  :out_debounce<=1;
		released         :out_debounce<=1;
		default          :out_debounce<=0;
		
	 endcase
  
  end

endmodule
