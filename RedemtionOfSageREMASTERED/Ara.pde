class Ara {

  //DECLARE
  //Starting proportions
  float aWidth, aHeight, startX, startY;

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

    if (velocity.y > 5) {
      velocity.y = 5;
    }

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
    if (powerUpActivated[0]) {
      
    }
  }

  void collisionDetection() {
    for (Platform other : platforms) {
      float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.iWidth);
      float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.iHeight);

      if (abs(xOverlap) > 0 && abs(yOverlap) > 0) {
        // Determine wchich overlap is the largest
        if (abs(xOverlap) > abs(yOverlap)) {
          location.y += yOverlap; // adjust player x - position based on overlap
          velocity.y = 0;
        } else {
          location.x += xOverlap; // adjust player y - position based on overlap
          velocity.x *= -1;
        }
      }
    }

    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, aWidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, aHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0 && !isCarried) {
      if (abs(xOverlap)-2 > abs(yOverlap)) {
        //If bottom collision
        if (velocity.y > 0) {
          location.y -= yOverlap; // adjust player x - position based on overlap
          velocity.y = 0;
        } else 
          player.location.y += yOverlap;
          
        //If top collision
        if (player.location.y < location.y) {
          player.velocity.y = 0; 
          player.canJump = true;
        }
      } else {
        player.location.x += xOverlap; // adjust player y - position based on overlap
        if (!powerUpActivated[0]) {
          velocity.x = player.velocity.x;  
        } else 
          player.velocity.x = 0;
      }
    }   
  }
}