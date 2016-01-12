PImage bgMenu;
PImage bgKeybindings;
PImage bgCredits;
PImage bgEnterName;

PImage btnStart;
PImage btnLevelSelect;
PImage btnHighscores;
PImage btnCredits;
PImage btnExit;

PImage btnLevel1;
PImage btnLevel2;
PImage btnLevel3;
PImage btnBack;

PImage imgScore100;
PImage imgLevel1;
PImage imgLevel2;
PImage imgLevel3;

void loadImages() {
	bgMenu = loadImage("img/background.png");
	bgKeybindings = loadImage("img/keybindings.png");
	bgCredits = loadImage("img/credits.png");
	bgEnterName = loadImage("img/name.png");

	btnStart = loadImage("img/buttons/startButton.JPG");
	btnLevelSelect = loadImage("img/buttons/levelSelectButton.JPG");
	btnHighscores = loadImage("img/buttons/highScoresButton.JPG");
	btnCredits = loadImage("img/buttons/creditsButton.JPG");
	btnExit = loadImage("img/buttons/exitButton.JPG");

  btnLevel1 = loadImage("img/buttons/level1.PNG");
  btnLevel2 = loadImage("img/buttons/level2.PNG");
  btnLevel3 = loadImage("img/buttons/level3.PNG");
  btnBack = loadImage("img/buttons/back.PNG");

  imgScore100 = loadImage("img/misc/100.png");
  imgLevel1 = loadImage("img/misc/level1.png");
  imgLevel2 = loadImage("img/misc/level2.png");
  imgLevel3 = loadImage("img/misc/level3.png");
}