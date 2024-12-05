import peasy.*;
PeasyCam _camera;

float _timeStep;
int _lastTimeDraw = 0;
float _deltaTimeDraw = 0.0;
float _simTime = 0.0;
float _elapsedTime = 0.0;

DeformableObject _struc, _shear, _bend;
PVector _airForce;
  
void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup()
{
   frameRate(DRAW_FREQ);
   _lastTimeDraw = millis();

   float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);
   perspective((FOV*PI)/180, aspect, NEAR, FAR);
   _camera = new PeasyCam(this, 0);
   _camera.rotateX(QUARTER_PI);
   _camera.rotateZ(PI);
   _camera.setDistance(500);

   initSimulation();
}

void keyPressed()
{
  
   if (key == 'D' || key == 'd')
      DRAW_MODE = !DRAW_MODE;
      
   if(key == 'V' || key == 'v')
      v = !v;
      
   if(key == 'G' || key == 'g')
      g = !g;
      
   if (key == 'R' || key == 'r')
      restartSimulation();

   if (key == 'I' || key == 'i')
      initSimulation();
      
   if (keyCode == RIGHT)
      _airForce.mult(1.05);

   if (keyCode == LEFT)
      _airForce.div(1.05);
}

void initSimulation()
{
   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   _airForce = new PVector(5,0,0);
   _struc = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, STRUC_COLOR, xPostes, alturaPoste - 30, 0);
   _bend = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, BEND_COLOR, 0, alturaPoste - 30, 1);
   _shear = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, SHEAR_COLOR, -xPostes, alturaPoste - 30, 2);
}

void restartSimulation()
{
   _simTime = 0.0;
   _timeStep = TS*TIME_ACCEL;
   _elapsedTime = 0.0;
   initSimulation();
}

void draw()
{
   int now = millis();
   _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
   _elapsedTime += _deltaTimeDraw;
   _lastTimeDraw = now;
   background(BACKGROUND_COLOR);
   drawStaticEnvironment();
   drawDynamicEnvironment();

   if (REAL_TIME)
   {
      float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
      float expectedIterations = expectedSimulatedTime/_timeStep;
      int iterations = 0;

      for (; iterations < floor(expectedIterations); iterations++)
         updateSimulation();

      if ((expectedIterations - iterations) > random(0.0, 1.0))
      {
         updateSimulation();
         iterations++;
      }
   } 
   else
      updateSimulation();

   displayInfo();
}

void drawStaticEnvironment()
{
   noStroke();

   fill(0, 255, 0);
   box(1.0, 1000.0, 1.0);
   stroke(0);
   strokeWeight(1);
   line(-width/2, 0, width/2, 0);
   
   stroke(0);
   strokeWeight(3);
   line(xPostes, 0, 0, xPostes, 0, alturaPoste);
   line(0, 0, 0, 0, 0, alturaPoste);
   line(-xPostes, 0, 0, -xPostes, 0, alturaPoste);
   
   float pos = -xPostes;
   for(int i = 0; i < 3; i++){
     pushMatrix();
     translate(pos, 0, alturaPoste);
     sphere(1.0);
     pos += xPostes;
     popMatrix();
   }
   
   fill(255, 255, 255);
   sphere(1.0);
}

void drawDynamicEnvironment()
{
   _struc.render();
   _shear.render();
   _bend.render();
}

void updateSimulation()
{
   _struc.update(_timeStep);
   _shear.update(_timeStep);
   _bend.update(_timeStep);
   
   _airForce.x = (1.2+ (float)random(0,1)/float(maximoViento)*0.1)* -1 ;
   _airForce.y = 0.12 + (float)random(0,1)/float(maximoViento)*0.01;
   
   _struc.setAire(_airForce);
   _shear.setAire(_airForce);
   _bend.setAire(_airForce);
   
   if(v == true){
     _struc.updateAire();
     _shear.updateAire();
     _bend.updateAire();
   }

   _simTime += _timeStep;
}


void displayInfo()
{
   pushMatrix();
   {
      camera();
      fill(0,0,255);
      textSize(15);
      
      text("INSTRUCCIONES", width*0.025, height*0.05);
      text("Pulsa la tecla 'v' para activar/desactivar el viento", width*0.025, height*0.075);
      text("Pulsa la tecla 'g' para activar/desactivar la gravedad", width*0.025, height*0.1);
      
      text("FUERZAS EXTERNAS:", width - width*0.2, height*0.05);
      if(v == true)
        text("Viento activado", width - width*0.2, height*0.075);
      else
        text("Viento desactivado", width - width*0.2, height*0.075);
      if(g == true)
        text("Gravedad activada", width - width*0.2, height*0.1);
      else
        text("Gravedad desactivada", width - width*0.2, height*0.1);
   }
   popMatrix();
}
