// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   

      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;

      _a = new PVector(0.0, 0.0);
      _F = new PVector(0.0, 0.0);
   

      _radius = radius;
      _color = c;

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

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   void update(float timeStep)
   {
      updateForce();

      updateSimplecticEuler(timeStep);
   }

   void randomVelocity(){
      _v = new PVector(random(-1,1), random(-1,1));
   }

   void updateForce()
   {
      // Froz = -Kd * v
      PVector Froz = PVector.mult(_v, -Kd);


      _F.set(Froz);
      if(_forceLeft){
         _F.add(new PVector(-FPool, FPool));
      }
  
   }

   void updateSimplecticEuler(float timeStep)
   {
      updateForce();      
      _a = PVector.div(_F,_m);
      
    _v.add(PVector.mult(_a,timeStep)); // v(t+h) = v(t) + a(s(t),v(t))*h
    _s.add(PVector.mult(PVector.mult(_v,100),timeStep)); // s(t+h) = s(t) + v(t) en cm*h 
    
   }

   void planeCollision(ArrayList<PlaneSection> planes)
   {
      for (int i = 0; i < planes.size(); i++)
      {
         float distancia = planes.get(i).getDistance(_s);

         if (!planes.get(i).checkSide(_s) && planes.get(i).checkLimits(_s)) {
            PVector normal = planes.get(i).getNormal();
            _s.y =  _s.y + normal.y * distancia;
         }

         if(distancia < _radius && planes.get(i).checkLimits(_s))
         {
            planeCollisionHandler(planes.get(i), distancia);
         }
      }
   }

   void planeCollisionHandler(PlaneSection plane, float distancia)
   {
      float incS = _radius - distancia;
      PVector normal = plane.getNormal();
      _s.add(PVector.mult(normal, incS));

      float vn = _v.dot(normal);
      PVector velNormal = PVector.mult(normal, vn);
      PVector velTangential = PVector.sub(_v, velNormal);

      
      _v = PVector.sub(velTangential, PVector.mult(velNormal, CR1));
   }

         

   void particleCollision(float timeStep) {
   
    ArrayList<Particle> parts = _ps.getParticleArray();
    
    for(int i = 0; i < parts.size(); i++) 
    {
      if(_id != parts.get(i)._id)
      {
         Particle otherParticle = parts.get(i);
         PVector d = PVector.sub(otherParticle._s, _s);
         float distanciaMag = d.mag();
         float minDist = _radius + otherParticle._radius;
         if(distanciaMag < minDist)
         {
            println(_ps.getCollisionModelType());
            if(_ps.getCollisionModelType() == CollisionModelType.VELOCITY)
            {
               particleCollisionHandlerVelocityModel(otherParticle, d, distanciaMag, minDist);

            }
            else if(_ps.getCollisionModelType() == CollisionModelType.SPRING)
            {
               particleCollisionHandlerSpringModel(otherParticle, d, distanciaMag, minDist);

            }
            collisionCount++;
            
         }
      }
    }
   }

   void particleCollisionHandlerVelocityModel(Particle otherParticle, PVector d, float distanciaMag, float minDist)
   {
      PVector VUnit = d.copy();
      VUnit.normalize();

      //Descomposición
      PVector n1 = PVector.mult(VUnit, _v.dot(d)/distanciaMag);
      PVector n2 = PVector.mult(VUnit, otherParticle._v.dot(d)/distanciaMag);
      PVector t1 = PVector.sub(_v, n1);
      PVector t2 = PVector.sub(otherParticle._v, n2); 

      //Restitucion
      float L = minDist - distanciaMag;
      float vrel = PVector.sub(n1, n2).mag();

      PVector oldS = _s.copy();
      PVector oldOtherS = otherParticle._s.copy();

      _s.add(PVector.mult(n1, -L/vrel));
      otherParticle._s.add(PVector.mult(n2, -L/vrel));

      if (oldS.sub(_s).mag() > _radius) {
         deviation++;
      }

      if (oldOtherS.sub(otherParticle._s).mag() > otherParticle._radius) {
         deviation++;
      }

      //Nuevas velocidades
      float u1 = n1.dot(d)/distanciaMag;
      float u2 = n2.dot(d)/distanciaMag;

      float new_v1 = (( _m - otherParticle._m) * u1 + 2 * otherParticle._m * u2) / (_m + otherParticle._m); 
      new_v1 *= CR2;
      float new_v2 = (( otherParticle._m - _m) * u2 + 2 * _m * u1) / (_m + otherParticle._m);   
      new_v2 *= CR2;

      PVector n1_prime = PVector.mult(VUnit, new_v1);
      _v = PVector.add(n1_prime, t1);

      PVector n2_prime = PVector.mult(VUnit, new_v2);
      otherParticle._v = PVector.add(n2_prime, t2);
   }

   void particleCollisionHandlerSpringModel(Particle otherParticle, PVector d, float distanciaMag, float minDist)
   {
         float dx = otherParticle._s.x - _s.x;
         float dy = otherParticle._s.y - _s.y;
         float angle = atan2(dy, dx);
        
          float targetX = _s.x + cos(angle) * minDist;
          float targetY = _s.y + sin(angle) * minDist;
          
          float Fmuellex = (targetX - otherParticle._s.x) * Ke; //Distancia * constante elástica = fuerza del muelle
          float Fmuelley = (targetY - otherParticle._s.y) * Ke;
         
          //Nuevas velocidades de salida para ambas partículas: en estas actuará una fuerza del muelle determinada por sus posiciones
          _v.x -= Fmuellex;
          _v.y -= Fmuelley;
          otherParticle._v.x += Fmuellex;
          otherParticle._v.y += Fmuelley;
   }   
   

   void render()
   {
      noStroke();
      fill(_color);
      ellipse(_s.x, _s.y, 2*_radius , 2*_radius);
   }
}
