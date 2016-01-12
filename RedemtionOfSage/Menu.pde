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
        //Higschore 
        case 2:
          subMenu = 2;
          highscores.load("highscore.csv");
          enteredMenu = true;
          break;
        //Credits
        case 3:
          subMenu = 3;
          mpos = 0;
          enteredMenu = true;
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
      case 3:
        if (keyPressed) {
          subMenu = 0;
          enteredMenu = true;
        }
      }
    }
  }

  void display() {
    
    textFont(menuFont);

    if (level == 0 && subMenu == 0) {
      backgroundMusic.pause();
      backgroundMusic.rewind();

      if (mpos == 0) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnStart, 411, 258);

      if (mpos == 1) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevelSelect, 411, 309);

      if (mpos == 2) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnHighscores, 411, 359);
      
      if (mpos == 3) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnCredits, 411, 410);

      if (mpos == 4) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnExit, 411, 461);
      
      noTint();
      
      
    } else if (level == 0 && subMenu == 1) {

      if (mpos == 0) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevel1, 411, 258);

      if (mpos == 1) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevel2, 411, 309);

      if (mpos == 2) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnLevel3, 411, 359);
      
      if (mpos == 3) 
        tint(255, 0, 0);
      else 
        noTint();

      image(btnBack, 411, 410);

      noTint();
      
    } else if (level == 0 && subMenu == 2) {
      // display header row
      fill(255);
      textSize(32);
      text("Place", width/5, height/2.5);
      text("Name", 2*width/5, height/2.5);
      text("Score", 3*width/5, height/2.5);
      text("Time", 4*width/5, height/2.5);
      textSize(24);
      // for each score in list
      for (int iScore=0; iScore<highscores.getScoreCount(); iScore++) {
        // only show the top 10 scores
        if (iScore>=9) break;

        // fetch a score from the list
        Score score = highscores.getScore(iScore);

        // display score in window
        text((iScore+1) , width/5, height/2.5 + 100 + iScore*22);
        text(score.name, 2*width/5, height/2.5 + 100 + iScore*22);
        text(score.score, 3*width/5, height/2.5 + 100 +iScore*22);
        text(score.time / 1000/ 60 + ":" + nf(score.time / 1000 % 60, 2), 4*width/5, height/2.5 + 100 + iScore*22);
      }
    } else if (level == 0 && subMenu == 3) { 
      
    } else if (level == 0 && subMenu == 4) {
      pushStyle();
      fill(255);
      textAlign(LEFT, CENTER);
      textSize(32);
      text(userInput, 644, 315);
      popStyle();
    }
  }
}