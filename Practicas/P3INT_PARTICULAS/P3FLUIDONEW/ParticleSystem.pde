// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   Grid _grid;
   HashTable _hashTable;
   CollisionDataType _collisionDataType;
   CollisionModelType _collisionModelType;
   DataStructureType _dataStructureType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _grid = new Grid(SC_GRID);
      _hashTable = new HashTable(SC_HASH, NC_HASH);
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

   void setDataStructureType(DataStructureType dataStructureType)
   {
      _dataStructureType = dataStructureType;
   }

   DataStructureType getDataStructureType()
   {
      return _dataStructureType;
   }

   CollisionModelType getCollisionModelType()
   {
      return _collisionModelType;
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void updateCollisionData()
   {
   
      if (_dataStructureType == DataStructureType.GRID)
      {
         updateGrid();
      }
      else if (_dataStructureType == DataStructureType.HASH)
      {
         updateHashTable();
      }
      else if (_dataStructureType == DataStructureType.NONE)
      {
         updateNone();
      }
       
   }

   void updateGrid()
   {
      _grid.clear();
      for(Particle p : _particles)
      {
         _grid.addParticle(p);
      }

      for(Particle p : _particles)
      {
         p.updateNeighborsGrid(_grid);
      }

      
   }

   void updateHashTable()
   {
      
      _hashTable.clear();
      
      for(Particle p : _particles)
      {
         _hashTable.addParticle(p);
      }
      
      
      
      for(Particle p : _particles)
      {
         p.updateNeighborsHash(_hashTable);
      }
      
      
   }

   void updateNone()
   {
      for (Particle p : _particles)
      {
         p.planeCollision(_planes);
      }
      for (Particle p : _particles)
      {
         p.particleCollision(_particles);
      }
      
   }

   void checkOutOfBounds()
   {
      for (int i = _particles.size() - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         if (p.getPos().x < 0 || p.getPos().x > width || p.getPos().y < 0 || p.getPos().y > height)
         {
            _particles.remove(i);
         }
      }
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
      
   }

   void update(float timeStep)
   {
      int n = _particles.size();
      for (int i = n - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         p.update(timeStep);
      }
      checkOutOfBounds();
   }

   void renderActiveCells(){
      ArrayList<PVector> cellIndexes = new ArrayList<PVector>();

      
         for (Particle p : _particles)
         {
            PVector cellIndex = _grid.getCellIndex(p.getPos());

            if(!cellIndexes.contains(cellIndex))
            {
               cellIndexes.add(cellIndex);
            }
         }
            
      for (PVector cellIndex : cellIndexes)
      {
           noFill();
           strokeWeight(1);
            stroke(70,70,70);
           rect(cellIndex.x * SC_HASH, cellIndex.y * SC_HASH, SC_HASH, SC_HASH);
      }

   }
   

   void render()
   {
      if (_dataStructureType == DataStructureType.GRID)
      {
         _grid.render();
      }
      else
      {
          if(_dataStructureType == DataStructureType.HASH)
          {
            renderActiveCells(); //DESCOMENTAR PARA VISUALIZAR CELDAS ACTIVAS EN HASH   
          }
            
         for (int i = _particles.size() - 1; i >= 0 ; i--)
         {
            Particle p = _particles.get(i);
            p.render();
         }
      }
   }
}
