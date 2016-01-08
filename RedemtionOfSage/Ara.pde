class Ara {

  //DECLARE
  //Starting proportions
  float aWidth, aHeight, startX, startY, speed, locRel;

  //Vectors
  PVector location, velocity;

  //Booleans
  boolean isCarried; //For ara
  boolean[] powerUpActivated;

  int scalar;
  float angle;

  //OBJECT
  Ara(float _x, float _y) {
    //INITIALIZE
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);

    startX = location.x;
    startY = location.y;

    aWidth = 20;
    aHeight = 20; 
    angle = 0.05;
    scalar = 50;
    speed = 0.02;

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
    
 
    
    if (powerUpActivated[1]) {
      pushStyle();
      noFill();
      strokeWeight(5);
      stroke(255, 255, 0);
      rect(player.location.x, player.location.y, player.pWidth, player.pHeight);
      popStyle();
    } else if (powerUpActivated[0]) {
      aWidth = 20;
      aHeight = 20;
      rect(location.x, location.y, aWidth, aHeight);
    } else {
      location.x = (player.location.x + 10) + sin(angle) * scalar;
      angle = angle + speed;
      rect(location.x, location.y - 35, aWidth, aHeight); 
      
      if( location.x >= player.location.x - 39.9 && location.x < player.location.x + 20){
      aWidth += 0.1; 
      aHeight += 0.1;
      }
      else if( location.x >= player.location.x + 20 && location.x <= player.location.x + 59.9){
      aWidth -= 0.1; 
      aHeight -= 0.1;
      }else{
      aWidth = 20;
      aHeight = 20;
      }
    }
  }

  void araUpdatePosition() {

    location.add(velocity); //Speed
    //velocity.add(gravity); //Gravity
    //velocity.x *= friction;

    if (!powerUpActivated[0]) {
    // velocity.x *= friction;
    // location.x = player.location.x +10;
     location.y = player.location.y +10;
    }

    if (velocity.y > 5) {
      velocity.y = 5;
    }

    //Respawn
    if (location.y > height || location.x > (player.location.x + (width / 2)) || location.x < (player.location.x - (width / 2))) {
      powerUpActivated[0] = false;
    }
  }

  void respawn() {
    location.x = player.location.x;
    location.y = player.location.y;

    velocity.mult(0);
  }

  void powerUps() {
    if (powerUpActivated[0] && player.velocity.x >= 0) {
      velocity.set(8, 0);
    }
    if (powerUpActivated[0] && player.velocity.x < 0) {
      velocity.set(-8, 0);
    }
  }

  void collisionDetection() {
    if (powerUpActivated[0]) {
      for (Platform other : platforms) {
        float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.iWidth);
        float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.iHeight);

        if (abs(xOverlap) > 0 && abs(yOverlap) > 0) {
          // Determine wchich overlap is the largest
          if (abs(xOverlap) > abs(yOverlap)) {
            araRaaktIetsMusic.rewind();
            location.y += yOverlap; // adjust player x - position based on overlap
               araRaaktIetsMusic.play();      
          } else {
            location.x += xOverlap; // adjust player y - position based on overlap
            powerUpActivated[0] = false;                  
          }
        }
      }
    }

    for (MovEnemy other : movEnemy) {
      float xOverlap = calculate1DOverlap(location.x, other.location.x, aWidth, other.aWidth);
      float yOverlap = calculate1DOverlap(location.y, other.location.y, aHeight, other.aHeight);

      // Determine wchich overlap is the largest
      if (xOverlap != 0 && yOverlap != 0 && powerUpActivated[0]) {
        powerUpActivated[0] = false;
        enemyDiesMusic.rewind();
        enemyDiesMusic.play();
        movEnemy.remove(other);
        for (int i = 0; i < 60; i++) {
            enemyParticle.addenemyParticle();
          }
        break;
      }
    }
  }
}