import processing.video.*;

import oscP5.*;

import hypermedia.net.*;

import processing.sound.*;


Fluid fluid;
OscP5 oscP5;
UDP udp;

// Oscillator setup
TriOsc oscillator;
Env env;

float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.4;


String type;
int channel;
int note;
float vel;
int duration;


// Scriabin color values;
float[] note2hue = {0,270,60,340,190,355,230,40,280,130,350,210};
float[] note2sat = {100,60,100,60,40,100,45,100,34,75,50,70};
float[] note2bright = {100,100,100,100,100,60,100,100,100,80,80,100};
float[] note2angle = {PI/2, 8*PI/6, PI/6, PI, 11*PI/6, 4*PI/6, 9*PI/6, 2*PI/6, 7*PI/6, 0, 5*PI/6, 10*PI/6}; 

// Camera setup
Capture cam;
int index_cam=0;

// Scale of grid
int SCALE = 12;
int N1 = 60;
int N2 = 60;

boolean camOn;
float radio;
float angle_offset;
float diffusion;
float viscosity;

void settings() {
  //size(720,880); 
  //N1 = width/SCALE; //<>//
  //N2 = height/SCALE;
  
  fullScreen();
  N1 = displayWidth/SCALE;
  N2 = displayHeight/SCALE;
}

void setup() {
  
  // communication init
  oscP5 = new OscP5(this,7771);
  udp = new UDP(this, 7772);
  udp.listen(true);
  
  // oscillator init
  oscillator = new TriOsc(this);
  env  = new Env(this); 
 
  camOn = true;
  cam = new Capture(this,width,height);
  cam.start();
  
  frameRate(60);
  
  
  // Fluid init
  fluid = new Fluid(0.1,1e-14,1e-10);
  colorMode(HSB,360,100,100);
  
  angle_offset = 0;
  radio = 0.3;
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  if(camOn) {
    image(cam, 0, 0,width, height);
  }
  else{
    background(0,0,0);
  }
  
  // draw frame
  
  int marco = 30; //frame widht
  
  fill(255,0,100);
  quad(0, 0, marco/2, marco/2, marco/2, height - marco/2, 0, height);
  quad(0, 0, width, 0, width - marco/2, marco/2, marco/2, marco/2);
  quad(width, height, 0, height, marco/2, height - marco/2, width - marco/2, height - marco/2);
  quad(width, 0, width, height, width - marco/2, height - marco/2, width - marco/2, marco/2);
  
  fill(255,0,70);
  quad(marco/2, marco/2, 2*marco, 2*marco, 2*marco, height - 2*marco, marco/2, height - marco/2);
  fill(255,0,85);
  quad(marco/2, marco/2, width - marco/2, marco/2, width - 2*marco, 2*marco, 2*marco, 2*marco);
  quad(width - marco/2, height - marco/2, marco/2, height - marco/2, 2*marco, height - 2*marco, width - 2*marco, height - 2*marco);
  fill(255,0,80);
  quad(width - marco/2, marco/2, width - marco/2, height - marco/2, width - 2*marco, height - 2*marco, width - 2*marco, 2*marco);
  
  
  // get position in the canvas to insert fluid, this is taken from note value
  PVector c = PVector.fromAngle(note2angle[note % 12] + radians(angle_offset));
  int cx = int((0.5 + radio * c.x)*width/SCALE);
  int cy = int((0.5 - radio * c.y)*height/SCALE);
  float[]  amount = {vel, note2sat[note % 12],note2hue[note % 12],note2bright[note % 12]};
  PVector v = PVector.fromAngle(note2angle[note % 12]  + radians(angle_offset));
  

  
  // insert fluid
  for (int i = -1; i <= 1; i++){
    for (int j = -1; j <= 1; j++){
      fluid.setNote(cx+i,cy+j,amount);
      fluid.addVelocity(cx+i, cy+j, i*j*v.x, i*-j*v.y);
    }
  }
  //println(note2angle[note % 12]);

  // evolve fluid
  fluid.step();
  fluid.renderD(); //<>//
  fluid.fadeD();
  
}

float midiToFreq(int midiNote) {
  return 440 * pow(2, (midiNote - 69) / 12.0);
}

float velocityToAmplitude(int velocity) {
  return map(velocity, 0, 127, 0.0, 1.0);
}


void oscEvent(OscMessage theOscMessage) {
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
  
  if (theOscMessage.checkAddrPattern("/on"))
  {
    vel = theOscMessage.get(0).floatValue();
    note = theOscMessage.get(1).intValue();
    //println(theOscMessage.port());
    
  }
  
  if (theOscMessage.checkAddrPattern("/off"))
  {
    note = theOscMessage.get(0).intValue();
    //notes[pc].isFinished=true;
    //println(pc);
    }
  if (theOscMessage.checkAddrPattern("/camON"))
  {
    camOn = theOscMessage.get(0).floatValue() == 1;
    print(camOn);
    //notes[pc].isFinished=true;
    //println(pc);
    }
  if (theOscMessage.checkAddrPattern("/radio"))
  {
    radio = theOscMessage.get(0).floatValue();
    
    //notes[pc].isFinished=true;
    //println(pc);
    }
   
  if (theOscMessage.checkAddrPattern("/angle_offset"))
  {
    angle_offset = theOscMessage.get(0).floatValue();
    
    //notes[pc].isFinished=true;
    //println(pc);
    }
    
  if (theOscMessage.checkAddrPattern("/viscosity"))
  {
    viscosity = theOscMessage.get(0).floatValue();
    
    //notes[pc].isFinished=true;
    //println(pc);
    }
    
  if (theOscMessage.checkAddrPattern("/diffusion"))
  {
    diffusion = theOscMessage.get(0).floatValue();
    
    //notes[pc].isFinished=true;
    //println(pc);
    }
    
}

void receive(byte[] data, String ip, int port){
  data = subset(data, 0 ,data.length);
  String message = new String(data);
  String[] substrings = split(message, '/');
  
  // Extracting message
  type = substrings[2];
  channel = int(substrings[3]);
  note = int(substrings[4]);
  vel = int(substrings[5]);
  duration = int(substrings[6]);
  
  if (type.equals("note_on")){
    oscillator.freq(midiToFreq(note));
    oscillator.amp(velocityToAmplitude(int(vel)));
    oscillator.play();
    delay(duration);
    oscillator.stop();
  }
  
   //<>//
}
