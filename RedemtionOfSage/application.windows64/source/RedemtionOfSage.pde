<<<<<<< HEAD
import ddf.minim.*; //<>// //<>// //<>//
=======
import ddf.minim.*; 
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
import ddf.minim.analysis.*;

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

<<<<<<< HEAD
//kleur g
int checkpointColor1;
int checkpointColor2;
int checkpointStroke;
int strokeWeight1;
=======

>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
int score;
int lives;

color defaultWaveformcolor, currentWaveformcolor;

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
boolean collisionDetect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}

// Basic collision detection method
float calculate1DOverlap(float p0, float p1, float d0, float d1) {
  float dl = p0+d0-p1, dr = p1+d1-p0;  
<<<<<<< HEAD
  return (dr<0 || dl<0) ? 0 : (dr >= dl) ? -dl : dr; 
=======
  return (dr<0 || dl<0) ? 0 : (dr >= dl) ? -dl : dr;
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
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

void setup() {
<<<<<<< HEAD
  size(1500, 750, P3D);
=======
  size(1200, 600, P3D);
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
  smooth(8);
  frameRate(1000);

  loadImages();
  
<<<<<<< HEAD
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
=======
  //Code cleanup
  checkpointSetup();
  music();
  fft = new FFT(backgroundMusic.bufferSize(), backgroundMusic.sampleRate());

  gridSize = 40;

  keysPressed = new boolean[256];
  particlePos = new PVector(100, 100);
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31

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

void draw() {

  if (paused == false && level != 0) {
<<<<<<< HEAD
   displayTime = accumTime + millis() - startTime;
=======
    displayTime = accumTime + millis() - startTime;
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
  }
  if (paused == true) {
    startTime = millis();
  }

  loops = 0;
<<<<<<< HEAD
=======
  //update game
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
  while (millis () > next_game_tick && loops < MAX_FRAMESKIP) {
    if (!paused) { 
      update_game();
    }

    next_game_tick += SKIP_TICKS;
    loops++;
  }
<<<<<<< HEAD
  
=======

>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
  draw_game();
}

void update_game() {
  colortransition();
<<<<<<< HEAD
  
=======
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31

  if (level != 0) {
    player.update();
    ara.update();

    for (Collectable coin : coins) {
      coin.update();
<<<<<<< HEAD
      if (collisionObject){
=======
      if (collisionObject) {
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
        collisionObject = false;
        coins.remove(coin);
        break;
      }
    }
<<<<<<< HEAD
    //veranderd
    println(player.location.x, player.location.y);
    
    if(level == 1){
    if((player.location.x >= 2291) == true){
      checkpointStroke = color(242,242,99);
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
    if(level == 3){
      if(player.location.x >= 3290){
      checkpointStroke = color(242,242,99);
      checkpointColor1 = color(252,252,38);
      }
    }
        
=======
    //Checkpoint Cleanup
    checkpointUpdate();
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31

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
<<<<<<< HEAD
    
=======

>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
    for (Turret turret : turrets) {
      turret.update();
    }

    for (MovEnemy o : movEnemy) {
      o.update();
    }

    for (bullet b : bullet) {
      b.update();
<<<<<<< HEAD
      if (collisionObject){
=======
      if (collisionObject) {
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
        collisionObject = false;
        bullet.remove(b);
        break;
      }
    }
<<<<<<< HEAD
 
=======

>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
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
  drawBackground(); //



  if (level != 0) {
    grid();

    //LEVEL
    pushMatrix();
    translate(-pos.x, -pos.y);
<<<<<<< HEAD
if(level != 0){
   menuMusic.pause();
  // menuMusic.rewind();
  backgroundMusic.play();
  backgroundMusic.setGain(-12);
}

//Checkpoints level 1
if(level == 1){  
  noStroke();
  fill(64,64,64);
  rect(2291, 220, 8, 80);
  fill(checkpointColor1);
  ellipse(2285, 210, 20,20);
  
  noStroke();
  fill(64,64,64); 
  rect(4733, 210, 8, 80);
  //stroke(checkpointStroke);
  fill (checkpointColor2);
  ellipse(4727, 200, 20,20);

  menuMusic.pause();
  menuMusic.rewind();
  backgroundMusic.play();

  }

//checkpoint level 2
if (level == 2){
  noStroke();
  fill(64,64,64);
  rect(3336, 200, 8, 80);
  stroke(checkpointStroke);
  fill(checkpointColor1);
  ellipse(3330, 190, 20,20);
}

//checkpoints level 3
if(level == 3){
  noStroke();
  fill(64,64,64);
  rect(3290, 220, 8, 80);
  stroke(checkpointStroke);
  fill(checkpointColor1);
  ellipse(3284, 210, 20,20);
}
=======
    if (level != 0) {
      menuMusic.pause();
      // menuMusic.rewind();
      backgroundMusic.play();
      backgroundMusic.setGain(-15);
    }

    //Checkpoints level 1
    if (level == 1) {  
      noStroke();
      fill(64, 64, 64);
      rect(2291, 220, 8, 80);
      fill(checkpointColor1);
      ellipse(2285, 210, 20, 20);

      noStroke();
      fill(64, 64, 64); 
      rect(4733, 210, 8, 80);
      //stroke(checkpointStroke);
      fill (checkpointColor2);
      ellipse(4727, 200, 20, 20);

      menuMusic.pause();
      menuMusic.rewind();
      backgroundMusic.play();
    }

    //checkpoint level 2
    if (level == 2) {
      noStroke();
      fill(64, 64, 64);
      rect(3336, 200, 8, 80);
      stroke(checkpointStroke);
      fill(checkpointColor1);
      ellipse(3330, 190, 20, 20);
    }

    //checkpoints level 3
    if (level == 3) {
      noStroke();
      fill(64, 64, 64);
      rect(3290, 220, 8, 80);
      stroke(checkpointStroke);
      fill(checkpointColor1);
      ellipse(3284, 210, 20, 20);
    }
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31

    levelBuild();

    //setuppreview();
    player.display();
    ara.display();
<<<<<<< HEAD
    
=======

>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
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
<<<<<<< HEAD
    fill(255);
    text("fps: " + (int) frameRate, 10, 20);
    text("score: " + score, 10, 40);
=======
    fill(255, 0, 255);
    text("fps: " + (int) frameRate, 10, 20);
    text("score: " + score, 10, 52);
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31


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