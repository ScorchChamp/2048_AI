


class Node {
  float[] weights;
  float value = 0;

  Node(float[] weights) {
    this.weights = weights;
  }
  
  void calculateValue(float input) {
    value = 0;
    value += max(input * this.weights[0],0);
  }
  
  void calculateValue(float[] inputs) {
    value = 0;
    for (int i = 0; i < inputs.length; i++) {
      value += max(inputs[i] * this.weights[i],0);
    }
  }
}
/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
