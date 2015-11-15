void loadLevel(boolean objectsToo) {

  levels = loadJSONObject("level" + level + ".json");

  levelData = levels.getJSONArray("platforms");
  JSONObject playerData = levels.getJSONObject("player");
  JSONObject araData = levels.getJSONObject("ara");

  if (objectsToo == true) {
    player = new Player(playerData.getInt("x"), playerData.getInt("y"));
    ara = new Ara(araData.getInt("x"), araData.getInt("y"));
  }

  platforms.removeAll(platforms);

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
    platforms.add(new Platform(x, y, Pwidth, Pheight, index, i));
  }
}