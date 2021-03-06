class bullet {
  float xBullet;
  float yBullet;
  float vBullet;
  float bWidth;
  float bHeight;
  float angle;
  float vx, vy;

  bullet(float tempXBullet, float tempYBullet, float tempVBullet, float tempAngle) {
    xBullet = tempXBullet;
    yBullet = tempYBullet;
    vBullet = tempVBullet;
    bWidth = 10;
    bHeight = 10;
    angle = tempAngle;

    if (player.location.y < tempYBullet) {
      vx = -(vBullet*sin(angle));
      vy = -( vBullet*cos(angle));
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
    fill(255,0,0);
    rect(xBullet, yBullet, bWidth, bHeight);
  }

  void move() {
    xBullet = xBullet + vx;
    yBullet = yBullet + vy;
  }

  void collision() {
    float xOverlap = calculate1DOverlap(player.location.x, xBullet, player.pWidth, bWidth);
    float yOverlap = calculate1DOverlap(player.location.y, yBullet, player.pHeight, bHeight);

    // Determine wchich overlap is the largest
    if (xOverlap != 0 && yOverlap != 0) {
      collisionObject = true;
      if (ara.powerUpActivated[1]) {
          for (int i = 0; i < 40; i++) {
            bulletParticle.addbulletParticle();
          }
        }  
      if (!ara.powerUpActivated[1]){
        player.respawn();
      }  
  } 

    for (Platform other : platforms) {
      xOverlap = calculate1DOverlap(other.location.x, xBullet, other.iWidth, bWidth);
      yOverlap = calculate1DOverlap(other.location.y, yBullet, other.iHeight, bHeight);

      // Determine wchich overlap is the largest
      if (xOverlap != 0 && yOverlap != 0) {
        collisionObject = true;
        break;
      } 
    }
  }
}