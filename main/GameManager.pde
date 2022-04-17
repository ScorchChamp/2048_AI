


class GameManager {
  SlotManager SM;
  int seed;
  Boolean last_did_something = true;
  Boolean game_over = false;
  GameManager(int seed) {
    this.SM = new SlotManager(4,4);
    this.seed = seed;
    this.addRandomSlot();
  }
  
  int getFitness() {
    int fitness = 0;
    int[] all_values = {};
    for (Slot[] ss : this.SM.slots) {
      for (Slot s : ss) {
        fitness += s.value;
        all_values = (int[]) append(all_values, s.value);
      }
    }
    return fitness + (max(all_values)*3);
  }
  
  void draw() {
    fill(0);
    stroke(0);
    rect((width/1.1) - 100 , height-40, 200, 50);
    fill(255);
    text("Score: " + getFitness(), width/1.1, height-20);
    this.SM.draw();
  }
  
  void addRandomSlot() {
    this.SM.addRandomSlot();
  }
  
  void runUp() {
    for (int i = 0; i < this.SM.slots.length; i++) {
      for (int a = 0; a < this.SM.slots[i].length; a++) {
        for (int j = 1; j < this.SM.slots[i].length; j++) {
          while (this.SM.slots[i][j-1].value == 0 && this.SM.slots[i][j].value != 0) {
            this.SM.slots[i][j-1].value = this.SM.slots[i][j].value;
            this.SM.slots[i][j].value = 0;
          }
        }
      }
    }
  }
  void runDown() {
    for (int i = 0; i < this.SM.slots.length; i++) {
      for (int a = 0; a < this.SM.slots[i].length; a++) {
        for (int j = this.SM.slots[i].length-2; j >= 0; j--) {
          while (this.SM.slots[i][j+1].value == 0 && this.SM.slots[i][j].value != 0) {
            this.SM.slots[i][j+1].value = this.SM.slots[i][j].value;
            this.SM.slots[i][j].value = 0;
          }
        }
      }
    }
  }
  void runLeft() {
    for (int a = 0; a < this.SM.slots.length; a++) {
      for (int i = 1; i < this.SM.slots.length; i++) {
        for (int j = 0; j < this.SM.slots[i].length; j++) {
          while (this.SM.slots[i-1][j].value == 0 && this.SM.slots[i][j].value != 0) {
            this.SM.slots[i-1][j].value = this.SM.slots[i][j].value;
            this.SM.slots[i][j].value = 0;
          }
        }
      }
    }
  }
  void runRight() {
    for (int a = 0; a < this.SM.slots.length; a++) {
      for (int i = this.SM.slots.length-2; i >= 0; i--) {
        for (int j = 0; j < this.SM.slots[i].length; j++) {
          while (this.SM.slots[i+1][j].value == 0 && this.SM.slots[i][j].value != 0) {
            this.SM.slots[i+1][j].value = this.SM.slots[i][j].value;
            this.SM.slots[i][j].value = 0;
          }
        }
      }
    }
  }
  
  void runMoveUp() {
    this.SM.startMove();
    runUp();
    for (int i = 0; i < this.SM.slots.length; i++) {
      for (int j = 1; j < this.SM.slots[i].length; j++) {
        while (this.SM.slots[i][j-1].value == this.SM.slots[i][j].value && this.SM.slots[i][j].value != 0) {
          this.SM.slots[i][j-1].value += this.SM.slots[i][j].value;
          this.SM.slots[i][j].value = 0;
        }
      }
    }
    runUp();
    this.game_over = this.SM.endMove();
  }
  void runMoveDown() {
    this.SM.startMove();
    runDown();
    for (int i = 0; i < this.SM.slots.length; i++) {
      for (int j = this.SM.slots[i].length-2; j >= 0 ; j--) {
        while (this.SM.slots[i][j+1].value == this.SM.slots[i][j].value && this.SM.slots[i][j].value != 0) {
          this.SM.slots[i][j+1].value += this.SM.slots[i][j].value;
          this.SM.slots[i][j].value = 0;
        }
      }
    }
    runDown();
    this.game_over = this.SM.endMove();
  }
  void runMoveLeft() {
    this.SM.startMove();
    runLeft();
    for (int i = 1; i < this.SM.slots.length; i++) {
      for (int j = 0; j < this.SM.slots[i].length; j++) {
        while (this.SM.slots[i-1][j].value == this.SM.slots[i][j].value && this.SM.slots[i][j].value != 0) {
          this.SM.slots[i-1][j].value += this.SM.slots[i][j].value;
          this.SM.slots[i][j].value = 0;
        }
      }
    }
    runLeft();
    this.game_over = this.SM.endMove();
  }
  void runMoveRight() {
    this.SM.startMove();
    runRight();
    for (int i = this.SM.slots.length-2; i >= 0 ; i--) {
      for (int j = 0; j < this.SM.slots[i].length; j++) {
        while (this.SM.slots[i+1][j].value == this.SM.slots[i][j].value && this.SM.slots[i][j].value != 0) {
          this.SM.slots[i+1][j].value += this.SM.slots[i][j].value;
          this.SM.slots[i][j].value = 0;
        }
      }
    }
    runRight();
    this.game_over = this.SM.endMove();
  }
}
/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
