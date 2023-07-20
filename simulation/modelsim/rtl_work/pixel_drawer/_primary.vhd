library verilog;
use verilog.vl_types.all;
entity pixel_drawer is
    generic(
        RAM_DATA_WIDTH  : integer := 7;
        RAM_ADDR_WIDTH  : integer := 9;
        ROM_DATA_WIDTH  : integer := 96;
        ROM_ADDR_WIDTH  : integer := 12;
        SELECT_SIZE     : integer := 3
    );
    port(
        clk_i           : in     vl_logic;
        clk_serial      : in     vl_logic;
        rst_i           : in     vl_logic;
        inActiveArea_i  : in     vl_logic;
        screen_start_i  : in     vl_logic;
        ram_data_i      : in     vl_logic_vector;
        rom_data_i      : in     vl_logic_vector;
        v_cntr_mod32_i  : in     vl_logic_vector(4 downto 0);
        tile_addr_o     : out    vl_logic_vector;
        pixel_addr_o    : out    vl_logic_vector;
        serial_data_o   : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RAM_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ROM_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ROM_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SELECT_SIZE : constant is 1;
end pixel_drawer;
