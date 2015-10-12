class Trap {
  float x, y, iWidth, iHeight, 
    left, right, top, bottom;

  Trap(float _x, float _y, float _width, float _height) {
    x = _x;
    y = _y;
    iWidth = _width;
    iHeight = _height;

    left = x;
    right = x + iWidth;
    top = y;
    bottom = y + iHeight;
  }

  void run() {
    display();
    collisionDetection();
  }

  void display() {
    noStroke();
    fill(0, 0, 0);
    rectMode(CORNER);
    rect(x, y, iWidth, iHeight);
  }

  void collisionDetection() {
    if (rectRectIntersect(player1.nLeft, player1.nTop, player1.nRight, player1.nBottom, left, top, right, bottom)) {
      player1.x = 0;
    }
  }
}