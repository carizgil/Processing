public class DeformableObject
{
   int _numNodesX;
   int _numNodesY;
   int _numNodesZ;
   int _tipo;
   float _sepX;
   float _sepY;
   float _sepZ;
   color _color;
   
   ArrayList<DampedSpring> _springs;
   Particle[][][] _nodes;

   DeformableObject(int X, int Y, int Z, float sX, float sY, float sZ, color c, float posX, float altura, int tipo)
   {
     _numNodesX = X;
     _numNodesY = Y;
     _numNodesZ = Z;
     
     _sepX = sX;
     _sepY = sY;
     _sepZ = sZ;
     
     _color = c;
     
     _tipo = tipo;
     
     _nodes = new Particle[X][Y][Z];
     _springs = new ArrayList<DampedSpring>();
     _airForce = new PVector();
     
     for(int i = 0; i < _numNodesX; i++){
       for(int j = 0; j < _numNodesY; j++){
         for(int k = 0; k < _numNodesZ; k++){
           if((k == 0 || k == _numNodesZ - 1) && i == 0)
             _nodes[i][j][k] = new Particle(new PVector((i+posX)*_sepX, 0, (k+altura) * _sepZ), new PVector(0,0,0), mb, true, true);
           else
             _nodes[i][j][k] = new Particle(new PVector((i+posX)*_sepX, 0, (k+altura) * _sepZ), new PVector(0,0,0), mb, false, false);
         }
       }
     }
     
     if(tipo == 0)
       Structural();
     else if(tipo == 1){
       Bend();
     }
     else if(tipo == 2)
       Shear();
     else
       exit();
   }
   
   void Structural(){
     for(int i = 0; i < _numNodesX; i++){
       for(int j = 0; j < _numNodesY; j++){
         for(int k = 0; k < _numNodesZ; k++){
           if(i+1 < _numNodesX)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+1][j][k], Ke, Kd));
           if(j+1 < _numNodesY)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j+1][k], Ke, Kd));
           if(k+1 < _numNodesZ)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j][k+1], Kez, Kdz));
         }
       }
     }
   }
   
   void Bend(){
     for(int i = 0; i < _numNodesX; i++){
       for(int j = 0; j < _numNodesY; j++){
         for(int k = 0; k < _numNodesZ; k++){
           if((i == 0 || i == _numNodesX - 1) && k+1 < _numNodesZ){
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j][k+1], Ke, Kd));
             if(i==0)
               _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+1][j][k], Ke, Kd));
             if(i==_numNodesX - 1)
               _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i-1][j][k], Ke, Kd));
           }
           if((k == 0 || k == _numNodesZ - 1) && i+1 < _numNodesX){
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+1][j][k], Ke, Kd));
             if(k==0)
               _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j][k+1], Ke, Kd));
             if(k==_numNodesZ - 1)
               _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j][k-1], Ke, Kd));
           }
           if(i+2 < _numNodesX)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+2][j][k], Ke, Kd));
           if(j+2 < _numNodesY)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j+2][k], Ke, Kd));
           if(k+2 < _numNodesZ)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j][k+2], Kez, Kdz));
         }
       }
     }
   }
   
   void Shear(){
     for(int i = 0; i < _numNodesX; i++){
       for(int j = 0; j < _numNodesY; j++){
         for(int k = 0; k < _numNodesZ; k++){
           if((i == 0 || i == _numNodesX - 1) && k+1 < _numNodesZ){
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j][k+1], Ke, Kd));
           }
           if((k == 0 || k == _numNodesZ - 1) && i+1 < _numNodesX){
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+1][j][k], Ke, Kd));
           }
           if(i+1 < _numNodesX && j+1 < _numNodesY)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+1][j+1][k], Ke, Kd));
           if(i-1 >= 0 && j+1 < _numNodesY)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i-1][j+1][k], Ke, Kd));
           if(k+1 < _numNodesZ && j+1 < _numNodesY)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j+1][k+1], Kez, Kdz));
           if(k+1 < _numNodesZ && j-1 >= 0)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i][j-1][k+1], Kez, Kdz));
           if(k+1 < _numNodesZ && i+1 < _numNodesX)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i+1][j][k+1], Kez, Kdz));
           if(k+1 < _numNodesZ && i-1 >= 0)
             _springs.add(new DampedSpring(_nodes[i][j][k],_nodes[i-1][j][k+1], Kez, Kdz));
         }
       }
     }
   }

   int getNumNodes()
   {
      return _numNodesX*_numNodesY*_numNodesZ;
   }

   void update(float simStep)
   {
      for(int i = 0; i < _numNodesX; i++){
        for(int j = 0; j < _numNodesY; j++){
          for(int k = 0; k < _numNodesZ; k++){
            _nodes[i][j][k].update(simStep);
          }
        }
      }
      
      for(int i = 0; i < _springs.size(); i++){
        _springs.get(i).update(simStep);
      }
   }
   
   void updateAire(){
     for(int i = 0; i < _numNodesX; i++){
        for(int j = 0; j < _numNodesY; j++){
          for(int k = 0; k < _numNodesZ; k++){
             calcularFuerzaAire(i,j,k);
          }
        }
      }
   }
   
   void setAire(PVector aire){
     _airForce = aire.copy();
   }
   
   void calcularFuerzaAire(int i, int j, int k){
             PVector aire = _airForce.copy().normalize();
             float dot = normalPlano(i,j, k).dot(aire);
             _nodes[i][j][k].addExternalForce(_airForce.copy().mult(abs(dot)));
   }
   
   PVector normalPlano(int i, int j, int k){
     PVector nariz = new PVector(0,0,0);
     PVector narde = new PVector(0,0,0);
     PVector nabde = new PVector(0,0,0);
     PVector nabiz = new PVector(0,0,0);
     int n = 0;
     
     if(i-1 >= 0 && k+1 < _numNodesZ){
       PVector AB = PVector.sub(_nodes[i-1][j][k].getPosition(), _nodes[i][j][k].getPosition());
       PVector AC = PVector.sub(_nodes[i][j][k+1].getPosition(), _nodes[i][j][k].getPosition());
       n++;
       nariz = AB.cross(AC).normalize();
     }
     if(i+1 < _numNodesX && k+1 < _numNodesZ){
       PVector AB = PVector.sub(_nodes[i+1][j][k].getPosition(), _nodes[i][j][k].getPosition());
       PVector AC = PVector.sub(_nodes[i][j][k+1].getPosition(), _nodes[i][j][k].getPosition());
       n++;
       narde = AC.cross(AB).normalize();
     }
     if(i+1 < _numNodesX && k-1 >= 0){
       PVector AB = PVector.sub(_nodes[i+1][j][k].getPosition(), _nodes[i][j][k].getPosition());
       PVector AC = PVector.sub(_nodes[i][j][k-1].getPosition(), _nodes[i][j][k].getPosition());
       n++;
       nabde = AB.cross(AC).normalize();
     }
     if(i-1 >= 0 && k-1 >= 0){
       PVector AB = PVector.sub(_nodes[i-1][j][k].getPosition(), _nodes[i][j][k].getPosition());
       PVector AC = PVector.sub(_nodes[i][j][k-1].getPosition(), _nodes[i][j][k].getPosition());
       n++;
       nabiz = AC.cross(AB).normalize();
     }
     
     PVector mediaNormales = PVector.add(nariz, narde).add(nabde).add(nabiz);
     return mediaNormales.div(n).normalize();
   }

   void render()
   {
      if (DRAW_MODE)
         renderWithSegments();
      else
         renderWithQuads();
   }

   void renderWithSegments()
   {
      stroke(0);
      strokeWeight(0.5);

      for (DampedSpring s : _springs)
      {
         PVector pos1 = s.getParticle1().getPosition();
         PVector pos2 = s.getParticle2().getPosition();

         line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      }
   }

   void renderWithQuads()
   {
      int i, j, k;

      fill(_color);
      stroke(_color);
      strokeWeight(1.0);

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (i = 0; i < _numNodesX; i++)
         {
            if ((_nodes[i][j][0] != null) && (_nodes[i][j+1][0] != null))
            {
               PVector pos1 = _nodes[i][j][0].getPosition();
               PVector pos2 = _nodes[i][j+1][0].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (i = 0; i < _numNodesX; i++)
         {
            if ((_nodes[i][j][_numNodesZ-1] != null) && (_nodes[i][j+1][_numNodesZ-1] != null))
            {
               PVector pos1 = _nodes[i][j][_numNodesZ-1].getPosition();
               PVector pos2 = _nodes[i][j+1][_numNodesZ-1].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[0][j][k] != null) && (_nodes[0][j+1][_numNodesZ-1] != null))
            {
               PVector pos1 = _nodes[0][j][k].getPosition();
               PVector pos2 = _nodes[0][j+1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (j = 0; j < _numNodesY - 1; j++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[_numNodesX-1][j][k] != null) && (_nodes[_numNodesX-1][j+1][_numNodesZ-1] != null))
            {
               PVector pos1 = _nodes[_numNodesX-1][j][k].getPosition();
               PVector pos2 = _nodes[_numNodesX-1][j+1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (i = 0; i < _numNodesX - 1; i++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[i][0][k] != null) && (_nodes[i+1][0][k] != null))
            {
               PVector pos1 = _nodes[i][0][k].getPosition();
               PVector pos2 = _nodes[i+1][0][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }

      for (i = 0; i < _numNodesX - 1; i++)
      {
         beginShape(QUAD_STRIP);
         for (k = 0; k < _numNodesZ; k++)
         {
            if ((_nodes[i][_numNodesY-1][k] != null) && (_nodes[i+1][_numNodesY-1][k] != null))
            {
               PVector pos1 = _nodes[i][_numNodesY-1][k].getPosition();
               PVector pos2 = _nodes[i+1][_numNodesY-1][k].getPosition();

               vertex(pos1.x, pos1.y, pos1.z);
               vertex(pos2.x, pos2.y, pos2.z);
            }
         }
         endShape();
      }
   }
}
