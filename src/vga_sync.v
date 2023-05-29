`timescale 1ns / 1ps
module vga_sync(
	input clk_i,
	input rst_i,
	output reg hsync_o,
    output reg vsync_o,
    output reg inActiveArea_o
    );

localparam H_ACTIVE       	= 640; // horizontal display area
localparam H_FRONT_PORCH	=  16; // horizontal right border
localparam H_SYNC       	=  96; // horizontal retrace
localparam H_BACK_PORCH 	=  48; // horizontal left border
localparam H_MAX           	= H_ACTIVE + H_BACK_PORCH + H_FRONT_PORCH + H_SYNC - 1;

localparam V_ACTIVE       	= 480; // vertical display area
localparam V_FRONT_PORCH    =  33; // vertical bottom border
localparam V_SYNC       	=   2; // vertical retrace
localparam V_BACK_PORCH     =  10; // vertical top border
localparam V_MAX           	= V_ACTIVE + V_BACK_PORCH + V_FRONT_PORCH + V_SYNC - 1;

localparam H_CNTR_SIZE   	= $clog2(H_MAX); // log2|H_MAX|
localparam V_CNTR_SIZE   	= $clog2(V_MAX); // log2|V_MAX|

reg [H_CNTR_SIZE-1:0] H_cntr = 0;
reg [V_CNTR_SIZE-1:0] V_cntr = 0;

always @(posedge clk_i) begin
	if (rst_i)
		H_cntr <= 0;
	else if (H_cntr == H_MAX)
		H_cntr <= 0;
	else
		H_cntr <= H_cntr + 1;
end

always @(posedge clk_i) begin
	if (rst_i)
		V_cntr <= 0;
	else if (H_cntr == H_MAX) begin
		if (V_cntr == V_MAX)
			V_cntr <= 0;
		else
			V_cntr <= V_cntr + 1;	  
	end
end

always @(posedge clk_i) begin
	hsync_o <= ~(H_cntr >= (H_ACTIVE + H_FRONT_PORCH - 1) &&
			(H_cntr < (H_ACTIVE + H_FRONT_PORCH + H_SYNC - 1)));
	vsync_o <= ~(V_cntr >= (V_ACTIVE + V_FRONT_PORCH - 1) &&
			(V_cntr < (V_ACTIVE + V_FRONT_PORCH + V_SYNC - 1)));
end

always @(posedge clk_i) begin
// It is started 1 clock cycle ago so that 
// the multiplexer can match exactly with the counters of Hsync and Vsync. 
	inActiveArea_o <= 	((H_cntr < H_ACTIVE-2) || (H_cntr >= H_MAX - 1)) 
						&& 
						((V_cntr < V_ACTIVE) || ((V_cntr == V_MAX) && (H_cntr >= H_MAX - 1)))
						&& 
						~((V_cntr == V_ACTIVE-1) && (H_cntr >= H_MAX - 1));
end

endmodule