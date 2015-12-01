import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RedemtionOfSageREMASTERED extends PApplet {

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

boolean paused, collisionObject, changeLevel;

JSONArray levelData;
JSONArray turretData;
JSONArray movEnemyData;
JSONObject playerData;
JSONArray coinData;

ScoreList highscores = new ScoreList();

PVector gravity, pos;
float friction; //Same goes for friction

PFont popUpFont, statsFont, timerFont;
boolean[] keysPressed; //Keys Pressed
boolean shiftKey;  //Check Shift-key
int setIndex; //While building check index that needs to be set

// Basic collision detection method
public boolean collisionDetect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}

// Basic collision detection method
public float calculate1DOverlap(float p0, float p1, float d0, float d1) {
  float dl = p0+d0-p1, dr = p1+d1-p0;  
  return (dr<0 || dl<0) ? 0 : (dr >= dl) ? -dl : dr; 
}

float beginX, endX, beginY, endY, gridSize; //Size of the grid the game is built around
String userInput = "";

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

public void setup() {
  
  surface.setResizable(true);
  
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

public void draw() {

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

public void update_game() {
  if (level != 0) {
    player.update();
    ara.update();

    for (Collectable coin : coins) {
      coin.update();
      if (collisionObject){
        collisionObject = false;
        coins.remove(coin);
        break;
      }
    }

    for (Turret turret : turrets) {
      turret.update();
    }

    for (MovEnemy o : movEnemy) {
      o.update();
    }

    for (Platform b : platforms) {
      b.update();
      if (changeLevel) {
        if (level < 3) {
          level ++;
          setIndex = 0;
          loadLevel(true);
          changeLevel = false;
          break;
        } else {
          highscores.addScore(userInput, score);
          highscores.save("highscore.csv");
          highscores.load("highscore.csv");
          menu.subMenu = 3;
          level = 0;
          lives = 3;
          changeLevel = false;
          break;
        }
      }
    }

    for (bullet b : bullet) {
      b.update();
      if (collisionObject){
        collisionObject = false;
        bullet.remove(b);
        break;
      }
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

public void draw_game() {
  drawBackground(); //

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
class Ara {

  //DECLARE
  //Starting proportions
  float aWidth, aHeight, startX, startY;

  //Vectors
  PVector location, velocity;

  //Booleans
  boolean isCarried; //For ara
  boolean[] powerUpActivated;

  //OBJECT
  Ara(float _x, float _y) {
    //INITIALIZE
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1f);

    startX = _x;
    startY = _y;

    aWidth = 20;
    aHeight = 20; 

    isCarried = false;
    powerUpActivated = new boolean[2];
  }


  //FUNCTIONS
  public void update() {
    araUpdatePosition();
    collisionDetection();
  }

  public void display() {
    noStroke();
    fill(255, 255, 0);
    rectMode(CORNER); 
    rect(location.x, location.y, aWidth, aHeight);
  }

  public void araUpdatePosition() {
    location.add(velocity); //Speed
    velocity.add(gravity); //Gravity
    velocity.x *= friction;

    if (velocity.y > 5) {
      velocity.y = 5;
    }

    //Respawn
    if (location.y > height) {
      respawn();
    }
  }

  public void respawn() {
    location.x = startX;
    location.y = startY;

    velocity.mult(0);
  }

  public void powerUps() {
    if (powerUpActivated[0]) { 
      location.y -= 20;
      aHeight = 40;
    } else {     
      location.y += 20;
      aHeight = 20;
    } 
  }

  public void collisionDetection() {
    for (Platform other : platforms) {
      float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.iWidth);
      float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.iHeight);

      if (abs(xOverlap) > 0 && abs(yOverlap) > 0) {
        // Determine wchich overlap is the largest
        if (abs(xOverlap) > abs(yOverlap)) {
          location.y += yOverlap; // adjust player x - position based on overlap
          velocity.y = 0;
        } else {
          location.x += xOverlap; // adjust player y - position based on overlap
          velocity.x *= -1;
        }
      }
    }

    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, aWidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, aHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0 && !isCarried) {
      if (abs(xOverlap)-2 > abs(yOverlap)) {
        //If bottom collision
        if (velocity.y > 0) {
          location.y -= yOverlap; // adjust player x - position based on overlap
          velocity.y = 0;
        } else 
          player.location.y += yOverlap;
          
        //If top collision
        if (player.location.y < location.y) {
          player.velocity.y = 0; 
          player.canJump = true;
        }
      } else {
        player.location.x += xOverlap; // adjust player y - position based on overlap
        if (!powerUpActivated[0]) {
          velocity.x = player.velocity.x;  
        } else 
          player.velocity.x = 0;
      }
    }   
  }
}
public void drawBackground() {
  background(25, 41, 67); //Drawing background
}

public void grid() {
  if (shiftKey == true) {  //If in buildmode 
    //horizontal gridlines
    for (int i = 0; i < height/gridSize; i++) { //Number of lines that have to be drawn is calculated by dividing the height by the gridsize. eg; 800 / 40 = 20 lines
      stroke(255, 0, 0);
      line(0, i * gridSize, width, i * gridSize);
    }

    //vertical lines
    for (int i = 0; i < width / gridSize + 1; i ++) {
      float lx;
      lx = i * gridSize - (pos.x % gridSize);
      line(lx, 0, lx, height);
    }
  }
}
class Camera {

  public void drawWorld() {
    if (player.location.x - width/2 > 0) {
      pos.x = player.location.x - width/2; //Because camera is alligned to the left of the screen. Update camera to player pos
    } else {
      pos.x = 0;
    }
  }
}
class Collectable {

  //DECLARE
  //Vectors
  PVector location;

  float cwidth, cheight;
  
  int value;

  Collectable(float _x, float _y, float _width, float _height, int value) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    cwidth = _width;
    cheight = _height;

    this.value = value;
  }


  //FUNCTIONS
  public void update() {
    collision();
  }

  public void display() {
    fill(255, 255, 0);
    ellipseMode(CORNER);
    ellipse(location.x, location.y, cwidth, cheight);
  }

  public void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, cwidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, cheight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      score += 100; 
      collisionObject = true;
      location.x = -100;
    } 
  } 
}
public void keyPressed() {

  keysPressed[keyCode] = true;

  if (key != CODED && level == 0 && menu.subMenu == 4)
    userInput += key;
  if (keysPressed[' '] && level == 0 && menu.subMenu == 4) {
    level = 1;
    setIndex = 0; 
    loadLevel(true);
  }

  if (keysPressed[90]) {
    ara.powerUpActivated[0] = !ara.powerUpActivated[0];
    ara.powerUps();
  }

  if (keyCode == 16 && level != 0 && menu.subMenu != 4) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  if (keysPressed[77]) {
    menu.subMenu = 0;
    level = 0;
  }

  if (keyCode == 80 && level != 0 && menu.subMenu != 4) {
    paused = !paused;

    accumTime = accumTime + millis() - startTime;
  }

  if (keysPressed[83] && level != 1 && level != 0) { 
    level = 1;
    setIndex = 0; 
    loadLevel(true);
  }
  if (keysPressed[68] && level != 2 && level != 0) { 
    level = 2;
    setIndex = 0;
    loadLevel(true);
  }
  if (keysPressed[70] && level != 3 && level != 0) { 
    level = 3;
    setIndex = 0;
    loadLevel(true);
  }

  if (level == 0) {
    if (keyCode == DOWN) {
      menu.mpos++;
    }
    if (keyCode == UP) {
      menu.mpos--;
    }
  }
}

