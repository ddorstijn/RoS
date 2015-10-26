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

public class Main extends PApplet {

//Global variable INIT //<>//
float gravity = 0.1f; //Gravity for physics objects. Global so it can be used by all classes
float friction = 0.1f; //Same goes for friction

PFont message;

ArrayList<Platform> platforms; //Create a list of platforms. Starts empty

boolean[] keys = new boolean[3]; //Keys pressed and released doesn't always work if you just use the keyPressed command.
boolean shiftKey = false;  //Check if Shiftkey is pressed, toggle.

boolean isCarried = false;

public boolean rectRectIntersect(float playerLeft, float playerTop, float playerRight, float playerBottom, float otherLeft, float otherTop, float otherRight, float otherBottom) {
  return !(playerLeft >= otherRight || playerRight <= otherLeft || playerTop >= otherBottom || playerBottom <= otherTop);
}  // Basic collision detection method

float beginX, endX, beginY, endY; 
float gridSize = 40; //Size of the grid the game is built around

//Call every class
Player player1;
Camera worldCamera;
Ara ara1;

public void setup() {
  
  
  textAlign(CENTER);

  //No key is pressed in the beginning
  keys[0] = false; //Left
  keys[1] = false; //Right
  keys[2] = false; //Ctrl

  //Init classes
  platforms = new ArrayList<Platform>();

  //Create the level  
  platforms.add(new Platform(0.0f, 400.0f, 920.0f, 120.0f, 1)); // = platform 1 op level design
  platforms.add(new Platform(720.0f, 320.0f, 80.0f, 40.0f, 1)); // = platform 2 op level desing
  platforms.add(new Platform(1000.0f, 320.0f, 80.0f, 40.0f, 1));// = platform 3 op level desing
  platforms.add(new Platform(1160.0f, 400.0f, 280.0f, 120.0f, 1)); // = platform 4 op level design
  platforms.add(new Platform(1160.0f, 360.0f, 40.0f, 80.0f, 1)); // = platform + op level design
  platforms.add(new Platform(1400.0f, 360.0f, 40.0f, 40.0f, 1)); // = platform + op level design
  platforms.add(new Platform(1560.0f, 320.0f, 80.0f, 40.0f, 1)); // = platorm 5 op level dsing
  platforms.add(new Platform(1760.0f, 400.0f, 240.0f, 80.0f, 1)); // = platform 6 op level desing
  platforms.add(new Platform(2120.0f, 360.0f, 20.0f, 20.0f, 1)); // = platform + op level design
  platforms.add(new Platform(2320.0f, 360.0f, 20.0f, 20.0f, 1)); // = platform + op level design
  platforms.add(new Platform(2520.0f, 360.0f, 20.0f, 20.0f, 1)); // = platform + op level design
  platforms.add(new Platform(2720.0f, 360.0f, 20.0f, 20.0f, 1)); // = platform + op level design
  platforms.add(new Platform(2920.0f, 400.0f, 20.0f, 20.0f, 1)); // = platform + op level design
  platforms.add(new Platform(3120.0f, 400.0f, 320.0f, 80.0f, 1)); // = platform 7 op level design
  platforms.add(new Platform(3440.0f, 440.0f, 640.0f, 40.0f, 1));  // = platform 8 op level design
  platforms.add(new Platform(4080.0f, 400.0f, 160.0f, 120.0f, 1)); // = platform 9 op level design
  platforms.add(new Platform(3560.0f, 320.0f, 160.0f, 40.0f, 1)); // = platform 10 op level design
  platforms.add(new Platform(3800.0f, 280.0f, 160.0f, 40.0f, 1)); // = platform 11 op level design
  platforms.add(new Platform(4200.0f, 240.0f, 40.0f, 160.0f, 1)); // = basic use of ara 
  platforms.add(new Platform(4160.0f, 360.0f, 40.0f, 40.0f, 1));  // = basic use of ara

  platforms.add(new Platform(1240.0f, 360.0f, 40.0f, 40.0f, 2)); //enemy/trap
  platforms.add(new Platform(1320.0f, 360.0f, 40.0f, 40.0f, 2)); //enemy/trap

  platforms.add(new Platform(4280.0f, 400.0f, 400.0f, 80.0f, 3)); //Finish

  player1 = new Player();
  worldCamera = new Camera();
  ara1 = new Ara();

  message = createFont("Arial", 72, true);
  textFont(message);
}

//Main
public void draw() {

  //translate world with camera
  translate(-worldCamera.pos.x, -worldCamera.pos.y);
  worldCamera.draw();

  //setup
  drawBackground();
  player1.run();
  grid();
  preview();
  ara1.run();
  controls();

  //Run platform for each object
  for (int i = 0; i < platforms.size(); i++) { 
    Platform platform = (Platform) platforms.get(i);
    platform.run();
  }
};
class Ara {
  //INIT
  float aWidth = 20; // Diameter is used for the width of the ara box. Because rectMode center is used radius is middle to right
  float aHeight = 20; //Radius is half the diameter
  float x = width/2; // Postition of the ara on the x-axis
  float y = height/2 - 100; // Postition of the ara on the y-axis
  float vx, vy; //Horizontal and vertical speeds

