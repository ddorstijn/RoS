class Button {
  PVector location;

  float Width, Height;
  String[] levelSelect, credits;
  String currentMenu;
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space, subMenu;

  boolean enteredMenu;

  Button() {
    location = new PVector(width/2, height/2);

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
    switch (currentMenu) {
    case "mainMenu":
      if (mpos > 4) {
        mpos = 0;
        break;
      }
      if (mpos < 0) {
        mpos = 4;
        break;
      }
    case "levelSelect":
      if (currentMenu == "levelSelect") {
        if (mpos > levelSelect.length-1) {
          mpos = 0;
        } 
        if (mpos<0) {
          mpos = levelSelect.length-1;
          break;
        }
      }
    }

    if (keysPressed[67] && !enteredMenu && level == 0) {
      switch (subMenu) {
        //If in main menu
      case 0:
        switch (mpos) {
          //If cursor is on Start Game set level to 1
        case 0:
          subMenu = 4;
          mpos = 0;
          enteredMenu = true;
          break;
          //If cursor is on Level Select go to Level Select menu
        case 1:
          subMenu = 1;
          mpos = 0;
          enteredMenu = true;
          currentMenu = "levelSelect";
          break;
          //If on Credits fo to credits
        case 2:
          subMenu = 2;
          mpos = 0;
          enteredMenu = true;
          break;
          //If on Higschore show highscore
        case 3:
          subMenu = 3;
          highscores.load("highscore.csv");
          break;
          //Exit
        case 4:
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
          currentMenu = "mainMenu";
          break;
        }
        break;
        //Credits
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
    }

    textFont(menuFont);

    if (level == 0 && subMenu == 0) {
      backgroundMusic.pause();
      backgroundMusic.rewind();
    
      image(btnStart, 411, 258);
      image(btnLevelSelect, 411, 309);
      image(btnHighscores, 411, 359);
      image(btnCredits, 411, 410);
      image(btnExit, 411, 461);
      
      menuMusic.play();
      menuMusic.loop();
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
    } else if (level == 0 && subMenu == 3) {
      // display header row
      fill(0);
      textSize(20);
      text("Place        Name        Score        Time", width/2, 70);

      textSize(16);
      // for each score in list
      for (int iScore=0; iScore<highscores.getScoreCount(); iScore++) {
        // only show the top 10 scores
        if (iScore>=9) break;

        // fetch a score from the list
        Score score = highscores.getScore(iScore);

        // display score in window
        text((iScore+1) + "            " + score.name + "        " + score.score + "        " + score.time / 1000/ 60 + ":" + nf(score.time / 1000 % 60, 2), width/2, 100 + iScore*20);
      }
    } else if (level == 0 && subMenu == 4) {
      text("Enter your name: " + userInput, width/2, height/2 - 20);
    }
  }
}