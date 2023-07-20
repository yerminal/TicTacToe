library verilog;
use verilog.vl_types.all;
entity game_manager is
    generic(
        RAM_DATA_WIDTH  : integer := 7;
        RAM_ADDR_WIDTH  : integer := 9;
        CLK_FREQ        : integer := 100000
    );
    port(
        zeroButton      : in     vl_logic;
        oneButton       : in     vl_logic;
        activityButton  : in     vl_logic;
        clk             : in     vl_logic;
        data_o          : out    vl_logic_vector;
        write_addr_o    : out    vl_logic_vector;
        we_o            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RAM_DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of RAM_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of CLK_FREQ : constant is 1;
end game_manager;
