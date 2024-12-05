// Problem description: //<>//
// Simulation of a fluid using particles.
// Detect and resolve collisions between particles and planes.
// Detect and resolve collisions between particles.

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;

// System variables:

ParticleSystem _ps;
ArrayList<PlaneSection> _planes;
PlaneSection tempPlane;
boolean removedPlane = false;

// Performance measures:

float _Tint = 0.0;    // Integration time (s)
float _Tdata = 0.0;   // Data-update time (s)
float _Tcol1 = 0.0;   // Collision time particle-plane (s)
float _Tcol2 = 0.0;   // Collision time particle-particle (s)
float _Tsim = 0.0;    // Total simulation time (s) Tsim = Tint + Tdata + Tcol1 + Tcol2
float _Tdraw = 0.0;   // Rendering time (s)
String _TRaw = "";    // Raw data

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y,P3D);
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
      _ps.setDataStructureType(DataStructureType.NONE);
   else if (key == 'g' || key == 'G')
      _ps.setDataStructureType(DataStructureType.GRID);
   else if (key == 'h' || key == 'H')
      _ps.setDataStructureType(DataStructureType.HASH);
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
   else if (key == 'q' || key == 'Q')
   {
      if(removedPlane == false)
         removePlane(3); //Indice del plano de abajo del todo
         removedPlane = true;
   }
      
}

void mousePressed()
{
   PVector s = new PVector();
   PVector v = new PVector();

   for(int i = 0; i < NB_MOUSE; i++)
      {
           s = new PVector(random(mouseX - NB_MOUSE_RADIUS ,mouseX + NB_MOUSE_RADIUS), random(mouseY-NB_MOUSE_RADIUS, mouseY + NB_MOUSE_RADIUS));
           v = new PVector(random(0,2), random(0,2));//Velocidad aleatoria para dispersar las particulas
           _ps.addParticle(M, s, v, R, color(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]));
      }
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, Tsim, raw");
   }

   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();
   _planes.add(new PlaneSection(width*0.2, height*0.75 - H, width*0.8,height*0.75 - H ,true));
   _planes.add(new PlaneSection(width*0.8,height*0.75 - H, width*0.9,height*0.75 - H + H/4 ,true));
   _planes.add(new PlaneSection(width*0.9,height*0.75 - H + H/4, width*0.55,height*0.75 ,true));
   _planes.add(new PlaneSection(width*0.55,height*0.75, width*0.45,height*0.75 ,true));
   _planes.add(new PlaneSection(width*0.45,height*0.75, width*0.1,height*0.75 - H + H/4 ,true));
   _planes.add(new PlaneSection(width*0.1,height*0.75 - H + H/4, width*0.2,height*0.75 - H ,true));
}

void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector());   
   _ps.setCollisionModelType(CollisionModelType.SPRING);
   _ps.setDataStructureType(DataStructureType.HASH);

   for (int i = 0; i < NB_POOL; i++)
   {
      //Posiciones aleatorias dentro del area designada 0.2-0.8 Horizontal y 0.35-0.45 Vertical
      float x = random(width*0.2, width*0.8);
      float y = random(height*0.75 - H + H/5, height*0.75 - H + 2*H/5);
      
      _ps.addParticle(M, new PVector(x,y), new PVector(0,0), R, color(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]));
      
   }
}

void restartSimulation()
{
   endSimulation();
   initSimulation();
   removedPlane = false;
}

void removePlane(int index)
{
   _planes.remove(3);
}

void endSimulation()
{
   if (_writeToFile)
   {
      _output.flush();
      _output.close();
   }
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

   if (_writeToFile)
      writeToFile(_simTime + ", " + _ps.getNumParticles() + "," + _Tsim + "," + _TRaw);
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

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Time integrating equations: " + _Tint + " ms", width*0.03, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.03, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.03, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.03, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.03, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.03, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.03, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.03, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.03, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.03, height*0.250);
   text("Number of particles: " + _ps.getNumParticles(), width*0.03, height*0.275);
   text("Structure: " + _ps.getDataStructureType(), width*0.03, height*0.300);
   //////
   text("Left click to add particles", width*0.03, height*0.875);
   text("Press 'r' to restart simulation, 'c' to toggle Particle collisions, 'p' to togle Plane collisions ", width*0.03, height*0.900);
   text("Press '+' to increase time step, '-' to decrease time step", width*0.03, height*0.925);
   text("Press 'q' to remove a plane", width*0.03, height*0.950);
   text("Press 'n' to set data structure to none, 'g' to set data structure to grid, 'h' to set data structure to hash", width*0.03, height*0.975);
}
