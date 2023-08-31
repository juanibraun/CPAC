import controlP5.*;
import oscP5.*;
import netP5.*;

ControlP5 cp5;
Button[] buttons;
PFont font;
PFont fontTit;
PFont fontText;
PImage[] img; 

color[] colors = {color(255, 0, 0), color(144, 0, 255) , color(142, 201, 255), color(183, 70, 139), color(195, 242, 255), color(171, 0, 52), color(127, 139, 253), color(255, 127, 0), color(187, 117, 252), color(51, 204, 51), color(169, 103, 124), color(142, 201, 255)};
color highlight; //color for the button when it is highlighted
color buttColor;
color fontColor;
int myColor = color(255); // Background initial color - white

OscP5 oscP5;
OscP5 oscP52;
NetAddress myRemoteLocation;

void setup(){
  size(1000,650);  //Window size
  highlight = color(255, 255, 255, 150);
  buttColor = color(0);
  fontColor = color(255);
  int numButtons;
  numButtons = 6;
  buttons = new Button[numButtons];
  cp5 = new ControlP5(this);
  
  int numImages;
  numImages = 6;
  img = new PImage[numImages];
  img[0] = loadImage("Uruguayflag.png");
  img[1] = loadImage("Uruguayflag.png");
  img[2] = loadImage("spainflag.png");
  img[3] = loadImage("spainflag.png");
  img[4] = loadImage("italia.png");
  img[5] = loadImage("italia.png");

  
  //font = createFont("arial", 20);
  font = loadFont("MalgunGothic-Semilight-20.vlw");
  fontText = loadFont("MalgunGothic-Semilight-30.vlw");
  fontTit = loadFont("MalgunGothicBold-40.vlw");
  //fontTit = loadFont("MVBoli-40.vlw");
  //fontTit = createFont("MalgunGothic Semilight", 25);
  String[] names = {"buttonC", "buttonDb", "buttonD", "buttonEb", "buttonE", "buttonF"}; //, "buttonGb", "buttonG", "buttonAb", "buttonA", "buttonBb", "buttonB"};
  String[] labels = {"Urban population", "Rural Population", "Urban population", "Rural Population", "Urban population", "Rural Population"}; //, "Gb", "G", "Ab", "A", "Bb", "B"};
  
  for (int i=0; i<buttons.length; i++){
    buttons[i] = cp5.addButton(names[i]).setPosition(475, 65 + i*75).setSize(220, 50).setColorBackground(buttColor).setCaptionLabel(labels[i]).setFont(font).setColorForeground(highlight).setColorActive(colors[i]);
  }
  
  oscP5 = new OscP5(this,1234);
  oscP52 = new OscP5(this,1234);

  myRemoteLocation = new NetAddress("127.0.0.1", 5005);
  
}

void draw(){
  
  background(myColor); //the color background will change with the value of myColor
  
  for (int i=0; i<buttons.length; i++){
    if (buttons[i].isInside()) {
    //println("check11");
    buttons[i].getCaptionLabel().setColor(color(0));
    background(colors[i]);
    image(img[i], width/2, height/2);
    } else {
      buttons[i].getCaptionLabel().setColor(color(255));
    }
  }
  
   //font = loadFont("MalgunGothic-Semilight-20.vlw");
  textFont(fontText, 30); //si no textFont(font) tb deberia servir
  //textSize(25);
  fill (0, 0, 0);
  text("URUGUAY", 300, 140); // Text + cord x + cord y
  text("SPAIN", 330, 290); // Text + cord x + cord y
  text("ITALY", 330, 440); // Text + cord x + cord y
  
  textFont(fontTit);
  //text("Scriba'N Paint", 60, 70);
  text("Scriba'N Paint", 60, 590);
}




public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  
}



//void handleButtonState(Button button, color hoverColor) {
//  if (button.isInside()) {
//    //println("check11");
//    background(hoverColor);
//  } else {
//    //println("check22");
//    background(myColor);
//  }
//}



public void buttonC(int theValue) {
  OscMessage myMessage = new OscMessage("/adress");
  myMessage.add("uruguay");
  myMessage.add("urban");
  oscP5.send(myMessage, myRemoteLocation);
  println("a button event from buttonC: "+theValue);
  
}

public void buttonDb(int theValue) {
  OscMessage myMessage = new OscMessage("/adress");
  myMessage.add("uruguay");
  myMessage.add("rural");
  oscP5.send(myMessage, myRemoteLocation);
  println("a button event from buttonDb: "+theValue);
 
}

public void buttonD(int theValue) {
  println("a button event from buttonD: "+theValue);
  OscMessage myMessage = new OscMessage("/adress");
  myMessage.add("spain");
  myMessage.add("urban");
  oscP5.send(myMessage, myRemoteLocation);
  println("a button event from buttonD: "+theValue);
 
}

public void buttonEb(int theValue) {
  println("a button event from buttonEb: "+theValue);
  OscMessage myMessage = new OscMessage("/adress");
  myMessage.add("spain");
  myMessage.add("rural");
  oscP5.send(myMessage, myRemoteLocation);
  println("a button event from buttonEb: "+theValue);
  
}

public void buttonE(int theValue) {
  println("a button event from buttonE: "+theValue);
  OscMessage myMessage = new OscMessage("/adress");
  myMessage.add("italy");
  myMessage.add("urban");
  oscP5.send(myMessage, myRemoteLocation);
  println("a button event from buttonE: "+theValue);
  
}

public void buttonF(int theValue) {
  println("a button event from buttonF: "+theValue);
  OscMessage myMessage = new OscMessage("/adress");
  myMessage.add("italy");
  myMessage.add("rural");
  oscP5.send(myMessage, myRemoteLocation);
  println("a button event from buttonF: "+theValue);

}

public void buttonGb(int theValue) {
  println("a button event from buttonGb: "+theValue);
  
}

public void buttonG(int theValue) {
  println("a button event from buttonG: "+theValue);
 
}

public void buttonAb(int theValue) {
  println("a button event from buttonAb: "+theValue);

}

public void buttonA(int theValue) {
  println("a button event from buttonA: "+theValue);
 
}

public void buttonBb(int theValue) {
  println("a button event from buttonBb: "+theValue);
  
}

public void buttonB(int theValue) {
  println("a button event from buttonB: "+theValue);
  
}
