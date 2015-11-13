PVector pos = new PVector(0, 0);
float drawLine;
int gridSize = 40;
int lines = 0;
int _x;

void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  translate(-pos.x, 0);


  for (int i = 0; i < width / gridSize + 1; i ++) {
    drawLine = i * gridSize - (pos.x % gridSize);
    lines++;
    pushStyle();
    fill(0);
    textAlign(CENTER, CENTER);
    text(i + 1, drawLine + gridSize / 2, height/2);
    popStyle();
    line(drawLine, 0, drawLine, height);
    println(frameRate);
  }

  for (int i = 0; i < height/gridSize; i++) { //Number of lines that have to be drawn is calculated by dividing the height by the gridsize. eg; 800 / 40 = 20 lines
    stroke(255, 0, 0);
    line(pos.x - width, i * gridSize, pos.x + width, i * gridSize);
  }

  lines = 0;

  if (keyPressed) {
    switch (key) {
    case 'a':
      pos.x --;
      break;
    case 'd':
      pos.x++;
      break;
    }
  }
}