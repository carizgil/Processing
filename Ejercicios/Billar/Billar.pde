// Problem description: //<>//
// Simulating a pool table with moving balls. 
// The balls are subject to collisions with the walls and with each other. 
// Ability to interact with the balls by dragging them with the mouse.
//

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;
boolean _forceLeft = false;

int deviation = 0;
int collisionCount = 0;

// System variables:

ParticleSystem _ps;
ArrayList<PlaneSection> _planes;
Particle selectedParticle = null;

PVector currentPosition = new PVector(0, 0);
boolean drawVector = false;

// Performance measures:
float _Tint = 0.0;    // Integration time (s)
float _Tdata = 0.0;   // Data-update time (s)
float _Tcol1 = 0.0;   // Collision time particle-plane (s)
float _Tcol2 = 0.0;   // Collision time particle-particle (s)
float _Tsim = 0.0;    // Total simulation time (s) Tsim = Tint + Tdata + Tcol1 + Tcol2
float _Tdraw = 0.0;   // Rendering time (s)

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
   frameRate(DRAW_FREQ);
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   initSimulation();
}

void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 'c' || key == 'C')
      _computeParticleCollisions = !_computeParticleCollisions;
   else if (key == 'p' || key == 'P')
      _computePlaneCollisions = !_computePlaneCollisions;
   else if (key == 'n' || key == 'N')
      _ps.setCollisionDataType(CollisionDataType.NONE);
   else if (key == 'g' || key == 'G')
      _ps.setCollisionDataType(CollisionDataType.GRID);
   else if (key == 'h' || key == 'H')
      _ps.setCollisionDataType(CollisionDataType.HASH);
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
   else if (key == 'f' || key == 'F')
      _forceLeft = !_forceLeft;
   else if (key == 'v' || key == 'V')
      _ps.randomVelocitys();
   
}

void mousePressed() {
  float MouseX = mouseX;
  float MouseY = mouseY;
   if (mouseButton == RIGHT) {
    for (int i=0; i<10;i++)
    {
      float x = random(width*0.2, width*0.8);
      float y = random(height*0.4, height*0.8);
      float vx = random(-1, 1);
      float vy = random(-1, 1);
      _ps.addParticle(M, new PVector(x,y), new PVector(vx,vy), R, color(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]));
    
    }
  }
  if (mouseButton == LEFT) {
    for (Particle particle : _ps.getParticles()) {
    float distance = dist(MouseX, MouseY, particle._s.x, particle._s.y);
    if (distance < particle._radius && particle._v.mag() <= 0.2){
      selectedParticle = particle;
      break;
    }
  }
  }
  
}

void mouseDragged() {
  if (selectedParticle != null) {
      currentPosition.x = mouseX;
      currentPosition.y = mouseY;
      drawVector = true;
  }
}

void mouseReleased() {
  if (selectedParticle != null) {
    PVector finalPosition = new PVector(mouseX, mouseY);
    PVector velocity = PVector.sub(finalPosition, selectedParticle._s);
    velocity.div(100); //Ajustando a centimetros
    selectedParticle._v.x = velocity.x;
    selectedParticle._v.y = velocity.y;

   drawVector = false;
   currentPosition = new PVector(0, 0);
   selectedParticle = null;    
  }
}

void initSimulation()
{

   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();
   _planes.add(new PlaneSection(width*0.1, height*0.9, width*0.9,height*0.9 ,false));
   _planes.add(new PlaneSection(width*0.1, height*0.4, width*0.9,height*0.4 ,true));
   _planes.add(new PlaneSection(width*0.1, height*0.4, width*0.1,height*0.9 ,false));
   _planes.add(new PlaneSection(width*0.9, height*0.4, width*0.9,height*0.9 ,true));
   
}

void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector());   
   for (int i = 0; i < NB_POOL; i++)
   {
      float x = random(width*0.1, width*0.9);
      float y = random(height*0.3, height*0.9);
      float vx = random(-1, 1);
      float vy = random(-1, 1);
 
      _ps.addParticle(M, new PVector(x,y), new PVector(vx,vy), R, color(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]));
      _ps.setCollisionModelType(CollisionModelType.VELOCITY);
      
   }
}

void restartSimulation()
{
   endSimulation();
   initSimulation();
}

void endSimulation()
{
   
}

void draw()
{
   float time = millis();
   drawStaticEnvironment();
   drawMovingElements();
   _Tdraw = millis() - time;

   time = millis();
   updateSimulation();
   _Tsim = millis() - time;

   displayInfo();

   deviation = 0;
   collisionCount = 0;
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   for (int i = 0; i < _planes.size(); i++)
      _planes.get(i).render();
}

void drawMovingElements()
{
   _ps.render();
   if (drawVector) {
    stroke(255, 255, 255);
    strokeWeight(2);
    line(selectedParticle._s.x, selectedParticle._s.y, currentPosition.x, currentPosition.y);
   }
}

void updateSimulation()
{
   float time = millis();
   if (_computePlaneCollisions)
      _ps.computePlanesCollisions(_planes);
   _Tcol1 = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.updateCollisionData();
   _Tdata = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.computeParticleCollisions(_timeStep);
   _Tcol2 = millis() - time;

   time = millis();
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _Tint = millis() - time;
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Time integrating equations: " + _Tint + " ms", width*0.01, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.01, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.01, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.01, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.01, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.01, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.01, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.01, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.01, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.01, height*0.250);
   text("Number of particles: " + _ps.getNumParticles(), width*0.01, height*0.275);
}
