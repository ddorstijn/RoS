void keyPressed() {

  keysPressed[keyCode] = true;

  if (key != CODED && level == 0 && menu.subMenu == 4)
    userInput += key;
  if (keysPressed[' '] && level == 0 && menu.subMenu == 4) {
    level = 1;
    setIndex = 0; 
    loadLevel(true);
  }

  if (keyCode == UP && level != 0) {//////Check for (double) jump
    if (player.canJumpAgain == true && player.canJump == false && (player.velocity.y > 0 || player.velocity.y < 0 && player.velocity.y != 0)) {
      player.velocity.y = player.jumpSpeed / 1.2;
      player.canJumpAgain = false;
     }
     if (player.canJump == true) {
      player.velocity.y = player.jumpSpeed;
      player.canJump = false; // Jump is possible
      for(int i = 0; i < 30; i++){
      jump.addParticle();
      }
      player.canJump = false;
     }
  }  

  if (keysPressed[90]) {
    ara.powerUpActivated[0] = !ara.powerUpActivated[0];
    ara.powerUps();
  }

  if (keyCode == 16 && level != 0 /*&& menu.subMenu != 4*/) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  if (keysPressed[77]) {
    menu.subMenu = 0;
    level = 0;
  }

  if (keyCode == 80 && level != 0 && menu.subMenu != 4) {
    paused = !paused;

    accumTime = accumTime + millis() - startTime;
  }

  if (keysPressed[83] && level != 1 && level != 0) { 
    level = 1;
    setIndex = 0; 
    loadLevel(true);
  }
  if (keysPressed[68] && level != 2 && level != 0) { 
    level = 2;
    setIndex = 0;
    loadLevel(true);
  }
  if (keysPressed[70] && level != 3 && level != 0) { 
    level = 3;
    setIndex = 0;
    loadLevel(true);
  }

  if (level == 0) {
    if (keyCode == DOWN) {
      menu.mpos++;
    }
    if (keyCode == UP) {
      menu.mpos--;
    }
  }
}

void keyReleased() {
  keysPressed[keyCode] = false;
  menu.enteredMenu = false;
}

int playerIndex = 0;
  // add score, save scores and load scores by typing space, 's' or 'l'
  void keyTyped() {
    if (key == 's') highscores.save("highscore.csv");
    if (key == 'l') highscores.load("highscore.csv");
  }

//Level building!
void mousePressed() {
  if (shiftKey && mouseButton == RIGHT) {
    if (setIndex < 4) {
      for (Platform b : platforms) {
        if (b.isOver()) {
          platforms.remove(b);
          levelData.remove(b.value);
          saveJSONObject(levels, "data/level" + level + ".json");
          loadLevel(false);
          break;
        }
      }
    } else if (setIndex == 4) {
      for (Turret t : turrets) {
        if (t.isOver()) {
          turrets.remove(t);
          turretData.remove(t.value);
          saveJSONObject(levels, "data/level" + level + ".json");
          loadLevel(false);
          break;
        }
      }
    } else if (setIndex == 5) {
      for (MovEnemy t : movEnemy) {
        if (t.isOver()) {
          movEnemy.remove(t);
          movEnemyData.remove(t.value);
          saveJSONObject(levels, "data/level" + level + ".json");
          loadLevel(false);
          break;
        }
      }
    }
  }

  if (shiftKey && mouseButton == LEFT) {
    //Take first mouse position after clicked and allign it to the grid
    beginX = Math.round((pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

void mouseReleased() {
  if (shiftKey == true && mouseButton == LEFT) { 
    //Take position of the mouse when released and allign it to the grid
    endX = Math.round((pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    if (setIndex < 4) {
      // Create a new JSON platform object
      JSONObject newPlatform = new JSONObject();


      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX);
      position.setFloat("y", beginY);
      position.setFloat("width", endX);
      position.setFloat("height", endY);

      // Add position to platform
      newPlatform.setJSONObject("position", position);
      newPlatform.setInt("index", setIndex);
      newPlatform.setInt("value", levelData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray platformData = levels.getJSONArray("platforms");
      platformData.append(newPlatform);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
    } else if (setIndex == 4) {
      // Create a new JSON platform object
      JSONObject newTurret = new JSONObject();


      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX);
      position.setFloat("y", beginY);
      position.setFloat("width", endX);
      position.setFloat("height", endY);

      // Add position to platform
      newTurret.setJSONObject("position", position);
      newTurret.setInt("index", setIndex);
      newTurret.setInt("value", turretData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray turretData = levels.getJSONArray("turrets");
      turretData.append(newTurret);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
      println("level loaded");
    } else if (setIndex == 5) {
      // Create a new JSON platform object
      JSONObject newMovEnemy = new JSONObject();


      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX);
      position.setFloat("y", beginY);
      position.setFloat("width", endX);
      position.setFloat("height", endY);

      // Add position to platform
      newMovEnemy.setJSONObject("position", position);
      newMovEnemy.setInt("index", setIndex);
      newMovEnemy.setInt("value", movEnemyData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray movEnemyData = levels.getJSONArray("MovEnemy");
      movEnemyData.append(newMovEnemy);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
      println("level loaded");
    } else if (setIndex == 6) {
      // Create a new JSON platform object
      JSONObject newCoin = new JSONObject();

      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX + gridSize/2);
      position.setFloat("y", beginY + gridSize/2);
      position.setFloat("width", 10);
      position.setFloat("height", 10);

      // Add position to platform
      newCoin.setJSONObject("position", position);
      newCoin.setInt("index", setIndex);
      newCoin.setInt("value", movEnemyData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray coinsData = levels.getJSONArray("coins");
      coinsData.append(newCoin);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
      println("level loaded");
    }
  }
}


void levelBuild() {
  if (mousePressed && mouseButton == LEFT && shiftKey == true) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, abs(pos.x+mouseX-beginX), mouseY-beginY);
    popMatrix();
  }

  if (keysPressed['1']) {
    setIndex = 1;
  }
  if (keysPressed['2']) {
    setIndex = 2;
  }
  if (keysPressed['3']) {
    setIndex = 3;
  }
  if (keysPressed['4']) {
    setIndex = 4;
  }
  if (keysPressed['5']) {
    setIndex = 5;
  }
  if (keysPressed['6']) {
    setIndex = 6;
  }
}