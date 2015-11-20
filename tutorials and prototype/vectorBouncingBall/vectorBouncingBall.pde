PVector location = new PVector(10, 10); 
PVector velocity = new PVector(20, 0);
PVector gravity = new PVector(0, 0.05);
float friction = 0.99;
int radius = 10;

void setup() {
  size(400, 400);
  surface.setResizable(true);
  frameRate(60);
}

void draw() {
  background(0);

  stroke(255, 0, 0);  
  strokeWeight(0.5);
  noFill();
  quad(location.x - radius, location.y - radius, location.x + radius, location.y - radius, location.x + radius, location.y + radius, location.x - radius, location.y + radius);

  stroke(0, 255, 0);
  strokeWeight(1);
  line(location.x, location.y, location.x + (velocity.x * 10), location.y + (velocity.y * 10));
  
  stroke(0, 0, 255);
  strokeWeight(1);
  line(location.x, location.y, location.x + (gravity.x * 100), location.y + (gravity.y * 100));

  if (location.x > width || location.x < 0 ) {
    location.set(location.x - velocity.x, location.y - velocity.y);
    velocity.x *= -1;
  }
  if (location.y > height || location.y < 0 ) {
    location.set(location.x - velocity.x, location.y - velocity.y);
    velocity.mult(0.7);
    velocity.y *= -1;
  }
  
  
  location.add(velocity);
  velocity.add(gravity);
  velocity.mult(friction); //<>//

  text((int) frameRate, 10, 10);
}