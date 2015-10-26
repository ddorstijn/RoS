void drawBackground() {
  background(25, 41, 67); //Drawing background
}

void grid() {
  
  if (shiftKey == true) {  //If in buildmode 
    //horizontal gridlines
    for (int i = 0; i < height/gridSize; i++) //Number of lines that have to be drawn is calculated by dividing the height by the gridsize. eg; 800 / 40 = 20 lines
    {
      stroke(255, 0, 0);
      line(worldCamera.pos.x - width, i * gridSize, worldCamera.pos.x + width, i * gridSize);
    }

    //Vertical lines
    for (int i = 0; i < width/gridSize + worldCamera.pos.x; i++)
    {
      stroke(255, 0, 0);
      line (i * gridSize, 0, i * gridSize, height);
    }
  }
}