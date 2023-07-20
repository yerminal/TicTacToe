library verilog;
use verilog.vl_types.all;
entity clock_divider_negedge is
    generic(
        CLK_REF_FREQ    : integer := 50000000;
        CLK_OUT_FREQ    : integer := 25000000
    );
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        clk_o           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_REF_FREQ : constant is 1;
    attribute mti_svvh_generic_type of CLK_OUT_FREQ : constant is 1;
end clock_divider_negedge;
