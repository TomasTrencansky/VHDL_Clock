# THE CLOCK

![poster](images/poster_temp1.jpg) 

## Team Members :
1. Matej Nachtnebel (responsible for connecting the modules together)
2. Tomáš Trenčanský (responsible for graphical output and organization)
3. John Sergis (responsible for coding modules)
4. Mesk Lashin (responsible for coding modules)

## Descritpion
Our team decided to build not just a clock, but **THE Clock**. We built your typical clock features into it, like a stopwatch, a timer, an alarm, and of course, a digital clock. Our Clock is not using any external peripherals, just the Nexys A7 50-T board and it's built in seven segment display and buttons. 

But what do each of the buttons do? It's quite simple :
1. Left and Right buttons are for changing modes
2. Up and Down buttons are for setting the time
3. Center button is for activating the functions

We also built in the function where if you hold the button for a few the speed of change increases.

## Schematic
![schema](images/shematic_temp1.jpg)
# Individual components
We also used component [Clock enable](https://github.com/tomas-fryza/vhdl-labs/blob/master/solutions/lab5-counter/clock_en.vhd) which was covered in class and therefore won't be shown here

## [Input](https://github.com/TomasTrencansky/VHDL_Clock/blob/main/components/input/Input.vhd)
description which will be written later (propably)

Here be an amazing simulation image (which is being worked on currently)

**Input contains several individual components which are listed below**
### [UD counter](https://github.com/TomasTrencansky/VHDL_Clock/blob/main/components/UD%20counter/UD_counter.vhd)
UD counter is simple synchronous counter which has 5 inputs and one output. You can easily configure range of counting by setting generic value called NBITS. This range is allways 2^NBITS. 

Inputs :
* clk - input for clock signal 
* en - if one enables counting 
* add- if one then every rising edge of clk adds one
* sub- if one then every rising edge of clk adds one

Output :
* count - current number of counter
![UD counter_sim](images/UD_counter_waveform_V3.png)

### [Mode](https://github.com/TomasTrencansky/VHDL_Clock/blob/main/components/Mode/Mode.vhd)
Mode is made of 2 different components which work together to switch betweeen modes of clock after long press of Left or Right buttons. It has 4 inputs and one output.  It is set up to count from 0 to 2, because clock has 3 modes. Duration of needed press is easily adjustable by generic value of Long_press_time ( 1s = 200 000 000 for clock 10 MHz)
Modes:
* Clock & Alarm "00"  (0)
* Stopwatch "01"      (1)
* Timer "10"          (2)

Inputs
* clk = input for clock signal
* en = enables change of mode 
* btnl = input for button left
* btnr = input for button right
Output
* current_mode = outputs 2 bits with value between 0 and 2 

Componets:
* UD_counter - simple use of counter to keep track of mode 
* clock_enable - used for dection of long press

![mode_sim](images/Mode_waveform_V2.png)
![mode_des](images/Mode_design_V1.png)




### [Speed up](https://github.com/TomasTrencansky/VHDL_Clock/blob/main/components/Speed%20up/Speedup.vhd)
Speed up is simple component which with duration of btn input increases number of generated pulses. It has 4 speeds of pluse generation. 
Duration and periods after which it genenrates pulses are easily configurable by generics. It has 3 inputs and sigle output for pulses. 

Inputs
* clk = input for clock signal
* Btn = input signal
* rst = resets speed to frist level

Output
* pulse
![speedup_sim](images/Speedup_waveform.png)

### [Change](https://github.com/TomasTrencansky/VHDL_Clock/blob/main/components/Change/Change.vhd)
Depending on inputs sets right outputs to '1' until they are rest to '0' by rst input. Only one of change outputs (0,1,2) can be '1' at one time.
Coponent change has 5 inputs and 4 outputs. 

Inputs
* clk = input for clock signal
* Input_pulse_1 = input signal
* Input_pulse_2 = input signal
* rst = sets all outputs to '0'
* current_mode= 2bit input signal 

Outputs
* change_0 = changes to '1' if mode is '00' and Input_pulse_1 is '1' 
* change_1 = changes to '1' if mode is '00' and Input_pulse_2 is '1' 
* change_2 = changes to '1' if mode is '10' and Input_pulse_1 is '1' 
* change_active = when one of changes (1,2,3) is '1' change_active is also '1'
![change sim](images/Change_waveform.png)