  //Bounding box creation
  float left = x; //Left side of the box
  float right = x + aWidth; //Right side of the box
  float top = y; //Top of the box
  float bottom = y + aHeight; //Bottom of the box

  //Same as above but then calculated for the next frame. So de Next position
  float nLeft = left + vx;
  float nRight = right + vx;
  float nTop = top + vy;
  float nBottom = bottom + vy;

  //SETUP
  public void run() {
    display();
    araUpdatePosition();
  }

  public void respawn() {
    x = width/2;
    y = height/2;

    vx = 0;
    vy = 0;
  }

  public void display() {
    noStroke();
    fill(255, 255, 0);
    rectMode(CORNER); //Starts in the middle of the rectangle and goes outwards instead of the left corner
    rect(x, y, aWidth, aHeight); //Draw player
  }

  public void araUpdatePosition() {
    x += vx; // Horizontal speed
    y += vy; // Vertical speed
    vy += gravity; // Gravity

    left = x;
    right = x + aWidth;
    top = y;
    bottom = y + aHeight;

    nLeft = left + vx;
    nRight = right + vx;
    nTop = top + vy;
    nBottom = bottom + vy;


    //Create momentum. If ara realeased arrow key let the ara slowwly stop
    if (ara1.vx > 0) {
      ara1.vx -= friction/2;
      if (ara1.vx < 0.1f) { // This is to prevent sliding if the float becomes so close to zero it counts as a zero and the code stops but the ara still moves a tiny bit
        ara1.vx = 0;
      }
    } else if (ara1.vx < 0) {
      ara1.vx += friction/2;
      if (ara1.vx > -0.1f) {
        ara1.vx = 0;
      }
    }

    //Respawn
    if (y > height) {
      respawn();
    }
  }
}
public void drawBackground() {
  background(25, 41, 67); //Drawing background
}

public void grid() {
  
  if (shiftKey == true) {  //If in buildmode 
    //horizontal gridlines
    for (int i = 0; i < height/gridSize; i++) //Number of lines that have to be drawn is calculated by dividing the height by the gridsize. eg; 800 / 40 = 20 lines
    {
      stroke(255, 0, 0);
      line(worldCamera.pos.x - width, i * gridSize, worldCamera.pos.x + width, i * gridSize);
    }

    //Vertical lines
    for (int i = 0; i < width/gridSize + worldCamera.pos.x; i++)
    {
      stroke(255, 0, 0);
      line (i * gridSize, 0, i * gridSize, height);
    }
  }
}
class Camera {
  PVector pos; //Camera's position

  Camera() {
    pos = new PVector(0, 0);
  }

