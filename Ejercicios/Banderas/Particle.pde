static int _lastParticleId = 0; //<>//

public class Particle
{
   int _id;
   PVector _s;
   PVector _v;
   PVector _a;
   PVector _F;
   float _m;

   boolean _noGravity;
   boolean _clamped;


   Particle(PVector s, PVector v, float m, boolean noGravity, boolean clamped)
   {
      _id = _lastParticleId++;

      _s = s.copy();
      _v = v.copy();
      _m = m;

      _noGravity = noGravity;
      _clamped = clamped;

      _a = new PVector(0.0, 0.0, 0.0);
      _F = new PVector(0.0, 0.0, 0.0);
   }

   void update(float simStep)
   {
      if (_clamped)
         return;

      if (!_noGravity && g)
         updateWeightForce();

      _a = PVector.div(_F, _m);
      _v.add(PVector.mult(_a, simStep));
      _s.add(PVector.mult(_v, simStep));
      _F.set(0.0, 0.0, 0.0);
   }

   int getId()
   {
      return _id;
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
      PVector weigthForce = new PVector(0, 0, -G*_m);
      _F.add(weigthForce);
   }

   void addExternalForce(PVector F)
   {
      _F.add(F);
   }
}
