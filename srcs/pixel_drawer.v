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

// `timescale 1ns / 1ps

// module pixel_drawer
// #(	parameter RAM_DATA_WIDTH = 7, 
	// parameter RAM_ADDR_WIDTH = 9,
	// parameter ROM_DATA_WIDTH = 96,
	// parameter ROM_ADDR_WIDTH = 12,
	// parameter SELECT_SIZE = 3
// )
// (
	// input clk_i,
	// input clk_serial,
	// input rst_i,
	// input inActiveArea_i,
	// input screen_start_i,
	// input [(RAM_DATA_WIDTH-1):0] ram_data_i,
	// input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	// input [4:0] v_cntr_mod32_i,
	// output reg [(RAM_ADDR_WIDTH-1):0] tile_addr_o, // Connected to read_addr_i of BRAM
	// output [(ROM_ADDR_WIDTH-1):0] pixel_addr_o, // Connected to addr of BROM
	// output [(SELECT_SIZE-1):0] serial_data_o
// );

// reg STATE = 0;
// localparam S_READ_RAM = 0;
// localparam S_READ_ROM = 1;
// // localparam S_SEND_MUX = 2;

// wire ready_read;
// reg [(RAM_DATA_WIDTH-1):0] ram_data;
// reg [(ROM_DATA_WIDTH-1):0] rom_data;

// tile_type_to_ROM_addr
// #(	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	// .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
// )
// t1
// (
	// .rst_i(rst_i),
	// .tile_type_i(ram_data),
	// .v_cntr_mod32_i(v_cntr_mod32_i),
	// .screen_start_i(screen_start_i),
	// .addr_o(pixel_addr_o)
// );

// serial_data_converter
// #(	.ROM_DATA_WIDTH(ROM_DATA_WIDTH),
	// .SELECT_SIZE(SELECT_SIZE)
// )
// s1
// (
	// .clk_i(clk_serial),
	// .rst_i(rst_i),
	// .rom_data_i(rom_data),
	// .screen_start_i(screen_start_i),
	// .inActiveArea_i(inActiveArea_i),
	// .ready_read_o(ready_read),
	// .serial_data_o(serial_data_o)
// );

// initial begin
	// tile_addr_o <= 0;
	// ram_data <= 0;
// end

// reg [(RAM_ADDR_WIDTH-1):0] tile_addr_previous = 0;
// localparam RAM_LOOP_INCREMENT = 20;

// // RESET
// always @(posedge clk_serial) begin
	// if (rst_i) begin
		// tile_addr_o 		<= 0;
		// tile_addr_previous 	<= 0;
	// end
// end

// // READ RAM LOOP
// always @(posedge clk_i) begin
	// if (STATE == S_READ_RAM) begin
		// if (screen_start_i) begin
			// tile_addr_previous <= 0;
			// tile_addr_o <= 0;
		// end
		// else begin
			// if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i == 31))
				// begin
					// tile_addr_previous <= tile_addr_o + 1;
					// tile_addr_o <= tile_addr_o + 1;
				// end
			
			// if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i < 31))
				// tile_addr_o <= tile_addr_previous;
			// else
				// tile_addr_o <= tile_addr_o + 1;
		// end
		// ram_data <= ram_data_i;
		// STATE = S_READ_ROM;
	// end
// end

// // READ ROM LOOP
// reg ready_read_once = 0;
// always @(posedge clk_serial) begin
	// if (screen_start_i && STATE == S_READ_ROM) begin
		// rom_data <= rom_data_i;
		// STATE = S_READ_RAM;
	// end	
	// else begin
		// if (~ready_read)
			// ready_read_once <= 0;
		
		// if ((ready_read && ~ready_read_once) && (STATE == S_READ_ROM)) begin
			// rom_data <= rom_data_i;
			// STATE = S_READ_RAM;
			// ready_read_once <= 1;
		// end
	// end
// end

// // localparam CLK_COUNT_LIMIT 	= CLK_REF_FREQ/(2*CLK_OUT_FREQ)-1;
// // localparam COUNTR_SIZE 		= $clog2(CLK_COUNT_LIMIT);

// // reg [COUNTR_SIZE-1:0] counter = 0;
// // reg clk = 1;

// // assign clk_o = clk;

// // always @(posedge clk_i) begin
	// // if (rst_i)
		// // counter <= 0;
	// // else if (counter == CLK_COUNT_LIMIT) begin
		// // counter <= 0;
		// // clk <= ~clk;
	// // end
	// // else
		// // counter <= counter + 1;
