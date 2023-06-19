`timescale 1ns / 1ps

module serial_data_converter
#(	parameter ROM_DATA_WIDTH = 96,
	parameter SELECT_SIZE = 3
)
(
	input clk_i,
	input rst_i,
	input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	input screen_start_i,
	input inActiveArea_i,
	output reg ready_read_o,
	output reg [(SELECT_SIZE-1):0] serial_data_o
);

localparam MAX_LOOP_COUNT 		= ROM_DATA_WIDTH/SELECT_SIZE-1; // SFT_REG_MAX_LOOP_COUNT
localparam LOOP_COUNTER_SIZE	= $clog2(MAX_LOOP_COUNT); // log2|x|
localparam HALF_MAX_LOOP_COUNT 	= ROM_DATA_WIDTH/SELECT_SIZE/2-1;

reg [(LOOP_COUNTER_SIZE-1):0] loop_counter = MAX_LOOP_COUNT-1;
reg [(ROM_DATA_WIDTH-1):0] sft_reg = 0;
reg [(SELECT_SIZE-1):0] buffer = 0;

reg STATE = 0;
reg GO_TO_S_IDLE = 0;
localparam S_IDLE = 0;
localparam S_WORK = 1;

// IDLE
// always @(posedge clk_i) begin
	// // if (rst_i) begin
		// // serial_data_o <= 0;
		// // sft_reg <= 0;
		// // ready_read_o <= 1;
		// // loop_counter <= MAX_LOOP_COUNT;
		// // STATE = S_IDLE;
	// // end
	// if (STATE == S_IDLE) begin
		// if (inActiveArea_i)
			// STATE = S_WORK;	
		// if (screen_start_i) begin
			// sft_reg <= rom_data_i;
		// end
		// loop_counter <= MAX_LOOP_COUNT;
	// end
// end

// WORK
always @(posedge clk_i) begin
	case(STATE)
	S_IDLE	: 
	begin
		if (inActiveArea_i)
			STATE = S_WORK;	
		if (screen_start_i)
			sft_reg <= rom_data_i;
		loop_counter <= MAX_LOOP_COUNT;
		GO_TO_S_IDLE <= 0;
	end
	S_WORK	:
	begin
		if (loop_counter == MAX_LOOP_COUNT)
			loop_counter <= 0;
			if (GO_TO_S_IDLE) begin
				STATE = S_IDLE;
				serial_data_o <= 0;
			end
		else
			loop_counter <= loop_counter + 1;
		
		if (~inActiveArea_i)
			GO_TO_S_IDLE <= 1;
				
		if (loop_counter == HALF_MAX_LOOP_COUNT) begin
			ready_read_o <= 1;
			serial_data_o <= sft_reg[ROM_DATA_WIDTH-1:ROM_DATA_WIDTH-SELECT_SIZE];
			sft_reg[(ROM_DATA_WIDTH-1):SELECT_SIZE] <= sft_reg[(ROM_DATA_WIDTH-1)-SELECT_SIZE:0];
		end
		else if (loop_counter == MAX_LOOP_COUNT-2) begin
			serial_data_o <= sft_reg[ROM_DATA_WIDTH-1:ROM_DATA_WIDTH-SELECT_SIZE];
			buffer <= sft_reg[ROM_DATA_WIDTH-1-SELECT_SIZE:ROM_DATA_WIDTH-2*SELECT_SIZE];
		end
		else if (loop_counter == MAX_LOOP_COUNT-1) begin
			ready_read_o <= 0;
			sft_reg <= rom_data_i;
			serial_data_o <= buffer;
		end
		else begin
			if (~GO_TO_S_IDLE) begin
				serial_data_o <= sft_reg[ROM_DATA_WIDTH-1:ROM_DATA_WIDTH-SELECT_SIZE];
				sft_reg[(ROM_DATA_WIDTH-1):SELECT_SIZE] <= sft_reg[(ROM_DATA_WIDTH-1)-SELECT_SIZE:0];
			end
		end
	end
	endcase
end

endmodule
