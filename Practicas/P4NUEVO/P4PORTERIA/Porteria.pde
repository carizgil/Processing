public class Porteria{

        private float x;
        private float y;
        private float z;
        private int ancho;
        private int alto;
        private float numSegmentsX;
        private float numSegmentsY;
        private SpringLayout springLayout;
        private color OBJ_COLOR;
        ArrayList<DeformableObject> planos;

    Porteria(PVector position, int ancho, int alto, float numSegmentsX, float numSegmentsY, SpringLayout _springLayout, color OBJ_COLOR){
        this.x = position.x;
        this.y = position.y;
        this.z = position.z;
        this.ancho = ancho;
        this.alto = alto;
        this.numSegmentsX = numSegmentsX;
        this.numSegmentsY = numSegmentsY;
        this.springLayout = _springLayout;
        this.OBJ_COLOR = OBJ_COLOR;
        planos = new ArrayList<DeformableObject>();

        ///////////////////////////
        ///////  Paredes  /////////
        ///////////////////////////

        planos.add(new DeformableObject(new PVector(x,y,z), new PVector(1,1,0),true,ancho,alto,numSegmentsX,numSegmentsY,_springLayout,OBJ_COLOR)); // TELA DEL FONDO
        planos.add(new DeformableObject(new PVector(x,y,z), new PVector(1,0,1),true,ancho,alto,numSegmentsX,numSegmentsY,_springLayout,OBJ_COLOR)); // TELA DE ARRIBA
        planos.add(new DeformableObject(new PVector(x,y,z), new PVector(0,1,1),false,alto,alto,numSegmentsX,numSegmentsY,_springLayout,OBJ_COLOR)); // TELA DE ABAJO
        planos.add(new DeformableObject(new PVector(x+(ancho-1) * numSegmentsX,y,z), new PVector(0,1,1),false,alto,alto,numSegmentsX,numSegmentsY,_springLayout,OBJ_COLOR)); // TELA DE ATRAS
        println("Porteria creada");
        ///////////////////////////
        ///////  Esquinas  ////////
        ///////////////////////////

        planos.get(0).clampSide(new PVector(0,0));
        planos.get(0).clampSide(new PVector(ancho-1,alto-1));
        
        planos.get(1).clampSide(new PVector(0,0));
        planos.get(1).clampSide(new PVector(ancho-1,alto-1));
        
        planos.get(2).clampSide(new PVector(0,0));
        planos.get(2).clampSide(new PVector(alto-1,alto-1));
        
        planos.get(3).clampSide(new PVector(0,0));
        planos.get(3).clampSide(new PVector(alto-1,alto-1));

        if(_springLayout == _springLayout.BEND)
        {
            planos.get(0).clampSide(new PVector(1,1));
            planos.get(0).clampSide(new PVector(ancho-2,alto-2));
            planos.get(1).clampSide(new PVector(1,1));
            planos.get(1).clampSide(new PVector(ancho-2,alto-2));
            planos.get(2).clampSide(new PVector(1,1));
            planos.get(2).clampSide(new PVector(alto-2,alto-2));
            planos.get(3).clampSide(new PVector(1,1));
            planos.get(3).clampSide(new PVector(alto-2,alto-2));
        }
    }

    int getNumNodes(){
        int numNodes = 0;
        for(DeformableObject plano : planos){
            numNodes += plano.getNumNodes();
        }
        return numNodes;
    }

    ArrayList<Particle> getNodes(){
        ArrayList<Particle> nodes = new ArrayList<Particle>();
        for(DeformableObject plano : planos){
            nodes.addAll(plano.getNodes());
        }
        return nodes;
    }

    int getNumSprings(){
        int numSprings = 0;
        for(DeformableObject plano : planos){
            numSprings += plano.getNumSprings();
        }
        return numSprings;
    }

    void checkCollisionPlane(Plano plano)
   {
    for(Particle node : getNodes()){
      float distancia = plano.getPosition().y - node.getPosition().y ;
      if (distancia < 0)
      {
         node._s.y = plano.getPosition().y;
      }
   }
   }


    void update(float simStep){
        for(DeformableObject plano : planos){
            plano.update(simStep);
        }
    }

    void render(){
        for(DeformableObject plano : planos){
            plano.render();
        }
    }












}
