// Definitions:

enum IntegratorType 
{
   NONE, 
   EXPLICIT_EULER, 
   SIMPLECTIC_EULER, 
   RK2, 
   RK4,
   HEUN 
}


// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {18, 18, 18};      // Background color (RGB)
final int [] TEXT_COLOR = {240 , 227, 255};                  // Text color (RGB)
final int [] STATIC_ELEMENTS_COLOR = {187, 134, 252};     // Color of non-moving elements (RGB)
final int [] MOVING_ELEMENTS_COLOR = {3, 218, 198};     // Color of moving elements (RGB)
final float OBJECTS_SIZE = 20.0;                      // Size of the objects (m)
final String FILE_NAME = "Grafica5_EulerExplicito.csv";                  // File to write the simulation variables 


// Parameters of the problem:

final float TS = 0.003;      // Initial simulation time step (s)
final float M = 50.0;         // Particle mass (kg)
final float G = 9801;       // Acceleration due to gravity (m/(s·s))
final PVector Gvector = new PVector(0.0, G);  // Gravity vector (m/(s·s))
final float D = 200.0;       // Initial distance (m)
final float Ke = 10000.0;          // Elastic constant (N/m)
final float Kd = 20;              // Damping constant (N·s/m) 
final float l0 = 50.0;            // Rest length of the spring (m)
final float FDrawScale = 5;       // Force drawing scale 

// Constants of the problem:

final PVector C = new PVector(500.0, 500.0);              // Center of the spring system (m)
final PVector S0 = PVector.add(C, new PVector(0.0, -D));  // Particle's start position (m)
