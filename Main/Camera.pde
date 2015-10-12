class Camera {
  PVector pos; //Camera's position
  //The Camera should sit in the top left of the window

  Camera() {
    pos = new PVector(0, 0);
    //You should play with the program and code to see how the staring position can be changed
  }

  void draw() {
    //I used the mouse to move the camera
    //The mouse's position is always relative to the screen and not the camera's position
    pos.x = player1.x - width/2;
  }
}