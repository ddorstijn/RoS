void keyPressed() {
  
  if (keyCode == 16) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  if (key == 'a' && ara1.aHeight == 20) {
    ara1.location.y -= 20;
    ara1.aHeight += 20;
  } else if (key == 'a' && ara1.aHeight == 40 || keyCode == 17 && ara1.aHeight == 40) {     
    ara1.location.y += 20;
    ara1.aHeight -= 20;
  }
  
  if (key == 's' && level != 1) { 
    level = 1;
    loadLevel(true);
  }
  if (key == 'd' && level != 2) { 
    level = 2;
    loadLevel(true);
  }
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
    keys[2] = false; //In case ctrl is pressed
    if (isCarried) {
      ara1.velocity.x = player1.velocity.x; //ara's pos is player pos
      ara1.velocity.y = player1.velocity.y;
      isCarried = false;
    }
    break;
  }
}

void controls() {
  // Keyboard control
  if (keyPressed == true) {
    switch (keyCode) {
    case 37: // In case left arrow key is pressed and left is not obstructed move left
      keys[0] = true;
      break;
    case 39:
      keys[1] = true;
      break;
    case 17:
      keys[2] = true;
      break;
    case 38:
      if (player1.canJump == true) {
        player1.velocity.y = player1.jumpSpeed;
        player1.canJump = false; // Jump is possible
      }
      break;
    }
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

    // Create a new JSON platform object
    JSONObject newPlatform = new JSONObject();

    //Take position of the mouse when released and allign it to the grid
    endX = Math.round((worldCamera.pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    // Create a new JSON position object
    JSONObject position = new JSONObject();
    position.setFloat("x", beginX);
    position.setFloat("y", beginY);
    position.setFloat("width", endX);
    position.setFloat("height", endY);

    // Add position to bubble
    newPlatform.setJSONObject("position", position);
    newPlatform.setInt("index", 1);

    // Append the new JSON bubble object to the array
    JSONArray platformData = levels.getJSONArray("platforms");
    platformData.append(newPlatform);

    // Save new data
    saveJSONObject(levels, "data/level" + level + ".json");
    loadLevel(false);
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