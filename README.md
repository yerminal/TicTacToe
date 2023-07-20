# TicTacToe | METU EE314 Term Project
- This is a Tic-Tac-Toe game that can be played with a DE1-SoC board.
- The details about the project are in [TicTacToe_EE314_Project_Report.pdf](https://github.com/yerminal/TicTacToe/blob/main/docs/TicTacToe_EE314_Project_Report.pdf).
## Manual
- You will be using three buttons: logic-0, logic-1, and activity button. ![control_buttons.png](https://github.com/yerminal/TicTacToe/blob/main/docs/control_buttons.png)
- At every turn, the player in turn will enter the coordinates sequentially using the logic-0 and logic-1 buttons. Then, the player
should press the activity button.
- However, the coordinates should be typed in reverse. That is, the enter order is in LSB (least significant bit) to MSB (most significant bit).
- For example, the 5B coordinate corresponds to **1010 1000** instead of **0101 0001**.
### Example
- The triangle player has the turn. If the player wants to place a shape to the 4C coordinate, the player should press the input buttons with the 0010 1100 order.
- Notice that the order for entering a character is reversed so that the fpga reads 0100 0011.
- After pressing the activity button, a triangle will be placed if the 4C box is empty. Now, the circle player does the same.
## Game Screen
![screen_example.png](https://github.com/yerminal/TicTacToe/blob/main/docs/screen_example.png)
