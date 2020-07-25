# IMPLEMENTATION OF THE PONG GAME USING AN FPGA 

## Hardware design

The objective of this project is to program a two-player pong game on a FPGA using the VHDL language. The FPGA used is a Cyclone IV E : EP4CE6E22C8 from Altera. The large amount of input/output pin of this FPGA allows to deal with many leds without using external componenents likes decoders.

A matrix (4x8) of 32 leds is used as a visual platforme. Each anode is connected to an output pin and the cathodes are connected to the ground with a series resistor. The upper leds line is dedicated to player 2 and lower leds line is dedicated to player 1. Each player is free to move an horizontal bar using two leds. For this purpose, two press button are dedicated to each player in order to move left or right their bars. And a reset button is present in case one player desires to restart the game. 

We make use of 32 pins for the output (leds) and 5 pins for the inputs + 1 pin dedicated to the 50 MHz clock. Total of 38 pins.  

<p align="center">
  <img src="https://i.imgur.com/ZYI4AnZ.gif" width="500" height="700"/>
</p>

<p align="center">
  <img src="https://i.imgur.com/s4QrCZY.png" width="800" height="700"/>
</p>


## Software design using VHDL

Réaliser du schéma état avec différentes couleurs + numéros.
<p align="center">
  <img src="https://i.imgur.com/tM5dVSk.png" width="200" height="400"/>
</p>

A state machine is used to implement the pong game. Each trajectory of the ball is predicted using 24 states (assiociated to the 24 leds). The 8 remaining leds are used to move the lower and upper bars. If the ball hits a player bar : different directions of ball trajectories are possible using a random counter. Otherwise, the other player looses and all the 24 leds are blinking (the state machine switches between states "Loose1" and "Loose2" and vice-versa.)
<p align="center">
  <img src="https://i.imgur.com/EvrHNw4.png" width="500" height="500"/>
</p>
Some processes are used in the VHDL code : 

- 2 processes are dedicated to manage the press buttons of players 1 and 2. This will allow to manage the leds ranging from 25 to 32.
- 1 process to generate a low frequency clock of 1 Hz from the 50 MHz clock.
- 1 process to generate randomness using cnt_rnd that takes 3 values : 0, 1 and 2. It allows to determinate the trajectory of the ball.
- 1 process to update current state(etat_present) to next_state (etat_futur). This process is clocked by a 1 Hz clock
- 1 process to update the next state (etat_futur).
- 1 process that adjusts the output (leds) according to the current state. This will allow to manage the leds from 1 to 24.

## RTL decription







