class Platform {  //<>//
  float x, y, iWidth, iHeight, 
    left, right, top, bottom;

  int index;
  
  int pos;

  Platform(float _x, float _y, float _width, float _height, int _index, int _i) {
    x = _x;
    y = _y;
    iWidth = _width;
    iHeight = _height;

    left = x;
    right = x + iWidth;
    top = y;
    bottom = y + iHeight;

    //If index = 1 it's a normal platform
    //If index = 2 it's a trap or stationary enemy
    //If index = 3 it's the finish!
    index = _index;
    
    pos = _i;
  }

  void run() {
    display();
    collisionDetection();
  }

  void display() {
    noStroke();
    switch (index) {
    case 1:     
      fill(0, 0, 0);
      break;
    case 2:
      fill(255, 0, 0);
      break;
    case 3:
      fill(0, 255, 0);
      break;
    }
    rectMode(CORNER);
    rect(x, y, iWidth, iHeight);
  }

  void collisionDetection() {

    if (rectRectIntersect(player1.nLeft, player1.nTop, player1.nRight, player1.nBottom, left, top, right, bottom)) {
      if (player1.velocity.y > 0) {
        player1.bottom -= player1.radius;
        if (player1.bottom < top && player1.nBottom > top && player1.location.x > x - player1.radius + 1 && player1.location.x < x + iWidth + player1.radius - 1) {// If player collides from top side
          player1.velocity.y = 0;
          player1.bottom = top;
          player1.canJump = true;
          player1.angle = 0;
        }
      } 
      if (player1.velocity.x > 0) {// If player collides from right side
        player1.right -= player1.radius;
        if (player1.right < left && player1.nRight > left && player1.location.y > y - player1.radius) {// If player collides from left side
          player1.velocity.x = 0;
        }
      }       
      if (player1.velocity.x < 0) {// If player collides from right side
        player1.left += player1.radius;
        if (player1.left > right && player1.nLeft < right && player1.location.y > y - player1.radius) {// If player collides from left side
          player1.velocity.x = 0;
        }
      }
      if (player1.top >= bottom && player1.nTop <= bottom && player1.location.x > x - player1.radius + 1 && player1.location.x < x + iWidth + player1.radius - 1) {// If player collides from bottom side
        player1.velocity.y = 0;
      }

      if (index == 2) {
        fill(255);
        text("You suck!", worldCamera.pos.x + width/2, height/2);
        player1.respawn();
      }

      if (index == 3) {
        fill(255);
        text("You win!", worldCamera.pos.x + width/2, height/2);
      }
    }

    if (rectRectIntersect(ara1.nLeft, ara1.nTop, ara1.nRight, ara1.nBottom, left, top, right, bottom)) {
      if (ara1.velocity.x > 0) {// If ara collides from right side
        ara1.right -= ara1.aWidth/2;
        if (ara1.right < left && ara1.nRight > left) {// If ara collides from left side
          ara1.velocity.x = 0;
        }
      }       
      if (ara1.velocity.x < 0) {// If ara collides from right side
        ara1.left += ara1.aWidth/2;
        if (ara1.left > right && ara1.nLeft < right) {// If ara collides from left side
          ara1.velocity.x = 0;
        }
      }
      if (ara1.top > bottom && ara1.nTop < bottom) {// If ara collides from bottom side
        ara1.velocity.y = 0;
      }
      if (ara1.velocity.y > 0) {
        ara1.bottom -= ara1.aWidth/2;
        if (ara1.bottom < top && ara1.nBottom > top) {// If ara collides from top side
          ara1.velocity.y = 0;
          ara1.bottom = top;
        }
      }
    }
  }
}