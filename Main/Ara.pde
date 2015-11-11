class Ara {
  //INIT
  float aWidth = 20; // Diameter is used for the width of the ara box. Because rectMode center is used radius is middle to right
  float aHeight = 20; //Radius is half the diameter

  float startX;
  float startY;

  PVector location;
  PVector velocity;

  //Bounding box creation
  float left; //Left side of the box
  float right; //Right side of the box
  float top; //Top of the box
  float bottom; //Bottom of the box

  //Same as above but then calculated for the next frame. So de Next position
  float nLeft;
  float nRight;
  float nTop;
  float nBottom;

  Ara(float _x, float _y) {
    
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);

    startX = _x;
    startY = _y;

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

  //SETUP
  void run() {
    display();
    araUpdatePosition();
  }

  void respawn() {
    location.x = startX;
    location.y = startY;
    
    velocity.mult(0);
  }

  void display() {
    noStroke();
    fill(255, 255, 0);
    rectMode(CORNER); 
    rect(location.x, location.y, aWidth, aHeight); //Draw player
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
}