public void keyReleased() {
  keysPressed[keyCode] = false;
  menu.enteredMenu = false;
}

int playerIndex = 0;
  // add score, save scores and load scores by typing space, 's' or 'l'
  public void keyTyped() {
    if (key == 's') highscores.save("highscore.csv");
    if (key == 'l') highscores.load("highscore.csv");
  }

//Level building!
public void mousePressed() {
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

  if (shiftKey && mouseButton == LEFT) {
    //Take first mouse position after clicked and allign it to the grid
    beginX = Math.round((pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

public void mouseReleased() {
  if (shiftKey == true && mouseButton == LEFT) { 
    //Take position of the mouse when released and allign it to the grid
    endX = Math.round((pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    if (setIndex < 4) {
      // Create a new JSON platform object
      JSONObject newPlatform = new JSONObject();


      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX);
      position.setFloat("y", beginY);
      position.setFloat("width", endX);
      position.setFloat("height", endY);

      // Add position to platform
      newPlatform.setJSONObject("position", position);
      newPlatform.setInt("index", setIndex);
      newPlatform.setInt("value", levelData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray platformData = levels.getJSONArray("platforms");
      platformData.append(newPlatform);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
    } else if (setIndex == 4) {
      // Create a new JSON platform object
      JSONObject newTurret = new JSONObject();


      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX);
      position.setFloat("y", beginY);
      position.setFloat("width", endX);
      position.setFloat("height", endY);

      // Add position to platform
      newTurret.setJSONObject("position", position);
      newTurret.setInt("index", setIndex);
      newTurret.setInt("value", turretData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray turretData = levels.getJSONArray("turrets");
      turretData.append(newTurret);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
      println("level loaded");
    } else if (setIndex == 5) {
      // Create a new JSON platform object
      JSONObject newMovEnemy = new JSONObject();


      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX);
      position.setFloat("y", beginY);
      position.setFloat("width", endX);
      position.setFloat("height", endY);

      // Add position to platform
      newMovEnemy.setJSONObject("position", position);
      newMovEnemy.setInt("index", setIndex);
      newMovEnemy.setInt("value", movEnemyData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray movEnemyData = levels.getJSONArray("MovEnemy");
      movEnemyData.append(newMovEnemy);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
      println("level loaded");
    } else if (setIndex == 6) {
      // Create a new JSON platform object
      JSONObject newCoin = new JSONObject();

      // Create a new JSON position object
      JSONObject position = new JSONObject();
      position.setFloat("x", beginX + gridSize/2);
      position.setFloat("y", beginY + gridSize/2);
      position.setFloat("width", 10);
      position.setFloat("height", 10);

      // Add position to platform
      newCoin.setJSONObject("position", position);
      newCoin.setInt("index", setIndex);
      newCoin.setInt("value", movEnemyData.size() + 1);

      // Append the new JSON bubble object to the array
      JSONArray coinsData = levels.getJSONArray("coins");
      coinsData.append(newCoin);

      // Save new data
      saveJSONObject(levels, "data/level" + level + ".json");
      loadLevel(false);
      println("level loaded");
    }
  }
}


public void levelBuild() {
  if (mousePressed && mouseButton == LEFT && shiftKey == true) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, abs(pos.x+mouseX-beginX), mouseY-beginY);
    popMatrix();
  }

  if (keysPressed['1']) {
    setIndex = 1;
  }
  if (keysPressed['2']) {
    setIndex = 2;
  }
  if (keysPressed['3']) {
    setIndex = 3;
  }
  if (keysPressed['4']) {
    setIndex = 4;
  }
  if (keysPressed['5']) {
    setIndex = 5;
  }
  if (keysPressed['6']) {
    setIndex = 6;
  }
}
public void loadLevel(boolean objectsToo) {

  for (int i = 0; i < keysPressed.length; i++) {
    keysPressed[i] = false;
  }

  if (level == 0) {
  } else {
    levels = loadJSONObject("level" + level + ".json");

    levelData = levels.getJSONArray("platforms");
    turretData = levels.getJSONArray("turrets");
    movEnemyData = levels.getJSONArray("MovEnemy");
    coinData = levels.getJSONArray("coins");
    JSONObject playerData = levels.getJSONObject("player");
    JSONObject araData = levels.getJSONObject("ara");

    if (objectsToo == true) {
      player = new Player(playerData.getInt("x"), playerData.getInt("y"));
      ara = new Ara(araData.getInt("x"), araData.getInt("y"));
    }

    if (setIndex < 4) {
      platforms.removeAll(platforms);

      for (int i = 0; i < levelData.size(); i++) {
        // Get each object in the array
        JSONObject platform = levelData.getJSONObject(i); 
        // Get a position object
        JSONObject position = platform.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float Pwidth = position.getFloat("width");
        float Pheight = position.getFloat("height");

        // Get index
        int index = platform.getInt("index");

        // Put object in array
        platforms.add(new Platform(x, y, Pwidth, Pheight, index, i));
      }
    } 

    if (setIndex == 4 || setIndex == 0) {
      turrets.removeAll(turrets);

      for (int i = 0; i < turretData.size(); i++) {
        // Get each object in the array
        JSONObject turret = turretData.getJSONObject(i); 
        // Get a position object
        JSONObject position = turret.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float Twidth = position.getFloat("width");
        float Theight = position.getFloat("height");

        // Put object in array
        turrets.add(new Turret(x, y, Twidth, Theight, i));
      }
    }

    if (setIndex == 5 || setIndex == 0) {
      movEnemy.removeAll(movEnemy);

      for (int i = 0; i < movEnemyData.size(); i++) {
        // Get each object in the array
        JSONObject movEnemyObject = movEnemyData.getJSONObject(i); 
        // Get a position object
        JSONObject position = movEnemyObject.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float aWidth = position.getFloat("width");
        float aHeight = position.getFloat("height");

        // Put object in array
        movEnemy.add(new MovEnemy(x, y, aWidth, aHeight, i));
      }
    }

    if (setIndex == 6 || setIndex == 0) {
      coins.removeAll(coins);

      for (int i = 0; i < coinData.size(); i++) {
        // Get each object in the array
        JSONObject coinObject = coinData.getJSONObject(i); 
        // Get a position object
        JSONObject position = coinObject.getJSONObject("position");
        // Get properties from position
        float x = position.getFloat("x");
        float y = position.getFloat("y");
        float aWidth = position.getFloat("width");
        float aHeight = position.getFloat("height");

        // Put object in array
        coins.add(new Collectable (x, y, aWidth, aHeight, i));
      }

      if (setIndex == 0) {
        setIndex = 1;
      }
    }
  }
}
class Button {
  PVector location;

  float Width, Height;
  String[] mainMenu, levelSelect, credits;
  String currentMenu;
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space, subMenu;

  boolean enteredMenu;

  Button() {
    location = new PVector(width/2, height/2);

    mainMenu = new String[5];
    levelSelect = new String[4];
    credits = new String[5];

    menuFontSize = 24;
    menuFont = createFont("Linux Libertine G Semibold", menuFontSize);
    menuPopup = createFont("Linux Libertine G Semibold", 72);

    mpos = 0;
    space = 50;

    subMenu = 0;
    enteredMenu = false;

    currentMenu = "mainMenu";

    mainMenu[0] = "Start";
    mainMenu[1] = "Level Select";
    mainMenu[2] = "Credits";
    mainMenu[3] = "Highscores";
    mainMenu[4] = "Exit";

    levelSelect[0] = "Level 1";   
    levelSelect[1] = "Level 2";
    levelSelect[2] = "Level 3";
    levelSelect[3] = "Go Back";

    credits[0] = "Koen";
    credits[1] = "Jamy";
    credits[2] = "Tricia";
    credits[3] = "Florian";
    credits[4] = "Danny";
  }

  public void update() {
    switch (currentMenu) {
    case "mainMenu":
      if (mpos > mainMenu.length) {
        mpos = 0;
        break;
      }
      if (mpos < 0) {
        mpos = mainMenu.length;
        break;
      }
    case "levelSelect":
      if (mpos > levelSelect.length - 1) {
        mpos = 0;
      } 
      if (mpos<0) {
        mpos = levelSelect.length - 1;
        break;
      }
    }

    if (keysPressed[67] && !enteredMenu && level == 0) {
      switch (subMenu) {
        //If in main menu
      case 0:
        switch (mpos) {
          //If cursor is on Start Game set level to 1
        case 0:
          subMenu = 4;
          mpos = 0;
          enteredMenu = true;
          // level = 1;
          // setIndex = 0;
          // loadLevel(true);
          break;
          //If cursor is on Level Select go to Level Select menu
        case 1:
          subMenu = 1;
          mpos = 0;
          enteredMenu = true;
          break;
          //If on Credits fo to credits
        case 2:
          subMenu = 2;
          mpos = 0;
          enteredMenu = true;
          break;
          //If on Higschore show highscore
        case 3:
          subMenu = 3;
          highscores.load("highscore.csv");
          break;
          //Exit
        case 4:
          exit();
          break;
        }
        break;
        //If in levelSelect
      case 1:
        switch (mpos) {
        case 0:
          level = 1;
          setIndex = 0;
          loadLevel(true);
          break;
        case 1:
          level = 2;
          setIndex = 0;
          loadLevel(true);
          break;
        case 2:
          level = 3;
          setIndex = 0;
          loadLevel(true);
          break;
        case 3:
          subMenu = 0;
          mpos = 0;
          enteredMenu = true;
          break;
        }
        break;
      //Credits
      case 2:
        if (keyPressed) {
          subMenu = 0;
          enteredMenu = true;
        }
        break;
      }
    }
  }

  public void display() {
    if (level == 0 && subMenu < 2) {
      fill(255, 0, 0);
      ellipse(location.x - 100, location.y + mpos * space, 15, 15);

      fill(0);
      textFont(menuPopup);
      textAlign(CENTER, CENTER);
      text("R O S", location.x, location.y - 100);
    }

    textFont(menuFont);

    if (level == 0 && subMenu == 0) {
      for (int i = 0; i < mainMenu.length; i++) {
        fill(0);
        text(mainMenu[i], location.x, location.y + i * space);
      }
    } else if (level == 0 && subMenu == 1) {
      for (int i = 0; i < levelSelect.length; i++) {
        fill(0);
        text(levelSelect[i], location.x, location.y + i * space);
      }
    } else if (level == 0 && subMenu == 2) {
      for (int i = 0; i < credits.length; i++) {
        fill(0);
        text(credits[i], location.x, location.y + i * space);
      }
    } else if (level == 0 && subMenu == 3) {
      // display header row
      fill(0);
      textSize(20);
      text("Place        Name        Score", width/2, 70);

      textSize(16);
      // for each score in list
      for (int iScore=0; iScore<highscores.getScoreCount(); iScore++) {
        // only show the top 10 scores
        if (iScore>=9) break;
        
        // fetch a score from the list
        Score score = highscores.getScore(iScore);

        // display score in window
        text((iScore+1) + "            " + score.name + "        " + score.score, width/2, 100 + iScore*20);
      }
    } else if (level == 0 && subMenu == 4) {
      text("Keep tying until password matches", width/2, 20);
      text("Enter text here: " + userInput, width/2, height/2 - 20);
    }
  }
}
class Platform {

  //DECLARE
  //Vectors
  PVector location;

  float iWidth, iHeight, mousex;

  int index, value;

  public boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + iWidth && mouseY >= location.y && mouseY < location.y + iHeight;
  }


  Platform(float _x, float _y, float _width, float _height, int _index, int _value) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    iWidth = _width;
    iHeight = _height;

    //If index = 1 it's a normal platform
    //If index = 2 it's a trap or stationary enemy
    //If index = 3 it's the finish!
    index = _index;

    //position int the arrayList
    value = _value;
  }


  //FUNCTIONS
  public void update() {  
    mousex = mouseX + pos.x;

    collision();
  }

  public void display() {

    noStroke();

    if (isOver() && shiftKey) {
      fill(0, 0, 255);
    } else { 
      switch (index) {
      case 1:     
        fill(0, 0, 0);
        break;
      case 2:
        fill(255, 0, 0);
        break;
      case 3:
        fill(0, 255, 0);
        break;
      }
    }

    rectMode(CORNER);
    rect(location.x, location.y, iWidth, iHeight);
  }

  public void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, iWidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, iHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      if (index == 2) {
        player.respawn();
      } else if (index == 3) {
        changeLevel = true;
      }
      if (abs(xOverlap) > abs(yOverlap)) {
        player.location.y += yOverlap; // adjust player x - position based on overlap
        //If bottom collision
        if (player.velocity.y < 0) {
          player.velocity.y = 0;
        }
        //If top collision
        if (player.location.y < location.y) {
          player.velocity.y = 0;
          player.canJump = true;
        }
      } else {
        player.location.x += xOverlap; // adjust player y - position based on overlap
        player.velocity.x = 0;
      }
    }
  }
}
class Player { 

