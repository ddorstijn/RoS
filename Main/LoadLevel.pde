void loadLevel(boolean objectsToo) {
  levels = loadJSONObject("level" + level + ".json");

  JSONArray levelData = levels.getJSONArray("platforms");
  JSONObject playerData = levels.getJSONObject("player");
  JSONObject araData = levels.getJSONObject("ara");

  // The size of the array of Platform objects is determined by the total XML elements named "platforms"
  platforms = new Platform[levelData.size()];
  if (objectsToo == true) {
    player1 = new Player(playerData.getInt("x"), playerData.getInt("y"));
    ara1 = new Ara(araData.getInt("x"), araData.getInt("y"));
  }

  for (int i = 0; i < levelData.size(); i++) {
    // Get each object in the array
    JSONObject platform = levelData.getJSONObject(i); 
    // Get a position object
    JSONObject position = platform.getJSONObject("position");
    // Get properties from position
    float x = position.getFloat("x");
    float y = position.getFloat("y");
    float Pwidth = position.getFloat("width");
    float Pheight = position.getFloat("height");

    // Get index
    int index = platform.getInt("index");

    // Put object in array
    platforms[i] = new Platform(x, y, Pwidth, Pheight, index, i);
  }
}