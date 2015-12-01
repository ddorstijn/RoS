import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RedemtionOfSage extends PApplet {

int TICKS_PER_SECOND = 60; //<>// //<>// //<>//
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

boolean paused, bulletCollision;

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
public boolean collisionDetect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}

public boolean CircleRectCollision(float circleX, float circleY, float radius, float rectangleX, float rectangleY, float rectangleWidth, float rectangleHeight){
    
  float circleDistanceX = abs(circleX - rectangleX - rectangleWidth/2); 
  float circleDistanceY = abs(circleY - rectangleY - rectangleHeight/2); 

  if (circleDistanceX > (rectangleWidth/2 + radius)) { 
    return false;
  } 

  if (circleDistanceY > (rectangleHeight/2 + radius)) { 
    return false;
  } 

  if (circleDistanceX <= (rectangleWidth/2)) { 
    return true;
  }  

  if (circleDistanceY <= (rectangleHeight/2)) { 
    return true;
  }

  float cornerDistance_sq = pow(circleDistanceX - rectangleWidth/2, 2) + 
    pow(circleDistanceY - rectangleHeight/2, 2); 

  return (cornerDistance_sq <= pow(radius, 2)); 
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
      if (bulletCollision) {
        bulletCollision = false;
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
      if (bulletCollision) {
        bulletCollision = false;
        break;
      }
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

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

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

    //Bounding box creation
    left = location.x; //Left side of the box
    right = location.x + aWidth; //Right side of the box
    top = location.y; //Top of the box
    bottom = location.y + aHeight; //Bottom of the box

    //Same as above but then calculated for the next frame. So de Next position
    nLeft = left + velocity.x;
    nRight = right + velocity.x;
    nTop = top + velocity.y;
    nBottom = bottom + velocity.y;
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

    left = location.x;
    right = location.x + aWidth;
    top = location.y;
    bottom = location.y + aHeight;

    nLeft = left + velocity.x;
    nRight = right + velocity.x;
    nTop = top + velocity.y;
    nBottom = bottom + velocity.y;

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
    if (powerUpActivated[0]) { //<>//
      location.y -= 20;
      aHeight = 40;
    } else {     
      location.y += 20;
      aHeight = 20;
    } //<>// //<>//
  }

  public void collisionDetection() {
    // Display all bubbles
    for (Platform other : platforms) {

      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.y > 0) {
          bottom -= aHeight /2;
          if (bottom < other.top && nBottom > other.top && location.x > other.location.x - aHeight/2 + 1 && location.x < other.location.x + other.iWidth + aHeight/2 - 1) {// If player collides from top side
            velocity.y = 0;
            bottom = top;
          }
        } 
        if (velocity.x > 0) {// If player collides from right side
          right -= aWidth/2;
          if (right < other.left && nRight > other.left && location.y > other.location.y - aWidth/2) {// If player collides from left side
            velocity.x = 0;
          }
        }       
        if (velocity.x < 0) {// If player collides from right side
          left += aWidth/2;
          if (left > other.right && nLeft < other.right && location.y > other.location.y - aWidth/2) {// If player collides from left side
            velocity.x = 0;
          }
        }
        if (top >= other.bottom && nTop <= other.bottom && location.x > other.location.x - aHeight/2 + 1 && location.x < other.location.x + other.iWidth + aHeight - 1) {// If player collides from bottom side
          velocity.y = 0;
        }

        if (other.index == 2) {
          respawn();
        }
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
public void keyPressed() {

  keysPressed[keyCode] = true;

  if (keysPressed[90]) {
    ara.powerUpActivated[0] = !ara.powerUpActivated[0];
    ara.powerUps();
  }

  if (keyCode == 16) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  if (keyCode == 80) {
    paused = !paused;

    accumTime = accumTime + millis() - startTime;
  }

  if (keysPressed[83] && level != 1) { 
    level = 1;
    setIndex = 0; 
    loadLevel(true);
  }
  if (keysPressed[68] && level != 2) { 
    level = 2;
    setIndex = 0;
    loadLevel(true);
  }
  if (keysPressed[70] && level != 3) { 
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

    mainMenu = new String[4];
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
    mainMenu[3] = "Exit";

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
      if (mpos > mainMenu.length - 1) {
        mpos = 0;
        break;
      }
      if (mpos < 0) {
        mpos = mainMenu.length - 1;
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

    if (keysPressed[' '] && !enteredMenu && level == 0) {
      switch (subMenu) {
        //If in main menu
      case 0:
        switch (mpos) {
          //If cursor is on Start Game set level to 1
        case 0:
          level = 1;
          setIndex = 0;
          loadLevel(true);
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
          //If on Exit exit game
        case 3:
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
    }
  }
}
class Platform {

  //DECLARE
  //Vectors
  PVector location;

  float iWidth, iHeight;
  float left, right, top, bottom, mousex;

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

    left = location.x;
    right = location.x + iWidth;
    top = location.y;
    bottom = location.y + iHeight;

    //position int the arrayList
    value = _value;
  }


  //FUNCTIONS
  public void update() {  
    mousex = mouseX + pos.x;
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
}
class Player { 

  //DECLARE
  int diameter; 
  float radius, angle;

  //Start position
  int startX, startY;

  //Vectors
  PVector location, velocity, nlocation;

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if able to jump
  int colour;

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;
  float otherX, otherY, otherwidth, otherheight;


  //OBJECT
  Player(int _x, int _y) {

    //INITIALIZE
    startX = _x;
    startY = _y;    

    jumpSpeed = -4.1f;
    maxSpeed = 3;
    acceleration = 0.5f;

    canJump = true; //Check if ale to jump
    colour = 255; //White

    diameter = 40; 
    radius = diameter / 2;
    angle = 0;

    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1f);
    nlocation = PVector.add(location, velocity);
    friction = 0.9f;

    left = location.x - radius; //Left side of player
    right = location.x + radius; //Right side of player
    top = location.y - radius; //Top side of player
    bottom = location.y + radius; //Bottom side of player
  }


  //FUNCTIOMS
  public void update() {
    playerUpdatePosition();
    collisionDetection();
    controls();
  }

  public void display() {
    noStroke(); //No outline
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects
    rectMode(CENTER); 
    translate(location.x, location.y); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(0, 0, diameter, diameter); // character 
    popMatrix(); //End the drawing

    fill(0, 255, 0);
    rect(otherX, otherY, otherwidth, otherheight);
  }

  public void playerUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    velocity.x *= friction;
    nlocation = PVector.add(location, velocity);

    //Border left side of the level
    if (location.x < 0 + radius) {
      location.x = 0 + radius;
      velocity.x = 0;
    }

    if (velocity.x > maxSpeed) {
      velocity.x = maxSpeed;
    } else if (velocity.x < -maxSpeed) {
      velocity.x = -maxSpeed;
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

    left = location.x - radius;
    right = location.x + radius;
    top = location.y - radius;
    bottom = location.y + radius;

    nLeft = nlocation.x - radius;
    nRight = nlocation.x + radius;
    nTop = nlocation.y - radius;
    nBottom = nlocation.y + radius;

    if (location.y > height + 100) {
      respawn();
    }
  }

  public void respawn() {
    lives--;

    location.x = startX;
    location.y = startY;

    velocity.set(0, 0);
  }

  public void controls() {
    if (keysPressed[LEFT]) {  
      velocity.x -= acceleration;
    }
    if (keysPressed[RIGHT]) {
      velocity.x += acceleration;
    }
    if (keysPressed[' ']) {
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
      ara.location.x = location.x - radius/2;
      ara.location.y = location.y - radius/2;
      ara.isCarried = true;
    }
  }


  public void collisionDetection() {

    canJump = false;

    for (Collectable coin : coins) {
      if (collisionDetect(nLeft, nTop, nRight, nBottom, coin.left, coin.top, coin.right, coin.bottom)) {
        score += 100;
        coins.remove(coin);
        break;
      }
    }

    for (bullet b : bullet) {
      if (b.hit()) {
        respawn();
        bullet.removeAll(bullet);
        break;
      }
    }

    for (MovEnemy other : movEnemy) {
      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.nLeft, other.nTop, other.nRight, other.nBottom)) {
        respawn();
      }
    }

    for (Platform other : platforms) {

      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.y > 0) {
          if (bottom < other.top && nBottom > other.top && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.iWidth + radius - 1) {// If player collides from top side
            velocity.y = 0;
            bottom = top;
            canJump = true;
            angle = 0;
          }
        } 
        if (velocity.x > 0) {// If player collides from right side
          right -= radius;
          if (right < other.left && nRight > other.left && location.y > other.location.y - radius) {// If player collides from left side
            velocity.x = 0;
            location.x = other.location.x - radius;
          }
        }       
        if (velocity.x < 0) {// If player collides from right side
          left += radius;
          if (left > other.right && nLeft < other.right && location.y > other.location.y - radius) {// If player collides from left side
            velocity.x = 0;
            location.x = other.right + radius;
          }
        }
        if (top > other.bottom && nTop <= other.bottom && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.iWidth + radius - 1) {// If player collides from bottom side
          velocity.y = 0;
        }

        if (other.index == 2) {

          respawn();
        }

        if (other.index == 3) {
          if (level < 4) {
            level += 1;
            setIndex = 0; 
            loadLevel(true);
            break;
          }
        }
      }
    }

    // Display all platforms
    for (Turret other : turrets) {

      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.y > 0) {
          if (bottom < other.top && nBottom > other.top && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.twidth + radius - 1) {// If player collides from top side
            velocity.y = 0;
            bottom = top;
            canJump = true;
            angle = 0;
          }
        } 
        if (velocity.x > 0) {// If player collides from right side
          right -= radius;
          if (right < other.left && nRight > other.left && location.y > other.location.y - radius) {// If player collides from left side
            velocity.x = 0;
            location.x = other.location.x - radius;
          }
        }       
        if (velocity.x < 0) {// If player collides from right side
          left += radius;
          if (left > other.right && nLeft < other.right && location.y > other.location.y - radius) {// If player collides from left side
            velocity.x = 0;
            location.x = other.right + radius;
          }
        }
        if (top > other.bottom && nTop <= other.bottom && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.twidth + radius - 1) {// If player collides from bottom side
          velocity.y = 0;
        }
      }
    }

    ///////////////////////////////////////////// ARA  /////////////////////////////////////////////

    if (collisionDetect(nLeft, nTop, nRight, nBottom, ara.left, ara.top, ara.right, ara.bottom) && ara.aHeight == 20) {
      if (velocity.y > 0) {
        bottom -= radius;
        if (bottom < ara.top && nBottom > ara.top && location.x > ara.location.x - radius + 1 && location.x < ara.location.x + ara.aWidth + radius - 1) {// If player collides from top side
          velocity.y = 0;
          bottom = top;
          canJump = true;
          angle = 0;
        }
      } 
      if (velocity.x > 0) {// If player collides from right side
        right -= radius;
        if (right < ara.left && nRight > ara.left && location.y > ara.location.y - radius) {// If player collides from left side
          ara.location.x = location.x + radius; 
          ara.velocity.x = velocity.x; //Push ara
        }
      }       
      if (velocity.x < 0) {// If player collides from right side
        left += radius;
        if (left > ara.right && nLeft < ara.right && location.y > ara.location.y - radius) {// If player collides from left side
          ara.location.x = location.x - radius - ara.aWidth;
          ara.velocity.x = velocity.x;
        }
      }
    }

    if (collisionDetect(nLeft, nTop, nRight, nBottom, ara.left, ara.top, ara.right, ara.bottom) && ara.powerUpActivated[0]) {
      if (velocity.y > 0) {
        bottom -= radius;
        if (bottom < ara.top && nBottom > ara.top && location.x > ara.location.x - radius + 1 && location.x < ara.location.x + ara.aWidth + radius - 1) {// If player collides from top side
          velocity.y = 0;
          bottom = top;
          canJump = true;
          angle = 0;
        }
      } 
      if (velocity.x > 0) {// If player collides from right side
        right -= radius;
        if (right < ara.left && nRight > ara.left && location.y > ara.location.y - radius) {
          velocity.x = 0;
          location.x = ara.left - radius;
        }
      }       
      if (velocity.x < 0) {// If player collides from right side
        left += radius;
        if (left > ara.right && nLeft < ara.right && location.y > ara.location.y - radius) {
          velocity.x = 0;
          location.x = ara.right + radius;
        }
      }
    }
  }
}
class bullet {
  float xBullet;
  float yBullet;
  float vBullet;
  float angle;
  float vx, vy;

