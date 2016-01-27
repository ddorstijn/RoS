class Platform {

  //DECLARE
  //Vectors
  PVector location;

  float iWidth, iHeight, mousex;

  int index, value;

  boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + iWidth && mouseY >= location.y && mouseY < location.y + iHeight;
  }


  Platform(float _x, float _y, float _width, float _height, int _index, int _value) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    iWidth = _width;
    iHeight = _height;

    //If index = 1 it's a normal platform
    //If index = 2 it's a trap or stationary enemy
    //If index = 3 it's the finish!
    index = _index;

    //position int the arrayList
    value = _value;
  }


  //FUNCTIONS
  void update() {  
    mousex = mouseX + pos.x;

    collision();
  }

  void display() {

    noStroke();

    if (isOver() && shiftKey) {
      fill(0, 0, 255);
    } else { 
      switch (index) {
      case 1:     
        fill(255);
        break;
      case 2:
        fill(255, 0, 0);
        break;
      case 3:if (isOver() && shiftKey) {
      fill(0, 0, 255);
    } else { 
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
    }
        fill(0, 255, 0);
        break;
      }
    }

    if (index != 2) {
      rectMode(CORNER);
      rect(location.x, location.y, iWidth, iHeight);
      fill(0);
      rect(location.x+3, location.y+3, iWidth-6, iHeight-6);
    } else {
      for (int i = 0; i < iWidth/40; i++) {
        triangle(location.x+(i*40), location.y+iHeight, location.x+(i*40)+20, location.y, location.x+(i*40)+40, location.y+iHeight);
      }
    }
  }

  void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, iWidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, iHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      if (index == 2) {
        player.respawn();
      } else if (index == 3) {
        changeLevel = true;
      }
<<<<<<< HEAD
      if (abs(xOverlap) > abs(yOverlap)) {//abs geeft een positieve waarde terug(- wordt dus +)
=======
      if (abs(xOverlap) > abs(yOverlap)) {
>>>>>>> ff9b1fa7f0ea32063bd741ecd5c51e74531e2d31
        player.location.y += yOverlap; // adjust player x - position based on overlap
        //If bottom collision
        if (player.velocity.y < 0) {
          player.velocity.y = 0;
        }
        //If top collision
        if (player.location.y < location.y) {
          player.velocity.y = 0;
          player.canJump = true;
          player.canJumpAgain = true;
        }
      } else {
        player.location.x += xOverlap; // adjust player y - position based on overlap
        player.velocity.x = 0;
      }
    }
  }
}