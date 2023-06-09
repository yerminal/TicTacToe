`timescale 1ns / 10ps

module screen_test
#(	parameter OUT_RGB_SIZE = 4
)
(
// INPUT DATA
input clk_ref,
input btnC,

// OUTPUT DATA
output Hsync,
output Vsync,
output [OUT_RGB_SIZE-1:0] vgaRed,
output [OUT_RGB_SIZE-1:0] vgaGreen,
output [OUT_RGB_SIZE-1:0] vgaBlue
);

localparam RAM_DATA_WIDTH = 7; 
localparam RAM_ADDR_WIDTH = 9;
localparam ROM_DATA_WIDTH = 96;
localparam ROM_ADDR_WIDTH = 12;
localparam SELECT_SIZE = 3;



// INTERNAL DATA
wire clk_pixel;
wire clk_serial;
wire inActiveArea;
wire inActiveAreaMUX;
wire screen_start;
wire [4:0] v_cntr_mod32;
	// ram
wire [(RAM_ADDR_WIDTH-1):0] ram_read_addr;
wire [(RAM_DATA_WIDTH-1):0] ram_read_data;
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
	.rst_i			(btnC),
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
	.rst_i			(btnC),
	.hsync_o		(Hsync),
    .vsync_o		(Vsync),
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
	.rst_i			(btnC),
	.select_i		(serial_data),
	.inActiveArea_i	(inActiveAreaMUX),
	.red_o			(vgaRed),
	.green_o		(vgaGreen),
	.blue_o			(vgaBlue)
);

clock_divider
#(	.CLK_REF_FREQ(100_000_000),
	.CLK_OUT_FREQ(25_000_000)
)
d1
(
	.clk_i(clk_ref),
	.rst_i(btnC),
	.clk_o(clk_serial)
);

clock_divider
#(	.CLK_REF_FREQ(100_000_000),
	.CLK_OUT_FREQ(2_500_000)
)
d2
(
	.clk_i(clk_ref),
	.rst_i(btnC),
	.clk_o(clk_pixel)
);
	
simple_dual_port_ram_dual_clock
#(	.DATA_WIDTH(RAM_DATA_WIDTH), 
	.ADDR_WIDTH(RAM_ADDR_WIDTH)
)
ram1
(
	// .data_i			(),
	.read_addr_i	(ram_read_addr), 
	// .write_addr_i	(),
	// .we_i			(), 
	.read_clock_i	(clk_pixel), 
	// .write_clock_i	(),
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

endmodule