  public boolean hit() {
    float dist = sqrt(sq(player.location.x-xBullet) + sq(player.location.y - yBullet) );
    if (dist < 30) {
      return true;
    } else {
      return false;
    }
  }

  bullet(float tempXBullet, float tempYBullet, float tempVBullet, float tempAngle) {
    xBullet = tempXBullet;
    yBullet = tempYBullet;
    vBullet = tempVBullet;
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
    ellipse (xBullet, yBullet, 10, 10);
  }

  public void move() {
    xBullet = xBullet + vx;
    yBullet = yBullet + vy;
  }

  public void collision() {
    for /*(bullet b : bullet)*/(int lenB = bullet.size(), b = lenB; b-- != 0; ) {
      final bullet u = bullet.get(b);
      for (Platform other : platforms) {
        if (CircleRectCollision(u.xBullet, u.yBullet, 5, other.left, other.top, other.right, other.bottom)) {
          bullet.set(b, bullet.get(--lenB));
          {
            println("BULLET COLLISION");
          }
          bullet.remove(lenB);
          bulletCollision = true;
          break;
        }
      }
    }
  }
}
class Collectable {

  //DECLARE
  //Vectors
  PVector location;

  float cwidth, cheight;
  float left, right, top, bottom;
  
  int value;

  Collectable(float _x, float _y, float _width, float _height, int value) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    cwidth = _width;
    cheight = _height;

