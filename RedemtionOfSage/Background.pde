void drawBackground() {
  if (level != 0) {
    background(0); //Drawing background
  } else if (menu.subMenu == 3){ 
    background(bgCredits);
  } else {
    background(bgMenu);
  }

  if (level != 0) {
    fft.forward(backgroundMusic.mix);
    
    stroke(currentWaveformcolor, 71);

    for(int i = 0; i < 45; i++) {
     float x = map( i-1, 0, 45, 0, width/2);
     
     strokeWeight(7);
     line(width/2+x, height/2 + fft.getBand(i)*4, width/2+x, height/2 - fft.getBand(i)*4);
     line(width/2-x, height/2 + fft.getBand(i)*4, width/2-x, height/2 - fft.getBand(i)*4);
    }
  }
}

void colortransition() {
  if (currentWaveformcolor != defaultWaveformcolor) {
      currentWaveformcolor = lerpColor(currentWaveformcolor, defaultWaveformcolor, .05);
  }
}

void grid() {
  if (shiftKey == true) {  //If in buildmode 
    strokeWeight(2);
    //horizontal gridlines
    for (int i = 0; i < height/gridSize; i++) { //Number of lines that have to be drawn is calculated by dividing the height by the gridsize. eg; 800 / 40 = 20 lines
      stroke(255, 0, 0);
      line(0, i * gridSize, width, i * gridSize);
    }

    //vertical lines
    for (int i = 0; i < width / gridSize + 1; i ++) {
      float lx;
      lx = i * gridSize - (pos.x % gridSize);
      line(lx, 0, lx, height);
    }
  }
}