class HashTable
{
   ArrayList<ArrayList<Particle>> _table;

   int _numCells;
   float _cellSize;
   color[] _colors;

   HashTable(float cellSize, int numCells)
   {
      _table = new ArrayList<ArrayList<Particle>>();
      _cellSize = cellSize;
      _numCells = numCells;

      _colors = new color[_numCells];

      for (int i = 0; i < _numCells; i++)
      {
         ArrayList<Particle> cell = new ArrayList<Particle>();
         _table.add(cell);
         _colors[i] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
      }
   }

   int getIndex(Particle p)
   {
      long xd = int(floor(p.getPos().x / _cellSize));
      long yd = int(floor(p.getPos().y / _cellSize));
      long zd = int(floor(p.getPos().z / _cellSize));

      long suma = 73856093*xd + 19349663*yd + 83492791*zd;
      int index = int(suma % _numCells);

      if(index < 0)
      {
         return 0;
      }
      else
      {
         return index;
      }
   }

   void addParticle(Particle p)
   {
      int index = getIndex(p);
      p.setColor(_colors[index]);
      _table.get(index).add(p);
   }

   ArrayList<Particle> getNeighbors(PVector s)
   {
      ArrayList<Particle> neighbors = new ArrayList<Particle>();
      //ArrayList<Integer> indexes = new ArrayList<Integer>();
      //ArrayList<Integer> uniqIndexes = new ArrayList<Integer>();

      GhostParticle N = new GhostParticle(new PVector(s.x,s.y-_cellSize));
      GhostParticle S = new GhostParticle(new PVector(s.x,s.y+_cellSize));
      GhostParticle E = new GhostParticle(new PVector(s.x+_cellSize,s.y));
      GhostParticle W = new GhostParticle(new PVector(s.x-_cellSize,s.y));
      GhostParticle SELF = new GhostParticle(new PVector(s.x,s.y));

      neighbors.addAll(_table.get(getIndex(SELF)));
      neighbors.addAll(_table.get(getIndex(N)));
      neighbors.addAll(_table.get(getIndex(S)));
      neighbors.addAll(_table.get(getIndex(E)));
      neighbors.addAll(_table.get(getIndex(W)));

      /*
      indexes.add(getIndex(N));
      indexes.add(getIndex(S));
      indexes.add(getIndex(E));
      indexes.add(getIndex(W));
      indexes.add(getIndex(SELF));

      for (int index : indexes)
      {
         if (!uniqIndexes.contains(index))
         {
         uniqIndexes.add(index);
         neighbors.addAll(_table.get(index));
         }
      }
      */
      return neighbors;    
   }

   void clear()
   {
      for (int i = 0; i < _numCells; i++)
      {
         _table.get(i).clear();
      }
   }


   
}