  //DECLARE 
  float angle, pWidth, pHeight;

  //Vectors
  PVector location, velocity, start;

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if able to jump
  int colour;

  //OBJECT
  Player(int _x, int _y) {

    //INITIALIZE
    jumpSpeed = -4.1f;
    maxSpeed = 3;
    acceleration = 0.5f;

    canJump = true; //Check if ale to jump
    colour = 255; //White

    pWidth = 40;
    pHeight = 40;
    angle = 0;

    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1f);
    start = new PVector(_x, _y);
    friction = 0.9f;
  }


  //FUNCTIOMS
  public void update() {
    playerUpdatePosition();
    controls();
  }

  public void display() {
    noStroke(); //No outline
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects 
    translate(location.x + pWidth/2, location.y + pHeight/2); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(-pWidth/2, -pHeight/2, pWidth, pHeight); // character 
    popMatrix(); //End the drawing
  }

  public void playerUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    velocity.x *= friction;

    //Border left side of the level
    if (location.x < 0) {
      location.x = 0;
      velocity.x = 0;
    }

    if (velocity.y < 0 && angle <= PI / 2 && velocity.x >= 0 && angle > -(PI / 2)) {
      angle += 2 * PI / 360 * 8;
    } else if (velocity.y < 0 && angle >= -(PI / 2) && velocity.x < 0 && angle < PI / 2) {
      angle -= 2 * PI / 360 * 8;
    }

    if (angle > PI / 2) {
      angle = PI / 2;
    }
    if (angle < -PI / 2) {
      angle = -PI / 2;
    }

    if (canJump) {
      angle = 0;      
    }

    if (velocity.x > maxSpeed) {
      velocity.x = maxSpeed;
    } else if (velocity.x < -maxSpeed) {
      velocity.x = -maxSpeed;
    }

    if (location.y > height + 100) {
      respawn();
    }
  }

  public void respawn() {
    //lives--;
    location.set(start);
    velocity.set(0, 0);
  }

  public void controls() {
    if (velocity.y != 0.1f) {
      canJump = false;  
    }

    if (keysPressed[LEFT]) {  
      velocity.x -= acceleration;
    }
    if (keysPressed[RIGHT]) {
      velocity.x += acceleration;
    }
    if (keysPressed[67]) {
      if (canJump == true) {
        velocity.y = jumpSpeed;
        canJump = false; // Jump is possible
      }
    }

    //If x is pressed stick to the player
    if (keysPressed[88]) { 

      //stop moving
      ara.velocity.x = 0;
      ara.velocity.y = 0;

      //Move x to player x
      ara.location.x = location.x + pWidth/4;
      ara.location.y = location.y + pHeight/4;
      ara.powerUpActivated[0] = false;
      ara.powerUps();
      ara.isCarried = true;
    } else {
      ara.isCarried = false;
    }
  }
}
class bullet {
  float xBullet;
  float yBullet;
  float vBullet;
  float bWidth;
  float bHeight;
  float angle;
  float vx, vy;

