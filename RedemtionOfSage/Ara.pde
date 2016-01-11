class Ara {

  //DECLARE
  //Starting proportions
  float aWidth, aHeight, startX, startY, speed, locRel, timerSize;

  //Vectors
  PVector location, velocity;

  //Booleans
  boolean isCarried; //For ara
  boolean[] powerUpActivated;
  boolean canShoot;
  boolean shieldActivate;

  int scalar;
  int timer;
  int sTimer;
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
    timerSize = 5;

    isCarried = false;
    powerUpActivated = new boolean[2];
    canShoot = true;
    timer = 0;
    shieldActivate = true;
  }


  //FUNCTIONS
  void update() {
    araUpdatePosition();
    collisionDetection();

    if (!powerUpActivated[0] && !powerUpActivated[1]) {
      location.x = (player.location.x + 10) + sin(angle) * scalar;
      angle = angle + speed;

      if( location.x >= player.location.x - 39.9 && location.x < player.location.x + 20){
        aWidth += 0.1; 
        aHeight += 0.1;
      } else if( location.x >= player.location.x + 20 && location.x <= player.location.x + 59.9){
        aWidth -= 0.1; 
        aHeight -= 0.1;
      }else{
        aWidth = 20;
        aHeight = 20;
      }
    }
  }

  void display() {
    noStroke();
    fill(255, 255, 0);
    rectMode(CORNER);


    if (powerUpActivated[1] && millis() - sTimer < 3000) {//shield timer countdown with ellipses
      if (millis() - sTimer < 3000) {
      ellipse(player.location.x+((40/6)-2.5), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 2500) {
      ellipse(player.location.x+((40/6)*2-2.5), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 2000) {
      ellipse(player.location.x+((40/6)*3-2.5), player.location.y-10, timerSize, timerSize);
      }      
      if (millis() - sTimer < 1500) {
      ellipse(player.location.x+((40/6)*4-2.5), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 1000) {
      ellipse(player.location.x+((40/6)*5-2.5), player.location.y-10, timerSize, timerSize);
      }
      if (millis() - sTimer < 500) {
      ellipse(player.location.x+((40/6)*6-2.5), player.location.y-10, timerSize, timerSize);
      }  
    }
    if (!powerUpActivated[1] && millis() - timer < 3500) {
      if (!powerUpActivated[1] && timer != 0) {
        if (millis() - timer > 500) {
        ellipse(player.location.x+((40/6)-2.5), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 1000) {
        ellipse(player.location.x+((40/6)*2-2.5), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 1500) {
        ellipse(player.location.x+((40/6)*3-2.5), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 2000) {
        ellipse(player.location.x+((40/6)*4-2.5), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 2500) {
        ellipse(player.location.x+((40/6)*5-2.5), player.location.y-10, timerSize, timerSize);
        }
        if (millis() - timer > 3000) {
        ellipse(player.location.x+((40/6)*6-2.5), player.location.y-10, timerSize, timerSize);
        }       
      }
    } 
 
    
    if (powerUpActivated[1]) {//shield
      pushStyle();
      noFill();
      strokeWeight(5);
      stroke(255, 255, 0);
      rect(player.location.x, player.location.y, player.pWidth, player.pHeight);
      popStyle();
    } else if (powerUpActivated[0]) {//shoot
      aWidth = 20;
      aHeight = 20;
      rect(location.x, location.y, aWidth, aHeight);
    } else {
      rect(location.x, location.y - 35, aWidth, aHeight); 
    }
  }

  void araUpdatePosition() {

    if (powerUpActivated[1] && millis() - sTimer <= 3000) {
      powerUpActivated[1] = true;
      shieldActivate = true;
    }else if (powerUpActivated[1] && millis() - sTimer > 3000) {
      powerUpActivated[1] = false;
      shieldActivate = false;
      ara.timer = millis();
    } 

    if (!powerUpActivated[1] && shieldActivate == false && millis() - timer <= 3000) {
      shieldActivate = false;
    } else if (!powerUpActivated[1] && shieldActivate == false && millis() - timer > 3000) {
      shieldActivate = true;
    } 
    

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
      canShoot = true;
    }
  }

  void respawn() {
    location.x = player.location.x;
    location.y = player.location.y;

    velocity.mult(0);
  }

  void powerUps() {//schieten naar links of naar rechts
    if (powerUpActivated[0] && player.velocity.x >= 0 && canShoot == true) {
      velocity.set(8, 0);
      canShoot = false;
    }
    if (powerUpActivated[0] && player.velocity.x < 0 && canShoot == true) {
      velocity.set(-8, 0);
      canShoot = false;
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
            canShoot = true;                  
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
        canShoot = true;
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