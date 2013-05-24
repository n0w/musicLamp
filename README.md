musicLamp
=========

Music synced app to interface with arduino.

musicLamp has two components: hardware and software.

Arduino Uno is the hardware core, loaded with StdFirmata. The electrical wiring is fair simple:

- 6x NPN transistors
- 6x 220 ohms resistors
- 2x RGB LED Strips
- A mess of wires

Schematics are all over the web, it's just PWMing the transistors from a digital pin.

By doing so, you can establish the apparent brightness of each color component (R,G,B) from the led strips.

I started with a single strip, then I added the second strip. No major changes in source code;
just added the right pins to the pin's array in the processing sketch.

Source code is simple too; just upload StdFirmata with Arduino IDE and install processing. 

The processing sketch is a modified version of an instructable i read once, i think. 

Can't really remember, just posting this because somebody asked me too.

[+] Youtube video of musicLamp in action: http://www.youtube.com/watch?v=gY7ZkgfLY2g

[+] Schematic: http://i42.tinypic.com/ay2j4o.png
