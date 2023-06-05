`timescale 1ns / 1ps

module tb_vga_test;

localparam SELECT_SIZE = 3;
localparam OUT_RGB_SIZE = 4;

localparam HALF_PERIOD = 5;
localparam PERIOD = HALF_PERIOD*2;

reg clk = 0; // clk
reg btnC = 0; // rst
wire [OUT_RGB_SIZE-1:0] vgaRed;
wire [OUT_RGB_SIZE-1:0] vgaGreen;
wire [OUT_RGB_SIZE-1:0] vgaBlue;
wire Hsync;
wire Vsync;


reg [SELECT_SIZE-1:0] data = 1;
wire clk_vga;
wire clk_hsync;

// wire clk_hsync2;
wire inActiveArea;
wire inActiveAreaMUX;

vga_sync sync0(
	.clk_i			(clk_vga),
	.rst_i			(btnC),
	.hsync_o		(Hsync),
    .vsync_o		(Vsync),
    .inActiveArea_o	(inActiveArea),
	.inActiveAreaMUX_o(inActiveAreaMUX),
	.clk_hsync(clk_hsync)
    );

vga_rgb_mux
#(	.SELECT_SIZE(SELECT_SIZE),
	.OUT_RGB_SIZE(OUT_RGB_SIZE)
)
mux1
(
	.rst_i			(btnC),
	.select_i		(data),
	.inActiveArea_i	(inActiveAreaMUX),
	.red_o			(vgaRed),
	.green_o		(vgaGreen),
	.blue_o			(vgaBlue)
);

clock_divider
#(	.CLK_REF_FREQ(100_000_000),
	.CLK_OUT_FREQ(25_000_000)
)
d1
(
	.clk_i(clk),
	.rst_i(btnC),
	.clk_o(clk_vga)
);

// clock_divider
// #(	.CLK_REF_FREQ(25_000_000),
	// .CLK_OUT_FREQ(39062.5)
// )
// d2
// (
	// .clk_i(clk_vga),
	// .rst_i(btnC),
	// .clk_o(clk_hsync2)
// );

always #HALF_PERIOD clk=~clk;

reg [4:0] counter = 0;

always @(posedge clk_hsync) begin
	if (btnC) begin
		counter <= 0;
	end
	else begin
		if (counter == 31) begin
			if (data == 4)
				data <= 1;
			else
				data <= data + 1;
			counter <= 0;
		end
		else
			counter <= counter + 1;
	end
end

endmodule

