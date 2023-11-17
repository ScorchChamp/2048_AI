Population pop;
Game2048 game;
NeuralNetwork bestNN;
int generation = 0;
boolean displayGame = false;
float maxScore = 0;
JSONObject results;  

void setup() {
    size(800, 400);  // Adjust size as needed for displaying the game
    frameRate(165);
    pop = new Population(1000, 16, 10, 4, 3);  // Example configuration
    bestNN = pop.networks[0];
    game = new Game2048();
    results = new JSONObject();
}

  int lastMove = -1;
  int repeatMoveCount = 0;

void draw() {
    background(255);  // Set background color

    if (displayGame) {
      frameRate(5);
      // Display the game
      //bestNN.drawNetwork(400, 0, 400, 400);  // Draw the network
      if (game.isGameOver()) {
        displayGame = false;
        game = new Game2048();  // Reset game for next display
        frameRate(165);
        saveJSONObject(results, "results.json");
      } else {
        // Make the next move
        float[] currentState = game.getFlattenedBoard();
        int move = bestNN.decideMove(currentState);
        game.move(move);
        game.display();
      }
    } else {
        // Evolve the population
        pop.evaluateFitness();
        pop.generateNextGeneration();
        results.setFloat(str(generation), max(pop.fitnesses));
        generation++;
        textAlign(CENTER, CENTER);
        textSize(32);
        text("LEARNING...", width/4, height/2);

        // Find the best neural network in the new generation
        bestNN = findBestNetwork(pop);

        // Prepare to display the game played by the best neural network
        if (generation % 100 == 0) displayGame = true;
    }
    bestNN.drawNetwork(400,0,800,400);
    fill(0);
    textSize(16);
    textAlign(RIGHT, TOP);
    text("Generation: " + generation, width, 0);
    text("Score: " + game.getScore(), width, 20);
    text("Diversity: " + nf(pop.getDiversity(), 0, 2), width, 40);
    text("MR: " + nf(pop.mutationRate, 0, 5), width, 60);
}
NeuralNetwork findBestNetwork(Population pop) {
    int bestIndex = 0;
    float bestFitness = 0;
    for (int i = 0; i < pop.networks.length; i++) {
        if (pop.fitnesses[i] > bestFitness) {
            bestFitness = pop.fitnesses[i];
            bestIndex = i;
        }
    }
    return pop.networks[bestIndex];
}