  bullet(float tempXBullet, float tempYBullet, float tempVBullet, float tempAngle) {
    xBullet = tempXBullet;
    yBullet = tempYBullet;
    vBullet = tempVBullet;
    bWidth = 10;
    bHeight = 10;
    angle = tempAngle;

    if (player.location.y < tempYBullet) {
      vx = -(vBullet*sin(angle));
      vy = -(vBullet*cos(angle));
    } else {
      vx = (vBullet*sin(angle));
      vy = (vBullet*cos(angle));
    }
  }

  public void update() {
    move();
    collision();
  }

  public void display() {
    rect(xBullet, yBullet, bWidth, bHeight);
  }

  public void move() {
    xBullet = xBullet + vx;
    yBullet = yBullet + vy;
  }

  public void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, xBullet, player.pWidth, bWidth);
    float yOverlap = calculate1DOverlap(player.location.y, yBullet, player.pHeight, bHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      player.respawn();
      collisionObject = true;
      bullet.removeAll(bullet);
    } 

    for (Platform other : platforms) {
      xOverlap = calculate1DOverlap(other.location.x, xBullet, other.iWidth, bWidth);
      yOverlap = calculate1DOverlap(other.location.y, yBullet, other.iHeight, bHeight);

      // Determine wchich overlap is the largest
      if (xOverlap != 0 && yOverlap != 0) {
        collisionObject = true;
        break;
      } 
    }
  }
}
class MovEnemy {
  //DECLARE
  //Starting proportions
  float aWidth, aHeight, mousex; 

