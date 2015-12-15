void displayparticles() {
  jump.run();
  cParticle.run();
}





// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  ArrayList<cParticle> cParticles;
  PVector origin;

  ParticleSystem(PVector location) {
    particles = new ArrayList<Particle>();
    cParticles = new ArrayList<cParticle>();
    origin = new PVector(0,0);
  }

  void addParticle() {
    origin.set(player.location.x + player.pWidth/2,player.location.y-15 + player.pHeight);
    particles.add(new Particle(origin));
  }
  
  void addCParticle() {
    origin.set(ara.location.x + ara.aWidth/2,ara.location.y + ara.aHeight/2);
    cParticles.add(new cParticle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
    for (int c = cParticles.size()-1; c >= 0; c--) {
      cParticle q = cParticles.get(c);
      q.run();
      if (q.isDead()) {
        cParticles.remove(c);
      }
    }
  }
}



// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-0.5,0.75),random(-0.1,1));
    location = l.get();
    lifespan = 75;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    //stroke(255,lifespan);
    fill(238,221,130,lifespan);
    ellipse(location.x,location.y,20,6);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

class cParticle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  cParticle(PVector l) {
    acceleration = new PVector(random(-0.02,0.02),random(-0.02,0.02));
    velocity = new PVector(random(-0.5,0.75),random(-0.1,1));
    location = l.get();
    lifespan = 100;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(0,lifespan);
    fill(random(200,250),0,0,lifespan);
    ellipse(location.x,location.y,10,10);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}