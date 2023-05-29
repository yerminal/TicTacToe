`timescale 1ns / 1ps

module tile_type_to_ROM_addr
#(	parameter RAM_DATA_WIDTH = 7,
	parameter ROM_ADDR_WIDTH = 12
)
(
	input rst_i,
	input [RAM_DATA_WIDTH-1:0] tile_type_i,
	output reg [ROM_ADDR_WIDTH-1:0] addr_o
);

localparam
BOARD_EMPTY 			= 0,
BOARD_FILLED 			= 1,
BOARD_TRIANG 			= 2,
BOARD_TRIANG45 			= 3,
BOARD_TRIANG90 			= 4,
BOARD_TRIANG135 		= 5,
BOARD_TRIANG180 		= 6,
BOARD_CIRCLE 			= 7,
BOARD_CIRCLE45 			= 8,
BOARD_CIRCLE90 			= 9,
BOARD_CIRCLE135 		= 10,
BOARD_CIRCLE180 		= 11,
BOARD_0 				= 12,
BOARD_1 				= 13,
BOARD_2 				= 14,
BOARD_3 				= 15,
BOARD_4 				= 16,
BOARD_5 				= 17,
BOARD_6 				= 18,
BOARD_7 				= 19,
BOARD_8 				= 20,
BOARD_9 				= 21,   
BOARD_A 				= 22,
BOARD_B 				= 23,
BOARD_C 				= 24,
BOARD_D 				= 25,
BOARD_E 				= 26,
BOARD_F 				= 27,
BOARD_G 				= 28,
BOARD_H 				= 29,
BOARD_I 				= 30,
BOARD_J 				= 31,
TURN_FILLED_TRI_LU 		= 32,
TURN_FILLED_TRI_RU 		= 33,
TURN_FILLED_TRI_LD 		= 34,
TURN_FILLED_TRI_RD 		= 35,
TURN_EMPTY_TRI_LU 		= 36,
TURN_EMPTY_TRI_RU 		= 37,
TURN_EMPTY_TRI_LD 		= 38,
TURN_EMPTY_TRI_RD 		= 39,
TURN_FILLED_CIRC_LU 	= 40,
TURN_FILLED_CIRC_RU 	= 41,
TURN_FILLED_CIRC_LD 	= 42,
TURN_FILLED_CIRC_RD 	= 43,
TURN_EMPTY_CIRC_LU 		= 44,
TURN_EMPTY_CIRC_RU 		= 45,
TURN_EMPTY_CIRC_LD 		= 46,
TURN_EMPTY_CIRC_RD 		= 47,
TEXT_TRI_TOTAL_MOVES_0 	= 48,
TEXT_TRI_TOTAL_MOVES_1 	= 49,
TEXT_TRI_TOTAL_MOVES_2 	= 50,
TEXT_TRI_TOTAL_MOVES_3 	= 51,
TEXT_CIRC_TOTAL_MOVES_0 = 52,
TEXT_CIRC_TOTAL_MOVES_1 = 53,
TEXT_CIRC_TOTAL_MOVES_2 = 54,
TEXT_CIRC_TOTAL_MOVES_3	= 55,
TEXT_TRI_WINS_0 		= 56,
TEXT_TRI_WINS_1 		= 57,
TEXT_CIRC_WINS_0 		= 58,
TEXT_CIRC_WINS_1 		= 59,
TEXT_TRI_RECENT_POS_0 	= 60,
TEXT_TRI_RECENT_POS_1 	= 61,
TEXT_TRI_RECENT_POS_2 	= 62,
TEXT_TRI_RECENT_POS_3 	= 63,
TEXT_TRI_RECENT_POS_4 	= 64,
TEXT_CIRC_RECENT_POS_0 	= 65,
TEXT_CIRC_RECENT_POS_1 	= 66,
TEXT_CIRC_RECENT_POS_2 	= 67,
TEXT_CIRC_RECENT_POS_3 	= 68,
TEXT_CIRC_RECENT_POS_4 	= 69,
TEXT_TRI_WON_MSG_0 		= 70,
TEXT_TRI_WON_MSG_1 		= 71,
TEXT_TRI_WON_MSG_2 		= 72,
TEXT_TRI_WON_MSG_3 		= 73,
TEXT_TRI_WON_MSG_4 		= 74,
TEXT_TRI_WON_MSG_5 		= 75,
TEXT_TRI_WON_MSG_6 		= 76,
TEXT_TRI_WON_MSG_7 		= 77,
TEXT_TRI_WON_MSG_8 		= 78,
TEXT_CIRC_WON_MSG_0 	= 79,
TEXT_CIRC_WON_MSG_1 	= 80,
TEXT_CIRC_WON_MSG_2 	= 81,
TEXT_CIRC_WON_MSG_3 	= 82,
TEXT_CIRC_WON_MSG_4 	= 83,
TEXT_CIRC_WON_MSG_5 	= 84,
TEXT_CIRC_WON_MSG_6 	= 85,
TEXT_CIRC_WON_MSG_7 	= 86,
TEXT_CIRC_WON_MSG_8 	= 87;
			
always @(*) begin
	if (rst_i) begin	
		addr_o <= 0;
	end
	
	else begin
		case(tile_type_i)
			BOARD_EMPTY 			:	addr_o <= 'h000;
			BOARD_FILLED 			:	addr_o <= 'h001;
			BOARD_TRIANG 			:   addr_o <= 'h002;
			BOARD_TRIANG45 			:   addr_o <= 'h003;
			BOARD_TRIANG90 			:   addr_o <= 'h004;
			BOARD_TRIANG135 		:   addr_o <= 'h005;
			BOARD_TRIANG180 		:   addr_o <= 'h006;
			BOARD_CIRCLE 			:   addr_o <= 'h007;
			BOARD_CIRCLE45 			:   addr_o <= 'h008;
			BOARD_CIRCLE90 			:   addr_o <= 'h009;
			BOARD_CIRCLE135 		:   addr_o <= 'h00A;
			BOARD_CIRCLE180 		:   addr_o <= 'h00B;
			BOARD_0 				:   addr_o <= 'h00C;
			BOARD_1 				:   addr_o <= 'h00D;
			BOARD_2 				:   addr_o <= 'h00E;
			BOARD_3 				:   addr_o <= 'h00F;
			BOARD_4 				:   addr_o <= 'h010;
			BOARD_5 				:   addr_o <= 'h011;
			BOARD_6 				:   addr_o <= 'h012;
			BOARD_7 				:   addr_o <= 'h013;
			BOARD_8 				:   addr_o <= 'h014;
			BOARD_9 				:   addr_o <= 'h015;
			BOARD_A 				:   addr_o <= 'h016;
			BOARD_B 				:   addr_o <= 'h017;
			BOARD_C 				:   addr_o <= 'h018;
			BOARD_D 				:   addr_o <= 'h019;
			BOARD_E 				:   addr_o <= 'h01A;
			BOARD_F 				:   addr_o <= 'h01B;
			BOARD_G 				:   addr_o <= 'h01C;
			BOARD_H 				:   addr_o <= 'h01D;
			BOARD_I 				:   addr_o <= 'h01E;
			BOARD_J 				:   addr_o <= 'h01F;
			TURN_FILLED_TRI_LU 		:   addr_o <= 'h020;
			TURN_FILLED_TRI_RU 		:   addr_o <= 'h021;
			TURN_FILLED_TRI_LD 		:   addr_o <= 'h022;
			TURN_FILLED_TRI_RD 		:   addr_o <= 'h023;
			TURN_EMPTY_TRI_LU 		:   addr_o <= 'h024;
			TURN_EMPTY_TRI_RU 		:   addr_o <= 'h025;
			TURN_EMPTY_TRI_LD 		:   addr_o <= 'h026;
			TURN_EMPTY_TRI_RD 		:   addr_o <= 'h027;
			TURN_FILLED_CIRC_LU 	:   addr_o <= 'h028;
			TURN_FILLED_CIRC_RU 	:   addr_o <= 'h029;
			TURN_FILLED_CIRC_LD 	:   addr_o <= 'h02A;
			TURN_FILLED_CIRC_RD 	:   addr_o <= 'h02B;
			TURN_EMPTY_CIRC_LU 		:   addr_o <= 'h02C;
			TURN_EMPTY_CIRC_RU 		:   addr_o <= 'h02D;
			TURN_EMPTY_CIRC_LD 		:   addr_o <= 'h02E;
			TURN_EMPTY_CIRC_RD 		:   addr_o <= 'h02F;
			TEXT_TRI_TOTAL_MOVES_0 	:   addr_o <= 'h030;
			TEXT_TRI_TOTAL_MOVES_1 	:   addr_o <= 'h031;
			TEXT_TRI_TOTAL_MOVES_2 	:   addr_o <= 'h032;
			TEXT_TRI_TOTAL_MOVES_3 	:   addr_o <= 'h033;
			TEXT_CIRC_TOTAL_MOVES_0 :   addr_o <= 'h034;
			TEXT_CIRC_TOTAL_MOVES_1 :   addr_o <= 'h035;
			TEXT_CIRC_TOTAL_MOVES_2 :   addr_o <= 'h036;
			TEXT_CIRC_TOTAL_MOVES_3	:   addr_o <= 'h037;
			TEXT_TRI_WINS_0 		:   addr_o <= 'h038;
			TEXT_TRI_WINS_1 		:   addr_o <= 'h039;
			TEXT_CIRC_WINS_0 		:   addr_o <= 'h03A;
			TEXT_CIRC_WINS_1 		:   addr_o <= 'h03B;
			TEXT_TRI_RECENT_POS_0 	:   addr_o <= 'h03C;
			TEXT_TRI_RECENT_POS_1 	:   addr_o <= 'h03D;
			TEXT_TRI_RECENT_POS_2 	:   addr_o <= 'h03E;
			TEXT_TRI_RECENT_POS_3 	:   addr_o <= 'h03F;
			TEXT_TRI_RECENT_POS_4 	:   addr_o <= 'h040;
			TEXT_CIRC_RECENT_POS_0 	:   addr_o <= 'h041;
			TEXT_CIRC_RECENT_POS_1 	:   addr_o <= 'h042;
			TEXT_CIRC_RECENT_POS_2 	:   addr_o <= 'h043;
			TEXT_CIRC_RECENT_POS_3 	:   addr_o <= 'h044;
			TEXT_CIRC_RECENT_POS_4 	:   addr_o <= 'h045;
			TEXT_TRI_WON_MSG_0 		:   addr_o <= 'h046;
			TEXT_TRI_WON_MSG_1 		:   addr_o <= 'h047;
			TEXT_TRI_WON_MSG_2 		:   addr_o <= 'h048;
			TEXT_TRI_WON_MSG_3 		:   addr_o <= 'h049;
			TEXT_TRI_WON_MSG_4 		:   addr_o <= 'h04A;
			TEXT_TRI_WON_MSG_5 		:   addr_o <= 'h04B;
			TEXT_TRI_WON_MSG_6 		:   addr_o <= 'h04C;
			TEXT_TRI_WON_MSG_7 		:   addr_o <= 'h04D;
			TEXT_TRI_WON_MSG_8 		:   addr_o <= 'h04E;
			TEXT_CIRC_WON_MSG_0 	:   addr_o <= 'h04F;
			TEXT_CIRC_WON_MSG_1 	:   addr_o <= 'h050;
			TEXT_CIRC_WON_MSG_2 	:   addr_o <= 'h051;
			TEXT_CIRC_WON_MSG_3 	:   addr_o <= 'h052;
			TEXT_CIRC_WON_MSG_4 	:   addr_o <= 'h053;
			TEXT_CIRC_WON_MSG_5 	:   addr_o <= 'h054;
			TEXT_CIRC_WON_MSG_6 	:   addr_o <= 'h055;
			TEXT_CIRC_WON_MSG_7 	:   addr_o <= 'h056;
			TEXT_CIRC_WON_MSG_8 	:   addr_o <= 'h057;  
			default					:	addr_o <= 0;
		endcase
	end
end

endmodule
