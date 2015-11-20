Button menu;
boolean keysPressed[] = new boolean[256];
int level;

void setup() {
  size(600, 600, P2D);
  menu = new Button("Start", "Level Select", "Credits", "Exit");
  level = 0;
}

void draw() {
  background(255);
  
  menu.update();
  menu.display();
}

void keyPressed() {
  keysPressed[keyCode] = true;
  if (keyCode == DOWN) {
    menu.mpos++;
  }
  if (keyCode == UP) {
    menu.mpos--;
  }
}