PImage bgMenu;
PImage bgKeybindings;
PImage btnStart;
PImage btnLevelSelect;
PImage btnHighscores;
PImage btnCredits;
PImage btnExit;

void loadImages() {
	bgMenu = loadImage("img/background.png");
	bgKeybindings= loadImage("img/keybindings.png");

	btnStart = loadImage("img/buttons/startButton");
	btnLevelSelect = loadImage("img/buttons/levelSelectButton");
	btnHighscores = loadImage("img/buttons/highScoresButton");
	btnCredits = loadImage("img/buttons/creditsButton");
	btnExit = loadImage("img/buttons/exitButton");
}