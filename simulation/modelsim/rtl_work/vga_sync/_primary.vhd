library verilog;
use verilog.vl_types.all;
entity vga_sync is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        hsync_o         : out    vl_logic;
        vsync_o         : out    vl_logic;
        inActiveArea_o  : out    vl_logic;
        inActiveAreaMUX_o: out    vl_logic;
        screen_start_o  : out    vl_logic;
        v_cntr_mod32_o  : out    vl_logic_vector(4 downto 0)
    );
end vga_sync;
