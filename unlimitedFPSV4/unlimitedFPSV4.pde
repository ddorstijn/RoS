int TICKS_PER_SECOND = 60; //<>// //<>// //<>// //<>// //<>// //<>//
int SKIP_TICKS = 1000 / TICKS_PER_SECOND;
int MAX_FRAMESKIP = 10;

int next_game_tick = millis();
int loops;

//Gloal variable INIT
JSONObject levels;
int level;

int time;
int score;

JSONArray levelData;
JSONArray turretData;
JSONArray movEnemyData;
JSONObject playerData;

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

//Call every class
Player player;
Camera worldCamera;
Ara ara;

void setup() {
  size(1650, 480, P2D);
  smooth(8);
  frameRate(1000);

  gridSize = 40;

  keysPressed = new boolean[256];

  platforms = new ArrayList<Platform>();
  turrets = new ArrayList<Turret>();
  movEnemy = new ArrayList<MovEnemy>();

  time = millis() / 1000;
  score = 0;

  pos = new PVector(0, 0);

  level = 1;
  setIndex = 0;

  loadLevel(true);

  worldCamera = new Camera();

  coins = new ArrayList<Collectable>();
  coins.add(new Collectable (width/2 + 70, 300, 10, 10));
  coins.add(new Collectable (70, 300, 10, 10));

  popUpFont = createFont("Arial", 72, true);
  statsFont = createFont("Arial", 14, true);
  timerFont = createFont("Segoe UI Semibold", 50);
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

  worldCamera.drawWorld();
  time = millis() / 1000;
}

void draw_game() {
  drawBackground(); //UIgrid();

  grid();
  levelBuild();

  //LEVEL
  pushMatrix();
  translate(-pos.x, -pos.y);

  //setuppreview();
  player.display();
  ara.display();
  for (Collectable b : coins) {
    if (b.right > pos.x && b.left < pos.x + width) {
      b.display();
    }
  }

  for (Turret b : turrets) {
    if (b.right > pos.x && b.left < pos.x + width) {
      b.display();
    }
  }

  for (MovEnemy o : movEnemy) {
    if (o.right > pos.x && o.left < pos.x + width) {
      o.display();
    }
  }

  // Display all platforms
  for (Platform b : platforms) {
    if (b.right > pos.x && b.left < pos.x + width) {
      b.display();
    }
  }

  popMatrix();

  pushStyle();
  textAlign(LEFT);
  textFont(statsFont);
  fill(255);
  text("fps: " + (int) frameRate, 10, 20);
  text("score: " + score, 10, 40);

  textAlign(CENTER, TOP);
  textFont(timerFont);
  text(time / 60 + ":" + nf(time % 60, 2), width/2, 0);
  popStyle();


  //////////////////////////////SUPER QUICK EASY LAZY FUCKING FIX
  if (shiftKey && mouseButton == RIGHT) {
    if (setIndex < 4) {
      for (Platform b : platforms) {
        if (b.isOver()) {
          platforms.remove(b);
          levelData.remove(b.value);
          saveJSONObject(levels, "data/level" + level + ".json");
          loadLevel(false);
          break;
        }
      }
    } else if (setIndex == 4) {
      for (Turret t : turrets) {
        if (t.isOver()) {
          turrets.remove(t);
          turretData.remove(t.value);
          saveJSONObject(levels, "data/level" + level + ".json");
          loadLevel(false);
          break;
        }
      }
    } else if (setIndex == 5) {
      for (MovEnemy t : movEnemy) {
        if (t.isOver()) {
          movEnemy.remove(t);
          movEnemyData.remove(t.value);
          saveJSONObject(levels, "data/level" + level + ".json");
          loadLevel(false);
          break;
        }
      }
    }
  }
}