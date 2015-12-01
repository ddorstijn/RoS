class Player { 

  //DECLARE 
  float angle, pWidth, pHeight;

  //Vectors
  PVector location, velocity, start;

  //Properties
  float jumpSpeed, maxSpeed, acceleration;
  boolean canJump = true; //Check if able to jump
  int colour;

  //OBJECT
  Player(int _x, int _y) {

    //INITIALIZE
    jumpSpeed = -4.1;
    maxSpeed = 3;
    acceleration = 0.5;

    canJump = true; //Check if ale to jump
    colour = 255; //White

    pWidth = 40;
    pHeight = 40;
    angle = 0;

    location = new PVector(_x, _y);
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
    noStroke(); //No outline
    fill(colour); //Fill it white
    rect(location.x, location.y, pWidth, pHeight); // character 
  }

  void playerUpdatePosition() {
    location.add(velocity);
    velocity.add(gravity);
    velocity.x *= friction;

    //Border left side of the level
    if (location.x < 0) {
      location.x = 0;
      velocity.x = 0;
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
    //location.set(start);
    //velocity.set(0, 0);
  }

  void controls() {
    if (velocity.y != 0.1) {
      canJump = false;  
    }

    if (keysPressed[LEFT]) {  
      velocity.x -= acceleration;
    }
    if (keysPressed[RIGHT]) {
      velocity.x += acceleration;
    }
    if (keysPressed[67]) {
      if (canJump == true) {
        velocity.y = jumpSpeed;
        canJump = false; // Jump is possible
      }
    }

    //If x is pressed stick to the player
    if (keysPressed[88]) { 

      //stop moving
      ara.velocity.x = 0;
      ara.velocity.y = 0;

      //Move x to player x
      ara.location.x = location.x + pWidth/4;
      ara.location.y = location.y + pHeight/4;
      ara.powerUpActivated[0] = false;
      ara.powerUps();
      ara.isCarried = true;
    } else {
      ara.isCarried = false;
    }
  }
}