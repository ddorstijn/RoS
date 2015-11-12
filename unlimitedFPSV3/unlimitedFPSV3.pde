int TICKS_PER_SECOND = 60; //<>// //<>// //<>//
int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
int MAX_FRAMESKIP = 10;

int next_game_tick = millis();
int loops;
float interpolation;

//Gloal variable INIT
JSONObject levels;
int level = 1;

JSONArray levelData;
JSONObject playerData;

PVector gravity;
float friction; //Same goes for friction

PVector pos; //Camera's position

PFont popUpFont;
PFont statsFont;

boolean[] keys = new boolean[3]; //Keys Pressed
boolean shiftKey = false;  //Check Shift-key

boolean isCarried = false; //For ara

// Basic collision detection method
boolean rectRectIntersect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}  

float beginX, endX, beginY, endY; 
float gridSize = 40; //Size of the grid the game is built around

ArrayList<Platform> platforms;

//Call every class
//Platform[] platforms; 
Player player1;
Camera worldCamera;
Ara ara1;

void setup() {
  size(1650, 480);
  frameRate(-1);

  textAlign(CENTER);

  //No key is pressed in the beginning
  keys[0] = false; //Left
  keys[1] = false; //Right
  keys[2] = false; //Ctrl

  platforms = new ArrayList<Platform>();

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
  worldCamera.drawWorld();

  player1.update();
  ara1.update();

  controls();

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