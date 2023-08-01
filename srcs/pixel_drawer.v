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
	input inActiveArea_i,
	input screen_start_i,
	input [(RAM_DATA_WIDTH-1):0] ram_data_i,
	input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	input [4:0] v_cntr_mod32_i,
	output reg [(RAM_ADDR_WIDTH-1):0] tile_addr_o, // Connected to read_addr_i of BRAM
	output [(ROM_ADDR_WIDTH-1):0] pixel_addr_o, // Connected to addr of BROM
	output [(SELECT_SIZE-1):0] serial_data_o
);

wire ready_read;
reg [(RAM_DATA_WIDTH-1):0] ram_data;
reg [(ROM_DATA_WIDTH-1):0] rom_data;

tile_type_to_ROM_addr
#(	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	.ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
)
t1
(
	.rst_i(rst_i),
	.tile_type_i(ram_data_i),
	.v_cntr_mod32_i(v_cntr_mod32_i),
	.screen_start_i(screen_start_i),
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
	.rom_data_i(rom_data_i),
	.screen_start_i(screen_start_i),
	.inActiveArea_i(inActiveArea_i),
	.ready_read_o(ready_read),
	.serial_data_o(serial_data_o)
);

reg [(RAM_ADDR_WIDTH-1):0] tile_addr_previous = 0;
localparam RAM_LOOP_INCREMENT = 20;
reg ready_read_once = 0;

always @(posedge clk_i) begin
	if (rst_i) begin
		tile_addr_o 		<= 0;
		tile_addr_previous 	<= 0;
	end
	else begin
		if (screen_start_i) begin
			tile_addr_previous <= 0;
			tile_addr_o <= 0;
		end
		else begin
			if (~ready_read)
				ready_read_once <= 0;
			if (ready_read && ~ready_read_once) begin
				ready_read_once <= 1;
				if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i == 31))
					begin
						tile_addr_previous <= tile_addr_o + 1;
						tile_addr_o <= tile_addr_o + 1;
					end
				
				if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i < 31))
					tile_addr_o <= tile_addr_previous;
				else
					tile_addr_o <= tile_addr_o + 1;
			end
		end
	end	
end

endmodule
