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
    gravity = new PVector(0, 0.1);

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
  void update() {
    araUpdatePosition();
    collisionDetection();
  }

  void display() {
    noStroke();
    fill(255, 255, 0);
    rectMode(CORNER); 
    rect(location.x, location.y, aWidth, aHeight);
  }

  void araUpdatePosition() {
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

  void respawn() {
    location.x = startX;
    location.y = startY;

    velocity.mult(0);
  }

  void powerUps() {
    if (powerUpActivated[0]) { //<>//
      location.y -= 20;
      aHeight = 40;
    } else {     
      location.y += 20;
      aHeight = 20;
    } //<>// //<>//
  }

  void collisionDetection() {
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