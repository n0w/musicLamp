import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
//Lowest freq ---*         *--highest freq 
int[] ledPins = {5,3,6,10,9,11}; 
int[] lastFired = new int[ledPins.length];


//Sensitivity - shortest possible interval between beats
//minTimeOn   - the minimum time an LED can be on
int sensitivity = 100;
int minTimeOn = 100;

String mode;
String source;

Minim minim;
AudioInput in;
AudioPlayer song;
BeatDetect beat;

//Used to stop flashing if the only signal on the line is random noise
boolean hasInput = false;
float tol = 0.005;

void setup()
{

  mode = "mic";
  source = "";
  
  size(512, 200, P2D);
    
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[0]);
  
  for (int i = 0; i < ledPins.length; i++)
  {
    arduino.pinMode(ledPins[i], Arduino.OUTPUT);
  }
  
  minim = new Minim(this);
  
  in = minim.getLineIn(Minim.STEREO, 2048);
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  beat.setSensitivity(sensitivity);
  
}

void draw()
{
  beat.detect(in.mix); 
  drawWaveForm((AudioSource)in);
  
  if (hasInput)
  { //hasInput is set within drawWaveForm
    for (int i=0; i<ledPins.length; i++)
    {
      if ( beat.isRange( i+1, i+1, 1) )
      {
        arduino.digitalWrite(ledPins[i], Arduino.HIGH);
        lastFired[i] = millis();
      } else 
      {
        if ((millis() - lastFired[i]) > minTimeOn)
        {
          arduino.digitalWrite(ledPins[i], Arduino.LOW);
        }
      }
    } 
  }
} 

//Display the input waveform
//This method sets 'hasInput' - if any sample in the signal has a value
//larger than 'tol,' there is a signal and the lights should flash.
//Otherwise, only noise is present and the lights should stay off.
void drawWaveForm(AudioSource src)
{
  background(0);
  stroke(255);

  hasInput = false;
  
  for(int i = 0; i < src.bufferSize() - 1; i++)
  {
    line(i, 50 + src.left.get(i)*50, i+1, 50 + src.left.get(i+1)*50);
    line(i, 150 + src.right.get(i)*50, i+1, 150 + src.right.get(i+1)*50);
    
    if (!hasInput && (abs(src.left.get(i)) > tol || abs(src.right.get(i)) > tol))
    {
      hasInput = true;
    }
  } 
}

void resetPins(){
  for (int i=0; i<ledPins.length; i++)
  {
    arduino.digitalWrite(ledPins[i], Arduino.LOW);   
  } 
}

void stop()
{
  resetPins();  
  in.close();
    
  minim.stop();
  super.stop();
}
