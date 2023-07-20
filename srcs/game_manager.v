`timescale 1ns / 1ps

module countTime
#(	parameter CLK_INPUT_FREQ = 25_000_000,
	parameter WAIT_FOR_SECS = 10
)
(
	input clk_i,
	input start_count_i,
	output reg count_done_o
);

localparam COUNTR_SIZE = $clog2(CLK_INPUT_FREQ-1);
localparam COUNTR_SEC_SIZE = $clog2(WAIT_FOR_SECS-1);
reg [COUNTR_SIZE-1:0] counter = 0;
reg [COUNTR_SEC_SIZE-1:0] counter_sec_time = 0;

always @(posedge clk_i) begin
	if (start_count_i) begin
		if (counter == CLK_INPUT_FREQ-1) begin
				if (counter_sec_time == WAIT_FOR_SECS)
					count_done_o <= 1;
				else
					counter_sec_time <= counter_sec_time + 1;
				counter <= 0;
		end
		else
			counter <= counter + 1;
	end
	else begin
		counter <= 0;
		counter_sec_time <= 0;
		count_done_o <= 0;
	end
end

endmodule

module game_manager
#(
	parameter RAM_DATA_WIDTH=7,
	parameter RAM_ADDR_WIDTH=9,
	parameter CLK_FREQ=100_000
)
(
	input zeroButton,
	input oneButton,
	input activityButton,
	input clk,
	output reg [(RAM_DATA_WIDTH-1):0] data_o,
	output reg [(RAM_ADDR_WIDTH-1):0] write_addr_o,
	output reg we_o
);

reg [99:0] boardCircle;
reg [99:0] boardTriangle;
reg [99:0] boardSquare;

reg [3:0] userAdressLine;
reg [3:0] userAdressColumn;
reg [4:0] isValidCounter;

reg [1:0] STATE=0;
localparam S_GAME_LOGIC=0;
localparam S_WRITE_DATA=1;
localparam S_RAM_RESET=2;

localparam QUEUE_SIZE = 35;
reg [(RAM_DATA_WIDTH-1):0] data[QUEUE_SIZE-1:0];
reg [(RAM_ADDR_WIDTH-1):0] write_addr[QUEUE_SIZE-1:0];
reg [6:0] i;
reg [6:0] j;

reg [1:0] RESET_STATE=0;
localparam R_BOARD=0;
localparam R_MOVES=1;
localparam R_POSIT=2;
localparam R_WON=3;
reg [3:0] row_counter=0;
reg [3:0] colm_counter=0;

integer myIndex;

reg whosTurn;
reg [4:0] turnNumber;
reg lastZeroButton;
reg lastOneButton;
reg lastActivityButton;
reg startCount;
wire countDone;
reg isFinished;
reg isDraw=0;
reg lastWinner;
reg [4:0]activityTriangle=0;
reg [4:0]activityCircle=0;
reg [6:0]waitCounter;
reg [6:0]triangleWins;
reg [6:0]circleWins;
reg [6:0] draws;
reg [99:0]temp;
reg [6:0] firstSquareTriangle;
reg [6:0] secondSquareTriangle;
reg [6:0] firstSquareCircle;
reg [6:0] secondSquareCircle;

localparam
WINDW_EMPTY				= 0,
BOARD_EMPTY 			= 1,
BOARD_REDFIL 			= 2,
BOARD_TRIANG 			= 3,
BOARD_TRIANG45 		= 4,
BOARD_TRIANG90 		= 5,
BOARD_TRIANG135 		= 6,
BOARD_TRIANG180 		= 7,
BOARD_CIRCLE 			= 8,
BOARD_CIRCLE45 		= 9,
BOARD_CIRCLE90 		= 10,
BOARD_CIRCLE135 		= 11,
BOARD_CIRCLE180 		= 12,
TEXT_0               = 89,
TEXT_1               = 90,
TEXT_2               = 91,
TEXT_3               = 92,
TEXT_4               = 93,
TEXT_5               = 94,
TEXT_6               = 95,
TEXT_7               = 96,
TEXT_8               = 97,
TEXT_9               = 98,
TEXT_A               = 99,
TEXT_B               = 100,
TEXT_C               = 101,
TEXT_D               = 102,
TEXT_E               = 103,
TEXT_F               = 104,
TEXT_G               = 105,
TEXT_H               = 106,
TEXT_I               = 107,
TEXT_J               = 108,
TEXT_TRI_WON_MSG_0   = 71,
TEXT_TRI_WON_MSG_1   = 72,
TEXT_TRI_WON_MSG_2   = 73,
TEXT_TRI_WON_MSG_3   = 74,
TEXT_TRI_WON_MSG_4   = 75,
TEXT_TRI_WON_MSG_5   = 76,
TEXT_TRI_WON_MSG_6   = 77,
TEXT_TRI_WON_MSG_7   = 78,
TEXT_TRI_WON_MSG_8   = 79,
TEXT_CIRC_WON_MSG_0  = 80,
TEXT_CIRC_WON_MSG_1  = 81,
TEXT_CIRC_WON_MSG_2  = 82,
TEXT_CIRC_WON_MSG_3  = 83,
TEXT_CIRC_WON_MSG_4  = 84,
TEXT_CIRC_WON_MSG_5  = 85,
TEXT_CIRC_WON_MSG_6  = 86,
TEXT_CIRC_WON_MSG_7  = 87,
TEXT_CIRC_WON_MSG_8  = 88,
TURN_EMPTY_TRI_LU 	= 33,
TURN_EMPTY_TRI_RU 	= 34,
TURN_EMPTY_TRI_LD 	= 35,
TURN_EMPTY_TRI_RD 	= 36,
TURN_FILLED_TRI_LU 	= 37,
TURN_FILLED_TRI_RU 	= 38,
TURN_FILLED_TRI_LD 	= 39,
TURN_FILLED_TRI_RD 	= 40,
TURN_EMPTY_CIRC_LU 	= 41,
TURN_EMPTY_CIRC_RU 	= 42,
TURN_EMPTY_CIRC_LD 	= 43,
TURN_EMPTY_CIRC_RD 	= 44,
TURN_FILLED_CIRC_LU 	= 45,
TURN_FILLED_CIRC_RU 	= 46,
TURN_FILLED_CIRC_LD 	= 47,
TURN_FILLED_CIRC_RD 	= 48;

countTime
#(	.CLK_INPUT_FREQ(CLK_FREQ),
	.WAIT_FOR_SECS(10)
)
count1
(
	.clk_i(clk),
	.start_count_i(startCount),
	.count_done_o(countDone)
);

initial begin
	isFinished=0;
	whosTurn=0;
	turnNumber=1;
	isValidCounter=0;
	startCount=0;
	lastZeroButton=1;
	lastOneButton=1;
	userAdressLine=0;
	userAdressColumn=0;
	triangleWins=0;
	circleWins=0;
	draws=0;
	i=0;
	j=0;
	boardCircle=0;
	boardTriangle=0;
	boardSquare=0;
	temp=0;
end

always @(posedge clk)
begin
	case(STATE)
	S_GAME_LOGIC: begin
	
		if(zeroButton<lastZeroButton&&isFinished==0) begin //if zero button is pressed
			if(isValidCounter<4) //first 4 input detects the line index
				userAdressLine[isValidCounter]=0;
			else //last 4 input detects the column index
				userAdressColumn[isValidCounter-4]=0;
			
			isValidCounter=isValidCounter+1;
			
		end 
		else if(oneButton<lastOneButton&&isFinished==0) begin //if one button is pressed
			if(isValidCounter<4)
				userAdressLine[isValidCounter]=1;
			else
				userAdressColumn[isValidCounter-4]=1;
			
			isValidCounter=isValidCounter+1;
			
		end 
		else if(activityButton<lastActivityButton) begin //if the activity button is pressed (we need to locate the triangle or the circle)
			if(isValidCounter==8&& userAdressColumn<10 && userAdressLine<10 &&boardTriangle[10*userAdressLine+userAdressColumn]==0&&boardCircle[10*userAdressLine+userAdressColumn]==0 && boardSquare[10*userAdressLine+userAdressColumn]==0&&isFinished==0) begin
				STATE=S_WRITE_DATA;
				if(whosTurn==0) begin
					myIndex=10*userAdressLine+userAdressColumn;
					boardTriangle[10*userAdressLine+userAdressColumn]=1; //locate the triangle if whosTurn variable is 0
					write_addr[i]=20*(userAdressLine)+25+userAdressColumn;
					data[i]=BOARD_TRIANG;
					i=i+1;
					write_addr[i]=238;
					data[i]=userAdressLine+89;
					i=i+1;
					write_addr[i]=239;
					data[i]=userAdressColumn+99;
					i=i+1;

					whosTurn=~whosTurn;
					isValidCounter=0; //make zero for the next turn
					userAdressLine=0;
					userAdressColumn=0;
					
					//save the first and second activities of the players to place the squares on them at the 6th and 12th turns
					if(turnNumber==1)
						firstSquareTriangle=myIndex;
					else if(turnNumber==2)
						firstSquareTriangle=myIndex;
					else if(turnNumber==3)
						secondSquareTriangle=myIndex;
					else if(turnNumber==4)
						secondSquareTriangle=myIndex;
					
					if(turnNumber==11||turnNumber==12) begin
						boardSquare[firstSquareTriangle]=1;
						boardTriangle[firstSquareTriangle]=0;
						write_addr[i]=20*(firstSquareTriangle/10)+25+(firstSquareTriangle%10);
						data[i]=BOARD_REDFIL;
						i=i+1;
					end 
					else if(turnNumber==23||turnNumber==24) begin
						boardSquare[secondSquareTriangle]=1;
						boardTriangle[secondSquareTriangle]=0;
						write_addr[i]=20*(secondSquareTriangle/10)+25+(secondSquareTriangle%10);
						data[i]=BOARD_REDFIL;
						i=i+1;
					end
					
					turnNumber=turnNumber+1;
					activityTriangle=activityTriangle+1;
					data[i]=activityTriangle%10+89;
					write_addr[i]=225;
					i=i+1;
					data[i]=activityTriangle/10+89;
					write_addr[i]=224;
					i=i+1;

					//control if the triangle player wins after her/his activity	
					if(myIndex+33<100 && boardTriangle[myIndex+11]==1 && boardTriangle[myIndex+22]==1 &&boardTriangle[myIndex+33]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex+11)/10)+25+((myIndex+11)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex+22)/10)+25+((myIndex+22)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex+33)/10)+25+((myIndex+33)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						
					end 
					else if(myIndex>32 && boardTriangle[myIndex-11]==1 && boardTriangle[myIndex-22]==1 &&boardTriangle[myIndex-33]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex-11)/10)+25+((myIndex-11)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex-22)/10)+25+((myIndex-22)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex-33)/10)+25+((myIndex-33)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						
					end 
					else if(myIndex>26 &&boardTriangle[myIndex-9]==1 && boardTriangle[myIndex-18]==1 &&boardTriangle[myIndex-27]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex-9)/10)+25+((myIndex-9)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex-18)/10)+25+((myIndex-18)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex-27)/10)+25+((myIndex-27)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						
					end 
					else if(myIndex+27<100 && boardTriangle[myIndex+9]==1 && boardTriangle[myIndex+18]==1 &&boardTriangle[myIndex+27]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex+9)/10)+25+((myIndex+9)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex+18)/10)+25+((myIndex+18)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex+27)/10)+25+((myIndex+27)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						
					end 
					else if(myIndex>2 && boardTriangle[myIndex-1]==1 && boardTriangle[myIndex-2]==1 &&boardTriangle[myIndex-3]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex-1)/10)+25+((myIndex-1)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex-2)/10)+25+((myIndex-2)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex-3)/10)+25+((myIndex-3)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						
					end 
					else if(myIndex+3<100 && boardTriangle[myIndex+1]==1 && boardTriangle[myIndex+2]==1 &&boardTriangle[myIndex+3]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex+1)/10)+25+((myIndex+1)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex+2)/10)+25+((myIndex+2)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex+3)/10)+25+((myIndex+3)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						
					end 
					else if(myIndex>29 && boardTriangle[myIndex-10]==1 && boardTriangle[myIndex-20]==1 &&boardTriangle[myIndex-30]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-10)/10)+25+((myIndex-10)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-20)/10)+25+((myIndex-20)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-30)/10)+25+((myIndex-30)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						
					end 
					else if(myIndex+30<100 && boardTriangle[myIndex+10]==1 && boardTriangle[myIndex+20]==1 &&boardTriangle[myIndex+30]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex+10)/10)+25+((myIndex+10)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex+20)/10)+25+((myIndex+20)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex+30)/10)+25+((myIndex+30)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						
					end 
					else if(myIndex+22<100 && myIndex>10 && boardTriangle[myIndex-11]==1 && boardTriangle[myIndex+11]==1 &&boardTriangle[myIndex+22]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex-11)/10)+25+((myIndex-11)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex+11)/10)+25+((myIndex+11)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex+22)/10)+25+((myIndex+22)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						
					end 
					else if(myIndex+27<100 && myIndex>8 && boardTriangle[myIndex-9]==1 && boardTriangle[myIndex+9]==1 &&boardTriangle[myIndex+18]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex-9)/10)+25+((myIndex-9)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex+9)/10)+25+((myIndex+9)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex+18)/10)+25+((myIndex+18)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						
					end 
					else if(myIndex+9<100 && myIndex>17 && boardTriangle[myIndex-9]==1 && boardTriangle[myIndex-18]==1 &&boardTriangle[myIndex+9]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex-9)/10)+25+((myIndex-9)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex+9)/10)+25+((myIndex+9)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						write_addr[i]=20*((myIndex-18)/10)+25+((myIndex-18)%10);
						data[i]=BOARD_TRIANG45;
						i=i+1;
						
					end 
					else if(myIndex+11<100 && myIndex>21 && boardTriangle[myIndex-11]==1 && boardTriangle[myIndex-22]==1 &&boardTriangle[myIndex+11]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex-11)/10)+25+((myIndex-11)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex+11)/10)+25+((myIndex+11)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						write_addr[i]=20*((myIndex-22)/10)+25+((myIndex-22)%10);
						data[i]=BOARD_TRIANG135;
						i=i+1;
						
					end 
					else if(myIndex+2<100 && myIndex>0 && boardTriangle[myIndex-1]==1 && boardTriangle[myIndex+1]==1 &&boardTriangle[myIndex+2]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex-1)/10)+25+((myIndex-1)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex+1)/10)+25+((myIndex+1)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex+2)/10)+25+((myIndex+2)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						
					end 
					else if(myIndex+1<100 && myIndex>1 && boardTriangle[myIndex-2]==1 && boardTriangle[myIndex-1]==1 &&boardTriangle[myIndex+1]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex-1)/10)+25+((myIndex-1)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex+1)/10)+25+((myIndex+1)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						write_addr[i]=20*((myIndex-2)/10)+25+((myIndex-2)%10);
						data[i]=BOARD_TRIANG180;
						i=i+1;
						
					end 
					else if(myIndex+10<100 && myIndex>19 && boardTriangle[myIndex-10]==1 && boardTriangle[myIndex-20]==1 &&boardTriangle[myIndex+10]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-10)/10)+25+((myIndex-10)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex+10)/10)+25+((myIndex+10)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-20)/10)+25+((myIndex-20)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						
					end 
					else if(myIndex+20<100 && myIndex>9 && boardTriangle[myIndex-10]==1 && boardTriangle[myIndex+10]==1 &&boardTriangle[myIndex+20]==1) begin
						isFinished=1;
						lastWinner=0;
						triangleWins=triangleWins+1;
						data[i]=triangleWins%10+89;
						write_addr[i]=230;
						i=i+1;
						data[i]=triangleWins/10+89;
						write_addr[i]=229;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-10)/10)+25+((myIndex-10)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex+10)/10)+25+((myIndex+10)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						write_addr[i]=20*((myIndex-20)/10)+25+((myIndex-20)%10);
						data[i]=BOARD_TRIANG90;
						i=i+1;
						
					end 
					else if(turnNumber==26) begin
						isFinished=1;
						draws=draws+1;
						isDraw=1;
					end
					
					// DETERMINING TURN VGA
					if(isFinished==0 || (isDraw==1 && lastWinner==1)) begin
						//TURN CHANGE TO CIRCLE VGA
						data[i]=TURN_EMPTY_TRI_LU;
						write_addr[i]=81;
						i=i+1;
						data[i]=TURN_EMPTY_TRI_RU;
						write_addr[i]=82;
						i=i+1;
						data[i]=TURN_EMPTY_TRI_LD;
						write_addr[i]=101;
						i=i+1;
						data[i]=TURN_EMPTY_TRI_RD;
						write_addr[i]=102;
						i=i+1;
						
						data[i]=TURN_FILLED_CIRC_LU;
						write_addr[i]=96;
						i=i+1;
						data[i]=TURN_FILLED_CIRC_RU;
						write_addr[i]=97;
						i=i+1;
						data[i]=TURN_FILLED_CIRC_LD;
						write_addr[i]=116;
						i=i+1;
						data[i]=TURN_FILLED_CIRC_RD;
						write_addr[i]=117;
						i=i+1;
					end
				end
				else begin
					myIndex=10*userAdressLine+userAdressColumn;
					boardCircle[10*userAdressLine+userAdressColumn]=1; //locate the circle if whosTurn variable is 1
					
					write_addr[i]=20*(userAdressLine)+25+userAdressColumn;
					data[i]=BOARD_CIRCLE;
					i=i+1;
					write_addr[i]=258;
					data[i]=userAdressLine+89;
					i=i+1;
					write_addr[i]=259;
					data[i]=userAdressColumn+99;
					i=i+1;

					whosTurn=~whosTurn;
					isValidCounter=0;
					userAdressLine=0;
					userAdressColumn=0;
					
					//save the first and second activities of the players to place the squares on them at the 6th and 12th turns
					if(turnNumber==1)
						firstSquareCircle=myIndex;
					if(turnNumber==2)
						firstSquareCircle=myIndex;
					if(turnNumber==3)
						secondSquareCircle=myIndex;
					if(turnNumber==4)
						secondSquareCircle=myIndex;
					
					if(turnNumber==11||turnNumber==12) begin
						boardSquare[firstSquareCircle]=1;
						boardCircle[firstSquareCircle]=0;
						write_addr[i]=20*(firstSquareCircle/10)+25+(firstSquareCircle%10);
						data[i]=BOARD_REDFIL;
						i=i+1;
					end
					else if(turnNumber==23||turnNumber==24) begin
						boardSquare[secondSquareCircle]=1;
						boardCircle[secondSquareCircle]=0;
						write_addr[i]=20*(secondSquareCircle/10)+25+(secondSquareCircle%10);
						data[i]=BOARD_REDFIL;
						i=i+1;
					end
					
					turnNumber=turnNumber+1;
					activityCircle=activityCircle+1;
					data[i]=activityCircle%10+89;
					write_addr[i]=245;
					i=i+1;
					data[i]=activityCircle/10+89;
					write_addr[i]=244;
					i=i+1;
						
					//control if the circle wins after her/his activity
					if(myIndex+33<100 && boardCircle[myIndex+11]==1 && boardCircle[myIndex+22]==1 &&boardCircle[myIndex+33]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex+11)/10)+25+((myIndex+11)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex+22)/10)+25+((myIndex+22)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex+33)/10)+25+((myIndex+33)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						
					end 
					else if(myIndex>32 && boardCircle[myIndex-11]==1 && boardCircle[myIndex-22]==1 &&boardCircle[myIndex-33]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex-11)/10)+25+((myIndex-11)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex-22)/10)+25+((myIndex-22)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex-33)/10)+25+((myIndex-33)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						
					end 
					else if(myIndex>26 &&boardCircle[myIndex-9]==1 && boardCircle[myIndex-18]==1 &&boardCircle[myIndex-27]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex-9)/10)+25+((myIndex-9)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex-18)/10)+25+((myIndex-18)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex-27)/10)+25+((myIndex-27)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						
					end 
					else if(myIndex+27<100 && boardCircle[myIndex+9]==1 && boardCircle[myIndex+18]==1 &&boardCircle[myIndex+27]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex+9)/10)+25+((myIndex+9)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex+18)/10)+25+((myIndex+18)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex+27)/10)+25+((myIndex+27)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						
					end 
					else if(myIndex>2 && boardCircle[myIndex-1]==1 && boardCircle[myIndex-2]==1 &&boardCircle[myIndex-3]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex-1)/10)+25+((myIndex-1)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex-2)/10)+25+((myIndex-2)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex-3)/10)+25+((myIndex-3)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						
					end 
					else if(myIndex+3<100 && boardCircle[myIndex+1]==1 && boardCircle[myIndex+2]==1 &&boardCircle[myIndex+3]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex+1)/10)+25+((myIndex+1)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex+2)/10)+25+((myIndex+2)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex+3)/10)+25+((myIndex+3)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						
					end 
					else if(myIndex>29 && boardCircle[myIndex-10]==1 && boardCircle[myIndex-20]==1 &&boardCircle[myIndex-30]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex-10)/10)+25+((myIndex-10)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex-20)/10)+25+((myIndex-20)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex-30)/10)+25+((myIndex-30)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						
					end 
					else if(myIndex+30<100 && boardCircle[myIndex+10]==1 && boardCircle[myIndex+20]==1 &&boardCircle[myIndex+30]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex+10)/10)+25+((myIndex+10)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex+20)/10)+25+((myIndex+20)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex+30)/10)+25+((myIndex+30)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						
					end 
					else if(myIndex+22<100 && myIndex>10 && boardCircle[myIndex-11]==1 && boardCircle[myIndex+11]==1 &&boardCircle[myIndex+22]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex-11)/10)+25+((myIndex-11)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex+11)/10)+25+((myIndex+11)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex+22)/10)+25+((myIndex+22)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						
					end 
					else if(myIndex+27<100 && myIndex>8 && boardCircle[myIndex-9]==1 && boardCircle[myIndex+9]==1 &&boardCircle[myIndex+18]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex-9)/10)+25+((myIndex-9)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex+9)/10)+25+((myIndex+9)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex+18)/10)+25+((myIndex+18)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						
					end 
					else if(myIndex+9<100 && myIndex>17 && boardCircle[myIndex-9]==1 && boardCircle[myIndex-18]==1 &&boardCircle[myIndex+9]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex-9)/10)+25+((myIndex-9)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex+9)/10)+25+((myIndex+9)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						write_addr[i]=20*((myIndex-18)/10)+25+((myIndex-18)%10);
						data[i]=BOARD_CIRCLE45;
						i=i+1;
						
					end 
					else if(myIndex+11<100 && myIndex>21 && boardCircle[myIndex-11]==1 && boardCircle[myIndex-22]==1 &&boardCircle[myIndex+11]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex-11)/10)+25+((myIndex-11)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex+11)/10)+25+((myIndex+11)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						write_addr[i]=20*((myIndex-22)/10)+25+((myIndex-22)%10);
						data[i]=BOARD_CIRCLE135;
						i=i+1;
						
					end 
					else if(myIndex+2<100 && myIndex>0 && boardCircle[myIndex-1]==1 && boardCircle[myIndex+1]==1 &&boardCircle[myIndex+2]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex-1)/10)+25+((myIndex-1)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex+1)/10)+25+((myIndex+1)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex+2)/10)+25+((myIndex+2)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						
					end 
					else if(myIndex+1<100 && myIndex>1 && boardCircle[myIndex-2]==1 && boardCircle[myIndex-1]==1 &&boardCircle[myIndex+1]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex-1)/10)+25+((myIndex-1)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex+1)/10)+25+((myIndex+1)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						write_addr[i]=20*((myIndex-2)/10)+25+((myIndex-2)%10);
						data[i]=BOARD_CIRCLE180;
						i=i+1;
						
					end 
					else if(myIndex+10<100 && myIndex>19 && boardCircle[myIndex-10]==1 && boardCircle[myIndex-20]==1 &&boardCircle[myIndex+10]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex-10)/10)+25+((myIndex-10)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex+10)/10)+25+((myIndex+10)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex-20)/10)+25+((myIndex-20)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						
					end 
					else if(myIndex+20<100 && myIndex>9 && boardCircle[myIndex-10]==1 && boardCircle[myIndex+10]==1 &&boardCircle[myIndex+20]==1) begin
						isFinished=1;
						lastWinner=1;
						circleWins=circleWins+1;
						data[i]=circleWins%10+89;
						write_addr[i]=250;
						i=i+1;
						data[i]=circleWins/10+89;
						write_addr[i]=249;
						i=i+1;
						
						write_addr[i]=20*((myIndex)/10)+25+((myIndex)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex-10)/10)+25+((myIndex-10)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex+10)/10)+25+((myIndex+10)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						write_addr[i]=20*((myIndex+20)/10)+25+((myIndex+20)%10);
						data[i]=BOARD_CIRCLE90;
						i=i+1;
						
					end 
					else if(turnNumber==26) begin
						isFinished=1;
						draws=draws+1;
						isDraw=1;
					end
					
					// DETERMINING TURN VGA
					if(isFinished==0 || (isDraw==1 && lastWinner==0)) begin
						//TURN CHANGE TO TRIANGLE VGA
						data[i]=TURN_FILLED_TRI_LU;
						write_addr[i]=81;
						i=i+1;
						data[i]=TURN_FILLED_TRI_RU;
						write_addr[i]=82;
						i=i+1;
						data[i]=TURN_FILLED_TRI_LD;
						write_addr[i]=101;
						i=i+1;
						data[i]=TURN_FILLED_TRI_RD;
						write_addr[i]=102;
						i=i+1;
						
						data[i]=TURN_EMPTY_CIRC_LU;
						write_addr[i]=96;
						i=i+1;
						data[i]=TURN_EMPTY_CIRC_RU;
						write_addr[i]=97;
						i=i+1;
						data[i]=TURN_EMPTY_CIRC_LD;
						write_addr[i]=116;
						i=i+1;
						data[i]=TURN_EMPTY_CIRC_RD;
						write_addr[i]=117;
						i=i+1;
					end
				end
			end
			else if(isValidCounter!=8 || userAdressColumn>9 || userAdressLine>9 || boardTriangle[10*userAdressLine+userAdressColumn]==1 || boardCircle[10*userAdressLine+userAdressColumn]==1 || boardSquare[10*userAdressLine+userAdressColumn]==1) begin
					isValidCounter=0;
					userAdressLine=0;
					userAdressColumn=0;
			end
		end
		if(isFinished) begin
				startCount=1;
				if(countDone==1) begin
					startCount=0;
					isFinished=0;
					whosTurn=lastWinner;
					turnNumber=1;
					isValidCounter=0;
					lastZeroButton=1; // 1 LE BUNLARI
					lastOneButton=1; // 1 LE BUNLARI
					userAdressLine=0;
					userAdressColumn=0;
					
					boardCircle=0;
					boardTriangle=0;
					boardSquare=0;
					activityCircle=0;
					activityTriangle=0;
					temp=0;
					isDraw=0;
					
					STATE=S_RAM_RESET;
					write_addr_o=0;
					data_o=WINDW_EMPTY;
					we_o = 1;
				end
				else begin
					STATE=S_WRITE_DATA;
					if(lastWinner==0 && isDraw==0) begin
						for (j = 0; j < 9; j = j+1) begin 
						data[i]=TEXT_TRI_WON_MSG_0+j;
						write_addr[i]=290+j;
						i=i+1;
						end
					end
					else if(isDraw==1) begin
						data[i]=102;
						write_addr[i]=290;
						i=i+1;
						data[i]=100;
						write_addr[i]=291;
						i=i+1;
						data[i]=99;
						write_addr[i]=292;
						i=i+1;
						data[i]=104;
						write_addr[i]=293;
						i=i+1;
					end
					else begin
						for (j = 0; j < 9; j = j+1) begin 
						data[i]=TEXT_CIRC_WON_MSG_0+j;
						write_addr[i]=290+j;
						i=i+1;
						end
					end
				end
		end

		
		//save the buttons' last situations for the next cycle
		lastActivityButton=activityButton;
		lastOneButton=oneButton;
		lastZeroButton=zeroButton;
		
		if(STATE == S_WRITE_DATA) begin
			we_o = 1;
			i = 0;
		end
			
		
		end
		
		S_WRITE_DATA: begin
			if(i==QUEUE_SIZE-1) begin
				STATE<=S_GAME_LOGIC;
				we_o<=0;
				i<=0;
			end
			else begin
				we_o<=1;
				data[i]<=0;
				write_addr[i]<=0;
				data_o<=data[i];
				write_addr_o<=write_addr[i];
				i<=i+1;
			end
		end
		
		S_RAM_RESET: begin
			if(RESET_STATE == R_BOARD) begin
				if(row_counter == 10) begin
					if(colm_counter == 9) begin
						RESET_STATE <= R_MOVES;
						row_counter <= 0;
						colm_counter <= 0;
					end
					else begin
						row_counter <= 0;
						colm_counter <= colm_counter + 1;
					end
				end
				else begin
					write_addr_o<=20*row_counter+25+colm_counter;
					data_o <= BOARD_EMPTY;
					row_counter <= row_counter + 1;
				end
			end
			
			if(RESET_STATE == R_MOVES) begin
				if(row_counter == 2) begin
					if(colm_counter == 1) begin
						RESET_STATE <= R_POSIT;
						row_counter <= 0;
						colm_counter <= 0;
					end
					else begin
						row_counter <= 0;
						colm_counter <= colm_counter + 1;
					end
				end
				else begin
					write_addr_o<=20*row_counter+224+colm_counter;
					data_o <= TEXT_0;
					row_counter <= row_counter + 1;
				end
			end
			
			if(RESET_STATE == R_POSIT) begin
				if(row_counter == 2) begin
					if(colm_counter == 1) begin
						RESET_STATE <= R_WON;
						row_counter <= 0;
						colm_counter <= 0;
					end
					else begin
						row_counter <= 0;
						colm_counter <= colm_counter + 1;
					end
				end
				else begin
					write_addr_o<=20*row_counter+238+colm_counter;
					data_o <= WINDW_EMPTY;
					row_counter <= row_counter + 1;
				end
			end
			
			if(RESET_STATE == R_WON) begin
				if(colm_counter == 10) begin
					STATE <= S_GAME_LOGIC;
					RESET_STATE <= R_BOARD;
					we_o <= 0;
					row_counter <= 0;
					colm_counter <= 0;
					write_addr_o <= 0;
					data_o <= WINDW_EMPTY;
				end
				else begin
					write_addr_o<=290+colm_counter;
					data_o <= WINDW_EMPTY;
					colm_counter <= colm_counter + 1;
				end
			end
		end
	endcase
end
endmodule
