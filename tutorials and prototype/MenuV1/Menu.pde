class Button {
  PVector location;

  float Width, Height;
  String[] mainMenu, levelSelect, credits;
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space;

  int subMenu;

  Button() {
    location = new PVector(width/2, height/2);

    mainMenu = new String[4];
    levelSelect = new String[3];
    credits = new String[5];

    menuFontSize = 24;
    menuFont = createFont("Linux Libertine G Semibold", menuFontSize);
    menuPopup = createFont("Linux Libertine G Semibold", 72);

    mpos = 0;
    space = 50;

    subMenu = 0;

    mainMenu[0] = "Start";
    mainMenu[1] = "Level Select";
    mainMenu[2] = "Credits";
    mainMenu[3] = "Exit";

    levelSelect[0] = "Level 1";   
    levelSelect[1] = "Level 2";
    levelSelect[2] = "Level 3";

    credits[0] = "Koen";
    credits[1] = "Jamy";
    credits[2] = "Tricia";
    credits[3] = "Florian";
    credits[4] = "Danny";
  }

  void update() {
    if (mpos < 0 ) {
      mpos = mainMenu.length - 1;
    }
    if (mpos > mainMenu.length - 1) {
      mpos = 0;
    }

    if (keysPressed[' ']) {
      switch (subMenu) {
      case 0:
        switch (mpos) {
        case 0:
          level = 1;
          break;
        case 1:
          subMenu = 1;
          break;
        case 2:
          subMenu = 2;
          break;
        case 3:
          exit();
          break;
        }
        break;
      case 1:
        switch (mpos) {
        case 0:
          level = 1;
          break;
        case 1:
          level = 2;
          break;
        case 2:
          level = 3;
          break;
        case 3:
          subMenu = 0;
          break;
        }
        break;
      case 2:
        if (keyPressed) {
          subMenu = 0;
        }
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

    if (level == 0 && subMenu == 0) {
      for (int i = 0; i < mainMenu.length; i++) {
        fill(0);
        text(mainMenu[i], location.x, location.y + i * space);
      }
    } else if (level == 0 && subMenu == 1) {
      for (int i = 0; i < levelSelect.length; i++) {
        fill(0);
        text(levelSelect[i], location.x, location.y + i * space);
      }
    } else if (level == 0 && subMenu == 2) {
      for (int i = 0; i < credits.length; i++) {
        fill(0);
        text(credits[i], location.x, location.y + i * space);
      }
    }


    fill(255, 0, 0);
    ellipse(location.x - 100, location.y + mpos * space, 15, 15);
  }
}