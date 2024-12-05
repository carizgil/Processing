class Pelo
{
  float longitud;
  int nmuelles;
  float Lmuelle;
  PVector origen;
  
  Extremo[] vExtr = new Extremo[MUELLES+1];
  Muelle[] vMuelles = new Muelle[MUELLES];
  
  Pelo (float _longitud, int _nmuelles, PVector _origen)
  {
    longitud = _longitud;
    nmuelles = _nmuelles;
    Lmuelle = longitud/nmuelles;
    origen = _origen;
    
    for(int i = 0; i < vExtr.length; i++)
      vExtr[i] = new Extremo (origen.x + i *Lmuelle, origen.y);
    
    for (int i = 0; i<vMuelles.length; i++)
      vMuelles[i] = new Muelle(vExtr[i], vExtr[i+1], Lmuelle);
  }
  
  void update()
  {
    for (Muelle s: vMuelles)
    {
      s.update();
      s.display();
    }
    
    for (int i = 1; i < vExtr.length; i++)
    {
      vExtr[i].update();
      vExtr[i].display();
      vExtr[i].drag(mouseX, mouseY);
    }
  }
  
  void on_click()
  {
    for(Extremo b: vExtr)
      b.clicked(mouseX, mouseY);
  }
  
  void release()
  {
    for (Extremo b: vExtr)
      b.stopDragging();
  }
  
}