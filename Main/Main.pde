float gravity = 0.1; //<>//
float friction = 0.1;

ArrayList<Platform> platforms;

boolean[] keys = new boolean[3];
boolean shiftKey = false;  

boolean rectRectIntersect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}  

float beginX, endX, beginY, endY;
float gridSize = 40;

//platform position
Player player1;
Camera worldCamera;

void setup() {
  size(640, 480);
  //fullScreen();
  smooth(4);

  keys[0] = false;
  keys[1] = false;
  keys[2] = false;

  platforms = new ArrayList<Platform>();
  platforms.add(new Platform(width/2-gridSize, Math.round((height - 21)/ 40.0) * 40.0, 2*gridSize, gridSize, 0));

  player1 = new Player();
  worldCamera = new Camera();
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

  for (int i = 0; i < platforms.size(); i++) { 
    Platform platform = (Platform) platforms.get(i);
    platform.run();
  }
};