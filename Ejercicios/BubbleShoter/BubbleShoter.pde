float angle = 0.0;
float dt = 0.3;
int maxBalls = 1000;
ArrayList<PVector> positions = new ArrayList<PVector>();
ArrayList<PVector> velocities = new ArrayList<PVector>();
ArrayList<PVector> distances = new ArrayList<PVector>();
ArrayList<PVector> auxiliaries = new ArrayList<PVector>();
ArrayList<Integer> ballColors = new ArrayList<Integer>();

void setup() {
  size(600, 600);
}

void draw() {
  background(250);
  
  stroke(0);
  fill(150);
  strokeWeight(1);
  line(0, height-height/4, width, height-height/4);
  
  strokeWeight(5);
  circle(width/2, height-height/4, 20);
  
  pushMatrix();
  translate(width/2, height-height/4);
  rotate(radians(angle));
  line(0, 0, 0, - 50);
  line(0, - 50, - 5, - 45);
  line(0, - 50, 5, - 45);
  popMatrix();
  
  for (int i = 0; i < positions.size(); i++) {
    PVector distance = distances.get(i);
    PVector auxiliary = auxiliaries.get(i);
    
    auxiliary = PVector.add(PVector.mult(velocities.get(i), dt), auxiliary);
    
    int ballColor = randomColor();
    
    fill(ballColor);
    stroke(ballColor);
    circle(auxiliary.x, auxiliary.y, 20);
    
    auxiliaries.set(i, auxiliary);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (angle < 90)
        angle += 5;
    }
    if (keyCode == LEFT) {
      if (angle > -90)
        angle -= 5;
    }
  }
  if (key == ' ' && positions.size() < maxBalls) {
    PVector position = new PVector(width/2, height-height/4);
    PVector velocity = new PVector();
    PVector distance = new PVector();
    PVector auxiliary = new PVector(position.x, position.y);
    
    distance.x = 50 * width/2 * cos(radians(angle-90));
    distance.y = 50 * width/2 * sin(radians(angle-90));
    
    velocity = PVector.mult(distance.normalize(), 20);
    
    auxiliary.add(PVector.mult(velocity, dt));
    
    positions.add(position);
    velocities.add(velocity);
    distances.add(distance);
    auxiliaries.add(auxiliary);
  }
}

int randomColor() {
  return color(random(255), random(255), random(255));
}
