


class Client {
  Network AI;
  GameManager GM;
  int seed = 0;
  float[] chromosome = {};
  boolean dead = false;
  int[] layer_structure = new int[3];
  int generation = 0;

  Client(float[] chromosome, int generation) {
    this.generation = generation;
    this.GM = new GameManager(seed);
    this.chromosome = chromosome;
    layer_structure[0] = this.GM.SM.slots.length * this.GM.SM.slots[0].length;
    layer_structure[1] = 20;
    layer_structure[2] = 4;
    this.AI = new Network(GM.SM.slots.length*this.GM.SM.slots[0].length, layer_structure[1], layer_structure[2], this.chromosome);
  }

  Client(int generation) {
    this.generation = generation;
    this.GM = new GameManager(seed);
    layer_structure[0] = this.GM.SM.slots.length * this.GM.SM.slots[0].length;
    layer_structure[1] = 20;
    layer_structure[2] = 4;
    generateChromosome();
    this.AI = new Network(GM.SM.slots.length*this.GM.SM.slots[0].length, layer_structure[1], layer_structure[2], this.chromosome);
  }

  int getFitness() {
    return this.GM.getFitness();
  }

  void draw() {
    rect(0,0,width/2,height);
    this.GM.draw();
    this.AI.draw(generation);
  }

  void playGame() {
    if (dead) return;
    int value = this.AI.getResult(getAIInput());
    if (value == 0) this.GM.runMoveUp();
    if (value == 1) this.GM.runMoveDown();
    if (value == 2) this.GM.runMoveLeft();
    if (value == 3) this.GM.runMoveRight();
    if (this.GM.game_over) this.dead = true;
  }


  float[] getAIInput() {
    float[] input = {};
    for (Slot[] ss : this.GM.SM.slots) {
      for (Slot s : ss) {
        input = (float[]) append(input, s.value);
      }
    }
    return input;
  }

  void mate(Client c2) {
    for (int i = 0; i < chromosome.length; i++) {
      if (i > chromosome.length/2) {
        c2.chromosome[i] = this.chromosome[i];
      } else {
        this.chromosome[i] = c2.chromosome[i];
      }
    }
  }

  void generateChromosome() {
    int chromosome_length = layer_structure[0] + (layer_structure[0]*layer_structure[1]) + (layer_structure[1]*layer_structure[2]);
    for (int i = 0; i < chromosome_length; i++) {
      chromosome = (float[]) append(chromosome, random(-1, 1));
    }
  }
}

/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
