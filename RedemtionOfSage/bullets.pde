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
    collision();
  }

  void display() {
    ellipse (xBullet, yBullet, 10, 10);
  }

  void move() {
    xBullet = xBullet + vx;
    yBullet = yBullet + vy;
  }

  void collision() {
    for /*(bullet b : bullet)*/(int lenB = bullet.size(), b = lenB; b-- != 0; ) {
      final bullet u = bullet.get(b);
      for (Platform other : platforms) {
        if (CircleRectCollision(u.xBullet, u.yBullet, 5, other.left, other.top, other.right, other.bottom)) {
          bullet.set(b, bullet.get(--lenB));
          {
            println("BULLET COLLISION");
          }
          bullet.remove(lenB);
          bulletCollision = true;
          break;
        }
      }
    }
  }
}