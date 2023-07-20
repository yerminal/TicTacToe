library verilog;
use verilog.vl_types.all;
entity vga_rgb_mux is
    generic(
        SELECT_SIZE     : integer := 3;
        OUT_RGB_SIZE    : integer := 8
    );
    port(
        rst_i           : in     vl_logic;
        select_i        : in     vl_logic_vector;
        inActiveArea_i  : in     vl_logic;
        red_o           : out    vl_logic_vector;
        green_o         : out    vl_logic_vector;
        blue_o          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SELECT_SIZE : constant is 1;
    attribute mti_svvh_generic_type of OUT_RGB_SIZE : constant is 1;
end vga_rgb_mux;
