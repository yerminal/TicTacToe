`timescale 1ns / 1ps

module tile_type_to_ROM_addr
#(	parameter RAM_DATA_WIDTH = 7,
	parameter ROM_ADDR_WIDTH = 12
)
(
	input rst_i,
	input [RAM_DATA_WIDTH-1:0] tile_type_i,
	input [4:0] v_cntr_mod32_i,
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
			BOARD_EMPTY 			:	addr_o <= 0*32+v_cntr_mod32_i;
			BOARD_FILLED 			:	addr_o <= 1*32+v_cntr_mod32_i;
			BOARD_TRIANG 			:   addr_o <= 2*32+v_cntr_mod32_i;
			BOARD_TRIANG45 			:   addr_o <= 3*32+v_cntr_mod32_i;
			BOARD_TRIANG90 			:   addr_o <= 4*32+v_cntr_mod32_i;
			BOARD_TRIANG135 		:   addr_o <= 5*32+v_cntr_mod32_i;
			BOARD_TRIANG180 		:   addr_o <= 6*32+v_cntr_mod32_i;
			BOARD_CIRCLE 			:   addr_o <= 7*32+v_cntr_mod32_i;
			BOARD_CIRCLE45 			:   addr_o <= 8*32+v_cntr_mod32_i;
			BOARD_CIRCLE90 			:   addr_o <= 9*32+v_cntr_mod32_i;
			BOARD_CIRCLE135 		:   addr_o <= 10*32+v_cntr_mod32_i;
			BOARD_CIRCLE180 		:   addr_o <= 11*32+v_cntr_mod32_i;
			BOARD_0 				:   addr_o <= 12*32+v_cntr_mod32_i;
			BOARD_1 				:   addr_o <= 13*32+v_cntr_mod32_i;
			BOARD_2 				:   addr_o <= 14*32+v_cntr_mod32_i;
			BOARD_3 				:   addr_o <= 15*32+v_cntr_mod32_i;
			BOARD_4 				:   addr_o <= 16*32+v_cntr_mod32_i;
			BOARD_5 				:   addr_o <= 17*32+v_cntr_mod32_i;
			BOARD_6 				:   addr_o <= 18*32+v_cntr_mod32_i;
			BOARD_7 				:   addr_o <= 19*32+v_cntr_mod32_i;
			BOARD_8 				:   addr_o <= 20*32+v_cntr_mod32_i;
			BOARD_9 				:   addr_o <= 21*32+v_cntr_mod32_i;
			BOARD_A 				:   addr_o <= 22*32+v_cntr_mod32_i;
			BOARD_B 				:   addr_o <= 23*32+v_cntr_mod32_i;
			BOARD_C 				:   addr_o <= 24*32+v_cntr_mod32_i;
			BOARD_D 				:   addr_o <= 25*32+v_cntr_mod32_i;
			BOARD_E 				:   addr_o <= 26*32+v_cntr_mod32_i;
			BOARD_F 				:   addr_o <= 27*32+v_cntr_mod32_i;
			BOARD_G 				:   addr_o <= 28*32+v_cntr_mod32_i;
			BOARD_H 				:   addr_o <= 29*32+v_cntr_mod32_i;
			BOARD_I 				:   addr_o <= 30*32+v_cntr_mod32_i;
			BOARD_J 				:   addr_o <= 31*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_LU 		:   addr_o <= 32*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_RU 		:   addr_o <= 33*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_LD 		:   addr_o <= 34*32+v_cntr_mod32_i;
			TURN_FILLED_TRI_RD 		:   addr_o <= 35*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_LU 		:   addr_o <= 36*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_RU 		:   addr_o <= 37*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_LD 		:   addr_o <= 38*32+v_cntr_mod32_i;
			TURN_EMPTY_TRI_RD 		:   addr_o <= 39*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_LU 	:   addr_o <= 40*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_RU 	:   addr_o <= 41*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_LD 	:   addr_o <= 42*32+v_cntr_mod32_i;
			TURN_FILLED_CIRC_RD 	:   addr_o <= 43*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_LU 		:   addr_o <= 44*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_RU 		:   addr_o <= 45*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_LD 		:   addr_o <= 46*32+v_cntr_mod32_i;
			TURN_EMPTY_CIRC_RD 		:   addr_o <= 47*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_0 	:   addr_o <= 48*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_1 	:   addr_o <= 49*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_2 	:   addr_o <= 50*32+v_cntr_mod32_i;
			TEXT_TRI_TOTAL_MOVES_3 	:   addr_o <= 51*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_0 :   addr_o <= 52*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_1 :   addr_o <= 53*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_2 :   addr_o <= 54*32+v_cntr_mod32_i;
			TEXT_CIRC_TOTAL_MOVES_3	:   addr_o <= 55*32+v_cntr_mod32_i;
			TEXT_TRI_WINS_0 		:   addr_o <= 56*32+v_cntr_mod32_i;
			TEXT_TRI_WINS_1 		:   addr_o <= 57*32+v_cntr_mod32_i;
			TEXT_CIRC_WINS_0 		:   addr_o <= 58*32+v_cntr_mod32_i;
			TEXT_CIRC_WINS_1 		:   addr_o <= 59*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_0 	:   addr_o <= 60*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_1 	:   addr_o <= 61*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_2 	:   addr_o <= 62*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_3 	:   addr_o <= 63*32+v_cntr_mod32_i;
			TEXT_TRI_RECENT_POS_4 	:   addr_o <= 64*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_0 	:   addr_o <= 65*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_1 	:   addr_o <= 66*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_2 	:   addr_o <= 67*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_3 	:   addr_o <= 68*32+v_cntr_mod32_i;
			TEXT_CIRC_RECENT_POS_4 	:   addr_o <= 69*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_0 		:   addr_o <= 70*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_1 		:   addr_o <= 71*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_2 		:   addr_o <= 72*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_3 		:   addr_o <= 73*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_4 		:   addr_o <= 74*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_5 		:   addr_o <= 75*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_6 		:   addr_o <= 76*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_7 		:   addr_o <= 77*32+v_cntr_mod32_i;
			TEXT_TRI_WON_MSG_8 		:   addr_o <= 78*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_0 	:   addr_o <= 79*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_1 	:   addr_o <= 80*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_2 	:   addr_o <= 81*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_3 	:   addr_o <= 82*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_4 	:   addr_o <= 83*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_5 	:   addr_o <= 84*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_6 	:   addr_o <= 85*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_7 	:   addr_o <= 86*32+v_cntr_mod32_i;
			TEXT_CIRC_WON_MSG_8 	:   addr_o <= 87*32+v_cntr_mod32_i;  
			default					:	addr_o <= 0;
		endcase
	end
end

endmodule
