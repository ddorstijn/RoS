//Je kunt je eigen levels bouwen!!!
//Teken gewoon een vierkant om te beginnen
//Het vierkant blijft bestaan ook al herstart je het spel
//A en S om van level 1 en twee te switchen

JSONArray level1;
JSONArray level2;
JSONObject obj;

JSONArray platform;

int level = 1;

float beginX = 10, beginY = 10, endX = 10, endY = 10;

void setup() {  
  size(640, 480);
}

void draw() {
  background(0);
  preview();
  drawRect();
}

void keyPressed() {
  switch (key) {
  case 'a':
    level = 1;
    break;
  case 's':
    level = 2;
    break;
  }
}

void mousePressed() {
  beginX = mouseX;
  beginY = mouseY;
}

void mouseReleased() {
  obj = new JSONObject();

  endX = mouseX - beginX;
  endY = mouseY - beginY;

  obj.setFloat("x", beginX);
  obj.setFloat("y", beginY);
  obj.setFloat("width", endX);
  obj.setFloat("height", endY);

  switch (level) {
  case 1:
    level1.append(obj);
    saveJSONArray(level1, "data/level1.json");
    break;
  case 2:
    level2.append(obj);
    saveJSONArray(level2, "data/level2.json");
    break;
  }
}

void preview() {
  if (mousePressed) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(255);
    rect(beginX, beginY, mouseX - beginX, mouseY - beginY);
    popMatrix();
  }
}

void drawRect() {

  level1 = loadJSONArray("data/level1.json");
  level2 = loadJSONArray("data/level2.json");

  switch (level) {
  case 1:
    for (int i = 0; i < level1.size(); i++) {

      JSONObject platforms = level1.getJSONObject(i); 

      float x = platforms.getFloat("x");
      float y = platforms.getFloat("y");
      float iWidth = platforms.getFloat("width");
      float iHeight = platforms.getFloat("height");

      rect(x, y, iWidth, iHeight);
    }
    break;

  case 2:
    for (int i = 0; i < level2.size(); i++) {

      JSONObject platforms = level2.getJSONObject(i); 

      float x = platforms.getFloat("x");
      float y = platforms.getFloat("y");
      float iWidth = platforms.getFloat("width");
      float iHeight = platforms.getFloat("height");

      rect(x, y, iWidth, iHeight);
    }
    break;
  }
}