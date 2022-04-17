


class Network {
  int input_size;
  int hidden_layer_size;
  int output_size;
  Node[][] layers = {{}, {}, {}};
  boolean drawn = false;

  Network(int input_size, int hidden_layer_size, int output_size, float[] chromosome) {
    this.input_size = input_size;
    this.hidden_layer_size = hidden_layer_size;
    this.output_size = output_size;
    this.generateNodes(chromosome);
  }
  
  
  void draw(int generation) {
    if (drawn) return;
    else drawn = true;
    background(0);
    text("Generation: " + generation, width/1.5, height-20);
    float base_x = (width/2) + 10;
    float cyl_size = 10;
    float y_per_cyl_INPUT = (height/(input_size+1));
    for (int a = 0; a < input_size; a++) {
      float cil_y = y_per_cyl_INPUT*a + y_per_cyl_INPUT;
      circle(base_x, cil_y, cyl_size);
      for (int b = 0; b < hidden_layer_size; b++) {
        float HL_x = base_x + 250;
        float y_per_cyl_HL = (height/(hidden_layer_size+1));
        float cil_y_HL = y_per_cyl_HL*b + y_per_cyl_HL;
        circle(HL_x, cil_y_HL, cyl_size);
        if (layers[1][b].weights[a] > 0) stroke(0,255,0, map(abs(layers[1][b].weights[a]),0,1,0,255));
        else stroke(255,0,0, map(abs(layers[1][b].weights[a]),0,1,0,255));
        strokeWeight(abs(layers[1][b].weights[a]));
        line(base_x, cil_y, HL_x, cil_y_HL);
        for (int c = 0; c < output_size; c++) {
          stroke(255);
          float OUTPUT_x = base_x + 450;
          float y_per_cyl_OUTPUT = (height/(output_size+1));
          float cil_y_OUTPUT = y_per_cyl_OUTPUT*c + y_per_cyl_OUTPUT;
          circle(OUTPUT_x, cil_y_OUTPUT, cyl_size);
          if (layers[2][c].weights[b] > 0) stroke(0,255,0, map(abs(layers[2][c].weights[b]),0,1,0,255));
          else stroke(255,0,0, map(abs(layers[2][c].weights[b]),0,1,0,255));
          strokeWeight(abs(layers[2][c].weights[b]));
          line(HL_x, cil_y_HL, OUTPUT_x, cil_y_OUTPUT);
        }
      }
    }
  }
  
  int getResult(float[] input) {
    float highest = -100;
    int res = 0;
    float[] values = this.forwardProp(input);
    for (int i = 0; i < values.length; i++) {
      if (values[i] > highest) {
        highest = values[i];
        res = i;
      }
    }
    return res;
  }
  
  
  float[] forwardProp(float[] input) {
    float[] input_values = new float[this.layers[0].length];
    for (int i = 0; i < this.layers[0].length; i++) {
      this.layers[0][i].calculateValue(input[i]);
      input_values[i] = this.layers[0][i].value;
    }
    input_values = minMax(input_values);
    float[] HL_values = new float[this.layers[1].length];
    for (int i = 0; i < this.layers[1].length; i++) {
      this.layers[1][i].calculateValue(input_values);
      HL_values[i] = this.layers[1][i].value;
    }
    HL_values = minMax(HL_values);
    float[] output_values = new float[this.layers[2].length];
    for (int i = 0; i < this.layers[2].length; i++) {
      this.layers[2][i].calculateValue(HL_values);
      output_values[i] = this.layers[2][i].value;
    }
    output_values = minMax(output_values);
    return output_values;
  }
  
  float[] minMax(float[] values) {
    float highest = max(values);
    for (int i = 0; i < values.length; i++) {
      values[i] = map(max(0,values[i]), 0, highest, 0, 1);
    }
    return values;
  }
  
  void generateNodes(float[] chromosome) {
    for (int i = 0; i < this.input_size; i++) {
      float[] c = {};
      c = (float[]) append(c, chromosome[i]);
      this.layers[0] = (Node[]) append(this.layers[0], new Node(c));
    }
    for (int i = 0; i < this.hidden_layer_size; i++) {
      float[] c = {};
      for (int j = 0; j < this.input_size; j++) {
        c = (float[]) append(c, chromosome[(this.input_size) + this.input_size*i + j]);
      }
      layers[1] = (Node[]) append(this.layers[1], new Node(c));
    }
    for (int i = 0; i < this.output_size; i++) {
      float[] c = {};
      for (int j = 0; j < this.hidden_layer_size; j++) c = (float[]) append(c, chromosome[(this.input_size) + (this.input_size*this.hidden_layer_size) + (i*this.hidden_layer_size) + j]);
      layers[2] = (Node[]) append(this.layers[2], new Node(c));
    }
  }
}
/*
  You are legally bound to refer the following copy when you take pieces of this application:
  Base-Application made by ScorchChamp (Scorch#8227)
*/
