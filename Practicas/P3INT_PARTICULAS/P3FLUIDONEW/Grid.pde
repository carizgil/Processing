class ParticleList
{
   ArrayList<Particle> _vector;
   ParticleList()
   {
      _vector = new ArrayList<Particle>();
   }
}

class Grid
{
   float _cellSize;
   int _nRows;
   int _nCols;
   int _numCells;
   

   ParticleList [][] _cells;
   color [][] _colors;

   Grid(float cellSize)
   {
      _cellSize = cellSize;
      _nRows = int(height/_cellSize) + 2;
      _nCols = int(width/_cellSize) + 2;
      _numCells = _nRows*_nCols;

      _cells  = new ParticleList[_nRows][_nCols];
      _colors = new color[_nRows][_nCols];

      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
            _cells[i][j] = new ParticleList();
            _colors[i][j] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
         }
      }
   }

   void addParticle(Particle p)
   {
      int i = int(p.getPos().x/_cellSize);
      int j = int(p.getPos().y/_cellSize);

      if (i >= 0 && i < _nRows && j >= 0 && j < _nCols)
      {
         _cells[i][j]._vector.add(p);
      }
   }

   ArrayList<Particle> getNeighbors(PVector s)
   {
      int i = int(s.x/_cellSize);
      int j = int(s.y/_cellSize);
      ArrayList<Particle> neighbors = new ArrayList<Particle>();
      if (i > 0 && i < _nRows-1 && j > 0 && j < _nCols-1)
      {
         neighbors.addAll(_cells[i][j]._vector);
         neighbors.addAll(_cells[i+1][j]._vector);
         neighbors.addAll(_cells[i-1][j]._vector);
         neighbors.addAll(_cells[i][j+1]._vector);
         neighbors.addAll(_cells[i][j-1]._vector);
      }

      return neighbors;
      
   }

   ArrayList<Particle> getParticles()
   {
      ArrayList<Particle> particles = new ArrayList<Particle>();

      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
            particles.addAll(_cells[i][j]._vector);
         }
      }

      return particles;
   }

   PVector getCellIndex (PVector pos)
   {
      int i = int(pos.x/_cellSize);
      int j = int(pos.y/_cellSize);
      return new PVector(i, j);
   }

   void render()
   {
      strokeWeight(1);
      stroke(30,30,30);

      for (int i = 0; i < _nRows; i++) {
         float y = i * _cellSize;
         line(0, y, width, y);
      }

      for (int j = 0; j < _nCols; j++) {
         float x = j * _cellSize;
         line(x, 0, x, height);
      }

      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
         ParticleList cellParticles = _cells[i][j];
         for (Particle p : cellParticles._vector) {
            p.setColor(_colors[i][j]);
            p.render();
         }
         }
      }
   }

   void clear()
   {
      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
            _cells[i][j]._vector.clear();
         }
      }
   }



}
