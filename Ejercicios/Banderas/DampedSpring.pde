static int id = 0;

public class DampedSpring
{
   Particle _p1;
   Particle _p2;

   float _Ke;
   float _Kd;

   float _l0;
   float _l;
   float _v;

   PVector _e;
   PVector _eN;
   PVector _F;
   int _id;


   DampedSpring(Particle p1, Particle p2, float Ke, float Kd)
   {
     _id = id++;
     
     _p1 = p1;
     _p2 = p2;
     _Ke = Ke;
     _Kd = Kd;
     _l0 = PVector.sub(p2.getPosition(), p1.getPosition()).mag();
     _l = _l0;
     
     _e = new PVector();
     _eN = new PVector();
     _F = new PVector();
   }

   Particle getParticle1()
   {
      return _p1;
   }

   Particle getParticle2()
   {
      return _p2;
   }

   void update(float simStep)
   {
      float _ultL = _l;
      _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
      _l = _e.mag();
      
      float x = _l - _l0;
      _eN = _e.copy().normalize();
      float _dl = (_ultL - _l)/simStep;
      
      PVector e = PVector.mult(_eN, _Ke * x);
      PVector d = PVector.mult(_eN, _Kd * _dl);
      _F = PVector.sub(e, d);
      
      applyForces();
   }

   void applyForces()
   {
      _p1.addExternalForce(_F);
      _p2.addExternalForce(PVector.mult(_F, -1.0));
   }
}
