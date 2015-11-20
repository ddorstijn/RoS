int TICKS_PER_SECOND = 60; //Hoe vaak wordt het per seconde upgedate //<>//
int SKIP_TICKS = 1000 / TICKS_PER_SECOND; //1000 milliseconden
int MAX_FRAMESKIP = 10; //

int next_game_tick = millis();
int loops;

void setup() {
}

void draw() {
  loops = 0;
  while (millis() > next_game_tick && loops < MAX_FRAMESKIP) {         
    update_game();

    next_game_tick += SKIP_TICKS;
    loops++;
  }

  draw_game();
}

void update_game() {
}

void draw_game() {
}