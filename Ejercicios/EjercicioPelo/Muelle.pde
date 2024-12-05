class Muelle {

  PVector ancho, fuerzaA, fuerzaB;
  float longitud;
  float constante = 80;
  float amortiguamiento = 10;
  float elongacion;
  Extremo extremoA;
  Extremo extremoB;
  
  Muelle (Extremo extremo1, Extremo extremo2, float longitudInicial) {
    extremoA = extremo1;
    extremoB = extremo2;
    longitud = longitudInicial;
    ancho = new PVector(extremoB.loc.x - extremoA.loc.x, extremoB.loc.y - extremoA.loc.y);
    fuerzaA = new PVector();
    fuerzaB = new PVector();
  }
  
  void update() {
    ancho.x = extremoB.loc.x - extremoA.loc.x;
    ancho.y = extremoB.loc.y - extremoA.loc.y;
    elongacion = ancho.mag() - longitud;
    ancho.normalize();
    
    fuerzaA.x = constante * ancho.x * elongacion - (extremoA.vel.x - extremoB.vel.x) * amortiguamiento;
    fuerzaA.y = constante * ancho.y * elongacion - (extremoA.vel.y - extremoB.vel.y) * amortiguamiento;
    extremoA.applyForce(fuerzaA);
    
    fuerzaB.x = -constante * ancho.x * elongacion - (extremoB.vel.x - extremoA.vel.x) * amortiguamiento;
    fuerzaB.y = -constante * ancho.y * elongacion - (extremoB.vel.y - extremoA.vel.y) * amortiguamiento;
    extremoB.applyForce(fuerzaB);
  }

  void display() {
    strokeWeight(2);
    stroke(0);
    line(extremoA.loc.x, extremoA.loc.y, extremoB.loc.x, extremoB.loc.y);
  }
}
