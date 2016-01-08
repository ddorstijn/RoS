
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
}