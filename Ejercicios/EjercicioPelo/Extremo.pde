class Extremo
{
  PVector loc;
  PVector vel;
  PVector acc;
  float mass = 5, dt = 0.1;
  PVector gravity;
  float Ec, Ep;
  PVector peso;
  int mode;
  
  PVector drag0;
  boolean dragging = false;
  
  Extremo(float x, float y)
  {
    loc = new PVector(x,y);
    vel = new PVector();
    acc = new PVector();
    drag0 = new PVector();
    gravity = new PVector(0, 9.8);
    peso = new PVector();
  }
  
  void update()
  {
    vel.x += acc.x * dt;
    vel.y += acc.y * dt;
    
    loc.x += vel.x * dt;
    loc.y += vel.y * dt;
    
    acc.x = 0;
    acc.y = 0;
    
    peso.y = gravity.y * mass;
    applyForce(peso);
  }
  
  void applyForce(PVector force)
  {
    PVector f = force.get();
    f.div(mass);
    acc.add(f);
  }
  
  void display()
  {
    stroke(0);
    strokeWeight(2);
    fill(175, 120);
    
    if (dragging)
    {
      fill(50);
    }
  }
  
  void clicked(int x, int y)
  {
    float d = dist(x,y,loc.x, loc.y);
    float umbral = 5;
    
    if(d < umbral)
    {
      dragging =true;
      drag0.x = loc.x - x;
      drag0.y = loc.y - y;
    }
  }
  
  void stopDragging()
  {
    dragging = false;
    
  }
  
  void drag(int mx, int my)
  {
    if(dragging)
    {
      loc.x = mx + drag0.x;
      loc.y = my + drag0.y;
    }
  }
  
}
  
