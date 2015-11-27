class MovEnemy {
  //DECLARE
  int diameter; 
  float radius, angle, acceleration;

  //Starting proportions
  float aWidth, aHeight, startX, startY, mousex; 

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

  //Vectors
  PVector location, velocity, nlocation;

  //Position in array
  int value;

  boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + aWidth && mouseY >= location.y && mouseY < location.y + aHeight;
  }

  // Enemy object
  MovEnemy (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);
    nlocation = PVector.add(location, velocity);
    acceleration = 0.5;

    diameter = 40; 
    radius = diameter;
    angle = 0;

    aWidth = _width;
    aHeight = _height;

    left = location.x;
    right = location.x + aWidth;
    top = location.y;
    bottom = location.y + aHeight;

    value = i;
  }

  //FUNCTIONS
  void update() {  
    enemyUpdatePosition();
    collisionDetection();
  }

  void display() {

    if (isOver() && shiftKey) {
      fill(255, 0, 0);
    } else { 
      fill(113, 8, 151);
    }
    rectMode(CORNER);
    rect(location.x, location.y, aWidth, aHeight);
  }

  void enemyUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    nlocation = PVector.add(location, velocity);
    velocity.x = acceleration;

    left = location.x;
    right = location.x + radius;
    top = location.y - radius;
    bottom = location.y + radius;

    nLeft = nlocation.x;
    nRight = nlocation.x + radius;
    nTop = nlocation.y - radius;
    nBottom = nlocation.y + radius;

    for (Platform other : platforms) {
      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.x > 0) {// If enemy collides from right side
          right -= radius;
          if (right < other.left && nRight > other.left && location.y > other.location.y - radius) {// If enemy collides from left side
            velocity.x = acceleration;
            location.x -= acceleration;
            acceleration = -acceleration;
            System.out.println("left side");
          }
        }       
        if (velocity.x < 0) {// If enemy collides from right side
          left += radius;
          if (left > other.right && nLeft < other.right && location.y > other.location.y - radius) {// If enemy collides from left side
            velocity.x = acceleration;
            location.x -= acceleration;
            acceleration = 0.5;
            System.out.println("right side");
          }
        }
      }
    }
  }

  void collisionDetection() {
    for (Platform other : platforms) {

      if (collisionDetect(nLeft, nTop, nRight, nBottom, other.left, other.top, other.right, other.bottom)) {
        if (velocity.y > 0) {
          if (bottom < other.top && nBottom > other.top && location.x > other.location.x - radius + 1 && location.x < other.location.x + other.iWidth + radius - 1) {// If enemy collides from top side
            velocity.y = 0;
            bottom = top;
          }
        }
      }
    }
  }
}



class Turret {
  //DECLARE
  //Starting proportions
  float twidth, theight, startX, startY, mousex;

  //Bounding box
  float left, right, top, bottom;

  //Vectors
  PVector location;

  //Position in array
  int value;

  boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + twidth && mouseY >= location.y && mouseY < location.y + theight;
  }

  // Turret object
  Turret (float _x, float _y, float _width, float _height, int i) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    twidth = _width;
    theight = _height;

    left = location.x;
    right = location.x + twidth;
    top = location.y;
    bottom = location.y + theight;

    value = i;
  }


  //FUNCTIONS
  void update() {  
    left = location.x;
    right = location.x + twidth;
    top = location.y;
    bottom = location.y + theight;

    mousex = mouseX + pos.x;

    float dist = sqrt(sq(player.location.x-location.x) + sq(player.location.y - location.y) );
    if (dist < 300) {
      if (millis() % 5000 >= 0 && millis() % 2000 <= MAX_FRAMESKIP) {
        float angle =  atan((player.location.x-location.x) / (player.location.y-location.y));
        bullet.add(new bullet(location.x + twidth/2, location.y + theight/2, 3, angle));
      }
    }
  }

  void display() {

    if (isOver() && shiftKey) {
      fill(255, 0, 0);
    } else { 
      fill(0, 0, 255);
    }
    rectMode(CORNER);
    rect(location.x, location.y, twidth, theight);
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
    }
    endShape(CLOSE);
  }
}