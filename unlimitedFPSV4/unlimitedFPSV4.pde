int TICKS_PER_SECOND = 60; //<>// //<>// //<>//
int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
int MAX_FRAMESKIP = 10;

int next_game_tick = millis();
int loops;

//Gloal variable INIT
JSONObject levels;
int level = 1;

JSONArray levelData;
JSONObject playerData;

PVector gravity, pos;
float friction; //Same goes for friction

PFont popUpFont, statsFont;

boolean[] keysPressed; //Keys Pressed
boolean shiftKey;  //Check Shift-key

// Basic collision detection method
boolean rectRectIntersect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}  

float beginX, endX, beginY, endY, gridSize, mousex; //Size of the grid the game is built around

ArrayList<Platform> platforms;

//Call every class
//Platform[] platforms; 
Player player1;
Camera worldCamera;
Ara ara1;

void setup() {
  size(1650, 480);
  surface.setResizable(true);
  frameRate(-1);

  textAlign(CENTER);

  gridSize = 40;
  keysPressed = new boolean[256];
  platforms = new ArrayList<Platform>();

  pos = new PVector(0, 0);

  loadLevel(true);

  worldCamera = new Camera();

  popUpFont = createFont("Arial", 72, true);
  statsFont = createFont("Arial", 14, true);
}

void draw() {
  loops = 0;

  while (millis () > next_game_tick && loops < MAX_FRAMESKIP) {         
    update_game();

    next_game_tick += SKIP_TICKS;
    loops++;
  }

  draw_game();
}

void update_game() {

  player1.update();
  ara1.update();

  for (Platform b : platforms) {
    b.update();
  }

  worldCamera.drawWorld();
}

void draw_game() {

  drawBackground();

  //UI
  //Everything that must stay in one place relative to the screen position Doesn't need to be translated wich will make it stay in the same place
  grid();

  //LEVEL
  pushMatrix();
  translate(-pos.x, -pos.y);

  //setup
  preview();

  player1.display();
  ara1.display();

  // Display all bubbles
  for (Platform b : platforms) {
    if (b.right > pos.x && b.left < pos.x + width) { 
      b.display();
    }
  }
  popMatrix();

  textFont(statsFont);
  fill(255);
  text("fps: " + frameRate, 40, 20);

  //textFont(popUpFont);
  //text("You lose", width/2, height/2);
}