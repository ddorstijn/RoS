String[] species = { "Capra hircus", "Panthera pardus", "Equus zebra" };
String[] names = { "Goat", "Leopard", "Zebra" };

//JSONArray values;
JSONArray platforms;

float beginX;
float beginY;

float endX, endY;

void setup() {

  size(680, 480);
  
  //values = new JSONArray();

  //for (int i = 0; i < species.length; i++) {

  //  JSONObject animal = new JSONObject();

  //  animal.setInt("id", i);
  //  animal.setString("species", species[i]);
  //  animal.setString("name", names[i]);

  //  values.setJSONObject(i, animal);
  //}

  //saveJSONArray(values, "data/new.json");
}

void draw() {
  background(150, 150, 150);
  preview();
}

//Level building!
void mousePressed() {
  //Take first mouse position after clicked and allign it to the grid
  beginX = mouseX;
  beginY = mouseY;
}

void mouseReleased() {
  //Take position of the mouse when released and allign it to the grid
  endX =mouseX - beginX;
  endY = mouseY - beginY;

  for (int i = 0; i < species.length; i++) {

    JSONObject platform = new JSONObject();

    platform.setInt("id", i);
    platform.setString("species", species[i]);
    platform.setString("name", names[i]);

    platforms.setJSONObject(i, platform);
  }

  saveJSONArray(platforms, "data/new.json");

  //platforms.add(new Platform(beginX, beginY, abs(endX), endY, 1));

  //System.out.println("platforms.add(new Platform(" + beginX + ", " + beginY + ", " + abs(endX) + ", " + endY + ", " + "1)); ");
} 


void preview() {
  if (mousePressed && mouseButton == LEFT) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, mouseX - beginX, mouseY - beginY);
    popMatrix();
  }
}

// Sketch saves the following to a file called "new.json":
// [
//   {
//     "id": 0,
//     "species": "Capra hircus",
//     "name": "Goat"
//   },
//   {
//     "id": 1,
//     "species": "Panthera pardus",
//     "name": "Leopard"
//   },
//   {
//     "id": 2,
//     "species": "Equus zebra",
//     "name": "Zebra"
//   }
// ]