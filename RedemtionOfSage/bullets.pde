class bullet {
  float xBullet;
  float yBullet;
  float vBullet;
  float angle;
  float vx, vy;

  boolean hit() {
    float dist = sqrt(sq(player.location.x-xBullet) + sq(player.location.y - yBullet) );
    if (dist < 30) {
      return true;
    } else {
      return false;
    }
  }

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

  void update() {
    move();
  }

  void display() {
    ellipse (xBullet, yBullet, 10, 10);
  }

  void move() {
    xBullet = xBullet + vx;
    yBullet = yBullet + vy;
  }
}