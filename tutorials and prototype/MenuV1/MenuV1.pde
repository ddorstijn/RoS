Button menu;
boolean enteredMenu;
boolean keysPressed[] = new boolean[256];  
int level;

void setup() {
  size(600, 600, P2D);
  menu = new Button();
  level = 0;
}

void draw() {
  background(255);

  menu.update();
  menu.display();
}

void keyPressed() { 
  if (keyCode == DOWN) {
    menu.mpos++;
  }
  if (keyCode == UP) {
    menu.mpos--;
  }  

  keysPressed[keyCode] = true;
}

void keyReleased() {
  keysPressed[keyCode] = false;
  enteredMenu = false;
}