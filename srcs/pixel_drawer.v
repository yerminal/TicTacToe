`timescale 1ns / 1ps

module pixel_drawer
#(	parameter RAM_DATA_WIDTH = 7, 
	parameter RAM_ADDR_WIDTH = 9,
	parameter ROM_DATA_WIDTH = 96,
	parameter ROM_ADDR_WIDTH = 12,
	parameter SELECT_SIZE = 3
)
(
	input clk_i,
	input clk_serial,
	input rst_i,
	input [(RAM_DATA_WIDTH-1):0] ram_data_i,
	input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	input [4:0] v_cntr_mod32_i,
	output reg [(RAM_ADDR_WIDTH-1):0] tile_addr_o, // Connected to read_addr_i of BRAM
	output [(ROM_ADDR_WIDTH-1):0] pixel_addr_o, // Connected to addr of BROM
	output [(SELECT_SIZE-1):0] serial_data_o
);

reg STATE = 0;
localparam S_READ_RAM = 0;
localparam S_READ_ROM = 1;
// localparam S_SEND_MUX = 2;

wire ready_read;
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
	.v_cntr_mod32_i(v_cntr_mod32_i),
	.addr_o(pixel_addr_o)
);

serial_data_converter
#(	.ROM_DATA_WIDTH(ROM_DATA_WIDTH),
	.SELECT_SIZE(SELECT_SIZE)
)
s1
(
	.clk_i(clk_serial),
	.rst_i(rst_i),
	.rom_data_i(rom_data),
	.ready_read_o(ready_read),
	.serial_data_o(serial_data_o)
);

initial begin
	tile_addr_o <= 0;
	ram_data <= 20;
end

reg [(RAM_ADDR_WIDTH-1):0] tile_addr_previous = 0;
localparam RAM_LOOP_INCREMENT = 20;


// READ RAM LOOP
always @(posedge clk_i) begin
	if (rst_i)
		tile_addr_o <= 0;
	else begin
		if (STATE == S_READ_RAM) begin
			if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i == 31))
				begin
					tile_addr_previous <= tile_addr_o + 1;
					tile_addr_o <= tile_addr_o + 1;
				end
			
			if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1) && (v_cntr_mod32_i < 31))
				tile_addr_o <= tile_addr_previous;
			else
				tile_addr_o <= tile_addr_o + 1;

			ram_data <= ram_data_i;
			STATE = S_READ_ROM;
		end
	end
end

// READ ROM LOOP
always @(posedge clk_serial) begin
	if (rst_i)
		tile_addr_o <= 0;
	else begin
		if (ready_read && (STATE == S_READ_ROM)) begin
			rom_data <= rom_data_i;
			STATE = S_READ_RAM;
		end
	end
end

// always @(posedge clk_i) begin
	// if (rst_i)
		// tile_addr_o <= 0;
	// else begin
		// if (STATE == S_READ_RAM) begin
			// if (tile_addr_o == 299)
				// tile_addr_o <= 0;
			// else
				// tile_addr_o <= tile_addr_o + 1;

			// ram_data <= ram_data_i;
			// STATE = S_READ_ROM;
		// end
	// end
// end

// always @(posedge clk_serial) begin
	// if (rst_i)
		// tile_addr_o <= 0;
	// else begin
		// if (ready_read && (STATE == S_READ_ROM)) begin
			// rom_data <= rom_data_i;
			// STATE = S_READ_RAM;
		// end
	// end
// end

endmodule
