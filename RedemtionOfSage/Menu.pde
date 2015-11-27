class Button {
  PVector location;

  float Width, Height;
  String[] mainMenu, levelSelect, credits;
  String currentMenu;
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space, subMenu;

  boolean enteredMenu;

  Button() {
    location = new PVector(width/2, height/2);

    mainMenu = new String[4];
    levelSelect = new String[4];
    credits = new String[5];

    menuFontSize = 24;
    menuFont = createFont("Linux Libertine G Semibold", menuFontSize);
    menuPopup = createFont("Linux Libertine G Semibold", 72);

    mpos = 0;
    space = 50;

    subMenu = 0;
    enteredMenu = false;

    currentMenu = "mainMenu";

    mainMenu[0] = "Start";
    mainMenu[1] = "Level Select";
    mainMenu[2] = "Credits";
    mainMenu[3] = "Exit";

    levelSelect[0] = "Level 1";   
    levelSelect[1] = "Level 2";
    levelSelect[2] = "Level 3";
    levelSelect[3] = "Go Back";

    credits[0] = "Koen";
    credits[1] = "Jamy";
    credits[2] = "Tricia";
    credits[3] = "Florian";
    credits[4] = "Danny";
  }

  void update() {
    if (mpos < 0 ) {
      switch (currentMenu) {
      case "mainMenu":
        mpos = mainMenu.length - 1;
        break;
      case "levelSelect":
        mpos = levelSelect.length - 1;
        break;
      }
    }
    switch (currentMenu) {
    case "mainMenu":
      if (mpos > mainMenu.length - 1) {
        mpos = 0;
        break;
      }
    case "levelSelect":
      if (mpos > levelSelect.length - 1) {
        mpos = 0;
      }
      break;
    }

    if (keysPressed[' '] && !enteredMenu && level == 0) {
      switch (subMenu) {
        //If in main menu
      case 0:
        switch (mpos) {
          //If cursor is on Start Game set level to 1
        case 0:
          level = 1;
          setIndex = 0;
          loadLevel(true);
          break;
          //If cursor is on Level Select go to Level Select menu
        case 1:
          subMenu = 1;
          mpos = 0;
          enteredMenu = true;
          break;
          //If on Credits fo to credits
        case 2:
          subMenu = 2;
          mpos = 0;
          enteredMenu = true;
          break;
          //If on Exit exit game
        case 3:
          exit();
          break;
        }
        break;
        //If in levelSelect
      case 1:
        switch (mpos) {
        case 0:
          level = 1;
          setIndex = 0;
          loadLevel(true);
          break;
        case 1:
          level = 2;
          setIndex = 0;
          loadLevel(true);
          break;
        case 2:
          level = 3;
          setIndex = 0;
          loadLevel(true);
          break;
        case 3:
          subMenu = 0;
          mpos = 0;
          enteredMenu = true;
          break;
        }
        break;
      case 2:
        if (keyPressed) {
          subMenu = 0;
          enteredMenu = true;
        }
        break;
      }
    }
  }

  void display() {
    if (level == 0 && subMenu < 2) {
      fill(255, 0, 0);
      ellipse(location.x - 100, location.y + mpos * space, 15, 15);

      fill(0);
      textFont(menuPopup);
      textAlign(CENTER, CENTER);
      text("R O S", location.x, location.y - 100);
    }

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
  }
}