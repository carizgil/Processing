// Definitions:

enum CollisionDataType
{
   NONE,
   GRID,
   HASH
}

enum CollisionModelType{
   NONE,
   VELOCITY,
   SPRING
}

enum DataStructureType
{
   NONE,
   GRID,
   HASH
}

// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {18, 18, 18};      // Background color (RGB)
final int [] TEXT_COLOR = {240 , 227, 255};                  // Text color (RGB)
final int [] STATIC_ELEMENTS_COLOR = {187, 134, 252};     // Color of non-moving elements (RGB)
final int [] MOVING_ELEMENTS_COLOR = {3, 218, 198};     // Color of moving elements (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables


// Parameters of the problem:

final float TS = 0.03;     // Initial simulation time step (s)
final float M = 1;       // Particles' mass (kg)
final float R = 5;       // Particles' radius (m)
final float Kd = 0.2;
final float Kr = 0.2;
final float Ke = 40;
final float G = 9.81;      // Gravity acceleration (m/s^2)
final float H = 450;      // Height of the pool (m)


// Constants of the problem:

final color PARTICLES_COLOR = color(120, 160, 220);
final int SC_GRID = 10;             // Cell size (grid) (m)
final int SC_HASH = 10;             // Cell size (hash) (m)
final int NC_HASH = 10000;           // Number of cells (hash)
final int NB_POOL = 1000;              // Number of particles in the pool
final int NB_MOUSE = 100;            // Number of particles on click
final int NB_MOUSE_RADIUS = 50;      // Radius of the particles on click