// // end

// endmodule

// `timescale 1ns / 1ps

// module pixel_drawer
// #(	parameter RAM_DATA_WIDTH = 7, 
	// parameter RAM_ADDR_WIDTH = 9,
	// parameter ROM_DATA_WIDTH = 96,
	// parameter ROM_ADDR_WIDTH = 12,
	// parameter SELECT_SIZE = 3,
	// parameter CLK_REF_FREQ = 25_000_000,
	// parameter CLK_OUT_FREQ = 2_500_000
// )
// (
	// input clk_i,
	// input clk_serial,
	// input rst_i,
	// input inActiveArea_i,
	// input screen_start_i,
	// input [(RAM_DATA_WIDTH-1):0] ram_data_i,
	// input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	// input [4:0] v_cntr_mod32_i,
	// output reg [(RAM_ADDR_WIDTH-1):0] tile_addr_o, // Connected to read_addr_i of BRAM
	// output [(ROM_ADDR_WIDTH-1):0] pixel_addr_o, // Connected to addr of BROM
	// output [(SELECT_SIZE-1):0] serial_data_o
// );

// wire ready_read;
// reg [(RAM_DATA_WIDTH-1):0] ram_data;
// reg [(ROM_DATA_WIDTH-1):0] rom_data;

// tile_type_to_ROM_addr
// #(	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	// .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
// )
// t1
// (
	// .rst_i(rst_i),
	// .tile_type_i(ram_data_i),
	// .v_cntr_mod32_i(v_cntr_mod32_i),
	// .screen_start_i(screen_start_i),
	// .addr_o(pixel_addr_o)
// );

// serial_data_converter
// #(	.ROM_DATA_WIDTH(ROM_DATA_WIDTH),
	// .SELECT_SIZE(SELECT_SIZE)
// )
// s1
// (
	// .clk_i(clk_serial),
	// .rst_i(rst_i),
	// .rom_data_i(rom_data_i),
	// .screen_start_i(screen_start_i),
	// .inActiveArea_i(inActiveArea_i),
	// .ready_read_o(ready_read),
	// .serial_data_o(serial_data_o)
// );

// reg [(RAM_ADDR_WIDTH-1):0] tile_addr_previous = 0;
// localparam RAM_LOOP_INCREMENT = 20;
// reg ready_read_once = 0;

// reg STATE = 0;
// localparam S_READ_RAM = 0;
// localparam S_READ_ROM = 1;

// localparam CLK_COUNT_LIMIT 		= CLK_REF_FREQ/(2*CLK_OUT_FREQ)-1;
// localparam COUNTR_SIZE 			= $clog2(CLK_COUNT_LIMIT);
// reg [COUNTR_SIZE-1:0] counter 	= 0;

// // TEST CLOCK
// reg clk_state = 1;

// always @(posedge clk_serial) begin
	// clk_state <= clk_i;
	// if (rst_i) begin
		// tile_addr_o 		<= 0;
		// tile_addr_previous 	<= 0;
		// counter <= 0;
	// end
	// else begin
		// case(STATE)
			// S_READ_RAM	: begin
				// if (clk_state == 0 && clk_i == 1) begin
					// counter <= 0;
					// if (screen_start_i) begin
						// tile_addr_previous <= 0;
						// tile_addr_o <= 0;
					// end
					// else begin
						// if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i == 31))
							// begin
								// tile_addr_previous <= tile_addr_o + 1;
								// tile_addr_o <= tile_addr_o + 1;
							// end
						
						// if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i < 31))
							// tile_addr_o <= tile_addr_previous;
						// else
							// tile_addr_o <= tile_addr_o + 1;
					// end
					// // ram_data <= ram_data_i;
					// STATE = S_READ_ROM;
				// end
				// else
					// counter <= counter + 1;
			// end
			// S_READ_ROM	: begin
				// if (screen_start_i) begin
					// // rom_data <= rom_data_i;
					// STATE = S_READ_RAM;
				// end	
				// else begin
					// if (~ready_read)
						// ready_read_once <= 0;
					
					// if (ready_read && ~ready_read_once) begin
						// // rom_data <= rom_data_i;
						// STATE = S_READ_RAM;
						// ready_read_once <= 1;
					// end
				// end
			// end
		// endcase
	// end	
// end

// endmodule

// `timescale 1ns / 1ps

// module pixel_drawer
// #(	parameter RAM_DATA_WIDTH = 7, 
	// parameter RAM_ADDR_WIDTH = 9,
	// parameter ROM_DATA_WIDTH = 96,
	// parameter ROM_ADDR_WIDTH = 12,
	// parameter SELECT_SIZE = 3
