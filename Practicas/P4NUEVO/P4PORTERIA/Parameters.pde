// Definitions:

// Spring Layout
enum SpringLayout
{
   STRUCTURAL,
   SHEAR,
   BEND,
   STRUCTURAL_AND_SHEAR,
   STRUCTURAL_AND_BEND,
   SHEAR_AND_BEND,
   STRUCTURAL_AND_SHEAR_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time
final boolean PORTERO = false;


// Display and output parameters:

boolean DRAW_MODE = true;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1920;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1080;                      // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color BACKGROUND_COLOR = color(18, 18, 18);     // Background color (RGB)
final color TEXT_COLOR = color(240 , 227, 255);       // Text color (RGB)
final color OBJ_COLOR = color(187, 134, 252);         // Color of non-moving elements (RGB)
final color BALL_COLOR = color(3, 218, 198);          // Background color (RGB)
final color PLANO_COLOR = color(30, 30, 30);       // Color of the plane (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Initial definitions of the objects properties:


// Ball properties:

final float BALL_RADIUS = 100;
final PVector BALL_POSITION = new PVector(1000, 900-BALL_RADIUS, 2000);
final float BALL_MASS = 1.0;
final float BALL_KE = 60;

// Goal properties:
final PVector GOAL_POSITION = new PVector(0,0,0);
final int GOAL_WIDTH = 40;
final int GOAL_HEIGHT = 20;
final float GOAL_SPACING_WIDTH = 44;
final float GOAL_SPACING_HEIGHT = 44;


// Plane properties:
final PVector PLANE_POSITION = new PVector(900,900,450);
final PVector PLANE_NORMAL = new PVector(0,-1,0);
final PVector PLANE_SIZE = new PVector(2500,0,4000);
final color PLANE_COLOR = color(30, 30, 30);


// Parameters of the problem:

final float TS = 0.001;     // Initial simulation time step (s)
final float G = 9.81;       // Acceleration due to gravity (m/(s·s))

final int N_H = 20;         // Number of nodes of the object in the horizontal direction
final int N_V = 20;         // Number of nodes of the object in the vertical direction

final float D_H = 40.0;     // Separation of the object's nodes in the horizontal direction (m)
final float D_V = 20.0;     // Separation of the object's nodes in the vertical direction (m)

final float Ke = 10;    // Elastic constant (N/m)
final float Kd = 2;      // Damping constant (N·s/m)
final float KdAir = 0.0001; // Damping constant due to air resistance (N·s/m)
final float RUPTURE_FORCE = 8000;
final float M = 0.01;        // Mass of the nodes (kg)
final float Modulo = 2000.0;   // Modulus of the spring (m)

