   module switch_debouncer(input switch,
                              clk,
										reset,
							  output out_switch);
							  
wire out_debounce;

debouncer D1(.clk(clk),
             .reset(reset),
				 .switch(switch),
				 .out_debounce(out_debounce));
				 
rising_edge RE(.clk(clk),
               .reset(reset),
					.i(out_debounce),
					.out_switch(out_switch));


endmodule
