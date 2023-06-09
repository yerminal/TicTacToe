`timescale 1ns / 1ps

module tile_type_to_ROM_addr
#(	parameter RAM_DATA_WIDTH = 7,
	parameter ROM_ADDR_WIDTH = 12
)
(
	input rst_i,
	input [RAM_DATA_WIDTH-1:0] tile_type_i,
	input screen_start_i,
	input [4:0] v_cntr_mod32_i,
	output reg [ROM_ADDR_WIDTH-1:0] addr_o
);

localparam
WINDW_EMPTY				= 0,
BOARD_EMPTY 			= 1,
BOARD_REDFIL 			= 2,
BOARD_TRIANG 			= 3,
BOARD_TRIANG45 			= 4,
BOARD_TRIANG90 			= 5,
BOARD_TRIANG135 		= 6,
BOARD_TRIANG180 		= 7,
BOARD_CIRCLE 			= 8,
BOARD_CIRCLE45 			= 9,
BOARD_CIRCLE90 			= 10,
BOARD_CIRCLE135 		= 11,
BOARD_CIRCLE180 		= 12,
BOARD_0 				= 13,
BOARD_1 				= 14,
BOARD_2 				= 15,
BOARD_3 				= 16,
BOARD_4 				= 17,
BOARD_5 				= 18,
BOARD_6 				= 19,
BOARD_7 				= 20,
BOARD_8 				= 21,
BOARD_9 				= 22,
BOARD_A 				= 23,
BOARD_B 				= 24,
BOARD_C 				= 25,
BOARD_D 				= 26,
BOARD_E 				= 27,
BOARD_F 				= 28,
BOARD_G 				= 29,
BOARD_H 				= 30,
BOARD_I 				= 31,
BOARD_J 				= 32,
TURN_EMPTY_TRI_LU 		= 33,
TURN_EMPTY_TRI_RU 		= 34,
TURN_EMPTY_TRI_LD 		= 35,
TURN_EMPTY_TRI_RD 		= 36,
TURN_FILLED_TRI_LU 		= 37,
TURN_FILLED_TRI_RU 		= 38,
TURN_FILLED_TRI_LD 		= 39,
TURN_FILLED_TRI_RD 		= 40,
TURN_EMPTY_CIRC_LU 		= 41,
TURN_EMPTY_CIRC_RU 		= 42,
TURN_EMPTY_CIRC_LD 		= 43,
TURN_EMPTY_CIRC_RD 		= 44,
TURN_FILLED_CIRC_LU 	= 45,
TURN_FILLED_CIRC_RU 	= 46,
TURN_FILLED_CIRC_LD 	= 47,
TURN_FILLED_CIRC_RD 	= 48,
TEXT_TRI_TOTAL_MOVES_0 	= 49,
TEXT_TRI_TOTAL_MOVES_1 	= 50,
TEXT_TRI_TOTAL_MOVES_2 	= 51,
TEXT_TRI_TOTAL_MOVES_3 	= 52,
TEXT_CIRC_TOTAL_MOVES_0 = 53,
TEXT_CIRC_TOTAL_MOVES_1 = 54,
TEXT_CIRC_TOTAL_MOVES_2 = 55,
TEXT_CIRC_TOTAL_MOVES_3	= 56,
TEXT_TRI_WINS_0 		= 57,
TEXT_TRI_WINS_1 		= 58,
TEXT_CIRC_WINS_0 		= 59,
TEXT_CIRC_WINS_1 		= 60,
TEXT_TRI_RECENT_POS_0 	= 61,
TEXT_TRI_RECENT_POS_1 	= 62,
TEXT_TRI_RECENT_POS_2 	= 63,
TEXT_TRI_RECENT_POS_3 	= 64,
TEXT_TRI_RECENT_POS_4 	= 65,
TEXT_CIRC_RECENT_POS_0 	= 66,
TEXT_CIRC_RECENT_POS_1 	= 67,
TEXT_CIRC_RECENT_POS_2 	= 68,
TEXT_CIRC_RECENT_POS_3 	= 69,
TEXT_CIRC_RECENT_POS_4 	= 70,
TEXT_TRI_WON_MSG_0 		= 71,
TEXT_TRI_WON_MSG_1 		= 72,
TEXT_TRI_WON_MSG_2 		= 73,
TEXT_TRI_WON_MSG_3 		= 74,
TEXT_TRI_WON_MSG_4 		= 75,
TEXT_TRI_WON_MSG_5 		= 76,
TEXT_TRI_WON_MSG_6 		= 77,
TEXT_TRI_WON_MSG_7 		= 78,
TEXT_TRI_WON_MSG_8 		= 79,
TEXT_CIRC_WON_MSG_0 	= 80,
TEXT_CIRC_WON_MSG_1 	= 81,
TEXT_CIRC_WON_MSG_2 	= 82,
TEXT_CIRC_WON_MSG_3 	= 83,
TEXT_CIRC_WON_MSG_4 	= 84,
TEXT_CIRC_WON_MSG_5 	= 85,
TEXT_CIRC_WON_MSG_6 	= 86,
TEXT_CIRC_WON_MSG_7 	= 87,
TEXT_CIRC_WON_MSG_8 	= 88,
TEXT_0 					= 89,
TEXT_1 					= 90,
TEXT_2 					= 91,
TEXT_3 					= 92,
TEXT_4 					= 93,
TEXT_5 					= 94,
TEXT_6 					= 95,
TEXT_7 					= 96,
TEXT_8 					= 97,
TEXT_9 					= 98,
TEXT_A 					= 99,
TEXT_B 					= 100,
TEXT_C 					= 101,
TEXT_D 					= 102,
TEXT_E 					= 103,
TEXT_F 					= 104,
TEXT_G 					= 105,
TEXT_H 					= 106,
TEXT_I 					= 107,
TEXT_J 					= 108;

// assign v_cntr_mod32 = screen_start_i ? 0 : v_cntr_mod32_i;

always @(*) begin
	if (rst_i) begin	
		addr_o <= 0;
	end
	else begin
		case(tile_type_i)	
			WINDW_EMPTY				:	addr_o <= 0*32+v_cntr_mod32_i;	
			BOARD_EMPTY 			:	addr_o <= 1*32+v_cntr_mod32_i;
			BOARD_REDFIL 			:	addr_o <= 2*32+v_cntr_mod32_i;
			BOARD_TRIANG 			:	addr_o <= 3*32+v_cntr_mod32_i;
			BOARD_TRIANG45 			:	addr_o <= 4*32+v_cntr_mod32_i;
			BOARD_TRIANG90 			:	addr_o <= 5*32+v_cntr_mod32_i;
			BOARD_TRIANG135 		:	addr_o <= 6*32+v_cntr_mod32_i;
			BOARD_TRIANG180 		:	addr_o <= 7*32+v_cntr_mod32_i;
			BOARD_CIRCLE 			:	addr_o <= 8*32+v_cntr_mod32_i;
			BOARD_CIRCLE45 			:	addr_o <= 9*32+v_cntr_mod32_i;
			BOARD_CIRCLE90 			:	addr_o <= 10*32+v_cntr_mod32_i;
			BOARD_CIRCLE135 		:	addr_o <= 11*32+v_cntr_mod32_i;
			BOARD_CIRCLE180 		:	addr_o <= 12*32+v_cntr_mod32_i;
			BOARD_0 				:	addr_o <= 13*32+v_cntr_mod32_i;
			BOARD_1 				:	addr_o <= 14*32+v_cntr_mod32_i;
			BOARD_2 				:	addr_o <= 15*32+v_cntr_mod32_i;
			BOARD_3 				:	addr_o <= 16*32+v_cntr_mod32_i;
			BOARD_4 				:	addr_o <= 17*32+v_cntr_mod32_i;
			BOARD_5 				:	addr_o <= 18*32+v_cntr_mod32_i;
			BOARD_6 				:	addr_o <= 19*32+v_cntr_mod32_i;
			BOARD_7 				:	addr_o <= 20*32+v_cntr_mod32_i;
			BOARD_8 				:	addr_o <= 21*32+v_cntr_mod32_i;
			BOARD_9 				:	addr_o <= 22*32+v_cntr_mod32_i;
			BOARD_A 				:	addr_o <= 23*32+v_cntr_mod32_i;
			BOARD_B 				:	addr_o <= 24*32+v_cntr_mod32_i;
			BOARD_C 				:	addr_o <= 25*32+v_cntr_mod32_i;
			BOARD_D 				:	addr_o <= 26*32+v_cntr_mod32_i;
			BOARD_E 				:	addr_o <= 27*32+v_cntr_mod32_i;
			BOARD_F 				:	addr_o <= 28*32+v_cntr_mod32_i;
			BOARD_G 				:	addr_o <= 29*32+v_cntr_mod32_i;
			BOARD_H 				:	addr_o <= 30*32+v_cntr_mod32_i;
			BOARD_I 				:	addr_o <= 31*32+v_cntr_mod32_i;
			BOARD_J 				:	addr_o <= 32*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_LU 		:	addr_o <= 33*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_RU 		:	addr_o <= 34*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_LD 		:	addr_o <= 35*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_RD 		:	addr_o <= 36*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_LU 		:	addr_o <= 37*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_RU 		:	addr_o <= 38*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_LD 		:	addr_o <= 39*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_RD 		:	addr_o <= 40*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_LU 		:	addr_o <= 41*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_RU 		:	addr_o <= 42*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_LD 		:	addr_o <= 43*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_RD 		:	addr_o <= 44*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_LU 	:	addr_o <= 45*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_RU 	:	addr_o <= 46*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_LD 	:	addr_o <= 47*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_RD 	:	addr_o <= 48*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_0 	:	addr_o <= 49*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_1 	:	addr_o <= 50*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_2 	:	addr_o <= 51*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_3 	:	addr_o <= 52*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_0 :	addr_o <= 53*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_1 :	addr_o <= 54*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_2 :	addr_o <= 55*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_3	:	addr_o <= 56*32+v_cntr_mod32_i;	
			TEXT_TRI_WINS_0 		:	addr_o <= 57*32+v_cntr_mod32_i;
			TEXT_TRI_WINS_1 		:	addr_o <= 58*32+v_cntr_mod32_i;
			TEXT_CIRC_WINS_0 		:	addr_o <= 59*32+v_cntr_mod32_i;
			TEXT_CIRC_WINS_1 		:	addr_o <= 60*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_0 	:	addr_o <= 61*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_1 	:	addr_o <= 62*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_2 	:	addr_o <= 63*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_3 	:	addr_o <= 64*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_4 	:	addr_o <= 65*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_0 	:	addr_o <= 66*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_1 	:	addr_o <= 67*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_2 	:	addr_o <= 68*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_3 	:	addr_o <= 69*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_4 	:	addr_o <= 70*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_0 		:	addr_o <= 71*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_1 		:	addr_o <= 72*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_2 		:	addr_o <= 73*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_3 		:	addr_o <= 74*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_4 		:	addr_o <= 75*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_5 		:	addr_o <= 76*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_6 		:	addr_o <= 77*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_7 		:	addr_o <= 78*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_8 		:	addr_o <= 79*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_0 	:	addr_o <= 80*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_1 	:	addr_o <= 81*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_2 	:	addr_o <= 82*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_3 	:	addr_o <= 83*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_4 	:	addr_o <= 84*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_5 	:	addr_o <= 85*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_6 	:	addr_o <= 86*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_7 	:	addr_o <= 87*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_8 	:	addr_o <= 88*32+v_cntr_mod32_i;
            TEXT_0 					:	addr_o <= 89*32+v_cntr_mod32_i;
            TEXT_1 					:	addr_o <= 90*32+v_cntr_mod32_i;
            TEXT_2 					:	addr_o <= 91*32+v_cntr_mod32_i;
            TEXT_3 					:	addr_o <= 92*32+v_cntr_mod32_i;
            TEXT_4 					:	addr_o <= 93*32+v_cntr_mod32_i;
            TEXT_5 					:	addr_o <= 94*32+v_cntr_mod32_i;
            TEXT_6 					:	addr_o <= 95*32+v_cntr_mod32_i;
            TEXT_7 					:	addr_o <= 96*32+v_cntr_mod32_i;
            TEXT_8 					:	addr_o <= 97*32+v_cntr_mod32_i;
            TEXT_9 					:	addr_o <= 98*32+v_cntr_mod32_i;
			TEXT_A 					:	addr_o <= 99*32+v_cntr_mod32_i;
			TEXT_B 					:	addr_o <= 100*32+v_cntr_mod32_i;
			TEXT_C 					:	addr_o <= 101*32+v_cntr_mod32_i;
			TEXT_D 					:	addr_o <= 102*32+v_cntr_mod32_i;
			TEXT_E 					:	addr_o <= 103*32+v_cntr_mod32_i;
			TEXT_F 					:	addr_o <= 104*32+v_cntr_mod32_i;
			TEXT_G 					:	addr_o <= 105*32+v_cntr_mod32_i;
			TEXT_H 					:	addr_o <= 106*32+v_cntr_mod32_i;
			TEXT_I 					:	addr_o <= 107*32+v_cntr_mod32_i;
			TEXT_J 					:	addr_o <= 108*32+v_cntr_mod32_i;
			default					:	addr_o <= 0;
		endcase
	end
end

endmodule
