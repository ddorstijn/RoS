float gravity = 0.1; //Gravity for physics objects. Global so it can be used by all classes //<>//
float friction = 0.1; //Same goes for friction


PFont message;


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
  size(1000, 480);
  //fullScreen();
  smooth(4);

  //No key is pressed in the beginning
  keys[0] = false; //Left
  keys[1] = false; //Right
  keys[2] = false; //Ctrl

  //Init classes
  platforms = new ArrayList<Platform>();

  //Create the level  
  platforms.add(new Platform(0.0, 400.0, 920.0, 120.0, 1)); // = platform 1 op level design
  platforms.add(new Platform(720.0, 320.0, 80.0, 40.0, 1)); // = platform 2 op level desing
  platforms.add(new Platform(1000.0, 320.0, 80.0, 40.0, 1));// = platform 3 op level desing
  platforms.add(new Platform(1160.0, 400.0, 280.0, 120.0, 1)); // = platform 4 op level design
  platforms.add(new Platform(1160.0, 360.0, 40.0, 80.0, 1)); // = platform + op level design
  platforms.add(new Platform(1400.0, 360.0, 40.0, 40.0, 1)); // = platform + op level design
  platforms.add(new Platform(1560.0, 320.0, 80.0, 40.0, 1)); // = platorm 5 op level dsing
  platforms.add(new Platform(1760.0, 400.0, 240.0, 80.0, 1)); // = platform 6 op level desing
  platforms.add(new Platform(2120.0, 360.0, 20.0, 20.0, 1)); // = platform + op level design
  platforms.add(new Platform(2320.0, 360.0, 20.0, 20.0, 1)); // = platform + op level design
  platforms.add(new Platform(2520.0, 360.0, 20.0, 20.0, 1)); // = platform + op level design
  platforms.add(new Platform(2720.0, 360.0, 20.0, 20.0, 1)); // = platform + op level design
  platforms.add(new Platform(2920.0, 400.0, 20.0, 20.0, 1)); // = platform + op level design
  platforms.add(new Platform(3120.0, 400.0, 320.0, 80.0, 1)); // = platform 7 op level design
  platforms.add(new Platform(3440.0, 440.0, 640.0, 40.0, 1));  // = platform 8 op level design
  platforms.add(new Platform(4080.0, 400.0, 160.0, 120.0, 1)); // = platform 9 op level design
  platforms.add(new Platform(3560.0, 320.0, 160.0, 40.0, 1)); // = platform 10 op level design
  platforms.add(new Platform(3800.0, 280.0, 160.0, 40.0, 1)); // = platform 11 op level design

  platforms.add(new Platform(1240.0, 360.0, 40.0, 40.0, 2)); //enemy/trap
  platforms.add(new Platform(1320.0, 360.0, 40.0, 40.0, 2)); //enemy/trap
  
  platforms.add(new Platform(4280.0, 400.0, 400.0, 80.0, 3)); //Finish

  player1 = new Player();
  worldCamera = new Camera();
  ara1 = new Ara();
  
  message = createFont("Arial", 72, true);
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
  
  //Run platform for each object
  for (int i = 0; i < platforms.size(); i++) { 
    Platform platform = (Platform) platforms.get(i);
    platform.run();
  }
};