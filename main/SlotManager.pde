


class SlotManager {
  int block_width;
  Slot[][] slots;
  int[] save_state;
  int ticks_since_last_succesful_move = 0;
  
  SlotManager(int x, int y) {
    slots = new Slot[x][y];
    for (int i = 0; i < slots.length; i++) {
      for (int j = 0; j < slots[i].length; j++) {
        slots[i][j] = new Slot();
      }
    }
    slots[floor(random(slots.length))][floor(random(slots[0].length))].value = 2;
    block_width = min(width/x, height/y);
  }
  
  Slot getFreeSlot() {
    Slot[] new_slots = {};
    for (Slot[] slot_2d : this.slots) {
      for (Slot slot : slot_2d) {
        if (slot.value == 0) {
          new_slots = (Slot[]) append(new_slots, slot);
        }
      }
    }
    if (new_slots.length == 0) return null;
    return new_slots[floor(random(0,new_slots.length))];
  }
  
  
  boolean addRandomSlot() {
    Slot slot = getFreeSlot();
    slot.setValue(2);
    return true;
  }
  
  int getValue(int x, int y) {
    return slots[x][y].value;
  }
  
  void draw() {
    for (int i = 0; i < slots.length; i++) {
      for (int j = 0; j < slots[i].length; j++) {
        slots[i][j].draw(i*block_width, j*block_width,block_width,block_width);
      }
    }
  }
  
  
  void startMove() {
    ticks_since_last_succesful_move++;
    int[] save = {};
    for (Slot[] ss : this.slots) {
      for (Slot s : ss) {
        save = (int[]) append(save, s.value);
      }
    }
    this.save_state = save;
  }
  
  boolean didSomethingChange() {
    int index = 0;
    for (Slot[] ss : this.slots) {
      for (Slot s : ss) {
        if (s.value != this.save_state[index]) return true;
        index++;
      }
    }
    return false;
  }
  
  int getFreeMove() {
    if (getFreeSlot() != null) return 4;
    for (int i = 0; i < slots.length; i++) {
      for (int j = 0; j < slots[i].length; j++) {
        if (i != slots.length-1 && slots[i][j].value == slots[i+1][j].value) return 0;
        if (i != 0 && slots[i][j].value == slots[i-1][j].value) return 1;
        if (j != slots[i].length-1 && slots[i][j].value == slots[i][j+1].value) return 2;
        if (j != 0 && slots[i][j].value == slots[i][j-1].value) return 3;
      }
    }
    return -1;
  }
  
  
  boolean endMove() {
    if (ticks_since_last_succesful_move > 3) return true;
    if (didSomethingChange()) {
      ticks_since_last_succesful_move = 0;
      return !this.addRandomSlot();
    }
    return getFreeMove() == -1;
  }
}
/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
