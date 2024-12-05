// Class for a particle system controller
class ParticleSystem
{
   PVector _location;   
   ArrayList<Particle> _particles;
   int _nextId;
   PImage _tex;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _tex = loadImage(TEXTURE_FILE);      
      _nextId = 0;
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c, float lifeSpan)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c, lifeSpan));
      _nextId++;
   }

   void restart()
   {
      _particles.clear();
   }

   int getNumParticles()
   {
      return _particles.size();
   }
   
   float getTotalEnergy()
   {
      float energy = 0.0;
      int n = _particles.size();
      
      for (int i = 0; i < n; i++)
      {
         Particle p = _particles.get(i);
         energy += p.getEnergy();
      }
         
      return energy;   
   }

   void setLocation(PVector location)
   {
      _location = location;
   }

   PVector getLocation()
   {
      return _location;
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void update(float timeStep)
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         
         if (!p.isDead())
            p.update(timeStep);
         else
            _particles.remove(i);
      }
   }

   void render(boolean useTexture)
   {
      for (int i = _particles.size() - 1; i >= 0 ; i--)
      {
         Particle p = _particles.get(i);
         p.render(useTexture);
      }
   }
}
