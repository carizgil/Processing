class Particle {
  PVector _s;
  PVector _v;
  float lifespan;
  
  Particle(float x, float y) {
    _s = new PVector(x, y);
    _v = new PVector(random(-0.5, 0.5), random(-3, -1));
    lifespan = 255;
  }
  
  void update() {
    _v.add(new PVector(random(-0.1, 0.1), random(-0.1, 0.1)));
    _s.add(_v);
    lifespan -= 2;
  }
  
  void display() {
    noStroke();
    fill(0, lifespan);
    ellipse(_s.x, _s.y, 16, 16);
  }
  
  boolean isDead() {
    return lifespan < 0;
  }
}