  public void draw() {
    if (player1.x - width/2 > 0) {
      pos.x = player1.x - width/2; //Because camera is alligned to the left of the screen. Update camera to player pos
    } else {
      pos.x = 0;
    }
  }
}
public void keyPressed() {
  if (keyCode == 16) { //16 is the keyCode for shift
    shiftKey = !shiftKey;
  }

  if (key == 'a' && ara1.aHeight == 20) {
    ara1.y -= 20;
    ara1.aHeight += 20;
  } else if (key == 'a' && ara1.aHeight == 40 || keyCode == 17 && ara1.aHeight == 40) {     
    ara1.y += 20;
    ara1.aHeight -= 20;
  }
}

public void keyReleased()
{
  switch (keyCode) {
  case 37: // In case left arrow key is pressed 
    keys[0] = false;
    break;
  case 39: //In case the right arrow key is pressed
    keys[1] = false;
    break;
  case 17:
    keys[2] = false; //In case ctrl is pressed
    if (isCarried) {
      ara1.vx = player1.vx; //ara's pos is player pos
      ara1.vy = player1.vy;
      isCarried = false;
    }
    break;
  }
}

public void controls() {
  // Keyboard control
  if (keyPressed == true) {
    switch (keyCode) {
    case 37: // In case left arrow key is pressed and left is not obstructed move left
      keys[0] = true;
      break;
    case 39:
      keys[1] = true;
      break;
    case 17:
      keys[2] = true;
      break;
    case 38:
      if (player1.canJump == true) {
        player1.vy = player1.jumpSpeed;
        player1.canJump = false; // Jump is possible
      }
      break;
    }
  }

  // Check if speed doesn't get to high
  if (player1.vx > player1.maxSpeed) {
    player1.vx = player1.maxSpeed;
  } else if (player1.vx < -player1.maxSpeed) {
    player1.vx = -player1.maxSpeed;
  }
}

//Level building!
public void mousePressed() {
  if (shiftKey == true && mouseButton == LEFT) {
    //Take first mouse position after clicked and allign it to the grid
    beginX = Math.round((worldCamera.pos.x + mouseX - gridSize/2-1)/ gridSize) * gridSize;
    beginY = Math.round((mouseY - gridSize/2-1)/ gridSize) * gridSize;
  }
}

public void mouseReleased() {
  if (shiftKey == true && mouseButton == LEFT) {
    //Take position of the mouse when released and allign it to the grid
    endX = Math.round((worldCamera.pos.x + mouseX + gridSize/2-1)/ gridSize) * gridSize - beginX;
    endY = Math.round((mouseY + gridSize/2-1)/ gridSize) * gridSize - beginY;

    platforms.add(new Platform(beginX, beginY, abs(endX), endY, 1));

    System.out.println("platforms.add(new Platform(" + beginX + ", " + beginY + ", " + abs(endX) + ", " + endY + ", " + "1)); ");
  }
}

public void preview() {
  if (mousePressed && mouseButton == LEFT && shiftKey == true) {
    //show the preview of the box by just drawing a rectangle from begin to mouse
    pushMatrix();
    rectMode(CORNER);
    fill(0);
    rect(beginX, beginY, abs(worldCamera.pos.x + mouseX-beginX), mouseY-beginY);
    popMatrix();
  }
}
class Platform { //<>//
  float x, y, iWidth, iHeight, 
    left, right, top, bottom;

  int index;  

  Platform(float _x, float _y, float _width, float _height, int _index) {
    x = _x;
    y = _y;
    iWidth = _width;
    iHeight = _height;

    left = x;
    right = x + iWidth;
    top = y;
    bottom = y + iHeight;

    //If index = 1 it's a normal platform
    //If index = 2 it's a trap or stationary enemy
    //If index = 3 it's the finish!
    index = _index;
  }

  public void run() {
    display();
    collisionDetection();
  }

  public void display() {
    noStroke();
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
    rectMode(CORNER);
    rect(x, y, iWidth, iHeight);
  }

  public void collisionDetection() {

    if (rectRectIntersect(player1.nLeft, player1.nTop, player1.nRight, player1.nBottom, left, top, right, bottom)) {
      if (player1.vy > 0) {
        player1.bottom -= player1.radius;
        if (player1.bottom < top && player1.nBottom > top) {// If player collides from top side
          player1.vy = 0;
          player1.bottom = top;
          player1.canJump = true;
          player1.angle = 0;
        }
      } 
      if (player1.vx > 0) {// If player collides from right side
        player1.right -= player1.radius;
        if (player1.right < left && player1.nRight > left) {// If player collides from left side
          player1.vx = 0;
        }
      }       
      if (player1.vx < 0) {// If player collides from right side
        player1.left += player1.radius;
        if (player1.left > right && player1.nLeft < right) {// If player collides from left side
          player1.vx = 0;
        }
      }
      if (player1.top > bottom && player1.nTop < bottom) {// If player collides from bottom side
        player1.vy = 0;
      }

      if (index == 2) {
        fill(255);
        text("You suck!", worldCamera.pos.x + width/2, height/2);
        player1.respawn();
      }

      if (index == 3) {
        fill(255);
        text("You win!", worldCamera.pos.x + width/2, height/2);
      }
    }

    if (rectRectIntersect(ara1.nLeft, ara1.nTop, ara1.nRight, ara1.nBottom, left, top, right, bottom)) {
      if (ara1.vx > 0) {// If ara collides from right side
        ara1.right -= ara1.aWidth/2;
        if (ara1.right < left && ara1.nRight > left) {// If ara collides from left side
          ara1.vx = 0;
        }
      }       
      if (ara1.vx < 0) {// If ara collides from right side
        ara1.left += ara1.aWidth/2;
        if (ara1.left > right && ara1.nLeft < right) {// If ara collides from left side
          ara1.vx = 0;
        }
      }
      if (ara1.top > bottom && ara1.nTop < bottom) {// If ara collides from bottom side
        ara1.vy = 0;
      }
      if (ara1.vy > 0) {
        ara1.bottom -= ara1.aWidth/2;
        if (ara1.bottom < top && ara1.nBottom > top) {// If ara collides from top side
          ara1.vy = 0;
          ara1.bottom = top;
        }
      }
    }
  }
}
class Player { //<>//

