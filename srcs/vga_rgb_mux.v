`timescale 1ns / 1ps

module vga_rgb_mux
#(	parameter SELECT_SIZE = 3,
	parameter OUT_RGB_SIZE = 4
)
(
	input rst_i,
	input [SELECT_SIZE-1:0] select_i,
	input inActiveArea_i,
	output reg [OUT_RGB_SIZE-1:0] red_o,
	output reg [OUT_RGB_SIZE-1:0] green_o,
	output reg [OUT_RGB_SIZE-1:0] blue_o
);
	
always @(*) begin
	if (rst_i) begin	
		red_o 	<= 0;
		green_o <= 0;
		blue_o 	<= 0;
	end
	
	else if (inActiveArea_i) begin
		case(select_i)
			// BLACK
			0		: 	begin 
						red_o 	<= 'h0;
						green_o <= 'h0;
						blue_o 	<= 'h0;
						end        
			// WHITE               
			1		: 	begin      
						red_o 	<= 'hF;
						green_o <= 'hF;
						blue_o 	<= 'hF;
						end        
			// RED                 
			2		: 	begin      
						red_o 	<= 'hF;
						green_o <= 'h0;
						blue_o 	<= 'h0;
						end        
			// GREEN               
			3		: 	begin      
						red_o 	<= 'h0;
						green_o <= 'hF;
						blue_o 	<= 'h0;
						end        
			// BLUE                
			4		: 	begin      
						red_o 	<= 'h0;
						green_o <= 'h0;
						blue_o 	<= 'hF;
						end        
								   
			default	:	begin      
						red_o 	<= 'h0;
					    green_o <= 'h0;
                        blue_o 	<= 'h0;
						end
		endcase
	end
	
	else begin
		red_o 	<= 0;
		green_o <= 0;
		blue_o 	<= 0;
	end
end

endmodule
