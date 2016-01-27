BeatDetect beat;
BeatListener bl;

float kickSize;

void checkBeat() {
  if ( beat.isKick() ) kickSize = 32;

  kickSize = constrain(kickSize * 0.95, 16, 32);
}

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void stop()
{
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}