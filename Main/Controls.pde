void keyPressed() {
  if (keyCode == 16) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  //if (keyCode == 49 && ara1.aHeight == 40) {
  //  ara1.y -= 40;
  //  ara1.aHeight += 40;
  //} else {     
  //  ara1.y += 40;
  //  ara1.aHeight -= 40;
  //}

  //  if (keyCode == 83) {
  //   export();
  //}
}

void keyReleased()
{
  switch (keyCode) {
  case 37: // In case left arrow key is pressed 
    keys[0] = false;
    break;
  case 39: //In case the right arrow key is pressed
    keys[1] = false;
    break;
  case 17:
    keys[2] = false;
    if (isCarried) {
      ara1.vx = player1.vx;
      ara1.vy = player1.vy;
      isCarried = false;
    }
    break;
  }
}

//Level building!
void mousePressed() {
  if (shiftKey == true && mouseButton == LEFT) {
    //Take first mouse position after clicked and allign it to the grid
    beginX = Math.round((worldCamera.pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

void mouseReleased() {
  if (shiftKey == true && mouseButton == LEFT) {
    //Take position of the mouse when released and allign it to the grid
    endX = Math.round((worldCamera.pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    platforms.add(new Platform(beginX, beginY, abs(endX), endY, 1));

    System.out.println("platforms.add(new Platform(" + beginX + ", " + beginY + ", " + abs(endX) + ", " + endY + ", " + "1)); ");
  }
}

void preview() {
  if (mousePressed && mouseButton == LEFT && shiftKey == true) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, abs(worldCamera.pos.x + mouseX-beginX), mouseY-beginY);
    popMatrix();
  }
}