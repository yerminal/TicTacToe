`timescale 1ns / 1ps

module pixel_drawer
#(	parameter RAM_DATA_WIDTH = 7, 
	parameter RAM_ADDR_WIDTH = 9,
	parameter ROM_DATA_WIDTH = 96,
	parameter ROM_ADDR_WIDTH = 12
)
(
	input clk_i,
	input rst_i,
	input [(RAM_DATA_WIDTH-1):0] ram_data_i,
	input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	output reg [(RAM_ADDR_WIDTH-1):0] tile_addr_o,
	output reg [(ROM_ADDR_WIDTH-1):0] pixel_addr_o
);

localparam STATE = 0;

localparam S_READ_RAM = 0;
localparam S_READ_ROM = 1;
localparam S_SEND_MUX = 2;

reg [(RAM_DATA_WIDTH-1):0] ram_data;
reg [(ROM_DATA_WIDTH-1):0] rom_data;
reg [(ROM_DATA_WIDTH-1):0] pixel_data;

tile_type_to_ROM_addr
#(	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	.ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
)
t1
(
	.rst_i(rst_i),
	.tile_type_i(ram_data),
	.addr_o(pixel_addr_o)
);
	
initial begin
	tile_addr_o 	<= 0;
	pixel_addr_o	<= 0;
end

always @(posedge clk_i) begin
	if (rst_i) begin
		tile_addr_o <= 0;
	end
	else begin
		case(STATE)
			S_READ_RAM : begin
				if (tile_addr_o == 299)
					tile_addr_o <= 0;
				else
					tile_addr_o <= tile_addr_o + 1;
				ram_data <= ram_data_i;
				STATE = S_READ_ROM;
			end
			
			S_READ_ROM : begin
				rom_data <= rom_data_i;
				STATE = S_SEND_MUX;
			end
			
			S_SEND_MUX : begin
			// WRITE AND USE A MODULE THAT CONVERTS DATA TO SERIAL DATA
				STATE = S_READ_RAM;
			end
		endcase
	end
end

// TILE COORDINATE COUNTER
always @(posedge clk_i) begin
	if (rst_i) begin
		tile_addr_o <= 0;
	end
	else begin
		if (tile_addr_o == 299)
			tile_addr_o <= 0;
		else
			tile_addr_o <= tile_addr_o + 1;
	end
end

endmodule
