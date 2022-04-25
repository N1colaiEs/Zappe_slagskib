import processing.serial.*;
Serial myPort;  // Create object from Serial class

import processing.video.*;
import websockets.*;

import processing.sound.*;
SoundFile file;

WebsocketServer socket;
Capture video;
int msg;

color trackColor; 
float threshold = 25;
float distThreshold = 25;

ArrayList<Blob> blobs = new ArrayList<Blob>();
ArrayList<DatRect> themRects = new ArrayList<DatRect>();

class DatRect {
  float minx;
  float miny;
  float maxx;
  float maxy;
  DatRect(float x, float y) {
    minx = x;
    miny = y;
    maxx = x+300;
    maxy = y+200;
  }
  
  void show() {
    stroke(0);
    noFill();
      for (Blob b : blobs) {
        PVector blobmiddle = b.getMiddle();
        if(blobmiddle.x > minx && blobmiddle.x < maxx && blobmiddle.y > miny && blobmiddle.y < maxy){
            fill(0,0,255,127);
        }     
    }
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
  }
}

class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  ArrayList<PVector> points;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }
  PVector getMiddle(){
   return new PVector((minx+maxx)/2, (miny+maxy)/2); 
  }
  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);

    for (PVector v : points) {
      //stroke(0, 0, 255);
      //point(v.x, v.y);
    }
  }


  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  boolean isNear(float x, float y) {

    // The Rectangle "clamping" strategy
    // float cx = max(min(x, maxx), minx);
    // float cy = max(min(y, maxy), miny);
    // float d = distSq(cx, cy, x, y);

    // Closest point in blob strategy
    float d = 10000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}


void setup() {  
  size(900, 600);
  String[] cameras = Capture.list();
  socket = new WebsocketServer(this, 1337, "/transcript");
  printArray(cameras);
  video = new Capture(this, 900, 600);
  video.start();
  trackColor = color(255, 0, 0);
    file = new SoundFile(this, "taser.mp3");
  
  
  themRects.add(new DatRect(0, 0));
  themRects.add(new DatRect(300, 0));
  themRects.add(new DatRect(600, 0));
  themRects.add(new DatRect(0, 200));
  themRects.add(new DatRect(300, 200));
  themRects.add(new DatRect(600, 200));
  themRects.add(new DatRect(0, 400));
  themRects.add(new DatRect(300, 400));
  themRects.add(new DatRect(600, 400));
  
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold+=5;
  } else if (key == 'z') {
    distThreshold-=5;
  }
  if (key == 's') {
    threshold+=5;
  } else if (key == 'x') {
    threshold-=5;
  }


  println(distThreshold);
}

void draw() {

  
  video.loadPixels();
  image(video, 0, 0);

  blobs.clear();
  
 for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }
  
  for (Blob b : blobs) {
    if (b.size() > 500) {
      b.show();
    }
  }
  //textAlign(RIGHT);
  //fill(0);
  //text("distance threshold: " + distThreshold, width-10, 25);
  //text("color threshold: " + threshold, width-10, 50);
  /*
  stroke(1);
  fill(255);
  strokeWeight(2);
  rectMode(CORNER);
  fill(250,250,250,50);
  rect(0, 0, 300, 200);
  rect(300, 0, 300, 200);
  rect(600, 0, 300, 200);
  rect(0, 200, 300, 200);
  rect(300, 200, 300, 200);
  rect(600, 200, 300, 200);
  rect(0, 400, 300, 200);
  rect(300, 400, 300, 200);
  rect(600, 400, 300, 200);
  */
    for (DatRect r : themRects) {
    //if (r.size() > 500) {
      
      r.show();
      //}
    }
}


// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
void webSocketServerEvent(String msg){
 println(msg);
//check for dyr 
 for (Blob b : blobs) {
      PVector blobmiddle = b.getMiddle();
if(msg.equals("monkey") && blobmiddle.x<300 && blobmiddle.y<200){
System.out.print("apkatmand");
file.play();
myPort.write('1');         //send a 1
 }  
 
if(msg.equals("lion") && blobmiddle.x>300 && blobmiddle.x<600 && blobmiddle.y<200){
System.out.print("farlig tiger mis");
file.play();
myPort.write('2');         //send a 1

 }

if(msg.equals("giraffe") && blobmiddle.x>600 && blobmiddle.y<200){
System.out.print("langhalset hest");
file.play();
myPort.write('3');         //send a 1
 }
if(msg.equals("elephant") && blobmiddle.x<300 && blobmiddle.y>200 && blobmiddle.y<400){
System.out.print("næsehorn, men større og med lang snude");
file.play();
myPort.write('4');         //send a 1
 } 
 
if(msg.equals("rhino") && blobmiddle.x>300 && blobmiddle.x<600 && blobmiddle.y>200 && blobmiddle.y<400){
System.out.print("mindre elefant med skarp snude");
file.play();
myPort.write('5');         //send a 1
 } 
 
if(msg.equals("buffalo") && blobmiddle.x>600 && blobmiddle.y>200 && blobmiddle.y<400){
System.out.print("hot wings");
file.play();
myPort.write('6');         //send a 1
 }
 
if(msg.equals("gorilla") && blobmiddle.x<300 && blobmiddle.y>400){
System.out.print("Harambe");
file.play();
myPort.write('7');         //send a 1
 } 
 
if(msg.equals("chimpanzee") && blobmiddle.x>300 && blobmiddle.x<600 && blobmiddle.y>400){
System.out.print("sjov abekatmand");
file.play();
myPort.write('8');         //send a 1
  } 
if(msg.equals("crocodile") && blobmiddle.x>600 && blobmiddle.y>400){
System.out.print("sjov abekatmand");
file.play();
myPort.write('9');         //send a 1
  } 
 }
}
