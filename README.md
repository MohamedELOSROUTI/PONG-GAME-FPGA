# IMPLEMENTATION OF THE PONG GAME USING AN FPGA 

video link : https://www.youtube.com/watch?v=U0qfb-gVDw8

## Hardware design

The objective of this project is to program a two-players pong game on a FPGA using the VHDL language. The FPGA used is a Cyclone IV E : EP4CE6E22C8 from Altera. The large amount of input/output pins of this FPGA allows dealing with many leds without using external componenents likes decoders.

A matrix (4x8) of 32 leds is used as a visual platform. Each anode is connected to an output pin and the cathodes are connected to the ground with a series resistor. The upper leds line is dedicated to player 2 and lower leds line is dedicated to player 1. Each player is free to move a horizontal bar using two leds. For this purpose, two press button are dedicated to each player in order to move left or right their bars. And a reset button is present in case one player desires to restart the game. 

We make use of 32 pins for the output (leds) and 5 pins for the inputs + 1 pin dedicated to the 50 MHz clock. Total of 38 pins.  

### Animated representation
<p align="center">
  <img src="https://i.imgur.com/ZYI4AnZ.gif" width="500" height="700"/>
</p>

### Hardware implementation

<p align="center">
  <img src="https://i.imgur.com/s4QrCZY.png" width="800" height="700"/>
</p>


## Software design using VHDL

<p align="center">
  <img src="https://i.imgur.com/tM5dVSk.png" width="200" height="400"/>
</p>

A finite state machine can be used to implement the pong game. Each trajectory of the ball is predicted using 24 states (associated to the 24 leds). The 8 remaining leds are used to move the lower and upper bars. If the ball hits a player bar : different directions of ball trajectories are possible using a random counter. Otherwise, the other player loses and all the 24 leds are blinking (the state machine switches between states "Loose1" and "Loose2" and vice-versa.)

<p align="center">
  <img src="https://i.imgur.com/EvrHNw4.png" width="500" height="500"/>
</p>

Here's a Mealy Machine that models one given trajectory of the ball : 

<p align="center">
  <img src="https://i.imgur.com/zcu7m9B.png" width="900" height="250"/>
</p>


Some processes are used in the VHDL code : 

- 2 processes are dedicated to manage the press buttons of players 1 and 2. This will allow updating the position of the leds ranging from 25 to 32. Using push often generates many false triggers when pressed. We'll see later how can deal with switch bounce.
- 1 process to generate a low frequency clock of 1 Hz from the 50 MHz clock.
- 1 process to generate randomness using cnt_rnd. It allows to determinate the trajectory of the ball once it "hits" a yellow led.
- 1 process to update current state to next_state . This process is clocked by a 1 Hz clock
- 1 process to update the next state 
- 1 process that adjusts the output (leds) according to the current state. This will allow managing the leds from 1 to 24.


## RTL decription


See RTL 1.pdf and RTL 2. pdf to view the RTL representations.

## Managing the push buttons


<p align="center">
  <img src="https://i.imgur.com/AwwOMj3.jpg" width="100" height="100"/>
</p>

When we press a push button, there is a switch bounce problem. Instead of generating a single logical '1' value. It generates many transitions '1', '0', '1', ... during few microseconds before reching the final state '1'. 

Here's a plot of what happens when we press the push button :

<p align="center">
  <img src="https://i.imgur.com/4JAfriT.png" width="600" height="500"/>
</p>

This problem may affect the way we move the yellow leds under and above the matrix leds. One single push to the right/left press buttons may result in lighting up the extremities leds skipping intermediate leds. 


How to deal with a bounce switch ? There are two solutions : 

- Hardware approach : use a capacitor in series to make a RC filter. This allows removing the oscilliations but the high state is reached after a constant time proportional to R*C.

<p align="center">
  <img src="https://i.imgur.com/U8Ey24f.png"  />
</p>

Here's the effect of using a capacitor : the oscilliations are removed
<p align="center">
  <img src="https://i.imgur.com/Q33EDYZ.png width="600" height="500" "  />
</p>

For more information, have a look to this intersting article : https://www.allaboutcircuits.com/technical-articles/switch-bounce-how-to-deal-with-it/

- Software approach : make use of a 'low frequency' clock that settles the time at which a high value (logical '1') is read. This solution is chosen for this project. Each 120 ms (rising_edge), we check the value of the input pin, if it is set to '1', then move the yellow led one step further. 

## End

If you have any advice on how to improve the code, feel free to contact me.

If you want to go further, you can add a process that speeds up the red led each time it hits a yellow led in order to increase the complexity of the game :+1: .
