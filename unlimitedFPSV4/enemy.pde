class MovEnemy{
    //DECLARE
    //Starting proportions
  float aWidth, aHeight, startX, startY; 
  
  //Bounding box
  float left, right, top, bottom;

  //Bounding box for the next frame
  float nLeft, nRight, nTop, nBottom;

  //Vectors
  PVector location, velocity;


  //enemy object
  

}

class Turret{
    //DECLARE
    //Starting proportions
  float twidth, theight, startX, startY;
  
  //Bounding box
  float left, right, top, bottom;

  //Vectors
  PVector location;
  
  // Turret object
  Turret (float _x, float _y, float _width, float _height) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    twidth = _width;
    theight = _height;

    left = location.x;
    right = location.x + twidth;
    top = location.y;
    bottom = location.y + theight;
  }


  //FUNCTIONS
  void update() {  
    left = location.x;
    right = location.x + twidth;
    top = location.y;
    bottom = location.y + theight;
  }

  void display() {
    fill(0, 0, 255);
    rectMode(CORNER);
    rect(location.x, location.y, twidth, theight);
  }
}