import processing.opengl.*;
import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

PeasyCam cam;
ArrayList<Octahedron> octas;
PImage groundTexture;
int activeOcta = 0;
float magnitude = 10;
float rmagnitude = PI/32;
boolean rotationMode = false;

void setup() {
  size(1000,1000,OPENGL);
  rectMode(CENTER);
  cam = new PeasyCam(this, 250, 250, 0, 1000);
  cam.setSuppressRollRotationMode();
  
  octas = new ArrayList<Octahedron>();
  
  octas.add(new Octahedron(250, 250, 0, 0, 0, 0, 300));
  octas.add(new Octahedron(250+300, 250, 0, 0, 0, 0, 300));
  
  groundTexture = loadImage("data/Lost Lake.jpg");
}

void draw() {
  background(0);
  lights();

  pushMatrix();
  translate(0, 450, 0);

  noStroke();
  beginShape();
  texture(groundTexture);
  textureMode(NORMALIZED);

  float bound = 2400;
  vertex(-bound, .5, -bound, 0, 0);
  vertex(bound, .5, -bound, 1, 0);
  vertex(bound, .5, bound, 1, 1);
  vertex(-bound, .5, bound, 0, 1);
  endShape();
  popMatrix();
  
  for (int i=0; i<octas.size(); i++) {
      octas.get(i).setColor(i==activeOcta ? color(255,128,0) : color(255,64,64));
      octas.get(i).draw();
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT || keyCode == CONTROL) {
      magnitude = 10;
      rmagnitude = PI/32;
    }
    else if (keyCode == ALT || keyCode == 157) {
      rotationMode = false;
    }
  }
}

void keyPressed() {
  Octahedron octa = octas.get(activeOcta);

println(keyCode);  
  if (keyCode == SHIFT) {
    magnitude = 100;
    rmagnitude = PI/16;
  }
  else if (keyCode == CONTROL) {
    magnitude = 1;
    rmagnitude = PI/128;
  }
  else if (keyCode == ALT || keyCode == 157) {
    rotationMode = true;
  }
  else if (rotationMode && keyCode == UP) {
    octa.addRotate(rmagnitude,0,0);
  }
  else if (rotationMode && keyCode == DOWN) {
    octa.addRotate(-rmagnitude,0,0);
  }
  else if (rotationMode && keyCode == LEFT) {
    octa.addRotate(0,-rmagnitude,0);
  }
  else if (rotationMode && keyCode == RIGHT) {
    octa.addRotate(0,rmagnitude,0);
  }
  else if (rotationMode && keyCode == 65) {
    octa.addRotate(0,0,-rmagnitude);
  }
  else if (rotationMode && keyCode == 90) {
    octa.addRotate(0,0,rmagnitude);
  }
  else if (!rotationMode && keyCode == UP) {
    octa.addTranslate(0.0,-magnitude,0.0);
  }
  else if (!rotationMode && keyCode == DOWN) {
    octa.addTranslate(0.0,magnitude,0.0);
  }
  else if (!rotationMode && keyCode == LEFT) {
    octa.addTranslate(-magnitude,0.0,0.0);
  }
  else if (!rotationMode && keyCode == RIGHT) {
    octa.addTranslate(magnitude,0.0,0.0);
  }
  else if (!rotationMode && keyCode == 65) {
    octa.addTranslate(0,0,-magnitude);
  }
  else if (!rotationMode && keyCode == 90) {
    octa.addTranslate(0,0,magnitude);
  }
  else if (key == '[') {
    activeOcta--;
    if (activeOcta < 0) {
      activeOcta = octas.size() - 1;
    }
  }
  else if (key == ']') {
    activeOcta++;
    if (activeOcta >= octas.size()) {
      activeOcta = 0;
    }
  }
  else if (key == '+') {
    octas.add(octa.clone());
    activeOcta = octas.size() - 1;
  }
  else if (keyCode == 8) {
    if (octas.size() > 1) {
      octas.remove(activeOcta);
      activeOcta--;
      
      if (activeOcta < 0) {
        activeOcta = octas.size() - 1;
      }
    }
  }
}

class Octahedron {
    float x;
    float y;
    float z;
    float rx;
    float ry;
    float rz;
    float d;
    color c;
    
    public Octahedron(float x, float y, float z, float rx, float ry, float rz, float d) {
      this.x = x;
      this.y = y;
      this.z = z;
      this.rx = rx;
      this.ry = ry;
      this.rz = rz;
      this.d = d;
      this.c = color(255,128,128);
    }
    
    public Octahedron clone() {
      Octahedron newOcta = new Octahedron(this.x, this.y, this.z, this.rx, this.ry, this.rz, this.d);
      newOcta.addTranslate(30,-30,0);
      return newOcta;
    }
    
    public void draw() {
      pushMatrix();
      
      translate(this.x, this.y, this.z);
      rotateX(this.rx);
      rotateY(this.ry);
      rotateZ(this.rz);

      noFill();
      stroke(this.c);
      strokeWeight(10);
      
      rotateZ(radians(45));  
      rect(0,0,this.d,this.d);
      
      rotateZ(radians(45));
      rotateX(radians(45));
      rotateY(radians(90));
      rect(0,0,this.d,this.d);
      
      rotateZ(radians(45));
      rotateX(radians(45));
      rotateY(radians(90));
      rect(0,0,this.d,this.d);
      
      popMatrix();
    }
    
    public void setColor(color c) {
      this.c = c;
    }
    
    public void addRotate(float rx, float ry, float rz) {
      this.rx += rx;
      this.ry += ry;
      this.rz += rz;
    }
    
    public void addTranslate(float x, float y, float z) {
      this.x += x;
      this.y += y;
      this.z += z;
    }
}
