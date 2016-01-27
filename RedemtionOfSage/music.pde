
  AudioPlayer araGooienMusic;
  AudioPlayer araRaaktIetsMusic;
  AudioPlayer backgroundMusic;
  AudioPlayer checkpointMusic;
  AudioPlayer coinMusic;
  AudioPlayer enemyDiesMusic;
  AudioPlayer enemyShootMusic;
  AudioPlayer jumpMusic;
  AudioPlayer menuMusic;
  AudioPlayer playerDiesMusic;
  AudioPlayer selectMusic;
  AudioPlayer shieldHitMusic;

void music(){
  minim = new Minim(this);
  araGooienMusic = minim.loadFile("music/aragooien.wav");
  
  minim = new Minim(this);
  araRaaktIetsMusic = minim.loadFile("music/araraaktiets.wav");
  
  minim = new Minim(this);
  backgroundMusic = minim.loadFile("music/background2.mp3");
  
  minim = new Minim(this);
  checkpointMusic = minim.loadFile("music/checkpoint.wav");
  
  minim = new Minim(this);
  coinMusic = minim.loadFile("music/coin.wav");
  
  minim = new Minim(this);
  enemyDiesMusic = minim.loadFile("music/enemydies.wav");
  
  minim = new Minim(this);
  enemyShootMusic = minim.loadFile("music/enemyshoot.wav");
  
  minim = new Minim(this);
  jumpMusic = minim.loadFile("music/jump.wav");
  
  minim = new Minim(this);
  menuMusic = minim.loadFile("music/menu.mp3");
  
  minim = new Minim(this);
  playerDiesMusic = minim.loadFile("music/playerdies.wav");
  
  minim = new Minim(this);
  selectMusic = minim.loadFile("music/select.wav");  
  
  minim = new Minim(this);
  shieldHitMusic = minim.loadFile("music/shieldhit.wav");  
  
  fft = new FFT(backgroundMusic.bufferSize(), backgroundMusic.sampleRate());
  
  beat = new BeatDetect(backgroundMusic.bufferSize(), backgroundMusic.sampleRate());
   // set the sensitivity to 300 milliseconds
   // After a beat has been detected, the algorithm will wait for 300 milliseconds
   // before allowing another beat to be reported. You can use this to dampen the
   // algorithm if it is giving too many false-positives. The default value is 10,
   // which is essentially no damping. If you try to set the sensitivity to a negative value,
   // an error will be reported and it will be set to 10 instead.
   beat.setSensitivity(100);  
   kickSize = 16;
   // make a new beat listener, so that we won't miss any buffers for the analysis
   bl = new BeatListener(beat, backgroundMusic);  
}