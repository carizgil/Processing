public class Portero {
    PVector _S = new PVector(0, 0,0);
    ArrayList<Ball> Bolas = new ArrayList<Ball>(); 
    Portero(PVector _S) {
        this._S = _S;
        Bolas.add(new Ball(new PVector(_S.x, _S.y,_S.z),new PVector(0,0,0), 10.0,  100.0, color(255,0,0)));
        Bolas.add(new Ball(new PVector(_S.x, _S.y-150,_S.z),new PVector(0,0,0),  10.0,  100.0, color(255,0,0)));
        Bolas.add(new Ball(new PVector(_S.x, _S.y-300,_S.z),new PVector(0,0,0),  10.0,  100.0, color(255,0,0)));

        for (Ball b : Bolas) {
            b.setKe(300);
        }
    }

    void render(){
        if(PORTERO==true){
            
        for (Ball b : Bolas) {
            b.render();
        }
        
        // Render a cylinder
        pushMatrix();
        translate(_S.x, _S.y-150, _S.z);
        
        float angleStep = TWO_PI / 30;

        beginShape(QUAD_STRIP);
        for (int i = 0; i <= 30; i++) {
            float angle = i * angleStep;
            float x = 101 * cos(angle);
            float z = 101 * sin(angle);
            vertex(x, -300/2, z);
            vertex(x, 300/2, z);
        }
        endShape();
        popMatrix();
        }
    }

    void update(float _timeStep){
        if(PORTERO==true){
              
        for (Ball b : Bolas) {
            b._s.x = 1000 + 400* sin(_timeStep); // Move the balls along the x-axis
            _S.x = b._s.x;
        }
        }
    }

    void checkCollisionBall(Ball pelota){
        if(PORTERO==true){
            for (Ball b : Bolas) {
                b.checkCollisionBall(pelota);
            }
        }
    }

}

