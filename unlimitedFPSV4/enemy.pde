class MovEnemy {
  //DECLARE
  //Starting proportions
  float aWidth, aHeight, startX, startY, mousex; 

  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

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
    left = location.x;
    right = location.x + aWidth;
    top = location.y;
    bottom = location.y + aHeight;

    mousex = mouseX + pos.x;
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