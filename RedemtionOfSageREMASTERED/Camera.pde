class Camera {

  void drawWorld() {
    if (player.location.x - width/2 > 0) {
      pos.x = player.location.x - width/2; //Because camera is alligned to the left of the screen. Update camera to player pos
    } else {
      pos.x = 0;
    }
  }
}