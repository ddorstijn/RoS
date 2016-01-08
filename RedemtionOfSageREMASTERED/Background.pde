void drawBackground() {
  background(25, 41, 67); //Drawing background
  if(level == 1){
   background(10);  
   pushStyle();
   strokeWeight(1);
   noFill();
   for( int j=0; j<10; j++) {
   stroke( 255*noise(j/1.0),255-255*noise(j/1.0),255);
   beginShape();
   float f1 = noise(j/10.0)+0.5;
   float f2 = noise(j/7.0);  
   float f3 = noise(j/1.3)+.5;
   float f4 = noise(j/1.2,frameCount/500.0);
   for( int i=0; i<width+10; i+=10) {
     vertex( i, height/2+(100*f4)*sin(f1*TWO_PI*i/600 + 100*f2 - frameCount/(100.0*f3)));
   }
   endShape();
   }  
   filter(blur);
   popStyle();
  }
}

void grid() {
  if (shiftKey == true) {  //If in buildmode 
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