  //Vectors
  PVector location, velocity;

  //Position in array
  int value;

  public boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + aWidth && mouseY >= location.y && mouseY < location.y + aHeight;
  }

  // Enemy object
  MovEnemy (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);
    velocity = new PVector(0.5f, 0);
    gravity = new PVector(0, 0.1f);

    aWidth = _width;
    aHeight = _height;
    value = i;
  }

  //FUNCTIONS
  public void update() {  
    enemyUpdatePosition();
    collisionDetection();
  }

  public void display() {
    if (isOver() && shiftKey)
      fill(255, 0, 0);
    else 
      fill(113, 8, 151);

    rectMode(CORNER);
    rect(location.x, location.y, aWidth, aHeight);
  }

  public void enemyUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
  }

  public void collisionDetection() {
    for (Platform other : platforms) {
      float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.iWidth);
      float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.iHeight);

      if (abs(xOverlap) > 0 && abs(yOverlap) > 0) {
        // Determine wchich overlap is the largest
        if (abs(xOverlap) > abs(yOverlap)) {
          location.y += yOverlap; // adjust player x - position based on overlap
          velocity.y = 0;
        } else {
          location.x += xOverlap; // adjust player y - position based on overlap
          velocity.x *= -1;
        }
      }
    }   

    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, aWidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, aHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      player.respawn();
    }

  }
}



