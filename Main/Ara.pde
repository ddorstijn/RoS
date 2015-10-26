class Ara {
  //INIT
  int diameter = 40; // Diameter is used for the width of the ara box. Because rectMode center is used radius is middle to right
  float radius = diameter / 2; //Radius is half the diameter
  float x = width/2; // Postition of the ara on the x-axis
  float y = height/2 - 100; // Postition of the ara on the y-axis
  float vx, vy; //Horizontal and vertical speeds

  //Bounding box creation
  float left = x - radius; //Left side of the box
  float right = x + radius; //Right side of the box
  float top = y - radius; //Top of the box
  float bottom = y + radius; //Bottom of the box

  //Same as above but then calculated for the next frame. So de Next position
  float nLeft = left + vx;
  float nRight = right + vx;
  float nTop = top + vy;
  float nBottom = bottom + vy;

  //SETUP
  void run() {
    display();
    araUpdatePosition();
  }

  void display() {
    noStroke();
    fill(255, 0, 0);
    rectMode(CENTER); //Starts in the middle of the rectangle and goes outwards instead of the left corner
    rect(x, y, diameter, diameter); //Draw player
  }

  void araUpdatePosition() {
    x += vx; // Horizontal speed
    y += vy; // Vertical speed
    vy += gravity; // Gravity

    left = x - radius;
    right = x + radius;
    top = y - radius;
    bottom = y + radius;

    nLeft = left + vx;
    nRight = right + vx;
    nTop = top + vy;
    nBottom = bottom + vy;
    
    
    //Create momentum. If ara realeased arrow key let the ara slowwly stop
    if (ara1.vx > 0) {
      ara1.vx -= friction/2;
      if (ara1.vx < 0.1) { // This is to prevent sliding if the float becomes so close to zero it counts as a zero and the code stops but the ara still moves a tiny bit
        ara1.vx = 0;
      }
    } else if (ara1.vx < 0) {
      ara1.vx += friction/2;
      if (ara1.vx > -0.1) {
        ara1.vx = 0;
      }
    }

    //Respawn
    if (y > height) {
      x = width/2;
      y = height/2;
      
      vx = 0;
      vy = 0;
    }
  }
}