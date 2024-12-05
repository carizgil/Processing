///////////////////////////////////////////////////////////////////////
//
// WAVE
//
///////////////////////////////////////////////////////////////////////

abstract class Wave
{
  
  protected float A,C,W,Q,phi;
  protected PVector tmp;
  protected PVector D;
  
  public Wave(float _a,PVector _srcDir, float _L, float _C)
  {

    A = _a;
    C = _C;
    W = PI * 2f / _L; 
    Q = PI*A*W;
    phi = C*W;

    tmp = new PVector();
    D = new PVector().add(_srcDir).normalize();
  
  }
  
  abstract PVector getVariation(float x, float y, float z, float time);
}

///////////////////////////////////////////////////////////////////////
//
// DIRECTIONAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveDirectional extends Wave
{
  public WaveDirectional(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    tmp.x = 0;
    tmp.z = 0;
    tmp.y = A * sin((D.x*x +D.z*z)*W + time*phi);
    return tmp;
  }
}

///////////////////////////////////////////////////////////////////////
//
// RADIAL WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveRadial extends Wave
{
  public WaveRadial(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    
    float dist = (sqrt((x-D.x)*(x-D.x) + (z-D.z)*(z - D.z)));
    tmp.x = 0;
    tmp.z = 0;
    tmp.y = A * sin(W*dist - time*phi);
    
    return tmp;
}
}



///////////////////////////////////////////////////////////////////////
//
// GERSTNER WAVE
//
///////////////////////////////////////////////////////////////////////

class WaveGerstner extends Wave
{
  public WaveGerstner(float _a,PVector _srcDir, float _L, float _C)
  {
    super(_a, _srcDir, _L, _C);
 
  }
  
  public PVector getVariation(float x, float y, float z, float time)
  {
    tmp.x = Q * A * D.x * cos(W*(D.x*x + D.z*z) + time*phi);
    tmp.z = Q * A * D.z * cos(W*(D.x*x + D.z*z) + time*phi);
    tmp.y = -A * sin(W*(D.x*x + D.z*z) + time*phi);

    return tmp;
    }
}
