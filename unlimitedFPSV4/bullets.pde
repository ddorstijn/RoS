class bullet {
  float xBullet;
  float yBullet;
  float vBullet;
  float angle;
  float startXBullet;
  float StartYBullet;
  
  bullet(float tempXBullet, float tempYBullet, float tempVBullet, float tempAngle) {
    xBullet = tempXBullet;
    yBullet = tempYBullet;
    vBullet = tempVBullet;
    angle = tempAngle;
    
  }
  void display() {
    ellipse (xBullet, yBullet, 10, 10);
  }
  void move() {
    xBullet = xBullet + vBullet*sin(angle);
    yBullet = yBullet - vBullet*cos(angle);

  }
}