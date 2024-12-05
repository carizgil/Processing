PVector pos, vel, pos_aux, prev_pos_aux;
float dt = 0.7;

boolean funcion1 = true;

void setup() {
  size(1000, 600);
  pos = new PVector(0, 0);
  vel = new PVector(1, 0);
  pos_aux = new PVector();
  prev_pos_aux = new PVector();
  background(200);
}

void draw() {

  dibujoGrafica();

  if (pos.x >= 1440) {
    pos.x = 0;
    prev_pos_aux = new PVector();
  }

  translate(0, height/2);

  pos.x += dt;

  if (funcion1 == true)
    pos.y = sin(radians(pos.x)) * exp(-0.002*pos.x);
  else
    pos.y = 0.5 * sin(radians(3 * pos.x)) + 0.5 * sin(radians(3.5 * pos.x));

  pos.add(PVector.mult(vel, dt));

  pos_aux.x = map(pos.x, 0, 1440, 100, 800);
  pos_aux.y = map(pos.y, 1, -1, 0, 400);

  stroke(255, 0, 0);
  fill(255, 0, 0);
  ellipse(pos_aux.x, pos_aux.y - height/25*10, 10, 10);

  if (prev_pos_aux.x != 0 && prev_pos_aux.y != 0) {
    stroke(255, 0, 0);
    line(prev_pos_aux.x, prev_pos_aux.y - height/25*10, pos_aux.x, pos_aux.y - height/25*10);
  }

  prev_pos_aux.set(pos_aux);
}

void dibujoGrafica() {
  stroke(0);
  for (int i = 0; i < 21; i++) {
    line(width/10, 25+height/25*i, width-100, 25+height/25*i);
  }
  for (int j = 0; j <= 32; j++) {
    line(100+800/32*j, 25, 100+800/32*j, 505);
  }

  fill(0);
  text(-1, 75, 25+height/25*20);
  text("-0.5", 75, 25+height/25*15);
  text(0, 80, 25+height/25*10);
  text("0.5", 75, 25+height/25*5);
  text(1, 75, 25+height/25*0);
  text("y", 100, 20);
  text("x", 920, 25+height/25*10);

  textSize(15);
  text("Presiona la tecla 'c' para cambiar de función", 100+800/32*12, 25+height/25*21);
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    pos.x = 0;
    prev_pos_aux = new PVector();
    funcion1 = !funcion1;
    background(200);
  }
}
