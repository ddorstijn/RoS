class Camera {
  PVector pos; //Camera's position
  
  Camera() {
    pos = new PVector(0, 0);
  }

  void draw() {
    pos.x = player1.x - width/2; //Because camera is alligned to the left of the screen. Update camera to player pos
  }
}