// )
// (
	// input clk_i,
	// input clk_serial,
	// input rst_i,
	// input inActiveArea_i,
	// input screen_start_i,
	// input [(RAM_DATA_WIDTH-1):0] ram_data_i,
	// input [(ROM_DATA_WIDTH-1):0] rom_data_i,
	// input [4:0] v_cntr_mod32_i,
	// output reg [(RAM_ADDR_WIDTH-1):0] tile_addr_o, // Connected to read_addr_i of BRAM
	// output [(ROM_ADDR_WIDTH-1):0] pixel_addr_o, // Connected to addr of BROM
	// output [(SELECT_SIZE-1):0] serial_data_o
// );

// reg STATE = 0;
// localparam S_READ_RAM = 0;
// localparam S_READ_ROM = 1;
// // localparam S_SEND_MUX = 2;

// wire ready_read;
// reg [(RAM_DATA_WIDTH-1):0] ram_data;
// reg [(ROM_DATA_WIDTH-1):0] rom_data;

// tile_type_to_ROM_addr
// #(	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	// .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH)
// )
// t1
// (
	// .rst_i(rst_i),
	// .tile_type_i(ram_data),
	// .v_cntr_mod32_i(v_cntr_mod32_i),
	// .screen_start_i(screen_start_i),
	// .addr_o(pixel_addr_o)
// );

// serial_data_converter
// #(	.ROM_DATA_WIDTH(ROM_DATA_WIDTH),
	// .SELECT_SIZE(SELECT_SIZE)
// )
// s1
// (
	// .clk_i(clk_serial),
	// .rst_i(rst_i),
	// .rom_data_i(rom_data),
	// .screen_start_i(screen_start_i),
	// .inActiveArea_i(inActiveArea_i),
	// .ready_read_o(ready_read),
	// .serial_data_o(serial_data_o)
// );

// initial begin
	// tile_addr_o <= 0;
	// ram_data <= 0;
// end

// reg [(RAM_ADDR_WIDTH-1):0] tile_addr_previous = 0;
// localparam RAM_LOOP_INCREMENT = 20;

// // RESET
// always @(posedge clk_serial) begin
	// if (rst_i) begin
		// tile_addr_o 		<= 0;
		// tile_addr_previous 	<= 0;
	// end
// end

// // READ RAM LOOP
// always @(posedge clk_i) begin
	// if (STATE == S_READ_RAM) begin
		// if (screen_start_i) begin
			// tile_addr_previous <= 0;
			// tile_addr_o <= 0;
		// end
		// else begin
			// if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i == 31))
				// begin
					// tile_addr_previous <= tile_addr_o + 1;
					// tile_addr_o <= tile_addr_o + 1;
				// end
			
			// if ((tile_addr_o == tile_addr_previous + RAM_LOOP_INCREMENT - 1)&&(v_cntr_mod32_i < 31))
				// tile_addr_o <= tile_addr_previous;
			// else
				// tile_addr_o <= tile_addr_o + 1;
		// end
		// ram_data <= ram_data_i;
		// STATE = S_READ_ROM;
	// end
// end

// // READ ROM LOOP
// reg ready_read_once = 0;
// always @(posedge clk_serial) begin
	// if (screen_start_i && STATE == S_READ_ROM) begin
		// rom_data <= rom_data_i;
		// STATE = S_READ_RAM;
	// end	
	// else begin
		// if (~ready_read)
			// ready_read_once <= 0;
		
		// if ((ready_read && ~ready_read_once) && (STATE == S_READ_ROM)) begin
			// rom_data <= rom_data_i;
			// STATE = S_READ_RAM;
			// ready_read_once <= 1;
		// end
	// end
// end

// // localparam CLK_COUNT_LIMIT 	= CLK_REF_FREQ/(2*CLK_OUT_FREQ)-1;
// // localparam COUNTR_SIZE 		= $clog2(CLK_COUNT_LIMIT);

// // reg [COUNTR_SIZE-1:0] counter = 0;
// // reg clk = 1;

// // assign clk_o = clk;

// // always @(posedge clk_i) begin
	// // if (rst_i)
		// // counter <= 0;
	// // else if (counter == CLK_COUNT_LIMIT) begin
		// // counter <= 0;
		// // clk <= ~clk;
	// // end
	// // else
		// // counter <= counter + 1;
// // end

// endmodule
