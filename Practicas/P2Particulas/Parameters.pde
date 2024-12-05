// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {18,18,18};         // Background color (RGB)
final int [] TEXT_COLOR = {240 , 227, 255};              // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 
color smokeColor = color(255, 255, 255, 30);          // Color of the smoke

// Parameters of the simulation:

final float TS = 0.01;     // Initial simulation time step (s)
final float NT = 100000.0;    // Rate at which the particles are generated (number of particles per second) (1/s)           
final float L = 100.0;       // Particles' lifespan (s) 
final float R = 0.2;      // Radio en metros
final float M = 0.0001;      // Masa en kg
final float G = 9.801;     // Gravedad
//final float G = 0.0;     // Gravedad
final float Kd = 0.0001;   // Fricción con el aire en kg/m
final float CR1 = 0.5;     // Coeficiente de restitución con el suelo
final float CR2 = 0.5;     // Coeficiente de restitución con las paredes

// Parameters of the emisor

final float V = 10.0;       // Velocidad inicial en m/s
final float nozleAngle = PI/8; // Ángulo de la boquilla en grados
final int angleSubdivisions = 10; // Subdivisiones del ángulo de la boquilla
final PVector emisorPosition = new PVector(0, 0); // Posición del emisor
final PVector particeSystemPosition = new PVector(DISPLAY_SIZE_X/2, DISPLAY_SIZE_Y); // Posición del sistema de partículas

// Constants of the problem:

final String TEXTURE_FILE = "/img/smokeParticle.png";
