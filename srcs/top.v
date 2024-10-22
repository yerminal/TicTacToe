`timescale 1ns / 10ps

module top
#(	parameter OUT_RGB_SIZE = 8
)
(
// INPUT DATA
input CLOCK_50,
input KEY_N_0,
input KEY_N_1,
input KEY_N_2,
input KEY_N_3,

// OUTPUT DATA
output VGA_HS,
output VGA_VS,
output [OUT_RGB_SIZE-1:0] VGA_R,
output [OUT_RGB_SIZE-1:0] VGA_G,
output [OUT_RGB_SIZE-1:0] VGA_B,
output [3:0] LEDR,
output VGA_CLK,
output VGA_BLANK_N,
output VGA_SYNC_N
);

localparam RAM_DATA_WIDTH = 7; 
localparam RAM_ADDR_WIDTH = 9;
localparam ROM_DATA_WIDTH = 96;
localparam ROM_ADDR_WIDTH = 12;
localparam SELECT_SIZE = 3;

// INTERNAL DATA
wire clk_pixel;
wire clk_serial;
wire clk_game;

assign VGA_SYNC_N = 0;
assign VGA_CLK = clk_serial;
assign VGA_BLANK_N = 1;

assign LEDR[0] = KEY_N_0;
assign LEDR[1] = KEY_N_1;
assign LEDR[2] = KEY_N_2;
assign LEDR[3] = KEY_N_3;

wire inActiveArea;
wire inActiveAreaMUX;
wire screen_start;
wire [4:0] v_cntr_mod32;
	// ram
wire [(RAM_ADDR_WIDTH-1):0] ram_read_addr;
wire [(RAM_DATA_WIDTH-1):0] ram_read_data;
wire [(RAM_ADDR_WIDTH-1):0] ram_write_addr;
wire [(RAM_DATA_WIDTH-1):0] ram_write_data;
wire ram_we; 
wire ram_write_clock;
	// rom
wire [(ROM_ADDR_WIDTH-1):0] rom_addr;
wire [(ROM_DATA_WIDTH-1):0] rom_data;
	// serial data sent to VGA
wire [(SELECT_SIZE-1):0] serial_data;



pixel_drawer
#(	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	.RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
	.ROM_DATA_WIDTH(ROM_DATA_WIDTH),
	.ROM_ADDR_WIDTH(ROM_ADDR_WIDTH),
	.SELECT_SIZE(SELECT_SIZE)
)
p1
(
	.clk_i			(clk_pixel),
	.clk_serial		(clk_serial),
	.rst_i			(~KEY_N_0),
	.inActiveArea_i	(inActiveArea),
	.screen_start_i (screen_start),
	.ram_data_i		(ram_read_data),
	.rom_data_i		(rom_data),
	.v_cntr_mod32_i	(v_cntr_mod32),
	.tile_addr_o	(ram_read_addr), // Connected to read_addr_i of BRAM
	.pixel_addr_o	(rom_addr), // Connected to addr of BROM
	.serial_data_o  (serial_data)
);

vga_sync sync0(
	.clk_i			(clk_serial),
	.rst_i			(~KEY_N_0),
	.hsync_o			(VGA_HS),
    .vsync_o		(VGA_VS),
    .inActiveArea_o	(inActiveArea),
	.inActiveAreaMUX_o(inActiveAreaMUX),
	.screen_start_o	(screen_start),
	.v_cntr_mod32_o(v_cntr_mod32)
    );

vga_rgb_mux
#(	.SELECT_SIZE(SELECT_SIZE),
	.OUT_RGB_SIZE(OUT_RGB_SIZE)
)
mux1
(
	.rst_i			(~KEY_N_0),
	.select_i		(serial_data),
	.inActiveArea_i	(inActiveAreaMUX),
	.red_o			(VGA_R),
	.green_o			(VGA_G),
	.blue_o			(VGA_B)
);

clock_divider
#(	.CLK_REF_FREQ(50_000_000),
	.CLK_OUT_FREQ(25_000_000)
)
d1
(
	.clk_i(CLOCK_50),
	.rst_i(~KEY_N_0),
	.clk_o(clk_serial)
);

clock_divider
#(	.CLK_REF_FREQ(50_000_000),
	.CLK_OUT_FREQ(6_250_000)
)
d2
(
	.clk_i(CLOCK_50),
	.rst_i(~KEY_N_0),
	.clk_o(clk_pixel)
);

clock_divider_negedge
#(	.CLK_REF_FREQ(50_000_000),
	.CLK_OUT_FREQ(100_000)
)
d3
(
	.clk_i(CLOCK_50),
	.rst_i(~KEY_N_0),
	.clk_o(clk_game)
);

simple_dual_port_ram_dual_clock
#(	.DATA_WIDTH(RAM_DATA_WIDTH), 
	.ADDR_WIDTH(RAM_ADDR_WIDTH)
)
ram1
(
	.data_i			(ram_write_data),
	.read_addr_i	(ram_read_addr), 
	.write_addr_i	(ram_write_addr),
	.we_i				(ram_we), 
	.read_clock_i	(clk_pixel), 
	.write_clock_i	(clk_game),
	.q_o            (ram_read_data)
);

single_port_rom
#(	.DATA_WIDTH(ROM_DATA_WIDTH), 
	.ADDR_WIDTH(ROM_ADDR_WIDTH)
)
rom1
(
	.addr(rom_addr),
	.clk(clk_pixel), 
	.q(rom_data)
);

game_manager
#(
	.RAM_DATA_WIDTH(RAM_DATA_WIDTH),
	.RAM_ADDR_WIDTH(RAM_ADDR_WIDTH),
	.CLK_FREQ(100_000)
)
g1
(
	.zeroButton(KEY_N_3),
	.oneButton(KEY_N_2),
	.activityButton(KEY_N_1),
	.clk(clk_game),
	.data_o(ram_write_data),
	.write_addr_o(ram_write_addr),
	.we_o(ram_we)
);

endmodule
