class Ara {
  //INIT
  int diameter = 20; // Diameter is used for the width of the ara box. Because rectMode center is used radius is middle to right
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
    collisionDetection();
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

    if (y > height) {
      x = width/2;
      y = height/2;
      vx = 0;
      vy = 0;
    }
  }


  void collisionDetection() {

    if (rectRectIntersect(nLeft, nTop, nRight, nBottom, player1.left, player1.top, player1.right, player1.bottom)) {

      if (player1.vx > 0) {// If ara collides from right side
        right -= radius;
        if (right < player1.left && nRight > player1.left) {// If ara collides from left side
          vx = 0;
        }
      }       
      if (vx < 0) {// If ara collides from right side
        left += radius;
        if (left > right && nLeft < player1.right) {// If ara collides from left side
          vx = 0;
        }
      }
      if (top > player1.bottom && nTop < player1.bottom) {// If ara collides from bottom side
        vy = 0;
      }
      if (vy > 0) {
        bottom -= radius;
        if (bottom < player1.top && nBottom > player1.top) {// If ara collides from top side
          vy = 0;
          bottom = player1.top;
        }



        //If ara has momentum and collides with the player
        if (vx > 0) {// If ara collides from right side
          right -= radius;
          if (right < player1.left && nRight > player1.left) {// If ara collides from left side
            vx = 0;
          }
        }       
        if (vx < 0) {// If ara collides from right side
          left += radius;
          if (left > right && nLeft < player1.right) {// If ara collides from left side
            vx = 0;
          }
        }
        if (top > player1.bottom && nTop < player1.bottom) {// If ara collides from bottom side
          vy = 0;
        }
        if (vy > 0) {
          bottom -= radius;
          if (bottom < player1.top && nBottom > player1.top) {// If ara collides from top side
            vy = 0;
            bottom = player1.top;
          }
        }
      }

      //If ctrl is pressed stick to the player
      if (keys[2]) { 
        //stop moving
        vx = 0;
        vy = 0;

        //Move x to player x
        x = player1.x;
        y = player1.y;
        isCarried = true;
      }
    }
  }
}