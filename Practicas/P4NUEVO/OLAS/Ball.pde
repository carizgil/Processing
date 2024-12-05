public class Ball extends Particle
{
   float _r;       // Radius (m)
   color _color;   // Color (RGB)
   float Ke;       // Constante elástica del muelle

   Ball(PVector s, PVector v, float m, float r, color c)
   {
      super(s);
        _v = v;
        _m = m;
      Ke = BALL_KE;
      _r = r;
      _color = c;
   }

   void update(float dt)
   {
      updateDragForce();
      super.update(dt);
   }



   void setKe(float ke)
   {
      Ke = ke;
   }

   void checkCollisionBall(Particle pelota)
   {
      
      float distancia = PVector.sub(pelota.getPosition(), _s).mag();
      if (distancia < _r *0.8)
      {
        println("Collision");
         particleCollisionHandlerSpringModel(pelota, PVector.sub(pelota.getPosition(), _s), distancia, _r );
      }

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
           //otherParticle.addExternalForce(force);
          
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
