library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        OUT_RGB_SIZE    : integer := 8
    );
    port(
        CLOCK_50        : in     vl_logic;
        KEY_N_0         : in     vl_logic;
        KEY_N_1         : in     vl_logic;
        KEY_N_2         : in     vl_logic;
        KEY_N_3         : in     vl_logic;
        VGA_HS          : out    vl_logic;
        VGA_VS          : out    vl_logic;
        VGA_R           : out    vl_logic_vector;
        VGA_G           : out    vl_logic_vector;
        VGA_B           : out    vl_logic_vector;
        LEDR            : out    vl_logic_vector(3 downto 0);
        VGA_CLK         : out    vl_logic;
        VGA_BLANK_N     : out    vl_logic;
        VGA_SYNC_N      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of OUT_RGB_SIZE : constant is 1;
end top;