  //player init
  int diameter = 40; // Diameter is used for the width of the player box. Because rectMode center is used radius is middle to right
  float radius = diameter / 2;
  float angle = 0;

  //Start position
  final int startX = 80;
  final int startY = height/2 + 80;

  float x = startX; // Postition of the player on the x-axis
  float y = startY; // Postition of the player on the y-axis
  float vx, vy; //Horizontal and vertical accelerations
  float jumpSpeed = -4.1f;
  float maxSpeed = 3;
  float acceleration = 0.5f;

  boolean canJump = true; //Check if ale to jump
  int colour = 255; //White

  float left = x - radius; //Left side of player
  float right = x + radius; //Right side of player
  float top = y - radius; //Top side of player
  float bottom = y + radius; //Bottom side of player

  //Next positions
  float nLeft = left + vx; 
  float nRight = right + vx;
  float nTop = top + vy;
  float nBottom = bottom + vy;

  public void run() {
    playerUpdatePosition();
    collisionDetection();
    controls();
    drawPlayer();
  }

  public void respawn() {
    x = startX;
    y = startY;

    vx = 0;
    vy = 0;
  }

  public void drawPlayer() {
    noStroke(); //No outline
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects
    rectMode(CENTER); 
    translate(x, y); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(0, 0, diameter, diameter); // character
    popMatrix(); //End the drawing
  }


  public void playerUpdatePosition() {
    x += vx; // Horizontal acceleration
    y += vy; // Vertical acceleration
    vy += gravity; // Gravity

    //Create momentum. If player realeased arrow key let the player slowwly stop
    if (player1.vx > 0) {
      player1.vx -= friction;
      if (player1.vx < 0.1f) { // This is to prevent sliding if the float becomes so close to zero it counts as a zero and the code stops but the player still moves a tiny bit
        player1.vx = 0;
      }
    } else if (player1.vx < 0) {
      player1.vx += friction;
      if (player1.vx > -0.1f) {
        player1.vx = 0;
      }
    }

    //Border left side of the level
    if (x < 0 + radius) {
      x = 0 + radius;
      vx = 0;
    }


    if (canJump == false && angle <= PI / 2 && vx >= 0 && angle > -(PI / 2)) {
      angle += 2 * PI / 360 * 8;
    } else if (canJump == false && angle >= -(PI / 2) && vx < 0 && angle < PI / 2) {
      angle -= 2 * PI / 360 * 8;
    }

    if (angle > PI / 2) {
      angle = PI / 2;
    }
    if (angle < -PI / 2) {
      angle = -PI / 2;
    }

    left = x - radius;
    right = x + radius;
    top = y - radius;
    bottom = y + radius;

    nLeft = left + vx;
    nRight = right + vx;
    nTop = top + vy;
    nBottom = bottom + vy;

    if (y > height + 100) {
      respawn();
    }
  }

  public void controls() {
    if (keys[0]) {  
      vx -= acceleration;
    }
    if (keys[1]) {
      vx += acceleration;
    }
    //If ctrl is pressed stick to the player
    if (keys[2]) { 

      //stop moving
      ara1.vx = 0;
      ara1.vy = 0;

      //Move x to player x
      ara1.x = x - radius/2;
      ara1.y = y - radius/2;
      isCarried = true;
    }
  }

  public void collisionDetection() {

    if (rectRectIntersect(nLeft, nTop, nRight, nBottom, ara1.left, ara1.top, ara1.right, ara1.bottom)) {

      if (vx > 0) {// If player collides from left side
        right -= radius;        
        if (right < ara1.left && nRight > ara1.left) {
          ara1.x = x + radius; 
          ara1.vx = vx; //Push ara
        }
      }       

      if (vx < 0) {// If player collides from right side
        left += radius;
        if (left > ara1.right && nLeft < ara1.right) {
          ara1.x = x - radius - ara1.aWidth;
          ara1.vx = vx;
        }
      }

      if (vy > 0) {
        bottom -= radius;
        if (bottom < ara1.top && nBottom > ara1.top) {// If player collides from top side
          vy = 0;
          bottom = top;
          canJump = true;
          angle = 0;
        }
      }
    }
  }
}
  public void settings() {  size(1000, 480);  smooth(4); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
