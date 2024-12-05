ArrayList<Particle> particles;
PVector emisor;

void setup() {
  size(800, 600);
  particles = new ArrayList<Particle>();
  emisor = new PVector(width/2, height);
}

void draw() {
  background(255);
  
  if (frameCount % 5 == 0) {
    emisorParticulas();
  }
  
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
}

void emisorParticulas() {
  Particle p = new Particle(emisor.x, emisor.y);
  particles.add(p);
}
