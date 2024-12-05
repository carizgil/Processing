// Class for a simple spring with no damping
public class Spring
{
   PVector _pos1;   // First end of the spring (m)
   PVector _pos2;   // Second end of the spring (m)
   float _KePropia;       // Elastic constant (N/m)
   float _l0Propia;       // Rest length (m)
   float _l;      // Current length of the spring (m)

   float _energy;   // Energy (J)
   PVector _F;      // Force applied by the spring towards pos1 (the force towards pos2 is -_F) (N)
   float Ek;        // Energía cinética
   float Eg;        // Energía potencial gravitatoria;
   float Ee;        // Energía potencial elástica

   Spring(PVector pos1, PVector pos2, float Ke, float l0)
   {
      _pos1 = pos1;
      _pos2 = pos2;
      _KePropia = Ke;
      _l0Propia = l0;
      _l = PVector.dist(_pos2, _pos1);
      _energy = 0.0;
      _F = new PVector(0.0, 0.0);
   }

   void setPos1(PVector pos1)
   {
      _pos1 = pos1;
   }

   void setPos2(PVector pos2)
   {
      _pos2 = pos2;
   }

   void setKe(float Ke)
   {
      _KePropia = Ke;
   }

   void setRestLength(float l0)
   {
      _l0Propia = l0;
   }

   void update()
   { 
    // Cálculo de la fuerza actual del resorte (sin amortiguamiento)
    float F = -_KePropia * (PVector.dist(_pos2, _pos1) - _l0Propia); // Fuerza = -Ke * (l - l0)

    // Dirección de la fuerza normalizada
    PVector u = PVector.sub(_pos2, _pos1);
    u.normalize();

    // Actualización de la fuerza en la clase
    _F = PVector.mult(u, F);

    // Actualización de la energía potencial elástica
      updateEnergy();
   }

   void updateEnergy()
   {
      Ee = 0.5 * _KePropia * pow(PVector.sub(_pos1, _pos2).mag(),2); // E elastica =  1/2 * k * x^2     
      _energy = Ee;
   }

   float getEnergy()
   {
      return _energy;
   }

   PVector getForce()
   {
      return _F;
   }

   float getError()
   {
      return PVector.dist(_pos2, _pos1) - (M*G)/_KePropia - l0;
   }
}
