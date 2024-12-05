public class Ball extends Particle
{
   float _r;       // Radius (m)
   color _color;   // Color (RGB)
   float Ke;       // Constante elástica del muelle

   Ball(PVector s, PVector v, float m, float r, color c)
   {
      super(s, v, m, false, false);
      Ke = BALL_KE;
      _r = r;
      _color = c;
   }

   void update(float dt)
   {
      updateDragForce();
      super.update(dt);
   }

   void updateVelocity(float mag)
   {
      _v.mult(mag);
   }

   void checkCollision(Porteria porteria)
   {
      for (Particle particle : porteria.getNodes())
      {
         if(PVector.sub(particle.getPosition() , this.getPosition()).mag() < _r)
         {
         particleCollisionHandlerSpringModel(particle, PVector.sub(particle.getPosition(), this.getPosition()), PVector.sub(particle.getPosition(), this.getPosition()).mag(), _r);
         }
      }

   }

   void setKe(float ke)
   {
      Ke = ke;
   }

   void checkCollisionBall(Ball pelota)
   {
      
      float distancia = PVector.sub(pelota.getPosition(), _s).mag();
      if (distancia < _r + pelota.getRadius())
      {
         particleCollisionHandlerSpringModel(pelota, PVector.sub(pelota.getPosition(), _s), distancia, _r + pelota.getRadius());
      }

   }

  

   void checkCollisionPlane(Plano plano)
   {
      float distancia = abs(_s.y - plano.getPosition().y);
      if (distancia < _r)
      {
         particleCollisionHandlerPlane(plano);
      }
   }

   void particleCollisionHandlerPlane(Plano plano){
      float Fmuelle = (plano.getPosition().y - _s.y) * Ke;
      plano.getNormal();
      PVector force = PVector.mult(plano.getNormal(), Fmuelle);
      _F.add(force);
      
   }

   void particleCollisionHandlerSpringModel(Particle otherParticle, PVector d, float distanciaMag, float minDist)
   {
    
          float angleXY = atan2(d.y, d.x);
          float angleXZ = atan2(d.z, d.x);
          float angleYZ = atan2(d.z, d.y);
         
          float targetX = _s.x + cos(angleXY) * minDist;
          float targetY = _s.y + sin(angleXY) * minDist;
          float targetZ = _s.z + sin(angleXZ) * minDist;
           
          float Fmuellex = (targetX - otherParticle._s.x) * Ke; 
          float Fmuelley = (targetY - otherParticle._s.y) * Ke;
          float Fmuellez = (targetZ - otherParticle._s.z) * Ke;
          
           PVector force = new PVector(Fmuellex, Fmuelley, Fmuellez);
           _F.sub(force);
           otherParticle.addExternalForce(force);
           if (force.mag() > RUPTURE_FORCE)
            otherParticle._enabled = false;
          
   }  

   float getRadius()
   {
      return _r;
   }

   void render()
   {
      pushMatrix();
      {
         translate(_s.x, _s.y, _s.z);
         fill(_color);
         stroke(0);
         strokeWeight(0.5);
         //noStroke();
         sphereDetail(25);
         sphere(_r);
      }
      popMatrix();
   }
}
