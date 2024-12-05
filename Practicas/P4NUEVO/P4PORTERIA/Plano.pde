public class Plano {

    PVector origen;
    PVector normal;
    PVector dimension;
    color c;

    Plano(PVector origen, PVector normal, PVector dimension, color c) {
        this.origen = origen;
        this.normal = normal;
        this.dimension = dimension;
        this.c = c;
    }

    PVector getNormal() {
        
        return normal;
    }

    PVector getPosition() {
        return origen;
    }

    void render() {
        pushMatrix();
        translate(origen.x, origen.y, origen.z);
        fill(c);
        box(dimension.x, dimension.y, dimension.z);
        popMatrix();
    }


}