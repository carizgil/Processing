// Problem description: //<>//
//
// Numerical integration with different integrators for a mass-spring system
//

// Differential equations:
//
// F= m * a
// a = F/m
// v = da/dt
// s = dv/dt
//
// F = Fe + Fg + Fd
// 
// Fe = -k * (l-l0)
// Fg = m * g
// Fd = -Kd * v
//

// Simulation and time control:

IntegratorType _integrator = IntegratorType.RK4;  // ODE integration method
IntegratorType _lastIntegrator = IntegratorType.NONE;   // ODE integration method
float _timeStep;        // Simulation time-step (s):: h o dt
float _simTime = 0.0;   // Simulated time (s)


// Output control:

boolean _writeToFile = true;
boolean _drawForcesFlag = false;
PrintWriter _output;
float maxElongation = 0;

// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
float _energy;                // Total energy of the particle (J)
PVector _Fw = new PVector();  // Weight force (N)
PVector _Fe = new PVector();  // Elastic force (N)
PVector _Fres = new PVector();  // Resultant force (N)
PVector _Fd = new PVector();  // Damping force (N)

// Springs:

Spring _sp;

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

void mouseClicked()
{
   _s.x = mouseX;
   _s.y = mouseY;

   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == ' ')
   {
      if (_integrator != IntegratorType.NONE)
      {
         _lastIntegrator = _integrator;
         _integrator = IntegratorType.NONE;
      }
      else
         _integrator = _lastIntegrator;
   }   
   else if (key == '1')
      _integrator = IntegratorType.EXPLICIT_EULER;
   else if (key == '2')
      _integrator = IntegratorType.SIMPLECTIC_EULER;
   else if (key == '3')
      _integrator = IntegratorType.RK2;
   else if (key == '4')
      _integrator = IntegratorType.RK4;
   else if (key == '5')
      _integrator = IntegratorType.HEUN;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
   else if (key == 'd' || key == 'D')
      _drawForcesFlag = !_drawForcesFlag;
   
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, E, sx, sy, vx, vy, ax, ay, ts");
   }

   _simTime = 0.0;
   _timeStep = TS;

   _s = S0.copy();
   _v.set(0.0, 0.0, 0.0);
   _a.set(0.0, 0.0, 0.0);
   _sp = new Spring(C, _s, Ke, l0);

}

void restartSimulation()
{
   endSimulation();
   _integrator = IntegratorType.NONE;
   maxElongation = 0;
   initSimulation();
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

   updateSimulation();
   calculateEnergy();
   displayInfo();
   drawElongation();

   if (_writeToFile && frameCount % 4 == 0)
      writeToFile(_simTime + ", " + _energy + ", " + _s.x + ", " + _s.y + ", " + _v.x + ", " + _v.y + "," + _a.x + ", " + _a.y + ", " + _timeStep);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   fill(STATIC_ELEMENTS_COLOR[0], STATIC_ELEMENTS_COLOR[1], STATIC_ELEMENTS_COLOR[2]);
   ellipse(C.x, C.y, 10, 10);
   //
   //
}

