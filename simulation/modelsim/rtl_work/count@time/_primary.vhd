library verilog;
use verilog.vl_types.all;
entity countTime is
    generic(
        CLK_INPUT_FREQ  : integer := 25000000;
        WAIT_FOR_SECS   : integer := 10
    );
    port(
        clk_i           : in     vl_logic;
        start_count_i   : in     vl_logic;
        count_done_o    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_INPUT_FREQ : constant is 1;
    attribute mti_svvh_generic_type of WAIT_FOR_SECS : constant is 1;
end countTime;
