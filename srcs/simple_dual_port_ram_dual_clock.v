`timescale 1ns / 1ps
// Simple Dual Port RAM with separate read/write addresses and
// separate read/write clocks

module simple_dual_port_ram_dual_clock
#(parameter DATA_WIDTH=7, parameter ADDR_WIDTH=9)
(
	input [(DATA_WIDTH-1):0] data_i,
	input [(ADDR_WIDTH-1):0] read_addr_i, write_addr_i,
	input we_i, read_clock_i, write_clock_i,
	output reg [(DATA_WIDTH-1):0] q_o
);
	
	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	always @ (posedge write_clock_i)
	begin
		// Write
		if (we_i)
			ram[write_addr_i] <= data_i;
	end
	
	always @ (posedge read_clock_i)
	begin
		// Read 
		q_o <= ram[read_addr_i];
	end
	
endmodule
