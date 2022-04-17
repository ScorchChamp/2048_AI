
Network AI;
int chromosome_length;
int pool_size = 2000;
Family family;
int seed = 0;
int high_score = 0;

public void setup() {
  frameRate(60);
  size(1000, 500);
  family = new Family(pool_size);
}

void draw() {
  for (int fast_forward = 0; fast_forward < 1; fast_forward++) {
    int drawing = -1;
    int amount_dead = 0;
    for (int i = 0 ; i < family.people.length; i++) {
      Client c = family.people[i];
      c.playGame();
      if (c.getFitness() > high_score) high_score = c.getFitness();
      if (c.dead) {
        drawing = 0;
        amount_dead++;
      }
      if (drawing == -1 && !c.dead) drawing = i;
      if (drawing == i) {
        c.draw();
      }
    }
    if (amount_dead == family.people.length) {
      family.haveChildren();
    }
  }
}





/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
