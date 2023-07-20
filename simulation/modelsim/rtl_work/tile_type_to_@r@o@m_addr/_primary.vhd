library verilog;
use verilog.vl_types.all;
entity tile_type_to_ROM_addr is
    generic(
        RAM_DATA_WIDTH  : integer := 7;
        ROM_ADDR_WIDTH  : integer := 12
    );
    port(
        rst_i           : in     vl_logic;
        tile_type_i     : in     vl_logic_vector;
        screen_start_i  : in     vl_logic;
        v_cntr_mod32_i  : in     vl_logic_vector(4 downto 0);
        addr_o          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RAM_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ROM_ADDR_WIDTH : constant is 1;
end tile_type_to_ROM_addr;
