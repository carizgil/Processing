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

   boolean _checked;
      
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
      _checked = false;

   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void check()
   {
      _checked = true;
   }

   void uncheck()
   {
      _checked = false;
   }

   PVector getPos()
   {
      return _s;
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

   void setColor(color c)
   {
      _color = c;
   }

   void update(float timeStep)
   {
      updateForce();
      updateSimplecticEuler(timeStep);
      
   }

   void updateForce()
   {
      float vSquared = pow(_v.mag(),2);
      PVector vNormalized = _v.copy();
      vNormalized.normalize();
     
      PVector Froz = PVector.mult(PVector.mult(vNormalized,vSquared),-Kd);
      PVector Fg = new PVector(0.0, 9.8*_m);

      _F.add(PVector.add(Froz, Fg));
   }

   void updateSimplecticEuler(float timeStep)
   {
      updateForce();      
      _a = PVector.div(_F,_m);
  
    _v.add(PVector.mult(_a,timeStep)); 
    _s.add(PVector.mult(_v,timeStep)); 
   _F = new PVector(0,0);
    
   }

   void planeCollision(ArrayList<PlaneSection> planes)
   {
      for (int i = 0; i < planes.size(); i++)
      {

         float distancia = planes.get(i).getDistance(_s);
         
         if (!planes.get(i).checkSide(_s) && planes.get(i).checkLimits(_s)) {
            PVector normal = planes.get(i).getNormal();
            _s.y =  _s.y + normal.y * distancia;
            //_s.x =  _s.x - normal.x;
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

      
      _v = PVector.add(velTangential, PVector.mult(velNormal, -Kr));

   }

   void particleCollision(ArrayList<Particle> particles)
   {
      for(int i = 0; i < particles.size(); i++) 
    {
      if(_id != particles.get(i)._id)
      {
         Particle otherParticle = particles.get(i);
         PVector d = PVector.sub(otherParticle._s, _s);
         float distanciaMag = d.mag();
         float minDist = _radius + otherParticle._radius;
         if(distanciaMag < minDist)
         {
            
            if(_ps.getCollisionModelType() == CollisionModelType.VELOCITY)
            {
               particleCollisionHandlerVelocityModel(otherParticle, d, distanciaMag, minDist);

            }
            else if(_ps.getCollisionModelType() == CollisionModelType.SPRING)
            {
               particleCollisionHandlerSpringModel(otherParticle, d, distanciaMag, minDist);

            }
            
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
      _s.add(PVector.mult(n1, -L/vrel));
      otherParticle._s.add(PVector.mult(n2, -L/vrel));

      //Nuevas velocidades
      float u1 = n1.dot(d)/distanciaMag;
      float u2 = n2.dot(d)/distanciaMag;

      float new_v1 = (( _m - otherParticle._m) * u1 + 2 * otherParticle._m * u2) / (_m + otherParticle._m); 
      new_v1 *= Kr;
      float new_v2 = (( otherParticle._m - _m) * u2 + 2 * _m * u1) / (_m + otherParticle._m);   
      new_v2 *= Kr;

      PVector n1_prime = PVector.mult(VUnit, new_v1);
      _v = PVector.add(n1_prime.mult(Kr), t1);
      

      PVector n2_prime = PVector.mult(VUnit, new_v2);
      otherParticle._v = PVector.add(n2_prime.mult(Kr), t2);
      
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
          _F.x -= Fmuellex;
          _F.y -= Fmuelley;
          otherParticle._F.x += Fmuellex;
          otherParticle._F.y += Fmuelley;
          
   }   

   void updateNeighborsGrid(Grid grid)
   {
      
      ArrayList<Particle> neighbors = grid.getNeighbors(_s);
      particleCollision(neighbors);
      
      
   }

   void updateNeighborsHash(HashTable hashTable)
   {
      ArrayList<Particle> neighbors = hashTable.getNeighbors(_s);
      particleCollision(neighbors);
   }

   void updateNeighborsNone()
   {
      
   }

   void render()
   {
      noStroke();
      fill(_color);
      if(_ps.getDataStructureType() == DataStructureType.NONE)
         fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
      ellipse(_s.x, _s.y, 2*_radius , 2*_radius);
   }

}

public class GhostParticle extends Particle
{

   PVector _s;

   GhostParticle(PVector s)
   {
      super(null, 0, 0, s, new PVector(0, 0), 0, color(0));
      _s = s;
   }
}