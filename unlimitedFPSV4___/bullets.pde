class Bullet {

  float x, y, angle, speed;

  Bullet(float x, float y, float angle) {
    this.x = x;
    this.y = y;
    this.angle = angle;

    speed = 3;
  }

  void update() {
    x = x + speed*sin(angle);
    y = y - speed*cos(angle);
  }

  void display() {
    ellipse (x, y, 10, 10);
  }
}