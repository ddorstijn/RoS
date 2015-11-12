PVector v1 = new PVector(0, 200);
PVector v2 = new PVector(200, 0);
PVector v3 = v1.copy();

void setup() {
  size(600, 600);
  surface.setResizable(true);
}

void draw() {
  background(0);

  translate(width/2, height/2);

  stroke(100);
  strokeWeight(0.2);
  line(-(width/2), 0, width/2, 0);
  line(0, -(height/2), 0, height/2);

  stroke(255, 0, 0);
  strokeWeight(6);
  point(v1.x, v1.y);
  strokeWeight(1);
  line(0, 0, v1.x, v1.y);

  stroke(0, 255, 0);
  strokeWeight(6);
  point(v2.x, v2.y);
  strokeWeight(1);
  line(0, 0, v2.x, v2.y);

  if (keyPressed) {
    switch(key) {
    case '1':
      v3 = v1.copy();
      v3.normalize();
      println("normalize!");
      break;
    case '2':
      v3 = v1.copy();
      v3.mult(-1);
      println("flip!");
      break;
    case '3':
      v3 = v1.copy();
      v3.setMag(50);
      println("set magnitude!");
      break;
    case '4':
      v3 = v1.copy();
      v3 = PVector.add(v1, v2);
      println("add together!");
      stroke(0, 255, 0);
      strokeWeight(0.1);
      line(v1.x, v1.y, v3.x, v3.y);
      strokeWeight(1);
      break;
    case '5':
      v3 = v1.copy();
      v3 = PVector.sub(v1, v2);
      println("subtract!");
      break;
    case '6':
      v3 = v1.copy();
      v3 = PVector.div(v1, 2);
      println("subdivide!");
      break;
    case '7':
      v3.rotate(2*PI/360);
      println("rotate!");
      break;
    case '8':
      float angle = PVector.angleBetween(v1, v2);
      v3 = new PVector(1, 0);
      v3.setMag(150);
      v3.rotate(angle/2);
      break;
    case 'a':
      v2.rotate(-2*PI/360);
      break;
    case 'd':
      v2.rotate(2*PI/360);
      break;
    case 'j':
      v1.rotate(-2*PI/360);
      break;
    case 'l':
      v1.rotate(2*PI/360);
      break;
    }
  }

  stroke(0, 0, 255);
  strokeWeight(6);
  point(v3.x, v3.y);
  strokeWeight(1);
  line(0, 0, v3.x, v3.y);
}