class Player { //<>// //<>//
  //player init
  int diameter = 40; // Diameter is used for the width of the player box. Because rectMode center is used radius is middle to right
  float radius = diameter / 2;
  float angle = 0; 
  float x = 80; // Postition of the player on the x-axis
  float y = height/2; // Postition of the player on the y-axis
  float vx, vy; //Horizontal and vertical speeds
  float jumpSpeed = -4.1;
  float maxSpeed = 4;
  float speed = 0.6;

  boolean canJump = true; //Check if ale to jump
  int colour = 255; //White
  
  float left = x - radius; //Left side of player
  float right = x + radius; //Right side of player
  float top = y - radius; //Top side of player
  float bottom = y + radius; //Bottom side of player

  //Next positions
  float nLeft = left + vx; 
  float nRight = right + vx;
  float nTop = top + vy;
  float nBottom = bottom + vy;

  void run() {
    playerUpdatePosition();
    controls();
    drawPlayer();
  }

  void drawPlayer() {
    noStroke(); //No outline
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects
    rectMode(CENTER); 
    translate(x, y); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(0, 0, diameter, diameter); // character
    popMatrix(); //End the drawing
  }


  void playerUpdatePosition() {
    x += vx * 0.60; // Horizontal speed
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

    if (y > height + 100) {
      x = width/2;
      y = height/2;

      vx = 0;
      vy = 0;
    }
  }

  void controls() {
    if (keys[0]) {  
      vx -= speed;
    }
    if (keys[1]) {
      vx += speed;
    }
    //if (keys[2]) {
    //  vy = jumpSpeed;
    //  canJump = false; // Jump is possible
    //}
  }
}