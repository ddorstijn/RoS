//Drawing objects on screen

void drawBackground() {
  background(25, 41, 67);
  noStroke();
  rectMode(CENTER);
}

void grid() {

  if (shiftKey == true) {   
    for (int i = 0; i < height/gridSize; i++)
    {
      stroke(255, 0, 0);
      line(worldCamera.pos.x - width, i * gridSize, worldCamera.pos.x + width, i * gridSize);
    }

    for (int i = 0; i < width/gridSize + worldCamera.pos.x; i++)
    {
      stroke(255, 0, 0);
      line (i * gridSize, 0, i * gridSize, height);
    }
  }
}