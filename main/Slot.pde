

class Slot {
  int value = 0;
  Slot() {
  }
  
  void setValue(int value) {
    this.value = value;
  }
  
  void draw(int x, int y, int w, int h) {
      fill(215);
      if (this.value == 2) fill(#776e65);
      if (this.value == 4) fill(#776e65);
      if (this.value == 8) fill(#f2b179);
      if (this.value == 16) fill(#f59563);
      if (this.value == 32) fill(#f67c5f);
      if (this.value == 64) fill(#f65e3b);
      if (this.value == 128) fill(#edcf72);
      if (this.value == 256) fill(#edcc61);
      if (this.value == 512) fill(#edc850);
      if (this.value == 1024) fill(#edc53f);
      if (this.value >= 2048) fill(#edc22e);
      stroke(255);
      strokeWeight(5);
      rect(x,y, w, h);
      textSize(32);
      fill(255);
      textAlign(CENTER, CENTER);
      if (value != 0) text(value, x+(w/2),y+(h/2));
  }
}
/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
