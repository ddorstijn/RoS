void loadLevel(boolean objectsToo) {
   
   checkpoint1Activated = false;//elke x naar nieuw level, staat op vals
   checkpoint2Activated = false;
      
  for (int i = 0; i < keysPressed.length; i++) {//alles wat je hebt ingevuld staat op vals
    keysPressed[i] = false;
  }
<<<<<<< HEAD
  bullet.removeAll(bullet);//verwijdert alle bullets zodra je nieuw level laad
  if (level != 0) {//in de levels start hij background muziek
=======
  
  //Remove all bullets
  bullet.removeAll(bullet);
  
  if (level != 0 || level == 3) {
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
    backgroundMusic.play();
    menuMusic.pause();
    menuMusic.rewind();
  }
  if (level == 0) {//in menu start hij menu muziek
    menuMusic.play();
    backgroundMusic.pause();
    backgroundMusic.rewind();
    
  } else {
    levels = loadJSONObject("level" + level + ".json");//laden van JSON level file

    levelData = levels.getJSONArray("platforms");
    turretData = levels.getJSONArray("turrets");
    movEnemyData = levels.getJSONArray("MovEnemy");
    coinData = levels.getJSONArray("coins");
    JSONObject playerData = levels.getJSONObject("player");
    JSONObject araData = levels.getJSONObject("ara");

    if (objectsToo == true) {
      player = new Player(playerData.getInt("x"), playerData.getInt("y"));
      ara = new Ara(araData.getInt("x"), araData.getInt("y"));
    }

    if (setIndex < 4) {
      platforms.removeAll(platforms);

      for (int i = 0; i < levelData.size(); i++) {//totale size van array
        // Get each object in the array
        JSONObject platform = levelData.getJSONObject(i); 
        // Get a position object
        JSONObject position = platform.getJSONObject("position"); //pakt position
        // Get properties from position
        float x = position.getFloat("x"); //lezen van alle data
        float y = position.getFloat("y");
        float Pwidth = position.getFloat("width");
        float Pheight = position.getFloat("height");

        // Get index
        int index = platform.getInt("index");

        // Put object in array
        platforms.add(new Platform(x, y, Pwidth, Pheight, index, i));
      }
    } 

    if (setIndex == 4 || setIndex == 0) {
      turrets.removeAll(turrets);

      for (int i = 0; i < turretData.size(); i++) {
        // Get each object in the array
        JSONObject turret = turretData.getJSONObject(i); 
        // Get a position object
        JSONObject position = turret.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float Twidth = position.getFloat("width");
        float Theight = position.getFloat("height");

        // Put object in array
        turrets.add(new Turret(x, y, Twidth, Theight, i));
      }
    }

    if (setIndex == 5 || setIndex == 0) {
      movEnemy.removeAll(movEnemy);

      for (int i = 0; i < movEnemyData.size(); i++) {
        // Get each object in the array
        JSONObject movEnemyObject = movEnemyData.getJSONObject(i); 
        // Get a position object
        JSONObject position = movEnemyObject.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float aWidth = position.getFloat("width");
        float aHeight = position.getFloat("height");

        // Put object in array
        movEnemy.add(new MovEnemy(x, y, aWidth, aHeight, i));
      }
    }

    if (setIndex == 6 || setIndex == 0) {
      coins.removeAll(coins);

      for (int i = 0; i < coinData.size(); i++) {
        // Get each object in the array
        JSONObject coinObject = coinData.getJSONObject(i); 
        // Get a position object
        JSONObject position = coinObject.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float aWidth = position.getFloat("width");
        float aHeight = position.getFloat("height");

        // Put object in array
        coins.add(new Collectable (x, y, aWidth, aHeight, i));
      }

      if (setIndex == 0) {
        setIndex = 1;
      }
    }
  }
}