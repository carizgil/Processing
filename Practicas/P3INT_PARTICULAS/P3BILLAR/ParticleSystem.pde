// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   CollisionDataType _collisionDataType;
   CollisionModelType _collisionModelType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _collisionDataType = CollisionDataType.NONE;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c));
      _nextId++;
   }

   void restart()
   {
      _particles.clear();
   }

   void setCollisionDataType(CollisionDataType collisionDataType)
   {
      _collisionDataType = collisionDataType;
   }

   void setCollisionModelType(CollisionModelType collisionModelType)
   {
      _collisionModelType = collisionModelType;
   }

   CollisionModelType getCollisionModelType()
   {
      return _collisionModelType;
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticles()
   {
      return _particles;
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void updateCollisionData()
   {
      //
      //
      //  
   }

   void computePlanesCollisions(ArrayList<PlaneSection> planes)
   {
      for (int i = 0; i < _particles.size(); i++)
      {
         Particle p = _particles.get(i);
         p.planeCollision(planes);
      }
          
   }

   void computeParticleCollisions(float timeStep)
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         p.particleCollision(timeStep);
      }

      //deviation = deviation / _particles.size();
   }

   void update(float timeStep)
   {
      int n = _particles.size();
      for (int i = n - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         p.update(timeStep);
      }
   }

   void randomVelocitys()
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         p.randomVelocity();
      }
   }

   void render()
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         p.render();
         
      }
   }
}