    left = location.x;
    right = location.x + cwidth;
    top = location.y;
    bottom = location.y + cheight;
    
    this.value = value;
  }


  //FUNCTIONS
  public void update() {  
    left = location.x;
    right = location.x + cwidth;
    top = location.y;
    bottom = location.y + cheight;
  }

  public void display() {
    fill(255, 255, 0);
    ellipseMode(CORNER);
    ellipse(location.x, location.y, cwidth, cheight);
  }
}
class MovEnemy {
  //DECLARE
  int diameter; 
  float radius, angle, acceleration;

  //Starting proportions
  float aWidth, aHeight, startX, startY, mousex; 

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

  //Vectors
  PVector location, velocity, nlocation;

  //Position in array
  int value;

  public boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + aWidth && mouseY >= location.y && mouseY < location.y + aHeight;
  }

  // Enemy object
  MovEnemy (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1f);
    nlocation = PVector.add(location, velocity);
    acceleration = 0.5f;

    diameter = 40; 
    radius = diameter;
    angle = 0;

    aWidth = _width;
    aHeight = _height;

    left = location.x;
    right = location.x + aWidth;
    top = location.y;
    bottom = location.y + aHeight;

    value = i;
  }

  //FUNCTIONS
  public void update() {  
    enemyUpdatePosition();
    collisionDetection();
  }

  public void display() {

    if (isOver() && shiftKey) {
      fill(255, 0, 0);
    } else { 
      fill(113, 8, 151);
    }
    rectMode(CORNER);
    rect(location.x, location.y, aWidth, aHeight);
  }

  public void enemyUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    nlocation = PVector.add(location, velocity);
    velocity.x = acceleration;

    left = location.x;
    right = location.x + aWidth;
    top = location.y;
    bottom = location.y + aWidth;

    nLeft = nlocation.x;
    nRight = nlocation.x + aWidth;
    nTop = nlocation.y;
    nBottom = nlocation.y + aHeight;

    for (Platform other : platforms) {
      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.x > 0) {// If enemy collides from right side
          right -= radius;
          if (right < other.left && nRight > other.left && location.y > other.location.y - radius) {// If enemy collides from left side
            velocity.x = acceleration;
            location.x -= acceleration;
            acceleration = -acceleration;
            System.out.println("left side");
          }
        }       
        if (velocity.x < 0) {// If enemy collides from right side
          left += radius;
          if (left > other.right && nLeft < other.right && location.y > other.location.y - radius) {// If enemy collides from left side
            velocity.x = acceleration;
            location.x -= acceleration;
            acceleration = 0.5f;
            System.out.println("right side");
          }
        }
      }
    }
  }

  public void collisionDetection() {
    for (Platform other : platforms) {

      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.y > 0) {
          if (bottom < other.top && nBottom > other.top && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.iWidth + radius - 1) {// If enemy collides from top side
            velocity.y = 0;
            bottom = top;
          }
        }
      }
    }
  }
}



class Turret {
  //DECLARE
  //Starting proportions
  float twidth, theight, startX, startY, mousex;

  //Bounding box
  float left, right, top, bottom;

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

    left = location.x;
    right = location.x + twidth;
    top = location.y;
    bottom = location.y + theight;

    value = i;
  }


  //FUNCTIONS
  public void update() {  
    left = location.x;
    right = location.x + twidth;
    top = location.y;
    bottom = location.y + theight;

    mousex = mouseX + pos.x;

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
  public void settings() {  size(1200, 600, P2D);  smooth(8); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RedemtionOfSage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
