


class Family {
  float mutation_chance = 0.01;
  int poolSize = 0;
  int amount_dead = 0;
  int generation = 0;
  Client[] people;
  
  Family(int poolSize) {
    this.poolSize = poolSize;
    this.people = new Client[poolSize];
    for (int i = 0; i < poolSize; i++) {
      this.people[i] = new Client(generation);
    }
  }
  
  Client[] getTopFitness() {
    Client[] top = people;
    for (int i = 0; i < people.length; i++) {
      for (int j = i; j < top.length; j++) {
        if (people[i].getFitness() > top[j].getFitness()) {
          Client temp = top[j];
          top[j] = people[i];
          people[i] = temp;
        }
      }
    }
    return top;
  }
  
  void haveChildren() {
    generation++;
    Client[] sorted = getTopFitness();
    Client[] best_genomes = (Client[]) subset(sorted, 9* floor(sorted.length/10), floor(sorted.length/10));
    
    for (int i = 0; i < poolSize; i++) {
      float[] chrom1 = best_genomes[floor(random(0, best_genomes.length))].chromosome;
      float[] chrom2 = best_genomes[floor(random(0, best_genomes.length))].chromosome;
      
      float[] first_half = subset(chrom1, 0, floor(chrom1.length/2));
      float[] second_half = subset(chrom2, floor(chrom2.length/2), floor(chrom2.length/2));
      
      float[] new_chromosome = (float[]) concat(first_half, second_half);
      for (int j = 0; j < new_chromosome.length; j++) {
        if (random(1) < this.mutation_chance) new_chromosome[j] = random(-1,1);
      }
      this.people[i] = new Client(new_chromosome, generation);
    }
  }
}
/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
