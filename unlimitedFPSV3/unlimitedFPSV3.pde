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

PVector gravity;
float friction; //Same goes for friction

PVector pos; //Camera's position

PFont popUpFont, statsFont;

boolean[] keysPressed; //Keys Pressed
boolean shiftKey = false;  //Check Shift-key

// Basic collision detection method
boolean rectRectIntersect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}  

float beginX, endX, beginY, endY, gridSize; //Size of the grid the game is built around

ArrayList<Platform> platforms;

//Call every class
Player player1;
Camera worldCamera;
Ara ara1;

void setup() {
  size(1650, 480);
  frameRate(-1);

  textAlign(CENTER);

  keysPressed = new boolean[256];

  platforms = new ArrayList<Platform>();
  loadLevel(true);

  worldCamera = new Camera();
  
  popUpFont = createFont("Arial", 72, true);
  statsFont = createFont("Arial", 14, true);
  gridSize = 40;
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
  worldCamera.drawWorld();
  player1.update();
  ara1.update();

  // Display all bubbles
  for (Platform b : platforms) {
    b.update();
  }
}

void draw_game() {

  translate(-pos.x, -pos.y);

  //setup
  drawBackground();
  grid();
  preview();

  player1.display();
  ara1.display();

  // Display all bubbles
  for (Platform b : platforms) {
    b.display();
  }

  textFont(statsFont);
  fill(255);
  text(frameRate, pos.x + 40, 20);
}