`timescale 1ns / 1ps

module tb_serial_data_converter();

localparam ROM_DATA_WIDTH = 96;
localparam SELECT_SIZE = 3;
	
localparam HALF_PERIOD = 5;
localparam PERIOD = HALF_PERIOD*2;

reg clk = 0;
reg rst = 0;
reg [(ROM_DATA_WIDTH-1):0] rom_data;
wire [(SELECT_SIZE-1):0] serial_data;
wire ready_read;

serial_data_converter
#(	.ROM_DATA_WIDTH(ROM_DATA_WIDTH),
	.SELECT_SIZE(SELECT_SIZE)
)
s1
(
	.clk_i(clk),
	.rst_i(rst),
	.rom_data_i(rom_data),
	.ready_read_o(ready_read),
	.serial_data_o(serial_data)
);

always #HALF_PERIOD clk=~clk;

reg once_before = 0;
integer i = 500;

initial begin
	rom_data <= i;
	#HALF_PERIOD;
	while (i < 2000) begin
		while (~ready_read) begin
			#PERIOD;
			once_before <= 0;
		end
		if (once_before == 0) begin
			rom_data <= i;
			once_before <= 1;
			#PERIOD;
			i = i + 1;
		end
		else
			#PERIOD;
		
	end
end

endmodule

