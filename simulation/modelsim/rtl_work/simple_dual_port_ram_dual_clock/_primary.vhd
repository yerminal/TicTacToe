library verilog;
use verilog.vl_types.all;
entity simple_dual_port_ram_dual_clock is
    generic(
        DATA_WIDTH      : integer := 7;
        ADDR_WIDTH      : integer := 9
    );
    port(
        data_i          : in     vl_logic_vector;
        read_addr_i     : in     vl_logic_vector;
        write_addr_i    : in     vl_logic_vector;
        we_i            : in     vl_logic;
        read_clock_i    : in     vl_logic;
        write_clock_i   : in     vl_logic;
        q_o             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 1;
end simple_dual_port_ram_dual_clock;
