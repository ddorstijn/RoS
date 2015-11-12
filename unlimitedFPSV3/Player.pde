class Player { 

  //INITIALIZEZ
  int diameter; 
  float radius, angle;

  //Start position
  int startX, startY;

  //Vectors
  PVector location, velocity;

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if ale to jump
  int colour;

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

  Player(int _x, int _y) {
    startX = _x;
    startY = _y;    

    jumpSpeed = -4.1;
    maxSpeed = 3;
    acceleration = 0.5;

    canJump = true; //Check if ale to jump
    colour = 255; //White

    diameter = 40; 
    radius = diameter / 2;
    angle = 0;

    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);
    friction = 0.9;

    left = location.x - radius; //Left side of player
    right = location.x + radius; //Right side of player
    top = location.y - radius; //Top side of player
    bottom = location.y + radius; //Bottom side of player

    nLeft = left + velocity.x;
    nRight = right + velocity.x;
    nTop = top + velocity.y;
    nBottom = bottom + velocity.y;
  }

  void update() {
    playerUpdatePosition();
    collisionDetection();
    controls();
  }

  void respawn() {
    location.x = startX;
    location.y = startY;

    velocity.set(0, 0);
  }

  void display() {
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
      velocity.x = 0;
    }

    if (velocity.x > maxSpeed) {
    velocity.x = maxSpeed;
    } else if (velocity.x < -maxSpeed) {
    velocity.x = -maxSpeed;
    }

    if (canJump == false && angle <= PI / 2 && velocity.x >= 0 && angle > -(PI / 2)) {
      angle += 2 * PI / 360 * 8;
    } else if (canJump == false && angle >= -(PI / 2) && velocity.x < 0 && angle < PI / 2) {
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
      ara1.velocity.x = 0;
      ara1.velocity.y = 0;

      //Move x to player x
      ara1.location.x = location.x - radius/2;
      ara1.location.y = location.y - radius/2;
      isCarried = true;
    }
  }

  void collisionDetection() {

    if (rectRectIntersect(nLeft, nTop, nRight, nBottom, ara1.left, ara1.top, ara1.right, ara1.bottom) && ara1.aHeight == 20) {
      if (velocity.y > 0) {
        bottom -= radius;
        if (bottom < ara1.top && nBottom > ara1.top && location.x > ara1.location.x - radius + 1 && location.x < ara1.location.x + ara1.aWidth + radius - 1) {// If player collides from top side
          velocity.y = 0;
          bottom = top;
          canJump = true;
          angle = 0;
        }
      } 
      if (velocity.x > 0) {// If player collides from right side
        right -= radius;
        if (right < ara1.left && nRight > ara1.left && location.y > ara1.location.y - radius) {// If player collides from left side
          ara1.location.x = location.x + radius; 
          ara1.velocity.x = velocity.x; //Push ara
        }
      }       
      if (velocity.x < 0) {// If player collides from right side
        left += radius;
        if (left > ara1.right && nLeft < ara1.right && location.y > ara1.location.y - radius) {// If player collides from left side
          ara1.location.x = location.x - radius - ara1.aWidth;
          ara1.velocity.x = velocity.x;
        }
      }
    } else {

      
      if (rectRectIntersect(nLeft, nTop, nRight, nBottom, ara1.left, ara1.top, ara1.right, ara1.bottom) && ara1.aHeight == 40) {
        if (velocity.y > 0) {
          bottom -= radius;
          if (bottom < ara1.top && nBottom > ara1.top && location.x > ara1.location.x - radius + 1 && location.x < ara1.location.x + ara1.aWidth + radius - 1) {// If player collides from top side
            velocity.y = 0;
            bottom = top;
            canJump = true;
            angle = 0;
          }
        } 
        if (velocity.x > 0) {// If player collides from right side
          right -= radius;
          if (right < ara1.left && nRight > ara1.left && location.y > ara1.location.y - radius) {
            velocity.x = 0;
            location.x = ara1.left - radius;
    }
        }       
        if (velocity.x < 0) {// If player collides from right side
          left += radius;
          if (left > ara1.right && nLeft < ara1.right && location.y > ara1.location.y - radius) {
            velocity.x = 0;
            location.x = ara1.right + radius;
          }
        }
      }
    }
  }
}