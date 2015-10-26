class Platform { //<>// //<>//
  float x, y, iWidth, iHeight, 
    left, right, top, bottom, index;

  Platform(float _x, float _y, float _width, float _height, int _index) {
    x = _x;
    y = _y;
    iWidth = _width;
    iHeight = _height;

    left = x;
    right = x + iWidth;
    top = y;
    bottom = y + iHeight;

    index = _index; //Giving an id
  }

  void run() {
    display();
    collisionDetection();
    controls();
  }


  void display() {
    noStroke();
    fill(0, 0, 0);
    rectMode(CORNER);
    rect(x, y, iWidth, iHeight);
  }

  void controls() {
    // Keyboard control
    if (keyPressed == true) {
      switch (keyCode) {
      case 37: // In case left arrow key is pressed and left is not obstructed move left
        keys[0] = true;
        break;
      case 39:
        keys[1] = true;
        break;
      case 17:
        keys[2] = true;
        break;
      case 38:
        if (player1.canJump == true) {
          player1.vy = player1.jumpSpeed;
          player1.canJump = false; // Jump is possible
        }

        //if (player1.canJump == true) {
        //  player1.canJump = false;
        //  keys[2] = true;
        //}
        break;
      }
    }

    // Check if speed doesn't get to high
    if (player1.vx > player1.maxSpeed) {
      player1.vx = player1.maxSpeed;
    } else if (player1.vx < -player1.maxSpeed) {
      player1.vx = -player1.maxSpeed;
    }
  }

  void mouseReleased() {
    // Removal of a box
    if (mouseButton == RIGHT) {
      System.out.println(worldCamera.pos.x + mouseX + " " + left + " " + right);
      if (worldCamera.pos.x + mouseX > left && worldCamera.pos.x + mouseX < right && mouseY > top && mouseY < bottom) {
        platforms.remove(index);
      }
    }
  }

  void collisionDetection() {

    if (rectRectIntersect(player1.nLeft, player1.nTop, player1.nRight, player1.nBottom, left, top, right, bottom)) {
      if (player1.vx > 0) {// If player collides from right side
        player1.right -= player1.radius;
        if (player1.right < left && player1.nRight > left) {// If player collides from left side
          player1.vx = 0;
        }
      }       
      if (player1.vx < 0) {// If player collides from right side
        player1.left += player1.radius;
        if (player1.left > right && player1.nLeft < right) {// If player collides from left side
          player1.vx = 0;
        }
      }
      if (player1.top > bottom && player1.nTop < bottom) {// If player collides from bottom side
        player1.vy = 0;
      }
      if (player1.vy > 0) {
        player1.bottom -= player1.radius;
        if (player1.bottom < top && player1.nBottom > top) {// If player collides from top side
          player1.vy = 0;
          player1.bottom = top;
          player1.canJump = true;
          player1.angle = 0;
        }
      }
    }
    
    
    if (rectRectIntersect(ara1.nLeft, ara1.nTop, ara1.nRight, ara1.nBottom, left, top, right, bottom)) {
      if (ara1.vx > 0) {// If ara collides from right side
        ara1.right -= ara1.radius;
        if (ara1.right < left && ara1.nRight > left) {// If ara collides from left side
          ara1.vx = 0;
        }
      }       
      if (ara1.vx < 0) {// If ara collides from right side
        ara1.left += ara1.radius;
        if (ara1.left > right && ara1.nLeft < right) {// If ara collides from left side
          ara1.vx = 0;
        }
      }
      if (ara1.top > bottom && ara1.nTop < bottom) {// If ara collides from bottom side
        ara1.vy = 0;
      }
      if (ara1.vy > 0) {
        ara1.bottom -= ara1.radius;
        if (ara1.bottom < top && ara1.nBottom > top) {// If ara collides from top side
          ara1.vy = 0;
          ara1.bottom = top;
        }
      }
    }
  }
}