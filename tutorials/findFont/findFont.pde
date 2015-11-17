PFont myFont;
String[] fontList = PFont.list();
int i = 0;
int fontSize;

void setup() {
  fullScreen();
  fontSize = 32;
  myFont = createFont(fontList[i], fontSize);
}

void draw() {
  background(0);
  myFont = createFont(fontList[i], fontSize);
  textFont(myFont);
  textAlign(CENTER, CENTER);
  text(i + " " + fontList[i] + ": " + fontSize, width/2, height/2 - fontSize*2);
  text("Aa Bb Cc Dd Ee Ff Gg Hh Ii Jj Kk Ll Mm Nn Oo Pp 1234567890 !@#$%^&*()", width/2, height/2);
}

void keyPressed() {
  switch(keyCode) {
  case RIGHT:
    if (i < 300)
      i++;
    break;
  case LEFT:
    if (i > 0)
      i--;
    break;
  case DOWN:
    if (fontSize > 8)
      fontSize--;
    break;
  case UP:
    fontSize++;
    break;
  case 83:
    println("myFont = createFont(\"" + fontList[i] + "\", " + fontSize + ");");
  }

  switch(key) {
  case 'a':
    i = 0;
    break;
  case 'c':
    i = 24;
    break;
  case '5':
    i = 67;
    break;
  case 'e':
    i = 75;
    break;
  case 'f':
    i = 78;
    break;
  case 'g':
    i = 81;
    break;
  case 'h':
    i = 92;
    break;
  case 'i':
    i = 98;
    break;
  case 'j':
    i = 99;
    break;
  case 'l':
    i = 100;
    break;
  case 'm':
    i = 141;
    break;
  case 'n':
    i = 182;
    break;
  case 'p':
    i = 187;
    break;
  case 'q':
    i = 199;
    break;
  case 't':
    i = 262;
    break;
  case 'v':
    i = 280;
    break;
  case 'y':
    i = 289;
    break;
  }
}