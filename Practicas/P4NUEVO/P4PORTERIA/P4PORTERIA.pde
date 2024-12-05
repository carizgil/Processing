// Problem description: //<>//
// Deformable object simulation
import peasy.*;

// Display control:

PeasyCam _camera;   // Mouse-driven 3D camera

// Simulation and time control:

float _timeStep;              // Simulation time-step (s)
int _lastTimeDraw = 0;        // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;         // Simulated time (s)
float _elapsedTime = 0.0;     // Elapsed (real) time (s)

// Output control:

boolean _writeToFile = false;
PrintWriter _output;

// System variables:

Ball _ball;                           // Sphere
Porteria _defObj; // Deformable objects
Plano _plano; // Plano
Portero _portero;
SpringLayout _springLayout;           // Current spring layout
PVector _ballVel = new PVector(0,0,0);     // Ball velocity

// Main code:

void settings()
{
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}



void setup()
{
    frameRate(DRAW_FREQ);
    _lastTimeDraw = millis();
    
    float aspect = float(DISPLAY_SIZE_X) / float(DISPLAY_SIZE_Y);
    perspective((FOV * PI) / 180, aspect, NEAR, FAR);
    _camera = new PeasyCam(this, 0);
    _camera.setDistance(3000);
    _camera.pan(100 * 10,100 * 5);
    
    initSimulation(SpringLayout.STRUCTURAL_AND_BEND);
}

void stop()
{
    endSimulation();
}

void keyPressed()
{
    if (key == '1')
        restartSimulation(SpringLayout.STRUCTURAL);
    
    if (key == '2')
        restartSimulation(SpringLayout.SHEAR);
    
    if (key == '3')
        restartSimulation(SpringLayout.BEND);
    
    if (key == '4')
        restartSimulation(SpringLayout.STRUCTURAL_AND_SHEAR);
    
    if (key == '5')
        restartSimulation(SpringLayout.STRUCTURAL_AND_BEND);
    
    if (key == '6')
        restartSimulation(SpringLayout.SHEAR_AND_BEND);
    
    if (key == '7')
        restartSimulation(SpringLayout.STRUCTURAL_AND_SHEAR_AND_BEND);
    
    if (key == 'r')
        resetBall();
    
    if (key == 'b')
        restartBall();
    
    if (keyCode == UP)
        _ball.updateVelocity(1.2);
    
    if (keyCode == DOWN)
        _ball.updateVelocity(1/1.2);
    
    if (key == 'D' || key == 'd')
        DRAW_MODE = !DRAW_MODE;
    
    if (key == 'I' || key == 'i')
        initSimulation(_springLayout);
    if (keyCode == ' ')
    {
        PVector salida = new PVector(mouseX-width/2, mouseY - height/2 , - 1000 );
        salida.normalize();
        salida.mult(Modulo);
        _ballVel = salida;
        println("Velocidad de la pelota: " + _ballVel);
        _ball.setVelocity(_ballVel);
    }
}

void initSimulation(SpringLayout springLayout)
{
    if (_writeToFile)
        {
        _output = createWriter(FILE_NAME);
        writeToFile("t, n, Tsim");
}
    
    _simTime = 0.0;
    _timeStep = TS * TIME_ACCEL;
    _elapsedTime = 0.0;
    _springLayout = springLayout;
    
    _defObj = new Porteria(GOAL_POSITION,GOAL_WIDTH,GOAL_HEIGHT,GOAL_SPACING_WIDTH,GOAL_SPACING_HEIGHT,_springLayout,OBJ_COLOR);
    _ball = new Ball(BALL_POSITION, _ballVel, BALL_MASS,BALL_RADIUS ,BALL_COLOR);
    _plano = new Plano(PLANE_POSITION, PLANE_NORMAL, PLANE_SIZE, PLANE_COLOR);
    _portero = new Portero(new PVector(BALL_POSITION.x,BALL_POSITION.y,BALL_POSITION.z-800));
}

void restartBall()
{
    _ball.setPosition(BALL_POSITION);
    _ballVel.set(0, 0, 0);
    _ball.setVelocity(_ballVel);
}

void resetBall()
{
    _ball.setPosition(BALL_POSITION);
    _ballVel.set(0, 0, 0);
    //...
    //...
}

void restartSimulation(SpringLayout springLayout)
{
    _simTime = 0.0;
    _timeStep = TS * TIME_ACCEL;
    _elapsedTime = 0.0;
    _springLayout = springLayout;
    
    initSimulation(_springLayout);
    //...
    //...
}

void endSimulation()
{
    if (_writeToFile)
        {
        _output.flush();
        _output.close();
}
}

void draw()
{

    int now = millis();
    _deltaTimeDraw = (now - _lastTimeDraw) / 1000.0;
    _elapsedTime += _deltaTimeDraw;
    _lastTimeDraw = now;
    
    //println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");
    
    background(BACKGROUND_COLOR);
    drawStaticEnvironment();
    drawDynamicEnvironment();
    
    if (REAL_TIME)
        {
        float expectedSimulatedTime = TIME_ACCEL * _deltaTimeDraw;
        float expectedIterations = expectedSimulatedTime / _timeStep;
        int iterations = 0;
        
        for (; iterations < floor(expectedIterations); iterations++)
            updateSimulation();
        
        if((expectedIterations - iterations) > random(0.0, 1.0))
        {
            updateSimulation();
            iterations++;
    }
        
        //println("Expected Simulated Time: " + expectedSimulatedTime);
        //println("Expected Iterations: " + expectedIterations);
        //println("Iterations: " + iterations);
} 
    else
        updateSimulation();
    
    displayInfo();
    
    //if (_writeToFile)
     //   writeToFile(_simTime + "," + _defObj.getNumNodes() + ", 0");
}

void drawStaticEnvironment()
{
    noStroke();
    fill(255, 0, 0);
    box(1000.0, 1.0, 1.0);
    
    fill(0, 255, 0);
    box(1.0, 1000.0, 1.0);
    
    fill(0, 0, 255);
    box(1.0, 1.0, 1000.0);
    
    fill(255, 255, 255);
    sphere(1.0);

    _plano.render();
    
    //...
    //...
    //...
}

void drawDynamicEnvironment()
{
     _defObj.render();
    _ball.render();
    _portero.render();
    //...
}

void updateSimulation()
{
    _defObj.update(_timeStep);
    _defObj.checkCollisionPlane(_plano);
    _ball.checkCollision(_defObj);
    _ball.checkCollisionPlane(_plano);
    _ball.update(_timeStep);
    _portero.update(_simTime);
    _portero.checkCollisionBall(_ball);
    
    _simTime += _timeStep;
}

void writeToFile(String data)
{
    _output.println(data);
}

void displayInfo()
{
    pushMatrix();
    {
        camera();
        fill(TEXT_COLOR);
        textSize(20);
        
        text("Frame rate = " + 1.0 / _deltaTimeDraw + " fps", width * 0.025, height * 0.05);
        text("Elapsed time = " + _elapsedTime + " s", width * 0.025, height * 0.075);
        text("Simulated time = " + _simTime + " s ", width * 0.025, height * 0.1);
        text("Spring layout = " + _springLayout, width * 0.025, height * 0.125);
        text("Ball start velocity = " + _ballVel + " m/s", width * 0.025, height * 0.15);
}
    popMatrix();
}
