void keyPressed() {
  if (keyCode == 16) {
    shiftKey = !shiftKey;
  }
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
  if (shiftKey == true) {
    beginX = Math.round((worldCamera.pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

void mouseReleased() {
  if (shiftKey == true) {
    endX = Math.round((worldCamera.pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    platforms.add(new Platform(beginX, beginY, abs(endX), endY));
  }
}

void preview() {
  if (mousePressed && shiftKey == true) {
    rect(beginX, beginY, abs(worldCamera.pos.x + mouseX-beginX), mouseY-beginY);
  }
}