class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  
  Particle(float x, float y, float speed) {
    position = new PVector(x, y);
    velocity = new PVector(random(-1, 1), -speed);
    lifespan = 255.0;
  }
  
  void applyForce(PVector force) {
    velocity.add(force);
  }
  
  void update() {
    position.add(velocity);
    velocity.add(0, 0.1);
    lifespan -= 1.0;
  }
  
  void display() {
    noStroke();
    fill(0, 0, 255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }
  
  boolean isFinished() {
    return lifespan < 0 || position.y > height;
  }
}
