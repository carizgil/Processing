ArrayList<Particle> particles;
boolean applyWind = false;

void setup() {
  size(800, 800);
  particles = new ArrayList<Particle>();
}

void draw() {
  background(255);
  
  fill(0);
  textAlign(CENTER);
  textSize(16);
  text("Al apretar la tecla \"f\" se aplicará una fuerza tipo viento de izquierda a derecha", width/2, 20);
  
  particles.add(new Particle(width/2, height, random(3, 5)));
  
  if (applyWind) {
    for (Particle p : particles) {
      p.applyForce(new PVector(0.1, 0));
    }
  }
  
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    
    if (p.isFinished()) {
      particles.remove(i);
    }
  }
}

void keyPressed() {
  if (key == 'f' || key == 'F') {
    applyWind = !applyWind;
  }
}