class Turret {
  //DECLARE
  //Starting proportions
  float twidth, theight, startX, startY, mousex;

  //Vectors
  PVector location;

  //Position in array
  int value;

  public boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + twidth && mouseY >= location.y && mouseY < location.y + theight;
  }

  // Turret object
  Turret (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    twidth = _width;
    theight = _height;

    value = i;
  }


  //FUNCTIONS
  public void update() {  
    mousex = mouseX + pos.x;

    collision();

    float dist = sqrt(sq(player.location.x-location.x) + sq(player.location.y - location.y) );
    if (dist < 300) {
      if (millis() % 5000 >= 0 && millis() % 2000 <= MAX_FRAMESKIP) {
        float angle =  atan((player.location.x-location.x) / (player.location.y-location.y));
        bullet.add(new bullet(location.x + twidth/2, location.y + theight/2, 3, angle));
      }
    }
  }

  public void display() {

    if (isOver() && shiftKey) {
      fill(255, 0, 0);
    } else { 
      fill(0, 0, 255);
    }
    rectMode(CORNER);
    rect(location.x, location.y, twidth, theight);
  }

  public void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, twidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, theight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      if (abs(xOverlap)-2 > abs(yOverlap)) {
        player.location.y += yOverlap; // adjust player x - position based on overlap
        //If bottom collision
        if (player.velocity.y < 0) {
          player.velocity.y = 0;
        }
        //If top collision
        if (player.location.y < location.y) {
          player.velocity.y = 0; 
          player.canJump = true;
        }
      } else {
        player.location.x += xOverlap; // adjust player y - position based on overlap
        player.velocity.x = 0;
      }
    }
  }
}

