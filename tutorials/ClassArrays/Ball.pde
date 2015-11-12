class Ball {
  //INIT
  float x;
  float y;

  //OBJECTS
  Ball(float _x, float _y) {
    //DECLARE
    x = _x;
    y = _y;
  }

  //FUNCTIONS
  void display() {
    fill(255);
    ellipse(x, y, 50, 50);
  }
}