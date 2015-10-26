float gravity = 0.1; //Gravity for physics objects. Global so it can be used by all classes //<>// //<>//
float friction = 0.1; //Same goes for friction

ArrayList<Platform> platforms; //Create a list of platforms. Starts empty

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
  size(640, 480);
  //fullScreen();
  smooth(4);

  //No key is pressed in the beginning
  keys[0] = false; //Left
  keys[1] = false; //Right
  keys[2] = false; //Ctrl

  //Init classes
  platforms = new ArrayList<Platform>();
  platforms.add(new Platform(0, Math.round((height - 21)/ 40.0) * 40.0, 2*gridSize, gridSize, 0)); //Create the floor

  player1 = new Player();
  worldCamera = new Camera();
  ara1 = new Ara();
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

  //Run platform for each object
  for (int i = 0; i < platforms.size(); i++) { 
    Platform platform = (Platform) platforms.get(i);
    platform.run();
  }

};