class Boss {

  int n;
  float cx, cy, r, angle;
  Boss(int n, float cx, float cy, float r) {
    this.angle = 360.0f / n;
    this.n = n;
    this.cx = cx;
    this.cy = cy;
    this.r =r;
  }

  public void display() {
    beginShape();
    for (int i = 0; i < n; i++) {
      vertex(cx + r * cos(radians(angle * i)), 
        cy + r * sin(radians(angle * i)));
      rect(cx - r/2,cy - r/2,20,40); 
      rect(cx + r/4,cy - r/2,20,40);  
      rect(cx - r/8, cy + r/3,20,20);
    }
    endShape(CLOSE);
  }
}


// A single score
class Score {
  // has the name of the player
  String name;
  // and his/her score
  int score;

  // Constructor
  Score(String name, int score) {
    this.name = name;
    this.score = score;
  }
}

// ScoreList class manages a list of scores
class ScoreList {
  ArrayList<Score> scores = new ArrayList<Score>();
  Table scoreTable;

  // Constructor
  ScoreList() {
    scoreTable = new Table();
    scoreTable.addColumn("name");
    scoreTable.addColumn("score");
  }

  // Create a new Score and add it to the scores ArrayList
  public void addScore(String name, int score) {
    // Add a new score object to the scores ArrayList
    scores.add(new Score(name, score));
    // Sort the scores ArrayList after each score is added
    sortScores();
  }

