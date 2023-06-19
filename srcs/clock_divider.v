`timescale 1ns / 1ps

module clock_divider
#(	parameter CLK_REF_FREQ = 50_000_000,
	parameter CLK_OUT_FREQ = 25_000_000
)
(
	input clk_i,
	input rst_i,
	output clk_o
);

localparam CLK_COUNT_LIMIT 	= CLK_REF_FREQ/(2*CLK_OUT_FREQ)-1;
localparam COUNTR_SIZE 		= $clog2(CLK_COUNT_LIMIT);

reg [COUNTR_SIZE-1:0] counter = 0;
reg clk = 1;

assign clk_o = clk;

always @(posedge clk_i) begin
	if (rst_i)
		counter <= 0;
	else if (counter == CLK_COUNT_LIMIT) begin
		counter <= 0;
		clk <= ~clk;
	end
	else
		counter <= counter + 1;
end

endmodule
