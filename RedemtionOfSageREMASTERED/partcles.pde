void displayparticles() {
  jump.run();
  enemyParticle.run();
  bulletParticle.run();
}





// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  ArrayList<enemyParticle> enemyParticles;
  ArrayList<bulletParticle> bulletParticles;
  PVector origin;

  ParticleSystem(PVector location) {
    particles = new ArrayList<Particle>();
    enemyParticles = new ArrayList<enemyParticle>();
    bulletParticles = new ArrayList<bulletParticle>();
    origin = new PVector(0, 0);
  }

  void addParticle() {
    origin.set(player.location.x + player.pWidth/2, player.location.y + player.pHeight);
    particles.add(new Particle(origin));
  }

  void addenemyParticle() {
    origin.set(ara.location.x + ara.aWidth/2, ara.location.y + ara.aHeight/2);
    enemyParticles.add(new enemyParticle(origin));
  }

  void addbulletParticle() {
    origin.set(player.location.x + player.pWidth/2, player.location.y + player.pHeight/2);
    bulletParticles.add(new bulletParticle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
    for (int c = enemyParticles.size()-1; c >= 0; c--) {
      enemyParticle q = enemyParticles.get(c);
      q.run();
      if (q.isDead()) {
        enemyParticles.remove(c);
      }
    }
    for (int b = bulletParticles.size()-1; b >= 0; b--) {
      bulletParticle s = bulletParticles.get(b);
      s.run();
      if (s.isDead()) {
        bulletParticles.remove(b);
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
  float c1;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.02);
    velocity = new PVector(random(-0.75, 0.75), random(-0.85, 0.01));
    location = l.get();
    lifespan = 60;
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
    c1 +=10;
    c1%=255;
    stroke(100, 0, 0);
    pushStyle();
    colorMode(HSB);
    fill(c1, 255, 255, lifespan+60);
    rect(location.x, location.y, 8, 8);
    popStyle();
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

class enemyParticle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float epWidth;
  float epheight;

  enemyParticle(PVector l) {//enemy particles
    acceleration = new PVector(random(-0.01, 0.01), random(-0.01, 0.01));
    velocity = new PVector(random(-0.5, 0.5), random(-0.1, 0.7));
    location = l.get();
    lifespan = 160;
  }

  void run() {
    update();
    display();
    collisionDetection();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }
  void collisionDetection() {
    for (Platform other : platforms) {
      float xOverlap = calculate1DOverlap(location.x, other.location.x, epWidth, other.iWidth);
      float yOverlap = calculate1DOverlap(location.y, other.location.y, epheight, other.iHeight);

      if (abs(xOverlap) > 0 && abs(yOverlap) > 0) {
        // Determine wchich overlap is the largest
        if (abs(xOverlap) > abs(yOverlap)) {
          location.y += yOverlap; // adjust player x - position based on overlap
          velocity.y = 0;
        } else {
          location.x += xOverlap; // adjust player y - position based on overlap
          velocity.x *= -1;
        }
      }
    }
  }
  // Method to display
  void display() {
    stroke(0, lifespan);
    fill(187, 10, 30, lifespan);
    ellipse(location.x, location.y, 10, 10);
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

class bulletParticle {//bullet particles
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  bulletParticle(PVector l) {
    acceleration = new PVector(random(-0.02, 0.02), random(-0.02, 0.02));
    velocity = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
    location = l.get();
    lifespan = 50;
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
    stroke(250, lifespan);
    fill(150, 150, 0, lifespan);
    ellipse(location.x, location.y, 7, 7);
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