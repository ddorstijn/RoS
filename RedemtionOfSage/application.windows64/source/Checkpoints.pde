//Colour variable Checkpoints
int checkpointColor1;
int checkpointColor2;
int checkpointStroke;
int strokeWeight1;

void checkpointSetup() { 
  //Colours checkpoint
  checkpointColor1 = color(245, 245, 230);
  checkpointColor2 = color(245, 245, 230);
  checkpointStroke = color(245, 245, 250);
  strokeWeight1 = 0;
} 
void checkpointUpdate() {
 
  //Colour Changing
  if (level == 1) {
    if ((player.location.x >= 2291) == true) {
      checkpointStroke = color(242, 242, 99);
      checkpointColor1 = color(252, 252, 38);
    }
    if (player.location.x >= 4733) {
      checkpointStroke = color(242, 242, 99);
      checkpointColor2 = color(252, 252, 38);
    }
  }
  if (level == 2) {
    checkpointColor1 = color(245, 245, 230);
    if (player.location.x >= 3336) {
      checkpointStroke = color(242, 242, 99);
      checkpointColor1 = color(252, 252, 38);
    }
  }
  if (level == 3) {
    checkpointColor1 = color(245, 245, 230);
    if (player.location.x >= 3290) {
      checkpointStroke = color(242, 242, 99);
      checkpointColor1 = color(252, 252, 38);
    }
  }
}