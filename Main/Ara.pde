class Ara {
  
  //INIT
  //Starting proportions
  float aWidth, aHeight, startX, startY;
  
  //Bounding box
  float left, right, top, bottom;
  
  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;
  
  //Vectors
  PVector location, velocity;

  //OBJECT
  Ara(float _x, float _y) {
    //DECLARATION
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);

    startX = _x;
    startY = _y;
    
    aWidth = 20;
    aHeight = 20; 
  
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
}