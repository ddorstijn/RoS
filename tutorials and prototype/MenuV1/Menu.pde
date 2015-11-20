class Button {
  PVector location;

  float Width, Height;
  String[] menu;
  String[] levelselect = new String[3];
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space;

  Button(String m1, String m2, String m3, String m4) {
    location = new PVector(width/2, height/2);

    menu = new String[4];
    menuFontSize = 24;
    menuFont = createFont("Linux Libertine G Semibold", menuFontSize);
    menuPopup = createFont("Linux Libertine G Semibold", 72);
    
    levelselect[0] = "Level 1";   
    levelselect[1] = "Level 2";
    levelselect[2] = "Level 3";
    
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
      switch (mpos) {
      case 0:
        level = 1;
        break;
      case 1:
        level = 0;
        for (int i = 0; i < levelselect.length; i++) {
          fill(0);
          text(levelselect[i], location.x, location.y + i * space);
        }
        break;
      case 2:
        level = 1;
        text("Start Game", width/2, height/2);
        break;
      case 3:
        level = 1;
        text("Start Game", width/2, height/2);
        break;
      }
    }
  }

  void display() {
    fill(0);
    textFont(menuPopup);
    textAlign(CENTER, CENTER);
    text("R O S", location.x, location.y - 100);
    textFont(menuFont);

    if (level == 0) {
      for (int i = 0; i < menu.length; i++) {
        fill(0);
        text(menu[i], location.x, location.y + i * space);
      }
    }

    fill(255, 0, 0);
    ellipse(location.x - 100, location.y + mpos * space, 15, 15);
  }
}