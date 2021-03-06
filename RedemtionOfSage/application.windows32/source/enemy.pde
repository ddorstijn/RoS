class MovEnemy {
  //DECLARE
  //Starting proportions
  float aWidth, aHeight, mousex; 

  //Vectors
  PVector location, velocity;

  //Position in array
  int value;

  boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + aWidth && mouseY >= location.y && mouseY < location.y + aHeight;
  }

  // Enemy object
  MovEnemy (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);
    velocity = new PVector(0.5, 0);
    gravity = new PVector(0, 0.1);

    aWidth = _width;
    aHeight = _height;
    value = i;
  }

  //FUNCTIONS
  void update() {  
    enemyUpdatePosition();
    collisionDetection();
  }

  void display() {
    if (isOver() && shiftKey)
      fill(255, 0, 0);
    else 
    fill(0);
    stroke(255, 0, 0);
    strokeWeight(2);

    rectMode(CORNER);
    rect(location.x, location.y, aWidth, aHeight);
    triangle(location.x + 10, location.y, location.x, location.y - 15, location.x - 10, location.y);
    triangle(location.x + aWidth - 10, location.y, location.x + aWidth, location.y - 15, location.x + aWidth + 10, location.y);
    //triangle(location.x+4,location.y+4, location.x+20, location.y+8, location.x +10, location.y +14);
    //triangle(location.x+36,location.y+4, location.x+20, location.y+8, location.x +30, location.y +14);
    //rect(location.x+4, location.y+25, aWidth-8,aHeight/5);
  }


  void enemyUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
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
    if (xOverlap != 0 && yOverlap != 0) {
      playerDiesMusic.rewind();
      playerDiesMusic.play();
      player.respawn();
    }
  }
}



class Turret {
  //DECLARE
  //Starting proportions
  float twidth, theight, startX, startY, mousex;

  //Vectors
  PVector location;

  //Position in array
  int value;

  int interval; //Time between bullets shot

  boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + twidth && mouseY >= location.y && mouseY < location.y + theight;
  }

  // Turret object
  Turret (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    twidth = _width;
    theight = _height;

    value = i;

    interval = 60;
  }


  //FUNCTIONS
  void update() {  
    mousex = mouseX + pos.x;

    collision();

    float dist = sqrt(sq(player.location.x-location.x) + sq(player.location.y - location.y) );
    if (dist < 300) {
      if (interval == 0) {
        float angle =  atan((player.location.x-location.x) / (player.location.y-location.y));
        bullet.add(new bullet(location.x + twidth/2, location.y + theight/2, 3, angle));
        interval = 60;
        enemyShootMusic.rewind();
        enemyShootMusic.play();
      } else {
        interval--;
      }
    }
  }

  void display() {

    if (isOver() && shiftKey) {
      fill(255, 0, 0);
    } else { 
      fill(0, 0, 0);
    }
    rectMode(CORNER);
    stroke(255, 0, 0);
    strokeWeight(2);
    rect(location.x, location.y, twidth, theight);
    ellipse(location.x+5, location.y+5 , twidth - 10 , theight - 10);
  }

  void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, twidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, theight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      if (abs(xOverlap)-2 > abs(yOverlap)) {
        player.location.y += yOverlap; // adjust player x - position based on overlap
        //If bottom collision
        if (player.velocity.y < 0) {
          player.velocity.y = 0;
        }
        //If top collision
        if (player.location.y < location.y) {
          player.velocity.y = 0; 
          player.canJump = true;
        }
      } else {
        player.location.x += xOverlap; // adjust player y - position based on overlap
        player.velocity.x = 0;
      }
    }
  }
}

class Boss {

  int n;
  float cx, cy, r, angle;
  Boss(int n, float cx, float cy, float r) {
    this.angle = 360.0 / n;
    this.n = n;
    this.cx = cx;
    this.cy = cy;
    this.r =r;
  }

  void display() {
    beginShape();
    for (int i = 0; i < n; i++) {
      vertex(cx + r * cos(radians(angle * i)), 
        cy + r * sin(radians(angle * i)));
      rect(cx - r/2, cy - r/2, 20, 40); 
      rect(cx + r/4, cy - r/2, 20, 40);  
      rect(cx - r/8, cy + r/3, 20, 20);
    }
    endShape(CLOSE);
  }
}