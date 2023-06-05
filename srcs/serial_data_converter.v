`timescale 1ns / 1ps

module serial_data_converter
#(	parameter ROM_DATA_WIDTH = 96,
	parameter SELECT_SIZE = 3
)
(
	input clk_i,
	input rst_i,
	input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	input inActiveArea_i,
	output reg ready_read_o,
	output reg [(SELECT_SIZE-1):0] serial_data_o
);

localparam MAX_LOOP_COUNT 		= ROM_DATA_WIDTH/SELECT_SIZE-1; // SFT_REG_MAX_LOOP_COUNT
localparam LOOP_COUNTER_SIZE	= $clog2(MAX_LOOP_COUNT); // log2|x|

reg [(LOOP_COUNTER_SIZE-1):0] loop_counter = MAX_LOOP_COUNT-1;
reg [(ROM_DATA_WIDTH-1):0] sft_reg = 0;
reg [(SELECT_SIZE-1):0] buffer = 0;

reg STATE = 0;
reg GO_TO_S_IDLE = 0;
localparam S_WORK = 0;
localparam S_IDLE = 1;

// IDLE
always @(posedge clk_i) begin
	if (rst_i) begin
		serial_data_o <= 0;
		sft_reg <= 0;
		ready_read_o <= 1;
		loop_counter <= 0;
		STATE = S_WORK;
	end
	else if (STATE == S_IDLE) begin
		if (inActiveArea_i)
			STATE = S_WORK;
	end
end

// WORK
always @(posedge clk_i) begin
	if (rst_i) begin
		serial_data_o <= 0;
		sft_reg <= 0;
		ready_read_o <= 1;
		loop_counter <= 0;
		STATE = S_WORK;
	end
	else if (STATE == S_WORK) begin
		if (loop_counter == MAX_LOOP_COUNT)
			loop_counter <= 0;
			if (GO_TO_S_IDLE) begin
				STATE = S_IDLE;
				GO_TO_S_IDLE = 0;
			end
		else
			loop_counter <= loop_counter + 1;
		
		if (loop_counter == MAX_LOOP_COUNT-3) begin
			if (~inActiveArea_i)
				GO_TO_S_IDLE = 1;
			ready_read_o <= 1;
			serial_data_o <= sft_reg[SELECT_SIZE-1:0];
			sft_reg[(ROM_DATA_WIDTH-1)-SELECT_SIZE:0] <= sft_reg[(ROM_DATA_WIDTH-1):SELECT_SIZE];
		end
		else if (loop_counter == MAX_LOOP_COUNT-2) begin
			serial_data_o <= sft_reg[SELECT_SIZE-1:0];
			// sft_reg[(ROM_DATA_WIDTH-1)-SELECT_SIZE:0] <= sft_reg[(ROM_DATA_WIDTH-1):SELECT_SIZE];
			buffer <= sft_reg[2*SELECT_SIZE-1:SELECT_SIZE];
		end
		else if (loop_counter == MAX_LOOP_COUNT-1) begin
			ready_read_o <= 0;
			sft_reg <= rom_data_i;
			serial_data_o <= buffer;
		end
		else begin
			serial_data_o <= sft_reg[SELECT_SIZE-1:0];
			sft_reg[(ROM_DATA_WIDTH-1)-SELECT_SIZE:0] <= sft_reg[(ROM_DATA_WIDTH-1):SELECT_SIZE];
		end
	end
end

endmodule
