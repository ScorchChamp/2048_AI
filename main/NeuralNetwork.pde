class NeuralNetwork {
    int inputNodes;
    int hiddenNodes;
    int outputNodes;
    int numHiddenLayers;
    float[][][] weights; // 3D array to store weights for each layer
    float[][] biases; // 2D array to store biases for each layer
    float fitness;

    // Constructor
    NeuralNetwork(int inputNodes, int hiddenNodes, int outputNodes, int numHiddenLayers) {
        this.inputNodes = inputNodes;
        this.hiddenNodes = hiddenNodes;
        this.outputNodes = outputNodes;
        this.numHiddenLayers = numHiddenLayers;

        // Initialize weights and biases
        weights = new float[numHiddenLayers + 1][][];
        biases = new float[numHiddenLayers + 1][];
        initializeWeightsAndBiases();
    }

    // Initialize weights and biases with random values
    void initializeWeightsAndBiases() {
        for (int i = 0; i < numHiddenLayers + 1; i++) {
            int inNodes = (i == 0) ? inputNodes : hiddenNodes;
            int outNodes = (i == numHiddenLayers) ? outputNodes : hiddenNodes;

            weights[i] = new float[outNodes][inNodes];
            biases[i] = new float[outNodes];
            for (int j = 0; j < outNodes; j++) {
                biases[i][j] = random(-1, 1);
                for (int k = 0; k < inNodes; k++) {
                    weights[i][j][k] = random(-1, 1);
                }
            }
        }
    }
  float[] minMax(float[] values) {
    float highest = max(values);
    for (int i = 0; i < values.length; i++) {
      values[i] = map(max(0,values[i]), 0, highest, 0, 1);
    }
    return values;
  }

    // Feedforward
    float[] feedforward(float[] inputs) {
        float[] activations = minMax(inputs);

        for (int i = 0; i < numHiddenLayers + 1; i++) {
            float[] nextActivations = new float[(i == numHiddenLayers) ? outputNodes : hiddenNodes];

            for (int j = 0; j < nextActivations.length; j++) {
                nextActivations[j] = 0;
                for (int k = 0; k < activations.length; k++) {
                    nextActivations[j] += activations[k] * weights[i][j][k];
                }
                nextActivations[j] += biases[i][j];
                nextActivations[j] = sigmoid(nextActivations[j]);
            }

            activations = nextActivations;
        }

        return activations;
    }

    // Sigmoid activation function
    float sigmoid(float x) {
        return 1 / (1 + exp(-x));
    }
    // Inside the NeuralNetwork class

  // Method to copy the neural network
  NeuralNetwork copy() {
      NeuralNetwork clone = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes, numHiddenLayers);
      for (int i = 0; i < weights.length; i++) {
          for (int j = 0; j < weights[i].length; j++) {
              for (int k = 0; k < weights[i][j].length; k++) {
                  clone.weights[i][j][k] = this.weights[i][j][k];
              }
              clone.biases[i][j] = this.biases[i][j];
          }
      }
      return clone;
  }
  
  // Method to mutate the neural network
  void mutate(float mutationRate) {
      for (int i = 0; i < weights.length; i++) {
          for (int j = 0; j < weights[i].length; j++) {
              for (int k = 0; k < weights[i][j].length; k++) {
                  if (random(1) < mutationRate) {
                      //weights[i][j][k] += randomGaussian() * mutationRate; // Adjust mutation strength as needed
                      //weights[i][j][k] = max(-1, min(weights[i][j][k], 1));
                      weights[i][j][k] = random(-1, 1); // Adjust mutation strength as needed
                  }
              }
              if (random(1) < mutationRate) {
                  biases[i][j] += randomGaussian() * 0.005; // Adjust mutation strength as needed
                  biases[i][j] = max(-1, min(biases[i][j], 1));
              }
          }
      }
  }
  
  int decideMove(float[] inputs) {
    float[] output = feedforward(inputs);
    return indexOfMax(output);
  }

  int indexOfMax(float[] array) {
      int maxIndex = 0;
      for (int i = 1; i < array.length; i++) {
          if (array[i] > array[maxIndex]) {
              maxIndex = i;
          }
      }
      return maxIndex;
  }
    
    
 void drawNetwork(int x1, int y1, int x2, int y2) {
        int layerCount = numHiddenLayers + 2; // Including input and output layers
        int maxNodes = max(max(inputNodes, hiddenNodes), outputNodes);
        
        // Calculate spacing between nodes and layers
        int verticalSpacing = (y2 - y1) / (maxNodes - 1);
        int horizontalSpacing = (x2 - x1) / (layerCount - 1);

        // Draw nodes for each layer
        for (int layer = 0; layer < layerCount; layer++) {
            int nodesInLayer = (layer == 0) ? inputNodes : (layer == layerCount - 1) ? outputNodes : hiddenNodes;
            int startY = y1 + (y2 - y1 - (nodesInLayer - 1) * verticalSpacing) / 2; // Center nodes vertically

            for (int node = 0; node < nodesInLayer; node++) {
                int x = x1 + layer * horizontalSpacing;
                int y = startY + node * verticalSpacing;
                drawNode(x, y);
            }
        }

        // Draw connections between nodes (weights)
        for (int layer = 1; layer < layerCount; layer++) {
            int nodesInPreviousLayer = (layer == 1) ? inputNodes : hiddenNodes;
            int nodesInLayer = (layer == layerCount - 1) ? outputNodes : hiddenNodes;

            for (int prevNode = 0; prevNode < nodesInPreviousLayer; prevNode++) {
                for (int node = 0; node < nodesInLayer; node++) {
                    int startX = x1 + (layer - 1) * horizontalSpacing;
                    int startY = y1 + (y2 - y1 - (nodesInPreviousLayer - 1) * verticalSpacing) / 2 + prevNode * verticalSpacing;
                    int endX = x1 + layer * horizontalSpacing;
                    int endY = y1 + (y2 - y1 - (nodesInLayer - 1) * verticalSpacing) / 2 + node * verticalSpacing;
                    float weight = weights[layer - 1][node][prevNode];
                    drawConnection(startX, startY, endX, endY, weight);                
                  }
            }
        }
    }

    void drawNode(int x, int y) {
        ellipse(x, y, 10, 10); // Draw node as a small ellipse
    }

    void drawConnection(int x1, int y1, int x2, int y2, float weight) {
        strokeWeight(1);
        if (weight < 0) stroke(255,0,0,abs(weight)*255);
        else stroke(0,255,0,abs(weight)*255);
        line(x1, y1, x2, y2); // Draw line for connection
        noStroke();
    }    
}
