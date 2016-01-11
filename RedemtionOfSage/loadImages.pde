PImage bgMenu;
PImage bgKeybindings;
PImage bgCredits;
PImage bgEnterName;

PImage btnStart;
PImage btnLevelSelect;
PImage btnHighscores;
PImage btnCredits;
PImage btnExit;

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
}