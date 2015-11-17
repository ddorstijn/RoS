class Button {
  PVector location;

  float Width, Height;
  String[] menu;
  PFont menuFont, menuPopup;
  int menuFontSize, mpos, space;

  Button(String m1, String m2, String m3, String m4) {
    location = new PVector(width/2, height/2);

    menu = new String[4];
    menuFontSize = 24;
    menuFont = createFont("Linux Libertine G Semibold", menuFontSize);
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

    if (drawMenu) {
      for (int i = 0; i < menu.length; i++) {
        //fill(50);
        //rect(location.x - textWidth(menu[i]), location.y - menuFontSize - 20 + i * space, location.x + textWidth(menu[i]) + 10, menuFontSize + 20 + i * space);
        fill(0);
        text(menu[i], location.x, location.y + i * space);
      }
    }

    noFill();
    stroke(0);

    //curve that I want an object/sprite to move down
    bezier(location.x - textWidth(menu[1])/2, location.y + mpos * space, location.x, location.y + mpos * space + 10, location.x + textWidth(menu[1])/2, location.y + mpos * space - 10, location.x - textWidth(menu[1])/2, location.y + mpos * space);


    float t =  (frameCount/100.0)%1;
    float x = bezierPoint(location.x - textWidth(menu[1])/2, location.x, location.x + textWidth(menu[1])/2, location.x - textWidth(menu[1])/2, t);
    float y = bezierPoint(location.y + mpos * space, location.y + mpos * space + 10, location.y + mpos * space - 10, location.y + mpos * space, t);

    fill(255, 0, 0);
    ellipse(x, y, 5, 5);
  }
}