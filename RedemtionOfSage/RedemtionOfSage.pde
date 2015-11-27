int TICKS_PER_SECOND = 60; //<>//
int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
int MAX_FRAMESKIP = 10;

int next_game_tick = millis();
int loops;

//Gloal variable INIT
JSONObject levels;
int level;

int accumTime;   // total time accumulated in previous intervals
int startTime;   // time when this interval started
int displayTime;   // value to display on the clock face

int score;
int lives;

boolean paused;

JSONArray levelData;
JSONArray turretData;
JSONArray movEnemyData;
JSONObject playerData;
JSONArray coinData;

PVector gravity, pos;
float friction; //Same goes for friction

PFont popUpFont, statsFont, timerFont;
boolean[] keysPressed; //Keys Pressed
boolean shiftKey;  //Check Shift-key
int setIndex; //While building check index that needs to be set

// Basic collision detection method
boolean collisionDetect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}

float beginX, endX, beginY, endY, gridSize; //Size of the grid the game is built around

ArrayList<Platform> platforms;
ArrayList<Collectable> coins;
ArrayList<Turret> turrets;
ArrayList<MovEnemy> movEnemy;
ArrayList<bullet> bullet;

//Call every class
Player player;
Camera worldCamera;
Ara ara;
Boss boss;
Button menu;

void setup() {
  size(1200, 600, P2D);
  surface.setResizable(true);
  smooth(8);
  frameRate(1000);

  gridSize = 40;

  keysPressed = new boolean[256];

  platforms = new ArrayList<Platform>();
  turrets = new ArrayList<Turret>();
  movEnemy = new ArrayList<MovEnemy>();
  bullet = new ArrayList<bullet>();
  coins = new ArrayList<Collectable>();
  boss = new Boss(6, 170, 180, 5);

  statsFont = createFont("Arial", 14, true);
  timerFont = createFont("Segoe UI Semibold", 50, true);

  score = 0;
  lives = 3;

  pos = new PVector(0, 0);

  setIndex = 0;
  level = 0;

  loadLevel(true);

  worldCamera = new Camera();
  menu = new Button();
}

void draw() {

  if (paused == false && level != 0) {
   displayTime = accumTime + millis() - startTime;
  }
  if (paused == true) {
    startTime = millis();
  }

  loops = 0;
  while (millis () > next_game_tick && loops < MAX_FRAMESKIP) {
    if (!paused) { 
      update_game();
    }

    next_game_tick += SKIP_TICKS;
    loops++;
  }

  draw_game();
}

void update_game() {
  if (level != 0) {
    player.update();
    ara.update();

    for (Collectable coin : coins) {
      coin.update();
    }

    for (Turret turret : turrets) {
      turret.update();
    }

    for (MovEnemy o : movEnemy) {
      o.update();
    }

    for (Platform b : platforms) {
      b.update();
    }

    for (bullet b : bullet) {
      b.update();
    }

    worldCamera.drawWorld();
  }

  menu.update();

  if (lives < 1) {
    menu.subMenu = 0;
    level = 0;
    lives = 3;
  }
}

void draw_game() {
  drawBackground(); //UIgrid();

  if (level != 0) {
    grid();

    //LEVEL
    pushMatrix();
    translate(-pos.x, -pos.y);

    levelBuild();

    //setuppreview();
    player.display();
    ara.display();
    for (Collectable b : coins) {
      b.display();
    }

    for (Turret b : turrets) {
      b.display();
    }

    for (MovEnemy o : movEnemy) {
      o.display();
    }

    // Display all platforms
    for (Platform b : platforms) {
      b.display();
    }

    for (bullet b : bullet) {
      b.display();
    }

    popMatrix();

    pushStyle();
    textAlign(LEFT);
    textFont(statsFont);
    textSize(14);
    fill(255);
    text("fps: " + (int) frameRate, 10, 20);
    text("score: " + score, 10, 40);

    textAlign(CENTER, TOP);
    textFont(timerFont);
    text(displayTime / 1000/ 60 + ":" + nf(displayTime / 1000 % 60, 2), width/2, 0);

    if (paused) {
      text("Paused", width/2, height/2);
    }

    for (int i = 0; i < lives; i++) {
      noStroke();
      fill(255, 0, 0);
      beginShape();
      vertex(width-100 + i * 40, 10);
      bezierVertex(width-100 + i * 40, -5, width-140 + i * 40, 10, width-100 + i * 40, 30);
      vertex(width-100 + i * 40, 10);
      bezierVertex(width-100 + i * 40, -5, width-60 + i * 40, 10, width-100 + i * 40, 30);
      endShape();
    }

    popStyle();
  } else {
    startTime = millis();
  }

  menu.display();
}