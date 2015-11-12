//DECLARE
Ball[] ballCollection = new Ball[20];

void setup() {
  size(600, 600);
  
  for (int i = 0; i < 20; i++) {
    ballCollection[i] = new Ball(random(width), random(height));
  }
  
}

void draw() {
  fill(0);
  
  for (Ball i : ballCollection) { 
    i.display();
  }
}