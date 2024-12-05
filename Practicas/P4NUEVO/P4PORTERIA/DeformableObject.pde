public class DeformableObject
{
   int _numNodesH;   // Number of nodes in horizontal direction
   int _numNodesV;   // Number of nodes in vertical direction

   float _sepH;      // Separation of the object's nodes in the X direction (m)
   float _sepV;      // Separation of the object's nodes in the Y direction (m)

   SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
   color _color;                 // Color (RGB)

   Particle[][] _nodes;                             // Particles defining the object
   ArrayList<DampedSpring> _springs;                // Springs joining the particles

   //...
   //...
   //...

   DeformableObject(PVector initPos, PVector initDir,boolean xy, int numNodesH, int numNodesV, float sepH, float sepV, SpringLayout springLayout, color c)
   {
      _numNodesH = numNodesH;
      _numNodesV = numNodesV;
      _sepH = sepH;
      _sepV = sepV;
      _springLayout = springLayout;
      _color = c;

      _nodes = new Particle[_numNodesH][_numNodesV];
      _springs = new ArrayList<DampedSpring>();

      PVector dir = initDir;
      

      //////////////////////////
      // Create the particles //
      //////////////////////////
      if (xy)
      {
         for (int j = 0; j < _numNodesV; j++)
      {
         for (int i = 0; i < _numNodesH; i++)
         {
            
            PVector pos = new PVector(initPos.x + i*_sepH * dir.x, initPos.y + j * _sepV * dir.y, initPos.z + j *_sepH* dir.z);
            PVector vel = new PVector(0, 0, 0);
            _nodes[i][j] = new Particle(pos,vel,M,false, false);
         }
      }
      }
      else
      {
         for (int j = 0; j < _numNodesV; j++)
      {
         for (int i = 0; i < _numNodesH; i++)
         {
            
            PVector pos = new PVector(initPos.x + i*_sepH * dir.x, initPos.y + i * _sepV * dir.y, initPos.z + j *_sepH* dir.z);
            PVector vel = new PVector(0, 0, 0);
            _nodes[i][j] = new Particle(pos,vel,M,false, false);
         }
      }
      }
      
      ////////////////////////
      // Create the springs //
      ////////////////////////

      initSprings();

   }


   int getNumNodes()
   {
      return _numNodesH*_numNodesV;
   }

   ArrayList<Particle> getNodes()
   {
      ArrayList<Particle> nodes = new ArrayList<Particle>();

      for (int j = 0; j < _numNodesV; j++)
      {
         for (int i = 0; i < _numNodesH; i++)
         {
            nodes.add(_nodes[i][j]);
         }
      }

      return nodes;
   }

   int getNumSprings()
   {
      return _springs.size();
   }

   void clampSide(PVector coords){
      for (int i = 0; i < _numNodesH; i++) {
         for (int j = 0; j < _numNodesV; j++) {
         if (i == coords.x || j == coords.y) {
            _nodes[i][j].setClamped(true);
         }
         }
      }
   }

   void initSprings(){
      
      switch (_springLayout) {
         case STRUCTURAL:
          addStructuralSprings();
          break;
         case SHEAR:
            addShearSprings();
            break;
         case BEND:
            addBendSprings();
            break;
         case STRUCTURAL_AND_SHEAR:
            addStructuralSprings();
            addShearSprings();
            break;
         case STRUCTURAL_AND_BEND:
            addStructuralSprings();
            addBendSprings();
            break;
         case SHEAR_AND_BEND:
            addShearSprings();
            addBendSprings();
            break;
         case STRUCTURAL_AND_SHEAR_AND_BEND:
            addStructuralSprings();
            addShearSprings();
            addBendSprings();
            break;   
   }
   }

   //////////////////////////
   //// SPRING FUNCTIONS ////
   //////////////////////////

   void addStructuralSprings()
   {
      for (int i = 0; i < _numNodesH; i++)
      {
         for (int j = 0; j < _numNodesV; j++)
         {
            if (i < _numNodesH - 1)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j], Ke, Kd));
            if (j < _numNodesV - 1)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+1], Ke, Kd));
         }
      }
   }

   void addShearSprings()
   {
      for (int i = 0; i < _numNodesH; i++)
      {
         for (int j = 0; j < _numNodesV; j++)
         {
            if ((i < _numNodesH - 1) && (j < _numNodesV - 1))
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j+1], Ke, Kd));
            if ((i < _numNodesH - 1) && (j > 0))
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+1][j-1], Ke, Kd));
         }
      }
   }

   void addBendSprings()
   {
      for (int i = 0; i < _numNodesH; i++)
      {
         for (int j = 0; j < _numNodesV; j++)
         {
            if (i < _numNodesH - 2)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i+2][j], Ke, Kd));
            if (j < _numNodesV - 2)
               _springs.add(new DampedSpring(_nodes[i][j], _nodes[i][j+2], Ke, Kd));
         }
      }
   }

   void update(float simStep)
   {
      
      for (DampedSpring s : _springs) 
      {
         s.update(simStep);
      }

      for (int j = 0; j < _numNodesV; j++)
      {
         for (int i = 0; i < _numNodesH; i++)
         {
            _nodes[i][j].update(simStep);
         }
      }
   }


   void render()
   {
      if (DRAW_MODE)
         renderWithSegments();
      else
         renderWithQuads();
   }

   void renderWithQuads()
   {
     int i, j;

     fill(255,255,255,190);
     stroke(255,255,255);
     strokeWeight(2);

     for (j = 0; j < _numNodesV - 1; j++)
     {
       beginShape(QUAD_STRIP);
       for (i = 0; i < _numNodesH; i++)
       {
         if ((_nodes[i][j] != null) && (_nodes[i][j+1] != null))
         {
           PVector pos1 = _nodes[i][j].getPosition();
           PVector pos2 = _nodes[i][j+1].getPosition();

           vertex(pos1.x, pos1.y, pos1.z);
           vertex(pos2.x, pos2.y, pos2.z);
         }
       }
       endShape();
     }
  }

  void renderWithSegments()
  {
    stroke(_color);
    strokeWeight(2);

    for (DampedSpring s : _springs) 
    {
      if (s.isEnabled())
      {
        PVector pos1 = s.getParticle1().getPosition();
        PVector pos2 = s.getParticle2().getPosition();

        line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
      }
    }
  }
}
