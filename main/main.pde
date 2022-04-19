
Network AI;
int chromosome_length;
int pool_size = 1000;
Family family;
int seed = 0;
int high_score = 0;
int drawing = 0;

public void setup() {
  frameRate(144);
  size(1000, 500);
  family = new Family(pool_size);
}

void draw() {
  int amount_dead = 0;
  for (int i = 0 ; i < family.people.length; i++) {
    Client c = family.people[i];
    c.playGame();
    if (c.getFitness() > high_score) {
      high_score = c.getFitness();
      drawing = i;
      //frameRate(60000/high_score);
    }
    if (c.dead) {
      amount_dead++;
    }
    if (drawing == i) {
      c.draw();
    }
  }
  text(drawing, 30, 30);
  if (amount_dead == family.people.length) {
    family.haveChildren();
    high_score = 0;
  }
}





/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
