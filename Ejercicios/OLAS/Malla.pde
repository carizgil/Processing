public class Malla {

    ArrayList<Particle> particles;
    int mapSize;
    float cellSize;

    Malla(int mapSize, float cellSize){
        this.mapSize = mapSize;
        this.cellSize = cellSize;
        particles = new ArrayList<Particle>();
        ArrayList<Particle> particles = new ArrayList<Particle>();
    }

    void initMalla(float[][][] pos){
        initParticles(pos);
        println(particles.size());
    }

    void initParticles (float[][][] pos){
        for (int i = 0; i < mapSize; i++){
            for (int j = 0; j < mapSize; j++){
                
            Particle p = new Particle(new PVector(pos[i][j][0], pos[i][j][1], pos[i][j][2]));
            particles.add(p);
            }
        }
    }

    void updatePositions(float [][][] pos){
        int index = 0;
        for (int i = 0; i < mapSize; i++){
            for (int j = 0; j < mapSize; j++){
                particles.get(index).setPosition(new PVector (pos[i][j][0], pos[i][j][1], pos[i][j][2]));
                index++;
            }
        }
    }

    void checkCollision(Ball b){
        println("Checking collision");
        for (Particle p : particles){
            b.checkCollisionBall(p);
        }
        
    }

    void draw(){
        for (Particle p : particles){
            p.draw();
        }
    }
}