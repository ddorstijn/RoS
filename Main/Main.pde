Platform[] platforms; //<>//

JSONObject levels;
int level = 1;

JSONArray levelData;
JSONObject playerData;

//Gloal variable INIT
float gravity = 0.1; //Gravity for physics objects. Global so it can be used by all classes
float friction = 0.1; //Same goes for friction

PFont message;

boolean[] keys = new boolean[3]; //Keys pressed and released doesn't always work if you just use the keyPressed command.
boolean shiftKey = false;  //Check if Shiftkey is pressed, toggle.

boolean isCarried = false;

boolean rectRectIntersect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}  // Basic collision detection method

float beginX, endX, beginY, endY; 
float gridSize = 40; //Size of the grid the game is built around

//Call every class
Player player1;
Camera worldCamera;
Ara ara1;

void setup() {
  size(1000, 480);
  smooth(4);
  textAlign(CENTER);

  //No key is pressed in the beginning
  keys[0] = false; //Left
  keys[1] = false; //Right
  keys[2] = false; //Ctrl

  loadLevel();
  
  worldCamera = new Camera();

  message = createFont("Arial", 72, true);
  textFont(message);
}

//Main
void draw() {

  //translate world with camera
  translate(-worldCamera.pos.x, -worldCamera.pos.y);
  worldCamera.draw();

  //setup
  drawBackground();
  player1.run();
  grid();
  preview();
  ara1.run();
  controls();
  
  // Display all bubbles
  for (Platform b : platforms) {
    b.run();
  }
};