class Platform {

  //INITIALIZE

  //Vectors
  PVector location;

  float iWidth, iHeight;
  float left, right, top, bottom, mousex;

  int index, value;

  boolean isOver() { 
    return mousex >= location.x  && mousex < location.x + iWidth && mouseY >= location.y && mouseY < location.y + iHeight;
  }

  Platform(float _x, float _y, float _width, float _height, int _index, int _value) {
    //DECLARE 
    location = new PVector(_x, _y);

    iWidth = _width;
    iHeight = _height;

    //If index = 1 it's a normal platform
    //If index = 2 it's a trap or stationary enemy
    //If index = 3 it's the finish!
    index = _index;
    
    left = location.x;
    right = location.x + iWidth;
    top = location.y;
    bottom = location.y + iHeight;

    //position int the arrayList
    value = _value;
  }


  //FUNCTIONS
  void update() {  
    mousex = mouseX + pos.x;
  }

  void display() {

    noStroke();

    if (isOver() && shiftKey) {
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

    rectMode(CORNER);
    rect(location.x, location.y, iWidth, iHeight);
  }
}