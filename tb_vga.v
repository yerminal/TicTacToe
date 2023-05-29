`timescale 1ns / 1ps

module tb_vga();

localparam HALF_PERIOD = 5;
localparam SELECT_SIZE = 3;
localparam OUT_RGB_SIZE = 4;

localparam PERIOD = HALF_PERIOD*2;

// INPUT DATA
reg clk = 0;
reg rst = 0;
reg [SELECT_SIZE-1:0] select;

// INTERNAL DATA
wire inActiveArea;

// OUTPUT DATA
wire hsync;
wire vsync;
wire [OUT_RGB_SIZE-1:0] red;
wire [OUT_RGB_SIZE-1:0] green;
wire [OUT_RGB_SIZE-1:0] blue;

vga_sync sync1
	(
	.clk_i			(clk),
	.rst_i			(rst),
	.hsync_o		(hsync),
    .vsync_o		(vsync),
    .inActiveArea_o	(inActiveArea)
    );
	
vga_rgb_mux #(
	.SELECT_SIZE(SELECT_SIZE),
	.OUT_RGB_SIZE(OUT_RGB_SIZE)
	)
	mux1
	(
	.rst_i			(rst),
	.select_i		(select),
	.inActiveArea_i	(inActiveArea),
	.red_o			(red),
	.green_o		(green),
	.blue_o			(blue)
    );

always #HALF_PERIOD clk=~clk;

integer i = 0;

initial begin
	select <= i;
	#HALF_PERIOD;
	while (1) begin
		while (i < 5) begin
			select <= i;
			#PERIOD;
			i = i + 1;
		end
		i = 0;
	end
end

endmodule
