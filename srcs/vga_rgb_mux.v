`timescale 1ns / 1ps

module vga_rgb_mux
#(	parameter SELECT_SIZE = 3,
	parameter OUT_RGB_SIZE = 8
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
			'b000	: 	begin 
						red_o 	<= 'h00;
						green_o <= 'h00;
						blue_o 	<= 'h00;
						end        
			// WHITE               
			'b111	: 	begin      
						red_o 	<= 'hFF;
						green_o <= 'hFF;
						blue_o 	<= 'hFF;
						end        
			// RED                 
			'b100	: 	begin      
						red_o 	<= 'hFF;
						green_o <= 'h00;
						blue_o 	<= 'h00;
						end        
			// GREEN               
			'b010	: 	begin      
						red_o 	<= 'h00;
						green_o <= 'hFF;
						blue_o 	<= 'h00;
						end        
			// BLUE                
			'b001	: 	begin      
						red_o 	<= 'h00;
						green_o <= 'h00;
						blue_o 	<= 'hFF;
						end        
								   
			default	:	begin      
						red_o 	<= 'h00;
					    green_o <= 'h00;
                        blue_o 	<= 'h00;
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
