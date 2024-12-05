// Problem description: //<>//
// Simular una hoguera con humo donde el color de la misma debe cambiar según las partículas se
// alejen del foco de la hoguera o añadir una textura para el dibujado de las partículas.
//
// El sistema de partículas creará las partículas y cuando éstas lleguen al final de su tiempo de vida, las
// eliminará.
//
// Differential equations:
// 
// Ecuaciones de Movimiento:
// ds/dt = v
// dv/dt = a
//
// Donde:
// s es la posición de la partícula.
// v es la velocidad de la partícula.
// a es la aceleración de la partícula.
//
// Ecuaciones de Fuerza:
// \sum F = ma
// a = F/m
//
// Fuerza de Gravedad (F_Peso):
// F_Peso = m * g
// Donde:
// m es la masa de la partícula.
// g es la aceleración debido a la gravedad.
//
// Fuerza de Resistencia del Aire (F_Froz):
// F_Froz = -K_d * v
// Donde:
// K_d es una constante de resistencia del aire.
//
// Fuerza Total (F):
// F = F_Peso + F_Froz + F_Turbulence + F_Wind
//
// Ecuaciones de Energía:
// E_k = 0.5 * m * v^2
// E_g = m * g * s_y
// Energía Total    = E_k + E_g

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)
PImage textureImage;

 int particleNumber = 0;
float angleStep = 0;
float centeredNozle = 0;
float vDir = 0;


// Output control:

boolean _writeToFile = true;
boolean _useTexture = true;
PrintWriter _output;


// Variables to be monitored:

float _energy;                // Total energy of the system (J)
int _numParticles;            // Total number of particles

ParticleSystem _ps;


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
   
   textureImage = loadImage(TEXTURE_FILE);
   
}

void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 't' || key == 'T')
      _useTexture = !_useTexture;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, E, n,m");
   }

   _simTime = 0.0;
   _timeStep = TS;
   centeredNozle = PI/2 + nozleAngle/2;
   
   _ps = new ParticleSystem(particeSystemPosition);
   vDir = centeredNozle;

}

void restartSimulation()
{
   _ps.restart();
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
   
   drawStaticEnvironment();
   drawMovingElements();
   int millis = millis();
   updateSimulation();
   millis = millis() - millis;
   displayInfo();
   
   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _numParticles + ", " + millis);
    
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   
   
}

void drawMovingElements()
{
   _ps.render(_useTexture);
}

void updateSimulation() 
{   
   PVector location = _ps.getLocation();
   location.add(new PVector(random(-1,1), random(-1,1)));
   _ps.setLocation(location);

   spawnParticles();
   _ps.update(_timeStep);
   _energy = _ps.getTotalEnergy();
   _numParticles = _ps.getNumParticles();
   _simTime += _timeStep;
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
   text("Draw: " + frameRate + "fps", width*0.025, height*0.05);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.075);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.1); 
   text("Number of particles: " + _numParticles, width*0.025, height*0.125);
   text("Total energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
}

float radioAleatorio()
{
  return random(R/2, 3*R/2);
}

color alphaAleatorio()
{
  return color(red(smokeColor), green(smokeColor), blue(smokeColor),alpha(smokeColor) * random(0.1,0.5));
}

float velocidadAleatoria()
{
  return random(V/4,V);
}

void spawnParticles()
{
   particleNumber = ceil(NT * _timeStep);
   angleStep = nozleAngle/angleSubdivisions;
   vDir = vDir - angleStep;


   for (int i = 0; i < particleNumber; i++)
   {
      float chaosVel = velocidadAleatoria();
      PVector velVector = new PVector( chaosVel * cos(vDir), -chaosVel * sin(vDir));
      radioAleatorio();
      _ps.addParticle(M, new PVector(0, 0), velVector, radioAleatorio() , alphaAleatorio(), L);

      
      if (vDir < centeredNozle - nozleAngle)
      {
         vDir = centeredNozle;
      }

   }

}


Np = Nps * dt;
_s = centroEmisor;
anguloEmisor = 60;

for(int i = 0; i<Np; i++)
{
   anguloRandom = random(-anguloEmisor/2, anguloEmisor/2);
   float vmod = random(5,10);
   PVector _v = new PVector(vmod * cos(anguloRandom), vmod * sin(anguloRandom));
   particula.add(_s,_v);
}
