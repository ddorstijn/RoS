class bullet {
  float xBullet;
  float yBullet;
  float vBullet;
  float angle;
  float vx, vy;

  bullet(float tempXBullet, float tempYBullet, float tempVBullet, float tempAngle) {
    xBullet = tempXBullet;
    yBullet = tempYBullet;
    vBullet = tempVBullet;
    angle = tempAngle;

    if (player.location.y < tempYBullet) {
      vx = -(vBullet*sin(angle));
      vy = -(vBullet*cos(angle));
    } else {
      vx = (vBullet*sin(angle));
      vy = (vBullet*cos(angle));
    }
  }
  void display() {
    ellipse (xBullet, yBullet, 10, 10);
  }
  void move() {
    xBullet = xBullet + vx;
    yBullet = yBullet + vy;
  }
}