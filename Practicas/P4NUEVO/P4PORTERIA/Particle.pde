static int _lastParticleId = 0; //<>//

public class Particle
{
   int _id;            // Unique id for each particle

   PVector _s;         // Position (m)
   PVector _v;         // Velocity (m/s)
   PVector _a;         // Acceleration (m/(s*s))
   PVector _F;         // Force (N)
   float _m;           // Mass (kg)

   boolean _noGravity; // If true, the particle will not be affected by gravity
   boolean _clamped;   // If true, the particle will not move
   boolean _enabled;

   Particle(PVector s, PVector v, float m, boolean noGravity, boolean clamped)
   {
      _id = _lastParticleId++;

      _s = s.copy();
      _v = v.copy();
      _m = m;

      _noGravity = noGravity;
      _clamped = clamped;
      _enabled = true;

      _a = new PVector(0.0, 0.0, 0.0);
      _F = new PVector(0.0, 0.0, 0.0);
   }

   void update(float simStep)
   {
      if (_clamped)
         return;

      if (!_noGravity)
         updateWeightForce();

      // Simplectic Euler:
      // v(t+h) = v(t) + h*a(s(t),v(t))
      // s(t+h) = s(t) + h*v(t+h)

      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, simStep));
      _s.add(PVector.mult(_v, simStep));
      _F.set(0.0, 0.0, 0.0);
   }

   int getId()
   {
      return _id;
   }

   boolean getState()
   {
      return _enabled;
   }

   PVector getPosition()
   {
      return _s;
   }


   void setPosition(PVector s)
   {
      _s = s.copy();
      _a.set(0.0, 0.0, 0.0);
      _F.set(0.0, 0.0, 0.0);
   }

   void setVelocity(PVector v)
   {
      _v = v.copy();
   }

   void updateWeightForce()
   {
      PVector weigthForce = new PVector(0,G*_m,0);
      _F.add(weigthForce);
   }

   void updateDragForce()
   {
      PVector _vNorm = _v.copy().normalize();
      PVector dragForce = PVector.mult(_vNorm, -KdAir * _v.mag()*_v.mag());
      _F.add(dragForce);
   }

   void addExternalForce(PVector F)
   {
      _F.add(F);
   }

   void setClamped(boolean clamped)
   {
      _clamped = clamped;
   }
}
