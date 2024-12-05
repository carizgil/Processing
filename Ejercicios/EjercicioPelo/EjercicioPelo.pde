final int MUELLES = 5;
int NUMPELOS = 50;
Pelo pelo;
Pelo[] Pelos = new Pelo[NUMPELOS];

void setup()
{
  size (500, 600);
  
  for (int np = 0; np < NUMPELOS; np++)
  {
    PVector distribucion = new PVector (width * 0.5 + random(100), height * 0.5 + random(100));
    pelo = new Pelo (100, MUELLES, distribucion);
    Pelos[np] = pelo;
  }
}

void draw()
{
  background(255);
  fill(255,0,0);
  
  for (int np =0; np < NUMPELOS; np++)
  {
    Pelos[np].update();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    for (int np = 0; np < NUMPELOS; np++) {
      PVector distribucion = new PVector (width * 0.5 + random(100), height * 0.5 + random(100));
      pelo = new Pelo (100, MUELLES, distribucion);
      Pelos[np] = pelo;
    }
  }
}

void mousePressed()
{
  for (int np = 0; np < NUMPELOS; np++)
    Pelos[np].on_click();
}

void mouseReleased()
{
  for(int np = 0;np<NUMPELOS;np++)
    Pelos[np].release();
}