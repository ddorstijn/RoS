PVector pos = new PVector(0, 0); //<>//
float lx;
int gridSize = 40;
int lines = 0;
int _x;

void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  translate(-pos.x, 0);

  fill(0,255,0);
  rect(700, height/2, 40, 40);

  //VERTICALE LIJNEN
  for (int i = 0; i < width / gridSize + 1; i ++) {
    pushMatrix();
    translate(pos.x, 0);
    lx = i * gridSize - (pos.x % gridSize);
    line(lx, 0, lx, height);
    popMatrix();
  }

  //HORIZONTALE LIJNEN
  for (int i = 0; i < height/gridSize; i++) { //Number of lines that have to be drawn is calculated by dividing the height by the gridsize. eg; 800 / 40 = 20 lines
    stroke(255, 0, 0);
    line(pos.x - width, i * gridSize, pos.x + width, i * gridSize);
  }

  for (int i = 0; i < width / 10; i++) {
    fill(0);
    textAlign(CENTER, CENTER);
    text(i * 10, i * 10, i * 10);
  }

  lines = 0;
  //pos.x ++;
}

void keyPressed() {
 switch (key) {
 case 'a':
   pos.x -= 1;
   println(pos.x);
   break;
 case 'd':
   pos.x += 1;
   println(pos.x);
   break;
 }
}