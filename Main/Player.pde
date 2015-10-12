class Player { //<>//
  //player init
  int diameter = 40; // Diameter is used for the width of the player box. Because rectMode center is used radius is middle to right
  float radius = diameter / 2;
  float angle = 0; 
  float x = width/2; // Postition of the player on the x-axis
  float y = height/2; // Postition of the player on the y-axis
  float vx, vy; //Horizontal and vertical speeds
  float jumpSpeed = -4.1;
  float maxSpeed = 4;
  float speed = 0.6;

  boolean canJump = true;
  int colour = 255;

  float left = x - radius;
  float right = x + radius;
  float top = y - radius;
  float bottom = y + radius;

  float nLeft = left + vx;
  float nRight = right + vx;
  float nTop = top + vy;
  float nBottom = bottom + vy;

  void run() {
    playerUpdatePosition();
    controls();
    //stayInCanvas();
    drawPlayer();
  }

  void drawPlayer() {
    noStroke();
    fill(colour);
    pushMatrix();
    rectMode(CENTER);
    translate(x, y);
    rotate(angle);
    rect(0, 0, diameter, diameter); // character
    popMatrix();
  }


  void playerUpdatePosition() {
    x += vx; // Horizontal speed
    y += vy; // Vertical speed
    vy += gravity; // Gravity

    /*if (canJump == false && angle <= PI / 2 && vx >= 0) {
     angle += 2 * PI / 360 * 8;
     } else if (canJump == false && angle >= -(PI / 2) && vx < 0) {
     angle -= 2 * PI / 360 * 8;
     }
     
     if (angle > PI / 2) {
     angle = PI / 2;
     }
     if (angle < -PI / 2){
     angle = -PI / 2;
     }*/

    left = x - radius;
    right = x + radius;
    top = y - radius;
    bottom = y + radius;

    nLeft = left + vx;
    nRight = right + vx;
    nTop = top + vy;
    nBottom = bottom + vy;
  }

  void controls() {
    if (keys[0]) {  
      vx -= speed;
    }
    if (keys[1]) {
      vx += speed;
    }
    if (keys[2]) {
      vy = jumpSpeed;
      canJump = false; // Jump is possible
    }
  }

  //void stayInCanvas() {
  //  if (x > width - radius) { // If player is to far to the right then the speed should be 0 and to prevent the player from slightly bugging out of the level the position is reset
  //    x = width - radius;
  //    vx = 0;
  //  }

  //  if (x < 0 + radius) {
  //    x = 0 + radius;
  //    vx = 0;
  //  }
  //}
}