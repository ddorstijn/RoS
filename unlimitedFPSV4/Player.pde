class Player { 

  //INITIALIZEZ
  int diameter; 
  float radius, angle;

  //Start position
  int startX, startY;

  //Vectors
  PVector location, velocity, nlocation;

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if ale to jump
  int colour;

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

  // Basic collision detection method
  boolean rectRectIntersect(float otherX, float otherY, float otherWidth, float otherHeight) {
    return !(nlocation.x - radius < otherX || nlocation.x + radius < otherX + otherWidth || nlocation.y + radius < otherY || nlocation.y - radius < otherY + otherHeight);
  }

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
    nlocation = PVector.add(location, velocity);
    friction = 0.9;

    left = location.x - radius; //Left side of player
    right = location.x + radius; //Right side of player
    top = location.y - radius; //Top side of player
    bottom = location.y + radius; //Bottom side of player
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

    if (location.y > height + 100) {
      respawn();
    }
  }

  void controls() {
    if (keysPressed[0]) {  
      velocity.x -= acceleration;
    }
    if (keysPressed[1]) {
      velocity.x += acceleration;
    }
    //If ctrl is pressed stick to the player
    if (keysPressed[2]) { 

      //stop moving
      ara1.velocity.x = 0;
      ara1.velocity.y = 0;

      //Move x to player x
      ara1.location.x = location.x - radius/2;
      ara1.location.y = location.y - radius/2;
      ara1.isCarried = true;
    }
  }

  void collisionDetection() {
    for (int i = 0; i < platforms.size(); i++) {
      Platform other = (Platform) platforms.get(i);
      println(other.location.y);
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      if (rectRectIntersect(other.location.x, other.location.y, other.iWidth, other.iHeight)) {
        if (velocity.y > 0) {
          bottom -= radius;
          if (bottom < other.location.y && nlocation.y + radius > other.location.y && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.iWidth + radius - 1) {// If player collides from top side
            velocity.y = 0;
            bottom = top;
            canJump = true;
            angle = 0;
          }
        } 
        if (velocity.x > 0) {// If player collides from right side
          right -= radius;
          if (right < other.location.x && nlocation.x + radius > other.location.x && location.y > other.location.y - radius) {// If player collides from left side
            velocity.x = 0;
          }
        }       
        if (velocity.x < 0) {// If player collides from right side
          left += radius;
          if (left > other.location.x + other.iWidth && nlocation.x < other.location.x + other.iWidth && location.y > other.location.y - radius) {// If player collides from left side
            velocity.x = 0;
          }
        }
        if (top >= other.location.y + other.iHeight && nTop <= other.location.y + other.iHeight && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.iWidth + radius - 1) {// If player collides from bottom side
          velocity.y = 0;
        }
      }
    }
  }
}