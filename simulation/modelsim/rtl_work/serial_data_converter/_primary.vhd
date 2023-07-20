library verilog;
use verilog.vl_types.all;
entity serial_data_converter is
    generic(
        ROM_DATA_WIDTH  : integer := 96;
        SELECT_SIZE     : integer := 3
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        rom_data_i      : in     vl_logic_vector;
        screen_start_i  : in     vl_logic;
        inActiveArea_i  : in     vl_logic;
        ready_read_o    : out    vl_logic;
        serial_data_o   : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ROM_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SELECT_SIZE : constant is 1;
end serial_data_converter;
