`timescale 1ns / 1ps

module tb_pixel_drawer();

localparam RAM_DATA_WIDTH = 7; 
localparam RAM_ADDR_WIDTH = 9;
localparam ROM_DATA_WIDTH = 96;
localparam ROM_ADDR_WIDTH = 12;
localparam SELECT_SIZE = 3;

localparam HALF_PERIOD = 5;
localparam OUT_RGB_SIZE = 4;

localparam PERIOD = HALF_PERIOD*2;



// INPUT DATA
reg clk_ref = 0;
reg clk_pixel = 0;
reg rst = 0;
reg [SELECT_SIZE-1:0] select;

// INTERNAL DATA
wire inActiveArea;
wire clk_serial;
	// ram
wire [(RAM_ADDR_WIDTH-1):0] ram_read_addr;
wire [(RAM_DATA_WIDTH-1):0] ram_read_data;
	// rom
wire [(ROM_ADDR_WIDTH-1):0] rom_addr;
wire [(ROM_DATA_WIDTH-1):0] rom_data;

// OUTPUT DATA
wire hsync;
wire vsync;
wire [OUT_RGB_SIZE-1:0] red;
wire [OUT_RGB_SIZE-1:0] green;
wire [OUT_RGB_SIZE-1:0] blue;
wire [(SELECT_SIZE-1):0] serial_data;
wire [4:0] v_cntr_mod32;

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
	.rst_i			(rst),
	.ram_data_i		(ram_read_data),
	.rom_data_i		(rom_data),
	.v_cntr_mod32_i	(v_cntr_mod32),
	.tile_addr_o	(ram_read_addr), // Connected to read_addr_i of BRAM
	.pixel_addr_o	(rom_addr), // Connected to addr of BROM
	.serial_data_o  (serial_data)
);

vga_sync sync0(
	.clk_i			(clk_serial),
	.rst_i			(rst),
	.hsync_o		(Hsync),
    .vsync_o		(Vsync),
    .inActiveArea_o	(inActiveArea),
	.inActiveAreaMUX_o(inActiveAreaMUX),
	.v_cntr_mod32_o(v_cntr_mod32),
	.clk_hsync(clk_hsync)
    );

vga_rgb_mux
#(	.SELECT_SIZE(SELECT_SIZE),
	.OUT_RGB_SIZE(OUT_RGB_SIZE)
)
mux1
(
	.rst_i			(rst),
	.select_i		(data),
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
	.rst_i(rst),
	.clk_o(clk_serial)
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

always #(HALF_PERIOD*10) clk_pixel=~clk_pixel;
always #HALF_PERIOD clk_ref=~clk_ref;

integer i = 0;

initial begin
	// select <= i;
	// #HALF_PERIOD;
	// while (1) begin
		// while (i < 5) begin
			// select <= i;
			// #PERIOD;
			// i = i + 1;
		// end
		// i = 0;
	// end
	rst <= 1;
	#(HALF_PERIOD*10);
	rst <= 0;
	while (1) begin
	#HALF_PERIOD;
	end
end

endmodule
