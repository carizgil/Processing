import peasy.*;

final int _MAP_SIZE = 150;
final float _MAP_CELL_SIZE = 10f;
final float BALL_KE = 1;
final float G = 9.81f;
final float KdAir = 0.1f;

boolean _viewmode = false;
boolean _clear = false;

PeasyCam camera;

HeightMap map;
Malla malla;
Ball ball;
PImage img;

public void settings() {
    System.setProperty("jogl.disable.openglcore", "true");
    size(900,600, P3D);
  }
void setup()
{
  img = loadImage("water_surface.jpg");
  camera = new PeasyCam(this,100);
  camera.setMinimumDistance(50);
  camera.setMaximumDistance(2500);
  camera.setDistance(400);
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
  malla = new Malla(_MAP_SIZE, _MAP_CELL_SIZE);
  malla.initMalla(map.getPositions());
  ball = new Ball(new PVector(0,-300,0),new PVector(0,0,0),10,50,0xff0000ff);
  println(img.width + " : " + img.height);
}

void draw()
{
  background(255);
  lights();
  map.update();
  malla.updatePositions(map.getPositions());
  malla.checkCollision(ball);
  //malla.draw();
  ball.update(0.1);
  ball.render();
  if(_viewmode) map.presentWired();
  else map.present();
  presentAxis();
  drawInteractiveInfo();
  if(_clear)
  {
    map.waves.clear();
    map.waveArray = new Wave[0];
    _clear = false;
  }
}

void drawInteractiveInfo()
{
  float textSize = 100;
  float offsetX = -500;
  float offsetZ = -1000;
  float offsetY = -1000;
  
  int i = 0;
  noStroke();
  textSize(textSize);
  fill(0xff000000);
  text("q : sinusoidal wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("w : radial wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("e : gerstner wave", offsetX, offsetY + textSize*(++i),offsetZ);
  text("r : change viewmode", offsetX, offsetY + textSize*(++i),offsetZ);
  text("t : reset", offsetX, offsetY + textSize*(++i),offsetZ);
}

void keyPressed()
{
  float amplitude = random(2f)+8f;
  float dx = random(2f)-1;
  float dz = random(2f)-1;
  float wavelength = amplitude * (30 + random(2f));
  float speed = wavelength / (1+random(3f));
  
  if(key == 'q')
  {
    map.addWave(new WaveDirectional(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'w')
  {
    map.addWave(new WaveRadial(amplitude,new PVector(dx*(_MAP_SIZE*_MAP_CELL_SIZE/2f),0,dz*(_MAP_SIZE*_MAP_CELL_SIZE/2f)),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'e')
  {
    map.addWave(new WaveGerstner(amplitude,new PVector(dx,0,dz),wavelength,speed));//amplitude,direction,wavelength,speed
  }
  if(key == 'r')
  {
    _viewmode = !_viewmode;
  }
  if(key == 't')
  {
    _clear = true;
  }
  
  if(key == '1')
  {
    map.waves.get(0).W -=.001;  
  }
  
  if(key == '2')
  {
    map.waves.get(0).W +=.001;  
  }
  
  if(key == '3')
  {
    map.waves.get(0).phi -=.1;  
  }
  
  if(key == '4')
  {
    map.waves.get(0).phi +=.1;  
  }
  
  if(key == '5')
  {
    map.waves.get(0).A -=1;  
  }
  
  if(key == '6')
  {
    map.waves.get(0).A +=1;  
  }
  if(key == 'z'){
    ball.setPosition(new PVector(0,-300,0));
  }
 
}

void presentAxis()
{
  float axisSize = _MAP_SIZE*2f;
  stroke(0xffff0000);
  line(0,0,0,axisSize,0,0);
  stroke(0xff00ff00);
  line(0,0,0,0,-axisSize,0);
  stroke(0xff0000ff);
  line(0,0,0,0,0,axisSize);
}
