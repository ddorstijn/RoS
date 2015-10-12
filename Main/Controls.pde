void keyPressed() {
  if (keyCode == 16) {
    shiftKey = !shiftKey;
  }

  //  if (keyCode == 83) {
  //   export();
  //}
}

void keyReleased()
{
  switch (keyCode) {
  case 37: // In case left arrow key is pressed and left is not obstructed move left
    keys[0] = false;
    break;
  case 39:
    keys[1] = false;
    break;
  case 38:
    keys[2] = false;
    break;
  }
}

//Level building!

void mousePressed() {
  if (shiftKey == true && mouseButton == LEFT) {
    beginX = Math.round((worldCamera.pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

void mouseReleased() {
  if (shiftKey == true && mouseButton == LEFT) {
    endX = Math.round((worldCamera.pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    platforms.add(new Platform(beginX, beginY, abs(endX), endY, 1));
  }
}

void preview() {
  if (mousePressed && mouseButton == LEFT && shiftKey == true) {
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, abs(worldCamera.pos.x + mouseX-beginX), mouseY-beginY);
    popMatrix();
  }
}