void drawMovingElements()
{
   
   fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
   stroke(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
   line(C.x, C.y, _s.x, _s.y);
   ellipse(_s.x, _s.y, 10, 10);

   if(_drawForcesFlag)
      drawForces();
}

void drawElongation()
{
   float elongation = PVector.dist(_s, C);
   if (elongation > maxElongation)
      maxElongation = elongation;
      stroke(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
      
      strokeWeight(5);
   line(width*0.030, height-50 , width*0.025 + elongation, height-50);
   
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   strokeWeight(1);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   text("0", width*0.025, height-30);
   text("l0", width*0.025 + l0, height-30);
   if (maxElongation != l0)
      text("max", width*0.025 + maxElongation, height-30);
   
}

void drawForces()
{
   stroke(0, 0, 255);//AZUL PARA PESO
   fill(0, 0, 255);

   line(_s.x, _s.y, _s.x + _Fw.x /1000, _s.y + _Fw.y / 1000);
   text("Fw", _s.x + _Fw.x /1000, _s.y + _Fw.y /1000);

   stroke(0, 255, 0);//VERDE PARA ELASTICA
   fill(0, 255, 0);
   line(_s.x, _s.y, _s.x + _Fe.x /Ke, _s.y + _Fe.y /Ke);
   text("Fe", _s.x + _Fe.x /Ke, _s.y + _Fe.y /Ke);

   stroke (255, 0, 255);//MAGENTA PARA RESULTANTE
   fill(255, 0, 255);
   line(_s.x, _s.y, _s.x + _Fres.x /1000, _s.y + _Fres.y /1000);
   text("Fres", _s.x + _Fres.x /1000, _s.y + _Fres.y /1000);

   stroke(255, 255, 0);//AMARILLO PARA VELOCIDAD
   fill(255, 255, 0);
   line(_s.x, _s.y, _s.x + _v.x /5, _s.y + _v.y  /5);
   text("v", _s.x + _v.x /5, _s.y + _v.y  /5);

   stroke(255, 0, 0);//ROJO PARA ROZAMIENTO
   fill(255, 0, 0);
   line(_s.x, _s.y, _s.x + _Fd.x /50, _s.y + _Fd.y /50);
   text("Fd", _s.x + _Fd.x /50, _s.y + _Fd.y /50);
   
}

void updateSimulation()
{
   switch (_integrator)
   {
      case EXPLICIT_EULER:
         updateSimulationExplicitEuler();
         break;
   
      case SIMPLECTIC_EULER:
         updateSimulationSimplecticEuler();
         break;
   
      case HEUN:
         updateSimulationHeun();
         break;
   
      case RK2:
         updateSimulationRK2();
         break;
   
      case RK4:
         updateSimulationRK4();
         break;
   
      case NONE:
      default:
   }

   _simTime += _timeStep;
}

void calculateEnergy()
{
   
   float Ek = pow(_v.mag(),2) * M * 0.5;
   float  Eg = M * G * (height-_s.y);
   float Ee = _sp.getEnergy();

     
   _energy = Ek + Eg + Ee;
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
   text("Integrator {1,2,3,4,5} : " + _integrator.toString(), width*0.025, height*0.075);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.1);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.125);
   text("Energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
   text("Speed: " + _v.mag()/1000.0 + " km/s", width*0.025, height*0.175);
   text("Acceleration: " + _a.mag()/1000.0 + " km/s2", width*0.025, height*0.2);
   text("Draw forces {d,D}: " + _drawForcesFlag, width*0.025, height*0.225 );

   text("Press 'r' to restart , 'space' to pause", width*0.025, height*0.3);
}

void updateSimulationExplicitEuler()
{
   // s(t+h) = s(t) + h*v(t)
   // v(t+h) = v(t) + h*a(s(t),v(t))

   _a = calculateAcceleration(_s, _v);
   _s.add(PVector.mult(_v, _timeStep));
   _v.add(PVector.mult(_a, _timeStep));
}


void updateSimulationSimplecticEuler()
{

  _a =  calculateAcceleration(_s, _v);
  
  _v.add(PVector.mult(_a, _timeStep)); 
  _s.add(PVector.mult(_v, _timeStep));
  
}

void updateSimulationHeun()
{
   _a = calculateAcceleration(_s,_v); //Se calcula la aceleracion en el punto incial
  PVector s2 = PVector.add(_s, PVector.mult(_v, _timeStep)); //Se calcula la posicion en la siguiente posicion utilizando Euler
  PVector v2 = PVector.add(_v, PVector.mult(_a, _timeStep)); // Se calcula la velocidad en la siguiente posicion Euler
  PVector a2 = calculateAcceleration(s2, v2); // Se calcula la aceleracion en la siguiente posicion 
  
  PVector vheun = PVector.mult(PVector.add(_v, v2), 0.5); //Hayamos la velocidad promedio
  _s.add(PVector.mult(vheun, _timeStep)); // y aqui hacemos la formula s += v(prom)*dt para calcula la posicon en heun (LA POSICION EN EULER Y HEUN ES DIFERENTE)
  
  PVector aheun = PVector.mult(PVector.add(_a, a2), 0.5); // Hayamos la aceleracion promedio
  _v.add(PVector.mult(aheun, _timeStep)); // Y aqui hacemos v+= a(prom)*dt (LA VELOCIDAD EN EULER Y HEUN ES DIFERENTE)
}

void updateSimulationRK2()
{

  _a = calculateAcceleration(_s,_v);
  

  PVector k1v = PVector.mult(_a, _timeStep); //derivada de la velocidad en el punto medio
  PVector k1s = PVector.mult(_v, _timeStep); //derivada de la posicion en el punto medio

  PVector sMedios = PVector.add(_s, PVector.mult(k1s, 0.5)); //(s(t)+(v(t)*h)*0.5)
  PVector vMedios = PVector.add(_v, PVector.mult(k1v, 0.5));  //(v(t)+(a(t)*h)*0.5)
  PVector aMedios = calculateAcceleration (sMedios,vMedios);
  
  PVector k2v = PVector.mult(aMedios, _timeStep);//Aceleracion en el punto medio * h
  PVector k2s = PVector.mult(vMedios, _timeStep); //x = v(t)+ a(t)*h donde a(t) es la aceleracion en el punto medio
 
  _v.add(k2v);
  _s.add(k2s); 
}

void updateSimulationRK4()
{
   _a = calculateAcceleration(_s,_v);
  PVector k1v = PVector.mult(_a, _timeStep); //derivada de la velocidad en el punto medio
  PVector k1s = PVector.mult(_v, _timeStep);

  PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5)); //(s(t)+(v(t)*h)*0.5)
  PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));  //(v(t)+(a(t)*h)*0.5)
  PVector a2 = calculateAcceleration (s2,v2);

  PVector k2v = PVector.mult(a2, _timeStep);//Aceleracion en el punto medio * h
  PVector k2s = PVector.mult(v2, _timeStep);

  PVector s3 = PVector.add(_s, PVector.mult(k2s, 0.5)); //(s(t)+(v(t)*h)*0.5)
  PVector v3 = PVector.add(_v, PVector.mult(k2v, 0.5));  //(v(t)+(a(t)*h)*0.5)
  PVector a3 = calculateAcceleration (s3,v3);

  PVector k3v = PVector.mult(a3, _timeStep);//Aceleracion en el punto medio * h
  PVector k3s = PVector.mult(v3, _timeStep);

  PVector s4 = PVector.add(_s, k3s); //(s(t)+(v(t)*h))
  PVector v4 = PVector.add(_v, k3v);  //(v(t)+(a(t)*h))
  PVector a4 = calculateAcceleration (s4,v4);

  PVector k4v = PVector.mult(a4, _timeStep);//Aceleracion en el punto medio * h
  PVector k4s = PVector.mult(v4, _timeStep);
  
  
  
  _v.add(PVector.mult(k1v, 1/6.0));
  _v.add(PVector.mult(k2v, 1/3.0));
  _v.add(PVector.mult(k3v, 1/3.0));
  _v.add(PVector.mult(k4v, 1/6.0));
  
  _s.add(PVector.mult(k1s, 1/6.0));
  _s.add(PVector.mult(k2s, 1/3.0));
  _s.add(PVector.mult(k3s, 1/3.0));
  _s.add(PVector.mult(k4s, 1/6.0));

  
  
}

PVector calculateAcceleration(PVector s, PVector v)
{

   PVector a = new PVector();
   _sp.setPos2(s);
   _sp.update();


   _Fe = _sp.getForce(); //Fuerza elastica

   _Fw = PVector.mult(Gvector, M); //Fw = m*g

   _Fd = PVector.mult(v, -Kd); //Fd = -Kd*v
   
   
   _Fres = PVector.add(_Fe, _Fw);
   _Fres.add(_Fd);
   
   a = PVector.div(_Fres, M);
   println(_Fres);
   return a;
}
