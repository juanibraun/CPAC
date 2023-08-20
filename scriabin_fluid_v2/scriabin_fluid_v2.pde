import processing.video.*;

import oscP5.*;


Fluid fluid;
OscP5 oscP5;
float vel;
int note;
//int[] pixtwo = new int [width*height];
float[] note2hue = {0,287,60,7,195,3,271,40,284,120,206,240};
float[] note2sat = {100,31,100,23,100,61,81,100,51,100,19,100};
float[] note2bright = {100,74,100,100,100,73,88,100,82,100,60,100};
float[] note2angle = {PI/2, 4*PI/3, PI/6, PI, 11*PI/6, 2*PI/3, 3*PI/2, PI/3, 7*PI/6, 0, 5*PI/6, 5*PI/3}; 

Capture cam;
int index_cam=0;


void settings() {
  size(N*SCALE,N*SCALE); 
  //fullScreen();
}

void setup() {
  fluid = new Fluid(0.1,0.0000001,0.000001);
  oscP5 = new OscP5(this,7771);
 
 //Camera setup
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i, cameras[i]);
    }
    cam = new Capture(this, cameras[index_cam]);
    cam.start();
    }
  
  frameRate(60);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(0,100,100);
  image(cam, 0, 0,width, height);
   //<>//
  int cx = int(0.5*width/SCALE)+int(0.2*width/SCALE*cos(note2angle[note % 12]+PI));
  int cy = int(0.5*height/SCALE)+int(0.2*height/SCALE*sin(note2angle[note % 12]+PI));
  float[]  amount = {vel, note2sat[note % 12],note2hue[note % 12],note2bright[note % 12]};

  for (int i = -1; i <= 1; i++){
    for (int j = -1; j <= 1; j++){
      //fluid.addDensity(cx+i,cy+j,note2sat[note % 12]);
      //fluid.addHue(cx+i,cy+j,note2hue[note % 12]);
      //fluid.addBright(cx+i,cy+j,note2bright[note % 12]);
      fluid.setNote(cx+i,cy+j,amount); //<>//
    }
  }
  //println(note2angle[note % 12]);
  PVector v = PVector.fromAngle(note2angle[note % 12]+PI);
  //println(v);
  v.mult(1.5);
  t += 0.01;
  fluid.addVelocity(cx, cy, -v.x, -v.y); 
  fluid.step();
  fluid.renderD();
  fluid.fadeD();
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
    
}
