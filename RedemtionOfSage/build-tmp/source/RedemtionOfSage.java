import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RedemtionOfSage extends PApplet {

 //<>// //<>// //<>//


Minim minim;
FFT fft;

int TICKS_PER_SECOND = 60;
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

//kleur g
int checkpointColor1;
int checkpointColor2;
int checkpointStroke;
int strokeWeight1;
int score;
int lives;

int defaultWaveformcolor, currentWaveformcolor;

boolean paused, collisionObject, changeLevel;
boolean checkpoint1Activated, checkpoint2Activated, checkpointsoundplayed;

JSONArray levelData;
JSONArray turretData;
JSONArray movEnemyData;
JSONObject playerData;
JSONArray coinData;

ScoreList highscores = new ScoreList();

PVector gravity, pos, particlePos;
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
ParticleSystem jump;
ParticleSystem enemyParticle;
ParticleSystem bulletParticle;

public void setup() {
  
  
  frameRate(1000);

  loadImages();
  
  // rondje
  checkpointColor1 = color(245,245,230);
  checkpointColor2 = color(245,245,230);
  checkpointStroke = color(245,245,250);
  strokeWeight1 = 0;
  
  music();
  fft = new FFT(backgroundMusic.bufferSize(), backgroundMusic.sampleRate());
  
  gridSize = 40;

  keysPressed = new boolean[256];
  particlePos = new PVector(100,100);

  defaultWaveformcolor = color(20, 77, 207);
  currentWaveformcolor = color(20, 77, 207);

  platforms = new ArrayList<Platform>();
  turrets = new ArrayList<Turret>();
  movEnemy = new ArrayList<MovEnemy>();
  bullet = new ArrayList<bullet>();
  coins = new ArrayList<Collectable>();
  boss = new Boss(6, 170, 180, 5);
  jump = new ParticleSystem(particlePos);
  enemyParticle = new ParticleSystem(particlePos);
  bulletParticle = new ParticleSystem(particlePos);
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
  colortransition();

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
    //veranderd
    if(level == 1){
    if((player.location.x >= 2291) == true){
      strokeWeight1 = 3;
      checkpointStroke = color(255);
      checkpointColor1 = color(252,252,38);
    }
    if(player.location.x >= 4733){
      checkpointStroke = color(242,242,99);
      checkpointColor2 = color(252,252,38);
      }
    }
    if(level == 2){
      if(player.location.x >= 3336){
      checkpointStroke = color(242,242,99);
      checkpointColor1 = color(252,252,38);
      }
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
          highscores.addScore(userInput, score, displayTime);
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
    
    for (Turret turret : turrets) {
      turret.update();
    }

    for (MovEnemy o : movEnemy) {
      o.update();
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
//checkpoint rondje
if(level == 1){  
  //Drawing checkpoint 1
  noStroke();
  fill(64,64,64);
  rect(2291, 220, 8, 80);
  //strokeWeight(strokeWeight1);
  stroke(checkpointStroke);
  fill(checkpointColor1);
  ellipse(2285, 210, 20,20);
  noStroke();
  //Drawing checkpoint 2
  fill(64,64,64); 
  rect(4733, 210, 8, 80);
  fill (checkpointColor2);
  ellipse(4727, 200, 20,20);
  menuMusic.pause();
  // menuMusic.rewind();
  backgroundMusic.play();
  }


if (level == 2){ 
  //Drawing checkpoint 1
  fill(64,64,64);
  noStroke();
  rect(3336, 200, 8, 80);
  stroke(checkpointStroke);
  fill(checkpointColor1);
  ellipse(3330, 190, 20,20);
}
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
    displayparticles();
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

    popStyle();
  } else {
    startTime = millis();
  }

  menu.display();
}
class Ara {

  //DECLARE
  //Starting proportions
  float aWidth, aHeight, startX, startY, speed, locRel, timerSize;

  //Vectors
  PVector location, velocity;

  //Booleans
  boolean isCarried; //For ara
  boolean[] powerUpActivated;
  boolean canShoot;
  boolean shieldActivate;

  int scalar;
  int timer;
  int sTimer;
  float angle;

  //OBJECT
  Ara(float _x, float _y) {
    //INITIALIZE
    location = new PVector(_x, _y, 0);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1f);

    startX = location.x;
    startY = location.y;

    aWidth = 20;
    aHeight = 20; 
    angle = 0.05f;
    scalar = 50;
    speed = 0.02f;
    timerSize = 5;

    isCarried = false;
    powerUpActivated = new boolean[2];
    canShoot = true;
    timer = 0;
    shieldActivate = true;
  }


  //FUNCTIONS
  public void update() {
    araUpdatePosition();
    collisionDetection();

    if (!powerUpActivated[0] && !powerUpActivated[1]) {
      location.x = (player.location.x + 10) + sin(angle) * scalar;
      location.z = cos(angle);
      angle = angle + speed;

      if( location.x >= player.location.x - 39.9f && location.x < player.location.x + 20){
        aWidth += 0.1f; 
        aHeight += 0.1f;
      } else if( location.x >= player.location.x + 20 && location.x <= player.location.x + 59.9f){
        aWidth -= 0.1f; 
        aHeight -= 0.1f;
      }else{
        aWidth = 20;
        aHeight = 20;
      }
    }
  }

  public void display() {
    noStroke();
    fill(255, 255, 0);
    rectMode(CORNER);


    if (powerUpActivated[1] && millis() - sTimer < 3000) {//shield timer countdown with ellipses
      if (millis() - sTimer < 3000) {
      ellipse(player.location.x+((40/6)-2.5f), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 2500) {
      ellipse(player.location.x+((40/6)*2-2.5f), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 2000) {
      ellipse(player.location.x+((40/6)*3-2.5f), player.location.y-10, timerSize, timerSize);
      }      
      if (millis() - sTimer < 1500) {
      ellipse(player.location.x+((40/6)*4-2.5f), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 1000) {
      ellipse(player.location.x+((40/6)*5-2.5f), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 500) {
      ellipse(player.location.x+((40/6)*6-2.5f), player.location.y-10, timerSize, timerSize);
      }  
    }
    if (!powerUpActivated[1] && millis() - timer < 3500) {
      if (!powerUpActivated[1] && timer != 0) {
        if (millis() - timer > 500) {
        ellipse(player.location.x+((40/6)-2.5f), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 1000) {
        ellipse(player.location.x+((40/6)*2-2.5f), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 1500) {
        ellipse(player.location.x+((40/6)*3-2.5f), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 2000) {
        ellipse(player.location.x+((40/6)*4-2.5f), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 2500) {
        ellipse(player.location.x+((40/6)*5-2.5f), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 3000) {
        ellipse(player.location.x+((40/6)*6-2.5f), player.location.y-10, timerSize, timerSize);
        }       
      }
    } 
 
    
    if (powerUpActivated[1]) {//shield
      pushStyle();
      noFill();
      strokeWeight(5);
      stroke(255, 255, 0);
      rect(player.location.x, player.location.y, player.pWidth, player.pHeight);
      popStyle();
    } else if (powerUpActivated[0]) {//shoot
      aWidth = 20;
      aHeight = 20;
      rect(location.x, location.y, aWidth, aHeight);
    } else {
      pushMatrix();
      translate(location.x, location.y, location.z);
      rect(0, 0, aWidth, aHeight);
      popMatrix(); 
    }
  }

  public void araUpdatePosition() {

    if (powerUpActivated[1] && millis() - sTimer <= 3000) {
      powerUpActivated[1] = true;
      shieldActivate = true;
    }else if (powerUpActivated[1] && millis() - sTimer > 3000) {
      powerUpActivated[1] = false;
      shieldActivate = false;
      ara.timer = millis();
    } 

    if (!powerUpActivated[1] && shieldActivate == false && millis() - timer <= 3000) {
      shieldActivate = false;
    } else if (!powerUpActivated[1] && shieldActivate == false && millis() - timer > 3000) {
      shieldActivate = true;
    } 
    

    location.add(velocity); //Speed
    //velocity.add(gravity); //Gravity
    //velocity.x *= friction;

    if (!powerUpActivated[0]) {
    // velocity.x *= friction;
    // location.x = player.location.x +10;
     location.y = player.location.y +10;
    }

    if (velocity.y > 5) {
      velocity.y = 5;
    }

    //Respawn
    if (location.y > height || location.x > (player.location.x + (width / 2)) || location.x < (player.location.x - (width / 2))) {
      powerUpActivated[0] = false;
      canShoot = true;
    }
  }

  public void respawn() {
    location.x = player.location.x;
    location.y = player.location.y;

    velocity.mult(0);
  }

  public void powerUps() {//schieten naar links of naar rechts
    if (powerUpActivated[0] && player.velocity.x >= 0 && canShoot == true) {
      velocity.set(8, 0);
      canShoot = false;
    }
    if (powerUpActivated[0] && player.velocity.x < 0 && canShoot == true) {
      velocity.set(-8, 0);
      canShoot = false;
    }
  }


  public void collisionDetection() {
    if (powerUpActivated[0]) {
      for (Platform other : platforms) {
        float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.iWidth);
        float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.iHeight);

        if (abs(xOverlap) > 0 && abs(yOverlap) > 0) {
          // Determine wchich overlap is the largest
          if (abs(xOverlap) > abs(yOverlap)) {
            araRaaktIetsMusic.rewind();
            location.y += yOverlap; // adjust player x - position based on overlap
               araRaaktIetsMusic.play();      
          } else {
            location.x += xOverlap; // adjust player y - position based on overlap
            powerUpActivated[0] = false;
            canShoot = true;                  
          }
        }
      }
    }

    for (MovEnemy other : movEnemy) {
      float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.aWidth);
      float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.aHeight);

      // Determine wchich overlap is the largest
      if (xOverlap != 0 && yOverlap != 0 && powerUpActivated[0]) {
        powerUpActivated[0] = false;
        canShoot = true;
        enemyDiesMusic.rewind();
        enemyDiesMusic.play();
        movEnemy.remove(other);
        for (int i = 0; i < 60; i++) {
            enemyParticle.addenemyParticle();
          }
        break;
      }
    }
  }
}
public void drawBackground() {
  if (level != 0) {
    background(0); //Drawing background
  } else if (menu.subMenu == 3){ 
    background(bgCredits);
  } else if (level == 0 && menu.subMenu == 4){
    background(bgEnterName);
  } else {
    background(bgMenu);
  }

  if (level != 0) {
    fft.forward(backgroundMusic.mix);
    
    stroke(currentWaveformcolor, 71);

    for(int i = 0; i < 45; i++) {
     float x = map( i-1, 0, 45, 0, width/2);
     
     strokeWeight(7);
     line(width/2+x, height/2 + fft.getBand(i)*4, -1, width/2+x, height/2 - fft.getBand(i)*4, -1);
     line(width/2-x, height/2 + fft.getBand(i)*4, -1, width/2-x, height/2 - fft.getBand(i)*4, -1);
    }
  }
}

public void colortransition() {
  if (currentWaveformcolor != defaultWaveformcolor) {
      currentWaveformcolor = lerpColor(currentWaveformcolor, defaultWaveformcolor, .03f);
  }
}

public void grid() {
  if (shiftKey == true) {  //If in buildmode 
    strokeWeight(2);
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
      coinMusic.rewind();
      score += 100; 
      collisionObject = true;
      location.x = -100;
      coinMusic.play();
      currentWaveformcolor = color(255,255,0);
    } 
  } 
}
public void keyPressed() {

  keysPressed[keyCode] = true;

  menuControls();
  playerControls();
  araControls();
  gameControls();
  buildControls();
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



//Controls menu
public void menuControls() {
  if (level == 0 && menu.subMenu == 4) {
    if (key == BACKSPACE) {
      if (userInput.length() > 0) {
        userInput = userInput.substring(0, userInput.length()-1);
      }
    } else if ((keysPressed[ENTER]) || (keysPressed[RETURN])) {
      level = 1;
      setIndex = 0; 
      loadLevel(true);
    } else if (textWidth(userInput+key) < width) {
      userInput = userInput+key;
    }  
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

public void gameControls() {
  //enable buildmode
  if (keyCode == 16 && level != 0) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  //M-key to go to menu
  if (keysPressed[77]) {
    menu.subMenu = 0;
    level = 0;
  }

  //P-key to pause
  if (keyCode == 80 && level != 0) {
    paused = !paused;

    accumTime = accumTime + millis() - startTime;
  }
}

public void playerControls() {
  if (keyCode == UP && level != 0) {//////Check for (double) jump
    if (player.canJumpAgain == true && player.canJump == false && (player.velocity.y > 0 || player.velocity.y < 0 && player.velocity.y != 0)&&(!ara.powerUpActivated[1])) {
      player.velocity.y = player.jumpSpeed / 1.2f;
      player.canJumpAgain = false;
      jumpMusic.rewind();
      jumpMusic.play();
      jump.addParticle();
    }
    if (player.canJump == true) {
      player.velocity.y = player.jumpSpeed;
      player.canJump = false; // Jump is possible
      for (int i = 0; i < 12; i++) {
        jump.addParticle();
        jumpMusic.rewind();
        jumpMusic.play();
      }
      player.canJump = false;
    }
  }
}

public void araControls() {
  //If Z is pressed Ara shoots off
  if (keysPressed[90] && !ara.powerUpActivated[1] && level != 0 && ara.canShoot == true) {
    ara.powerUpActivated[0] = !ara.powerUpActivated[0];
    ara.powerUps();
    araGooienMusic.rewind();
    araGooienMusic.play();
  }

  //If X is pressed turn on shield
  if (keysPressed[88] && !ara.powerUpActivated[0] && level >= 1 && ara.shieldActivate == true) {
    if (keysPressed[88] && ara.powerUpActivated[1]) {
      ara.timer = millis();
      ara.shieldActivate = false;
      }
    ara.powerUpActivated[1] = !ara.powerUpActivated[1];
    ara.powerUps();
    ara.shieldActivate = false;
    ara.sTimer = millis();
  }
}

public void buildControls() {
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
}
public void loadLevel(boolean objectsToo) {
   
   checkpoint1Activated = false;
   checkpoint2Activated = false;
      
  for (int i = 0; i < keysPressed.length; i++) {
    keysPressed[i] = false;
  }
  bullet.removeAll(bullet);
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
  String[] levelSelect, credits;
  String currentMenu;
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space, subMenu;

  boolean enteredMenu;

  Button() {
    location = new PVector(width/2, height/2);

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

    levelSelect[0] = "Level 1";   
    levelSelect[1] = "Level 2";
    levelSelect[2] = "Level 3";
    levelSelect[3] = "Go Back";
  }

  public void update() {
    switch (currentMenu) {
    case "mainMenu":
      if (mpos > 4) {
        mpos = 0;
        break;
      }
      if (mpos < 0) {
        mpos = 4;
        break;
      }
    case "levelSelect":
      if (currentMenu == "levelSelect") {
        if (mpos > levelSelect.length-1) {
          mpos = 0;
        } 
        if (mpos<0) {
          mpos = levelSelect.length-1;
          break;
        }
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
          break;
          //If cursor is on Level Select go to Level Select menu
        case 1:
          subMenu = 1;
          mpos = 0;
          enteredMenu = true;
          currentMenu = "levelSelect";
          break;
        //Higschore 
        case 2:
          subMenu = 2;
          highscores.load("highscore.csv");
          enteredMenu = true;
          break;
        //Credits
        case 3:
          subMenu = 3;
          mpos = 0;
          enteredMenu = true;
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
          currentMenu = "mainMenu";
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
      case 3:
        if (keyPressed) {
          subMenu = 0;
          enteredMenu = true;
        }
      }
    }
  }

  public void display() {
    
    textFont(menuFont);

    if (level == 0 && subMenu == 0) {
      backgroundMusic.pause();
      backgroundMusic.rewind();

      if (mpos == 0) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnStart, 411, 258);

      if (mpos == 1) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevelSelect, 411, 309);

      if (mpos == 2) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnHighscores, 411, 359);
      
      if (mpos == 3) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnCredits, 411, 410);

      if (mpos == 4) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnExit, 411, 461);
      
      noTint();
      menuMusic.play();
      menuMusic.loop();
    } else if (level == 0 && subMenu == 1) {
      backgroundMusic.pause();
      backgroundMusic.rewind();

      if (mpos == 0) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevel1, 411, 258);

      if (mpos == 1) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevel2, 411, 309);

      if (mpos == 2) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevel3, 411, 359);
      
      if (mpos == 3) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnBack, 411, 410);

      noTint();
      
    } else if (level == 0 && subMenu == 2) {
      // display header row
      fill(255);
      textSize(32);
      text("Place", width/5, height/2.5f);
      text("Name", 2*width/5, height/2.5f);
      text("Score", 3*width/5, height/2.5f);
      text("Time", 4*width/5, height/2.5f);
      textSize(24);
      // for each score in list
      for (int iScore=0; iScore<highscores.getScoreCount(); iScore++) {
        // only show the top 10 scores
        if (iScore>=9) break;

        // fetch a score from the list
        Score score = highscores.getScore(iScore);

        // display score in window
        text((iScore+1) , width/5, height/2.5f + 100 + iScore*22);
        text(score.name, 2*width/5, height/2.5f + 100 + iScore*22);
        text(score.score, 3*width/5, height/2.5f + 100 +iScore*22);
        text(score.time / 1000/ 60 + ":" + nf(score.time / 1000 % 60, 2), 4*width/5, height/2.5f + 100 + iScore*22);
      }
    } else if (level == 0 && subMenu == 3) { 
      
    } else if (level == 0 && subMenu == 4) {
      pushStyle();
      fill(255);
      textAlign(LEFT, CENTER);
      textSize(32);
      text(userInput, 644, 315);
      popStyle();
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
        fill(255);
        break;
      case 2:
        fill(255, 0, 0);
        break;
      case 3:if (isOver() && shiftKey) {
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
        fill(0, 255, 0);
        break;
      }
    }

    if (index != 2) {
      rectMode(CORNER);
      rect(location.x, location.y, iWidth, iHeight);
      fill(0);
      rect(location.x+3, location.y+3, iWidth-6, iHeight-6);
    } else {
      for (int i = 0; i < iWidth/40; ++i) {
        triangle(location.x, location.y+iHeight, location.x+iWidth/2, location.y, location.x+iWidth, location.y+iHeight);
      }
    }
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
          player.canJumpAgain = true;
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
  PVector location, velocity, respawn, start;
   

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if able to jump
  boolean canJumpAgain = true; //Check if player can jump second time
  
  int colour;

  //OBJECT
  Player(int _x, int _y) {

    //INITIALIZE
    jumpSpeed = -4.1f;
    maxSpeed = 3;
    acceleration = 0.5f;

    canJump = true; //Check if able to jump
    canJumpAgain = true; //check if able tu double jump
    colour = 255; //White

    pWidth = 40;
    pHeight = 40;
    angle = 0;

    location = new PVector(_x, _y, 0);
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


  if( level == 1){
    if (location.x >= 2291 && !checkpoint2Activated){
      start = new PVector(2291, 150);
      checkpoint1Activated = true;
      checkpointMusic.play();
    }
    if (location.x >= 4733){
      start = new PVector(4733, 150);
      checkpoint2Activated = true;
      if (checkpointsoundplayed) {
        checkpointMusic.rewind();
        checkpointMusic.play();
        checkpointsoundplayed = true;
      }
    }
  }
  if(level == 2){
    if(location.x >= 3336){
      start = new PVector(3336, 130);
    }
  }

  
// 1765,200 
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

    if (canJumpAgain) {
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
    playerDiesMusic.rewind();
    playerDiesMusic.play();
    location.set(start);
    velocity.set(0, 0);
  }

  public void controls() {
    if (velocity.y != 0.1f) {
      canJump = false;
    }

    if (keysPressed[LEFT]) {  
      velocity.x -= acceleration;
      if (canJump){
        for (int i = 0; i < 1; i++) {
        jump.addParticle();
        }
      }
    }
    if (keysPressed[RIGHT]) {
      velocity.x += acceleration;
      if (canJump){
        for (int i = 0; i < 1; i++) {
          jump.addParticle();
        }
      }
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
      vy = -( vBullet*cos(angle));
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
    fill(255,0,0);
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
      collisionObject = true;
      if (ara.powerUpActivated[1]) {
          for (int i = 0; i < 40; i++) {
            bulletParticle.addbulletParticle();
          }
        }  
      if (!ara.powerUpActivated[1]){
        player.respawn();
      }  
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
    fill(0);
    stroke(255, 0, 0);
    strokeWeight(2);

    rectMode(CORNER);
    rect(location.x, location.y, aWidth, aHeight);
    triangle(location.x + 10, location.y, location.x, location.y - 15, location.x - 10, location.y);
    triangle(location.x + aWidth - 10, location.y, location.x + aWidth, location.y - 15, location.x + aWidth + 10, location.y);
    //triangle(location.x+4,location.y+4, location.x+20, location.y+8, location.x +10, location.y +14);
    //triangle(location.x+36,location.y+4, location.x+20, location.y+8, location.x +30, location.y +14);
    //rect(location.x+4, location.y+25, aWidth-8,aHeight/5);
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
      playerDiesMusic.rewind();
      playerDiesMusic.play();
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

  int interval; //Time between bullets shot

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

    interval = 60;
  }


  //FUNCTIONS
  public void update() {  
    mousex = mouseX + pos.x;

    collision();

    float dist = sqrt(sq(player.location.x-location.x) + sq(player.location.y - location.y) );
    if (dist < 300) {
      if (interval == 0) {
        float angle =  atan((player.location.x-location.x) / (player.location.y-location.y));
        bullet.add(new bullet(location.x + twidth/2, location.y + theight/2, 3, angle));
        interval = 60;
        enemyShootMusic.rewind();
        enemyShootMusic.play();
      } else {
        interval--;
      }
    }
  }

  public void display() {

    if (isOver() && shiftKey) {
      fill(255, 0, 0);
    } else { 
      fill(0, 0, 0);
    }
    rectMode(CORNER);
    stroke(255, 0, 0);
    strokeWeight(2);
    rect(location.x, location.y, twidth, theight);
    ellipse(location.x+5, location.y+5 , twidth - 10 , theight - 10);
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
      rect(cx - r/2, cy - r/2, 20, 40); 
      rect(cx + r/4, cy - r/2, 20, 40);  
      rect(cx - r/8, cy + r/3, 20, 20);
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
  // also her time
  int time;

  // Constructor
  Score(String name, int score, int time) {
    this.name = name;
    this.score = score;
    this.time = time;
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
    scoreTable.addColumn("time");
  }

  // Create a new Score and add it to the scores ArrayList
  public void addScore(String name, int score, int time) {
    // Add a new score object to the scores ArrayList
    scores.add(new Score(name, score, time));
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
      row.setInt("time", score.time);
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
      scores.add(new Score(row.getString("name"), row.getInt("score"), row.getInt("time")));
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
PImage bgMenu;
PImage bgKeybindings;
PImage bgCredits;
PImage bgEnterName;

PImage btnStart;
PImage btnLevelSelect;
PImage btnHighscores;
PImage btnCredits;
PImage btnExit;

PImage btnLevel1;
PImage btnLevel2;
PImage btnLevel3;
PImage btnBack;


public void loadImages() {
	bgMenu = loadImage("img/background.png");
	bgKeybindings = loadImage("img/keybindings.png");
	bgCredits = loadImage("img/credits.png");
	bgEnterName = loadImage("img/name.png");

	btnStart = loadImage("img/buttons/startButton.JPG");
	btnLevelSelect = loadImage("img/buttons/levelSelectButton.JPG");
	btnHighscores = loadImage("img/buttons/highScoresButton.JPG");
	btnCredits = loadImage("img/buttons/creditsButton.JPG");
	btnExit = loadImage("img/buttons/exitButton.JPG");

  btnLevel1 = loadImage("img/buttons/level1.PNG");
  btnLevel2 = loadImage("img/buttons/level2.PNG");
  btnLevel3 = loadImage("img/buttons/level3.PNG");
  btnBack = loadImage("img/buttons/back.PNG");
}

  AudioPlayer araGooienMusic;
  AudioPlayer araRaaktIetsMusic;
  AudioPlayer backgroundMusic;
  AudioPlayer checkpointMusic;
  AudioPlayer coinMusic;
  AudioPlayer enemyDiesMusic;
  AudioPlayer enemyShootMusic;
  AudioPlayer jumpMusic;
  AudioPlayer menuMusic;
  AudioPlayer playerDiesMusic;
  AudioPlayer selectMusic;
  AudioPlayer shieldHitMusic;

public void music(){
  minim = new Minim(this);
  araGooienMusic = minim.loadFile("music/aragooien.wav");
  
  minim = new Minim(this);
  araRaaktIetsMusic = minim.loadFile("music/araraaktiets.wav");
  
  minim = new Minim(this);
  backgroundMusic = minim.loadFile("music/background2.mp3");
  
  minim = new Minim(this);
  checkpointMusic = minim.loadFile("music/checkpoint.wav");
  
  minim = new Minim(this);
  coinMusic = minim.loadFile("music/coin.wav");
  
  minim = new Minim(this);
  enemyDiesMusic = minim.loadFile("music/enemydies.wav");
  
  minim = new Minim(this);
  enemyShootMusic = minim.loadFile("music/enemyshoot.wav");
  
  minim = new Minim(this);
  jumpMusic = minim.loadFile("music/jump.wav");
  
  minim = new Minim(this);
  menuMusic = minim.loadFile("music/menu.mp3");
  
  minim = new Minim(this);
  playerDiesMusic = minim.loadFile("music/playerdies.wav");
  
  minim = new Minim(this);
  selectMusic = minim.loadFile("music/select.wav");  
  
  minim = new Minim(this);
  shieldHitMusic = minim.loadFile("music/shieldhit.wav");  
  
  fft = new FFT(backgroundMusic.bufferSize(), backgroundMusic.sampleRate());
}
public void displayparticles() {
  jump.run();
  enemyParticle.run();
  bulletParticle.run();
}

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  ArrayList<enemyParticle> enemyParticles;
  ArrayList<bulletParticle> bulletParticles;
  PVector origin;

  ParticleSystem(PVector location) {
    particles = new ArrayList<Particle>();
    enemyParticles = new ArrayList<enemyParticle>();
    bulletParticles = new ArrayList<bulletParticle>();
    origin = new PVector(0, 0);
  }

  public void addParticle() {


    origin.set(player.location.x + player.pWidth/2, player.location.y-5 + player.pHeight);

    particles.add(new Particle(origin));
  }

  public void addenemyParticle() {
    origin.set(ara.location.x + ara.aWidth/2, ara.location.y + ara.aHeight/2);
    enemyParticles.add(new enemyParticle(origin));
  }



    public void addbulletParticle() {
    origin.set(player.location.x + player.pWidth/2, player.location.y + player.pHeight/2);
    bulletParticles.add(new bulletParticle(origin));

    }
      public void run() {
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.run();
        if (p.isDead()) {
          particles.remove(i);
        }
      }
      for (int c = enemyParticles.size()-1; c >= 0; c--) {
        enemyParticle q = enemyParticles.get(c);
        q.run();
        if (q.isDead()) {
          enemyParticles.remove(c);
        }
      }
      for (int b = bulletParticles.size()-1; b >= 0; b--) {
        bulletParticle s = bulletParticles.get(b);
        s.run();
        if (s.isDead()) {
          shieldHitMusic.rewind();
          shieldHitMusic.play();
          bulletParticles.remove(b);
        }
      }
    }
  }



  // A simple Particle class

  class Particle {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float lifespan;
    float c1;

    Particle(PVector l) {
      acceleration = new PVector(0, 0.02f);
      velocity = new PVector(random(-0.75f, 0.75f), random(-0.85f, 0.01f));
      location = l.get();
      lifespan = 60;
    }

    public void run() {
      update();
      display();
    }

    // Method to update location
    public void update() {
      velocity.add(acceleration);
      location.add(velocity);
      lifespan -= 1.0f;
    }

    // Method to display
    public void display() {
      c1 += 10;
      c1 %= 255;
      noStroke();
      pushStyle();
      colorMode(HSB);
      fill(c1, 255, 255, lifespan+60);
      rect(location.x, location.y, 8, 8);
      popStyle();
    }

    // Is the particle still useful?
    public boolean isDead() {
      if (lifespan < 0.0f) {
        return true;
      } else {
        return false;
      }
    }
  }

  class enemyParticle {
    PVector location;
    PVector velocity;
    PVector acceleration;
    float lifespan;
    float epWidth;
    float epheight;

    enemyParticle(PVector l) {//enemy particles
      acceleration = new PVector(random(-0.01f, 0.01f), random(-0.01f, 0.01f));
      velocity = new PVector(random(-0.5f, 0.5f), random(-0.1f, 0.7f));
      location = l.get();
      lifespan = 160;
    }

    public void run() {
      update();
      display();
      collisionDetection();
    }

    // Method to update location
    public void update() {
      velocity.add(acceleration);
      location.add(velocity);
      lifespan -= 1.0f;
    }
    public void collisionDetection() {
      for (Platform other : platforms) {
        float xOverlap = calculate1DOverlap(location.x, other.location.x, epWidth, other.iWidth);
        float yOverlap = calculate1DOverlap(location.y, other.location.y, epheight, other.iHeight);

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
    }
    // Method to display
    public void display() {
      stroke(0, lifespan);
      fill(187, 10, 30, lifespan);
      ellipse(location.x, location.y, 10, 10);
    }

    // Is the particle still useful?
    public boolean isDead() {
      if (lifespan < 0.0f) {
        return true;
      } else {
        return false;
      }
    }
  }

  class bulletParticle {//bullet particles
    PVector location;
    PVector velocity;
    PVector acceleration;
    float lifespan;

    bulletParticle(PVector l) {
      acceleration = new PVector(random(-0.02f, 0.02f), random(-0.02f, 0.02f));
      velocity = new PVector(random(-0.5f, 0.5f), random(-0.5f, 0.5f));
      location = l.get();
      lifespan = 50;
    }

    public void run() {
      update();
      display();
    }

    // Method to update location
    public void update() {
      velocity.add(acceleration);
      location.add(velocity);
      lifespan -= 1.0f;
    }

    // Method to display
    public void display() {
      stroke(250, lifespan);
      fill(150, 150, 0, lifespan);
      ellipse(location.x, location.y, 7, 7);
    }

    // Is the particle still useful?
    public boolean isDead() {
      if (lifespan < 0.0f) {
        return true;
      } else {
        return false;
      }
    }
  }
  public void settings() {  size(1200, 600, P3D);  smooth(8); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RedemtionOfSage" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
