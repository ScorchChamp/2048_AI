class Game2048 {
    int[][] board = new int[4][4];
    boolean gameOver = false;
    int lastMove = -1;
    int repeatMoveCount = 0;
    

    Game2048() {
        addTile();
        addTile();
    }

    void addTile() {
        // Find all empty spots
        ArrayList<int[]> emptySpots = new ArrayList<int[]>();
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                if (board[i][j] == 0) {
                    emptySpots.add(new int[]{i, j});
                }
            }
        }

        // Choose a random empty spot to place a new tile (2 or 4)
        if (!emptySpots.isEmpty()) {
            int[] spot = emptySpots.get((int) random(emptySpots.size()));
            board[spot[0]][spot[1]] = (random(1) < 0.9) ? 2 : 4;
        }
    }
    float[] getFlattenedBoard() {
      float[] flattened = new float[16];
      int index = 0;
      for (int i = 0; i < 4; i++) {
          for (int j = 0; j < 4; j++) {
              flattened[index++] = board[i][j];
          }
      }
      return flattened;
    }

  void move(int direction) {
    if (direction == lastMove) {
        repeatMoveCount++;
    } else {
        repeatMoveCount = 0;
    }
    lastMove = direction;

    boolean moved = false;
    for (int i = 0; i < 4; i++) {
        int[] line = new int[4];
        for (int j = 0; j < 4; j++) {
            line[j] = getCellValue(direction, i, j);
        }

        int[] merged = merge(line);
        for (int j = 0; j < 4; j++) {
            if (setCellValue(direction, i, j, merged[j])) {
                moved = true;
            }
        }
    }

    if (moved) {
        addTile();
        gameOver = isGameOver();
    }
}

private int getCellValue(int direction, int i, int j) {
    switch (direction) {
        case 0: return board[j][i]; // up
        case 1: return board[i][3 - j]; // right
        case 2: return board[3 - j][i]; // down
        case 3: return board[i][j]; // left
        default: throw new IllegalArgumentException("Invalid direction");
    }
}

private boolean setCellValue(int direction, int i, int j, int value) {
    int prevValue;
    switch (direction) {
        case 0: prevValue = board[j][i]; board[j][i] = value; break;
        case 1: prevValue = board[i][3 - j]; board[i][3 - j] = value; break;
        case 2: prevValue = board[3 - j][i]; board[3 - j][i] = value; break;
        case 3: prevValue = board[i][j]; board[i][j] = value; break;
        default: throw new IllegalArgumentException("Invalid direction");
    }
    return prevValue != value;
}



    int[] merge(int[] line) {
        ArrayList<Integer> list = new ArrayList<Integer>();
        for (int i = 0; i < line.length; i++) {
            int num = line[i];
            if (num != 0) list.add(num);
        }

        for (int i = 0; i < list.size() - 1; i++) {
            if (list.get(i).equals(list.get(i + 1))) {
                list.set(i, list.get(i) * 2);
                list.remove(i + 1);
            }
        }

        while (list.size() < 4) {
            list.add(0);
        }

        for (int i = 0; i < line.length; i++) {
            line[i] = list.get(i);
        }

        return line;
    }

    int[] reverse(int[] array) {
        for (int i = 0; i < array.length / 2; i++) {
            int temp = array[i];
            array[i] = array[array.length - 1 - i];
            array[array.length - 1 - i] = temp;
        }
        return array;
    }

    boolean isGameOver() {
      if (repeatMoveCount > 4) return true;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                if (board[i][j] == 0) {
                    return false;
                }
                if (j < 3 && board[i][j] == board[i][j + 1]) {
                    return false;
                }
                if (i < 3 && board[i][j] == board[i + 1][j]) {
                    return false;
                }
            }
        }
        return true;
    }

    int getScore() {
        int score = 0;
        int highest = 0;
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board[i].length; j++) {
              if (board[i][j] > highest) {
                highest = board[i][j];
              }
              score += board[i][j];
            }
        } 
        score += highest;
        return score;
    }

    void display() {
        // Display the game board in the Processing window //<>//
        // You can customize the size, colors, and fonts as per your preference
        int tileSize = 100;
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
              fill(215);
              int value = board[i][j];
              if (value == 2) fill(#776e65);
              if (value == 4) fill(#776e65);
              if (value == 8) fill(#f2b179);
              if (value == 16) fill(#f59563);
              if (value == 32) fill(#f67c5f);
              if (value == 64) fill(#f65e3b);
              if (value == 128) fill(#edcf72);
              if (value == 256) fill(#edcc61);
              if (value == 512) fill(#edc850);
              if (value == 1024) fill(#edc53f);
              if (value >= 2048) fill(#edc22e);
              //fill(200); // Change to desired color
              rect(j * tileSize, i * tileSize, tileSize, tileSize);
              textAlign(CENTER, CENTER);
              fill(0); // Change text color if needed
              textSize(32);
              text(value, j * tileSize + tileSize / 2, i * tileSize + tileSize / 2);
            }
        }
        stroke(255,0,0);
        strokeWeight(5);
        if (lastMove == 0) line(0, 0, tileSize*4, 0);
        if (lastMove == 1) line(tileSize*4, 0, tileSize*4, tileSize*4);
        if (lastMove == 2) line(0, tileSize*4, tileSize*4, tileSize*4);
        if (lastMove == 3) line(0, 0, 0, tileSize*4);
        noStroke();
        
        
        
    }
}
