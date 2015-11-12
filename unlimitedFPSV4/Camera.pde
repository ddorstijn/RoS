class Camera {
  
  Camera() {
    pos = new PVector(0, 0);
  }

  void drawWorld() {
    if (player1.location.x - width/2 > 0) {
      pos.x = player1.location.x - width/2; //Because camera is alligned to the left of the screen. Update camera to player pos
    } else {
      pos.x = 0;
    }
  }
}