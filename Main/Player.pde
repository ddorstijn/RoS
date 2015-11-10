class Player { //<>//

  //player init
  int diameter = 40; // Diameter is used for the width of the player box. Because rectMode center is used radius is middle to right
  float radius = diameter / 2;
  float angle = 0;

  //Start position
  int startX;
  int startY;

  PVector location;
  PVector velocity;

  float x; // Postition of the player on the x-axis
  float y; // Postition of the player on the y-axis
  float vx, vy; //Horizontal and vertical accelerations
  float jumpSpeed = -4.1;
  float maxSpeed = 3;
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

  Player(int _x, int _y) {
    startX = _x;
    startY = _y;    

    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);
    friction = 0.9;
  }

  void run() {
    playerUpdatePosition();
    collisionDetection();
    controls();
    drawPlayer();
  }

  void respawn() {
    location.x = startX;
    location.y = startY;

    velocity.set(0, 0);
  }

  void drawPlayer() {
    noStroke(); //No outline
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects
    rectMode(CENTER); 
    translate(location.x, location.y); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(0, 0, diameter, diameter); // character
    popMatrix(); //End the drawing
  }


  void playerUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    velocity.x *= friction;

    //Border left side of the level
    if (location.x < 0 + radius) {
      location.x = 0 + radius;
      velocity.limit(0);
    }
    
    if (velocity.x > maxSpeed){
      velocity.x = maxSpeed;
    } else if (velocity.x < -maxSpeed){
      velocity.x = -maxSpeed;
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

    left = location.x - radius;
    right = location.x + radius;
    top = location.y - radius;
    bottom = location.y + radius;

    nLeft = left + velocity.x;
    nRight = right + velocity.x;
    nTop = top + velocity.y;
    nBottom = bottom + velocity.y;

    if (location.y > height + 100) {
      respawn();
    }
  }

  void controls() {
    if (keys[0]) {  
      velocity.x -= acceleration;
    }
    if (keys[1]) {
      velocity.x += acceleration;
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

  void collisionDetection() {

    //if (rectRectIntersect(nLeft, nTop, nRight, nBottom, ara1.left, ara1.top, ara1.right, ara1.bottom)) {

    //  if (vx > 0) {// If player collides from left side
    //    right -= radius;        
    //    if (right < ara1.left && nRight > ara1.left) {
    //      ara1.x = x + radius; 
    //      ara1.vx = vx; //Push ara
    //    }
    //  }       

    //  if (vx < 0) {// If player collides from right side
    //    left += radius;
    //    if (left > ara1.right && nLeft < ara1.right) {
    //      ara1.x = x - radius - ara1.aWidth;
    //      ara1.vx = vx;
    //    }
    //  }

    //  if (vy > 0) {
    //    bottom -= radius;
    //    if (bottom < ara1.top && nBottom > ara1.top) {// If player collides from top side
    //      vy = 0;
    //      bottom = top;
    //      canJump = true;
    //      angle = 0;
    //    }
    //  }
    //}
  }
}