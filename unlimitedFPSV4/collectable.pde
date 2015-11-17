class Collectable {

  //DECLARE
  //Vectors
  PVector location;

  float cwidth, cheight;
  float left, right, top, bottom;


  Collectable(float _x, float _y, float _width, float _height) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    cwidth = _width;
    cheight = _height;

    left = location.x;
    right = location.x + cwidth;
    top = location.y;
    bottom = location.y + cheight;
  }


  //FUNCTIONS
  void update() {  
    left = location.x;
    right = location.x + cwidth;
    top = location.y;
    bottom = location.y + cheight;
  }

  void display() {
    fill(255, 255, 0);
    ellipseMode(CORNER);
    ellipse(location.x, location.y, cwidth, cheight);
  }
}