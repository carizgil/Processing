float dt = 0.1;
PVector a, b, c, p, velAB, velBC;

void setup() {
  size(600, 600);
  a = new PVector(width/2 - 0.2*width, height/2);
  b = new PVector(width/2 + 0.2*width, height/2 - 0.2*height);
  c = new PVector(width/2 + 0.4*width, height/2);
  p = new PVector(width/2 - 0.2*width, height/2); 
  
  // Definir las velocidades de los tramos
  velAB = PVector.sub(b, a);
  velAB.normalize();
  velAB.mult(10);
  
  velBC = PVector.sub(c, b);
  velBC.normalize();
  velBC.mult(50);
}

void draw() {
  background(250);
  
  stroke(0);
  line(a.x, a.y, b.x, b.y);
  
  stroke(0);
  line(b.x, b.y, c.x, c.y);
  
  stroke(0, 250, 0);
  fill(0, 200, 0);
  ellipse(p.x, p.y, 40, 40);
  
  stroke(250, 0, 0);
  fill(255);
  ellipse(a.x, a.y, 10, 10);
  
  stroke(0, 0, 250);
  fill(255);
  ellipse(b.x, b.y, 10, 10);
  
  stroke(0, 250, 0);
  fill(255);
  ellipse(c.x, c.y, 10, 10);
  
  if (p.x < b.x) {
    p.add(PVector.mult(velAB, dt));
  } 
  else if(p.x < c.x) {
    p.add(PVector.mult(velBC, dt));
  }
  
  if(p.x >= c.x) {
    p.set(a);
  }
}
