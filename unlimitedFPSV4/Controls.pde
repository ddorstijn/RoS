void keyPressed() {

  keysPressed[keyCode] = true;

  if (keysPressed[65]) {
    ara.powerUpActivated[0] = !ara.powerUpActivated[0];
    ara.powerUps();
  }

  if (keyCode == 16) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  if (keysPressed[83] && level != 1) { 
    level = 1;
    loadLevel(true);
  }
  if (keysPressed[68] && level != 2) { 
    level = 2;
    loadLevel(true);
  }
}

void keyReleased() {
  keysPressed[keyCode] = false;
}

//Level building!
void mousePressed() {
  if (shiftKey && mouseButton == LEFT) {
    //Take first mouse position after clicked and allign it to the grid
    beginX = Math.round((pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

void mouseReleased() {
  println(mouseButton);
  if (shiftKey == true && mouseButton == LEFT) { 
    // Create a new JSON platform object
    JSONObject newPlatform = new JSONObject();

    //Take position of the mouse when released and allign it to the grid
    endX = Math.round((pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    // Create a new JSON position object
    JSONObject position = new JSONObject();
    position.setFloat("x", beginX);
    position.setFloat("y", beginY);
    position.setFloat("width", endX);
    position.setFloat("height", endY);

    // Add position to platform
    newPlatform.setJSONObject("position", position);
    newPlatform.setInt("index", 1);
    newPlatform.setInt("value", levelData.size() + 1);

    // Append the new JSON bubble object to the array
    JSONArray platformData = levels.getJSONArray("platforms");
    platformData.append(newPlatform);

    // Save new data
    saveJSONObject(levels, "data/level" + level + ".json");
    loadLevel(false);
  }

  if (shiftKey && mouseButton == RIGHT) {
    for (Platform b : platforms) {
      if (b.isOver()) {
        platforms.remove(b);
        levelData.remove(b.value);
        saveJSONObject(levels, "data/level" + level + ".json");
        loadLevel(false);
        break;
      }
    }
  }
}


void preview() {
  if (mousePressed && mouseButton == LEFT && shiftKey == true) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, abs(pos.x + mouseX-beginX), mouseY-beginY);
    popMatrix();
  }
}