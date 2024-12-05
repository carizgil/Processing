// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle (-)

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)
   float _energy;       // Energy (J)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   float _lifeSpan;     // Total time the particle should live (s)
   float _timeToLive;   // Remaining time before the particle dies (s)

   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c, float lifeSpan)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);
      _energy = 0.0;

      _radius = radius;
      _color = c;
      _lifeSpan = lifeSpan;
      _timeToLive = _lifeSpan;
   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void setVel(PVector v)
   {
      _v = v;
   }

   PVector getForce()
   {
      return _F;
   }

   float getEnergy()
   {
      return _energy;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   float getTimeToLive()
   {
      return _timeToLive;
   }

   boolean isDead()
   {
      return (_timeToLive <= 0.0);
   }

   void update(float timeStep)
   {
      _timeToLive -= timeStep;

      updateSimplecticEuler(timeStep);
      updateEnergy();
   }

   void updateSimplecticEuler(float timeStep)
   {
      updateForce();
      calculateColor();
      
      _a = PVector.div(_F,_m);
  
    _v.add(PVector.mult(_a,timeStep)); // v(t+h) = v(t) + a(s(t),v(t))*h
    _s.add(PVector.mult(PVector.mult(_v,100),timeStep)); // s(t+h) = s(t) + v(t) en cm*h 
    
   }

   void updateForce()
   {
      
      PVector turbulence = new PVector(random(-0.001,0.001),0.0);
      PVector wind = new PVector(-0.0003,-0.001);
      // Fw = m*g
      PVector g = new PVector(0.0,G);
      PVector FPeso = PVector.mult(g,_m); 
      
      // Froz = -Kd * v(actual)
      float vSquared = pow(_v.mag(),2);
      PVector vNormalized = _v.copy();
      vNormalized.normalize();
      
      PVector Froz = PVector.mult(PVector.mult(vNormalized,vSquared),-Kd);
      //Se suman las fuerzas
      
      _F = PVector.add(Froz,FPeso);
      //_F.add(turbulence);
      _F.add(wind);


   }

   void updateEnergy()
   {
      //energía cinética es la masa por el cuadrado de la magnitud de la velocidad
       float _Ek = _m * pow(_v.mag(), 2) * 0.5;
    
       //energía potencial gravitacional es la masa por la constante gravitacional por la posición en el eje y
       float _Eg = _m * G * _s.y;
    
       // Suma la energía cinética y la energía potencial gravitacional
       _energy = _Ek + _Eg;
   }

   void render(boolean useTexture)
   {
      if (useTexture)
      {
      

        noStroke();
        noFill();
        fill(_color);
        
        //image(textureImage, _s.x, _s.y, _radius*100, 100*_radius);
         //ellipse(_s.x, _s.y, _radius*100, 100*_radius);
      } 
      else
      {
         // Dibuja un círculo si no se está utilizando la textura
         noStroke();
         fill(calculateColor());
         ellipse(_s.x, _s.y, _radius*100 , 100*_radius); 
      }
   }
   
   color calculateColor() {
      // Calcula el color en función de la distancia desde la base de la hoguera
      float distance = PVector.dist(_s, _ps._location);
      float colorFactor = map(distance, 0, 200, 255, 0);  // Ajusta según la distancia máxima deseada
      
      return color(255,colorFactor,0);  // Rojo con componente verde variable
   }
}