  // return amount of scores in scores ArrayList 
  public int getScoreCount(){
    return scores.size();
  }

  // return the score at iScore
  public Score getScore(int iScore){
    return scores.get(iScore);
  }
  
  // Sort the scores ArrayList
  public void sortScores() {  
    Collections.sort(scores, new HSComperator());
  }

  // Save scores to file named "scoreFileName"
  public void save(String scoreFileName) {
    // Copy scores from ArrayList to table
    for (Score score : scores) {
      TableRow row = scoreTable.addRow();
      row.setString("name", score.name);
      row.setInt("score", score.score);
    }
    
    // save the table to file
    saveTable(scoreTable, scoreFileName);
  }
  
  
  // Load scores from file called "scoreFileName"
  public void load(String scoreFileName) {
    
    // Load the scores into the Table object
    scoreTable = loadTable(scoreFileName, "header");
    
    // clear scores ArrayList
    scores.clear();
    
    // copy scores from table to the scores array
    for (int iScore=0; iScore<scoreTable.getRowCount(); iScore++) {
      TableRow row = scoreTable.getRow(iScore);
      scores.add(new Score(row.getString("name"), row.getInt("score")));
    }
  }
}


// Comperator class is needed in order for processing to know how
// to sort a list of scores
class HSComperator implements Comparator<Score> {
  @Override
    public int compare(Score o1, Score o2) {
    return o2.score - o1.score;
  }
}

  public void settings() {  size(1200, 600, P2D);  smooth(8); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RedemtionOfSageREMASTERED" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
