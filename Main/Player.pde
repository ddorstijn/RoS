class Player {   //<>//
  //player init
  int diameter = 40; // Diameter is used for the width of the player box. Because rectMode center is used radius is middle to right
  float radius = diameter / 2;
  float angle = 0;
  final int startX = 80;
  final int startY = height/2 + 80;
  float x = startX; // Postition of the player on the x-axis
  float y = startY; // Postition of the player on the y-axis
  float vx, vy; //Horizontal and vertical accelerations
  float jumpSpeed = -4.1;
  float maxSpeed = 2.5;
  float acceleration = 0.5;

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

  void run() {
    playerUpdatePosition();
    controls();
    drawPlayer();
  }

  void drawPlayer() {
    noStroke(); //No outline
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects
    rectMode(CENTER); 
    translate(x, y); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(0, 0, diameter, diameter); // character
    popMatrix(); //End the drawing
  }


  void playerUpdatePosition() {
    x += vx; // Horizontal acceleration
    y += vy; // Vertical acceleration
    vy += gravity; // Gravity

    //Create momentum. If player realeased arrow key let the player slowwly stop
    if (player1.vx > 0) {
      player1.vx -= friction;
      if (player1.vx < 0.1) { // This is to prevent sliding if the float becomes so close to zero it counts as a zero and the code stops but the player still moves a tiny bit
        player1.vx = 0;
      }
    } else if (player1.vx < 0) {
      player1.vx += friction;
      if (player1.vx > -0.1) {
        player1.vx = 0;
      }
    }
    
    //Border left side of the level
    if (x < 0 + radius) {
      x = 0 + radius;
      vx = 0;
    }


    /*if (canJump == false && angle <= PI / 2 && vx >= 0) {
     angle += 2 * PI / 360 * 8;
     } else if (canJump == false && angle >= -(PI / 2) && vx < 0) {
     angle -= 2 * PI / 360 * 8;
     }
     
     if (angle > PI / 2) {
     angle = PI / 2;
     }
     if (angle < -PI / 2){
     angle = -PI / 2;
     }*/

    left = x - radius;
    right = x + radius;
    top = y - radius;
    bottom = y + radius;

    nLeft = left + vx;
    nRight = right + vx;
    nTop = top + vy;
    nBottom = bottom + vy;

    if (y > height + 100) {
      x = startX;
      y = startY;

      vx = 0;
      vy = 0;
    }
  }

  void controls() {
    if (keys[0]) {  
      vx -= acceleration;
    }
    if (keys[1]) {
      vx += acceleration;
    }
    //if (keys[2]) {
    //  vy = jumpSpeed;
    //  canJump = false; // Jump is possible
    //}
  }
  
    void collisionDetection() {

    if (rectRectIntersect(nLeft, nTop, nRight, nBottom, ara1.left, player1.top, player1.right, player1.bottom)) {

      if (ara1.vx > 0) {// If ara collides from right side
        right -= radius;
        if (right < player1.left && nRight > player1.left) {// If ara collides from left side
          vx = 0;
        }
      }       
      if (vx < 0) {// If ara collides from right side
        left += radius;
        if (left > right && nLeft < ara1.right) {// If ara collides from left side
          vx = 0;
        }
      }
      if (top > ara1.bottom && nTop < ara1.bottom) {// If ara collides from bottom side
        vy = 0;
      }
      if (vy > 0) {
        bottom -= radius;
        if (bottom < ara1.top && nBottom > ara1.top) {// If ara collides from top side
          vy = 0;
          bottom = ara1.top;
        }



        //If ara has momentum and collides with the player
        if (vx > 0) {// If ara collides from right side
          right -= radius;
          if (right < ara1.left && nRight > ara1.left) {// If ara collides from left side
            vx = 0;
          }
        }       
        if (vx < 0) {// If ara collides from right side
          left += radius;
          if (left > right && nLeft < ara1.right) {// If ara collides from left side
            vx = 0;
          }
        }
        if (top > ara1.bottom && nTop < ara1.bottom) {// If ara collides from bottom side
          vy = 0;
        }
        if (vy > 0) {
          bottom -= radius;
          if (bottom < ara1.top && nBottom > ara1.top) {// If ara collides from top side
            vy = 0;
            bottom = ara1.top;
          }
        }
      }

      //If ctrl is pressed stick to the player
      if (keys[2]) { 
        //stop moving
        ara1.vx = 0;
        ara1.vy = 0;

        //Move x to player x
        ara1.x = player1.x;
        ara1.y = player1.y;
        isCarried = true;
      }
    }
  }
}