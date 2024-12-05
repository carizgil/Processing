int orbitDiameter = 200;
int ballDiameter = 20;
PVector center, ballPosition;
float angularVelocity;
float angle;
float lastTime;
float deltaTime;

void setup(){
  size(600, 600);
  center = new PVector(width/2, height/2);
  ballPosition = new PVector(center.x + orbitDiameter/2, center.y);
  lastTime = millis();
  
  angle = 1;
  float frequency = 1;
  angularVelocity = 2*PI*frequency;
}

void draw(){
  background(200);
  
  stroke(0);
  strokeWeight(2);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  textAlign(CENTER);
  fill(0);
  text("X", width - 10, height/2 + 20);
  text("Y", width/2 + 20, 20);
  
  stroke(255, 0, 0);
  noFill();
  ellipse(center.x, center.y, orbitDiameter, orbitDiameter);
  
  PVector orbitEdge = new PVector(orbitDiameter/2 * cos(angle) + center.x, orbitDiameter/2 * sin(angle) + center.y);
  line(ballPosition.x, ballPosition.y, orbitEdge.x, orbitEdge.y);
  
  fill(0, 250, 0);
  noStroke();
  ellipse(ballPosition.x, ballPosition.y, ballDiameter, ballDiameter);
  
  ballPosition.x = orbitEdge.x;
  ballPosition.y = orbitEdge.y;
  
  deltaTime = (millis() - lastTime) / 1000.0;
  angle += angularVelocity * deltaTime;
  
  lastTime = millis();
}
