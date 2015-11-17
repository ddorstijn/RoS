class Button {
  PVector location;

  float Width, Height;
  String[] menu;
  PFont menuFont, menuPopup;
  int move;
  int mpos;
  int space;

  Button(String m1, String m2, String m3, String m4) {
    location = new PVector(width/2, height/2);

    menu = new String[4];
    menuFont = createFont("Linux Libertine G Semibold", 24);
    menuPopup = createFont("Linux Libertine G Semibold", 72);

    mpos = 0;
    space = 50;


    menu[0] = m1;
    menu[1] = m2;
    menu[2] = m3;
    menu[3] = m4;
  }

  void update() {
    if (mpos < 0 ) {
      mpos = menu.length - 1;
    }
    if (mpos > menu.length - 1) {
      mpos = 0;
    }
    
    if (keysPressed[' ']) {
      drawMenu = false;
      text("Start Game", width/2, height/2);
    }
  }

  void display() {
    fill(0);
    textFont(menuPopup);
    textAlign(CENTER, CENTER);
    text("R O S", location.x, location.y - 100);
    textFont(menuFont);
    for (int i = 0; i < menu.length; i++) {
      text(menu[i], location.x, location.y + i * space);
    }

    ellipse(location.x - 100, location.y + mpos * space, 10, 10);
  }
}