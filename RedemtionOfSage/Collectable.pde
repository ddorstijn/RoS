class Collectable {

  //DECLARE
  //Vectors
  PVector location;

  float cwidth, cheight;
  
  int value;

  Collectable(float _x, float _y, float _width, float _height, int value) {

    //INITIALIZE 
    location = new PVector(_x, _y);

    cwidth = _width;
    cheight = _height;

    this.value = value;
  }


  //FUNCTIONS
  void update() {
    collision();
  }

  void display() {
    fill(255, 255, 0);
    ellipseMode(CENTER);
    ellipse(location.x+cwidth/2, location.y+cheight/2, cwidth+kickSize/2, cheight+kickSize/2);
    ellipseMode(CORNER);
  }

  void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, location.x, player.pWidth, cwidth);
    float yOverlap = calculate1DOverlap(player.location.y, location.y, player.pHeight, cheight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      coinMusic.rewind();
      score += 100; 
      collisionObject = true;
      location.x = -100;
      coinMusic.play();
      currentWaveformcolor = color(255,255,0);
    } 
  } 
}