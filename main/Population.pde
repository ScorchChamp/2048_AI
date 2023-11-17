class Population {
    NeuralNetwork[] networks;
    int generation = 1;
    float[] fitnesses;
    int populationSize;
    float mutationRate;

    Population(int size, int inputNodes, int hiddenNodes, int outputNodes, int numHiddenLayers) {
        populationSize = size;
        networks = new NeuralNetwork[size];
        fitnesses = new float[size];
        for (int i = 0; i < size; i++) {
            networks[i] = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes, numHiddenLayers);
        }
    }

    // Evaluate the fitness of each network
    void evaluateFitness() {
        for (int i = 0; i < populationSize; i++) {
          fitnesses[i] = calculateFitness(networks[i]);
        }
    }
    
    float getDiversity() {
      float medianFitness = fitnesses[floor(fitnesses.length / 2)];
      float maxFitness = max(fitnesses);
      return 1 - (medianFitness / maxFitness);
    }

    // Define your fitness function here
  float calculateFitness(NeuralNetwork nn) {
    Game2048 game = new Game2048();

    while (!game.isGameOver()) {
        float[] currentState = game.getFlattenedBoard();
        int move = nn.decideMove(currentState);
        game.move(move);
    }

    // Modify the score based on the game state and other factors
    float score = game.getScore();
    // You can adjust the score based on other criteria, such as the number of high-value tiles
    return score;
  }


    // Generate a new generation
    void generateNextGeneration() {
        NeuralNetwork[] newNetworks = new NeuralNetwork[populationSize];
        float diversity = getDiversity();
        mutationRate = map(diversity, 0, 1, min(0.005, 5.0/generation), 0);
        //if (diversity < 0.1) mutationRate = min(0.5, 100.0/generation);
        //else mutationRate = min(0.005, 5.0/generation);
        
      // Step 1: Create an array of indices
      int[] indices = new int[populationSize];
      for (int i = 0; i < populationSize; i++) {
          indices[i] = i;
      }
  
      // Step 2: Sort the indices based on fitness
      // Simple bubble sort for demonstration purposes
      for (int i = 0; i < populationSize - 1; i++) {
          for (int j = 0; j < populationSize - i - 1; j++) {
              if (fitnesses[indices[j]] < fitnesses[indices[j + 1]]) {
                  // Swap
                  int temp = indices[j];
                  indices[j] = indices[j + 1];
                  indices[j + 1] = temp;
              }
          }
      }
  
      // Step 3: Select a random index from the top 10
      int topLimit = min(100, populationSize); // Ensure it doesn't exceed population size

        // Select the best networks and breed them
        for (int i = 0; i < populationSize; i++) {
            NeuralNetwork parent1 = networks[indices[(int) random(topLimit)]];
            NeuralNetwork parent2 = networks[indices[(int) random(topLimit)]];
            NeuralNetwork child = crossover(parent1, parent2);
            child.mutate(mutationRate); // Mutation rate, adjust as needed
            newNetworks[i] = child;
        }

        networks = newNetworks;
        generation++;
    }


    // Crossover between two parents to produce a child network
    NeuralNetwork crossover(NeuralNetwork parent1, NeuralNetwork parent2) {
        NeuralNetwork child = parent1.copy();
        // Implement crossover logic, for example:
        // for each weight and bias, randomly choose from which parent to inherit
        for (int i = 0; i < child.weights.length; i++) {
            for (int j = 0; j < child.weights[i].length; j++) {
                for (int k = 0; k < child.weights[i][j].length; k++) {
                    if (random(1) < 0.5) {
                        child.weights[i][j][k] = parent2.weights[i][j][k];
                    }
                }
            }
        }
        return child;
    }

    // Utility function to sum an array of floats
    float sum(float[] array) {
        float total = 0;
        for (float value : array) {
            total += value;
        }
        return total;
    }
}
