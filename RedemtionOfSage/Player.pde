class Player { 

  //DECLARE 
  float angle, pWidth, pHeight;

  //Vectors
  PVector location, velocity, respawn, start;
   

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if able to jump
  boolean canJumpAgain = true; //Check if player can jump second time
  
  int colour, sColour;

  //OBJECT
  Player(int _x, int _y) {

    //INITIALIZE
    jumpSpeed = -4.1;
    maxSpeed = 3;
    acceleration = 0.5;

    canJump = true; //Check if able to jump
    canJumpAgain = true; //check if able tu double jump
    colour = color (0,55,55); //White
    sColour = color (0,255,255);

    pWidth = 40;
    pHeight = 40;
    angle = 0;

    location = new PVector(_x, _y, 0);
    velocity = new PVector(0, 0);
    gravity = new PVector(0, 0.1);
    start = new PVector(_x, _y);
    friction = 0.9;
  }


  //FUNCTIOMS
  void update() {
    playerUpdatePosition();
    controls();
  }

  void display() {
    stroke(sColour); //No outline
    strokeWeight(3);
    fill(colour); //Fill it white
    pushMatrix(); //Create a drawing without affecting other objects 
    translate(location.x + pWidth/2, location.y + pHeight/2); //Move the box to the x and I position
    rotate(angle); //For the jump mechanic
    rect(-pWidth/2, -pHeight/2, pWidth, pHeight); // character 
    popMatrix(); //End the drawing    
  }

  void playerUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    velocity.x *= friction;


  if( level == 1){
    if (location.x >= 2291 && !checkpoint2Activated){
      start = new PVector(2291, 150);
      checkpoint1Activated = true;
      checkpointMusic.play();
    }
    if (location.x >= 4733){
      start = new PVector(4733, 150);
      checkpoint2Activated = true;
      if (checkpointsoundplayed) {
        checkpointMusic.rewind();
        checkpointMusic.play();
        checkpointsoundplayed = true;
      }
    }
  }
  if(level == 2){
    if(location.x >= 3336){
      start = new PVector(3336, 130);
    }
  }

  
// 1765,200 
    //Border left side of the level
    if (location.x < 0) {
      location.x = 0;
      velocity.x = 0;
    }
    
    if (location.y < 0) {
      location.y = 0;
      velocity.y = 0;
    }
    
    if (velocity.y < 0 && angle <= PI / 2 && velocity.x >= 0 && angle > -(PI / 2)) {
      angle += 2 * PI / 360 * 8;
    } else if (velocity.y < 0 && angle >= -(PI / 2) && velocity.x < 0 && angle < PI / 2) {
      angle -= 2 * PI / 360 * 8;
    }

    if (angle > PI / 2) {
      angle = PI / 2;
    }
    if (angle < -PI / 2) {
      angle = -PI / 2;
    }

    if (canJump) {
      angle = 0;      
    }

    if (canJumpAgain) {
      angle = 0;      
    }

    if (velocity.x > maxSpeed) {
      velocity.x = maxSpeed;
    } else if (velocity.x < -maxSpeed) {
      velocity.x = -maxSpeed;
    }

    if (location.y > height + 100) {
      respawn();
    }
  }

  void respawn() {
    //lives--;
    playerDiesMusic.rewind();
    playerDiesMusic.play();
    location.set(start);
    velocity.set(0, 0);
  }

  void controls() {
    if (velocity.y != 0.1) {
      canJump = false;
    }

    if (keysPressed[LEFT] || keysPressed[51]) {  
      velocity.x -= acceleration;
      if (canJump){
        for (int i = 0; i < 1; i++) {
        jump.addParticle();
        }
      }
    }
    if (keysPressed[RIGHT] || keysPressed[52]) {
      velocity.x += acceleration;
      if (canJump){
        for (int i = 0; i < 1; i++) {
          jump.addParticle();
        }
      }
    }
  }
}