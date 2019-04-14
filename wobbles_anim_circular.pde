import processing.pdf.*;

ArrayList<PVector> nodes;
ArrayList<PVector> targets;
float radius;
float num_nodes;

float rnd_factor = 1.01;

void setup() {
  size(1100,1100);
  colorMode(HSB, 360, 100, 100, 100);
  frameRate(20);
  //noLoop();
  num_nodes = 340;
  
  nodes = new ArrayList<PVector>();
  targets = new ArrayList<PVector>();
  radius = width/2.5;
  
  init_nodes();
  
}

void draw() {
  background(120, 3, 100);
  
  translate(width/2, height/2); //radius+25);
   
  make_shape();
  update_shape();
  update_targets();
  check_edges();  //deletes nodes that escape
  
  //saveFrame("output/test.png");
}

void init_nodes() {
  for (int i = 0; i < num_nodes; i++) {
      float angle = random(TWO_PI);
      
      nodes.add(new PVector(cos(angle), sin(angle)));
      set_target(new PVector(cos(angle), sin(angle)));
  }      
}


void set_target(PVector n) {
  float rx = randomGaussian() * (radians(0.5));
  float ry = randomGaussian() * (radians(0.5));
  targets.add(new PVector(n.x + rx, n.y + ry));
    
}

void update_targets() {
    for (PVector t: targets) {
      //float rx = randomGaussian() * (radians(0.5));
      //float ry = randomGaussian() * (radians(0.5));
      float rx = random(radians(-0.5)*rnd_factor, radians(0.5)*rnd_factor);
      float ry = random(radians(-0.5)*rnd_factor, radians(0.5)*rnd_factor);
      t.add(new PVector(rx, ry));
    }
}


void make_shape() {
  beginShape();
  stroke(204, 90, 60, 60);
  noFill();
  for (PVector p: nodes) {
    curveVertex(p.x * radius, p.y * radius);
    //ellipse(p.x*radius, p.y*radius, 10, 10);
    //println(p.x, p.y);
  }
  endShape(CLOSE);
  println(nodes.size());
   
}


void update_shape() {
  for (int i = 0; i < nodes.size(); i++) {
      PVector n = nodes.get(i);
      PVector t = targets.get(i);
      
      n.x = lerp(n.x, t.x, 0.025);
      n.y = lerp(n.y, t.y, 0.025);
  }
}

void check_edges() {
  float w_max = width * 1.5;
  float h_max = height * 1.5;
  float w_min = width - width * 1.5;
  float h_min = height - height * 1.5;
    
  for (int i = nodes.size()-1; i >=0; i--) {
     PVector n = nodes.get(i);
     //println(n.x, n.y, n.x * radius, n.y * radius); 
     if(n.x * radius > w_max || n.x  * radius < w_min || n.y  * radius > h_max || n.y * radius < h_min) {
       nodes.remove(n);
     }
     
  }
}
