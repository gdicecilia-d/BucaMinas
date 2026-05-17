import 'dart:math';
import 'board_models.dart';

class MinesweeperEngine {
  List<List<CellModel>> board = [];
  GameState gameState = GameState.idle;
  GameDifficulty difficulty = GameDifficulty.easy;

  /// Creates a two-dimensional matrix initialized to zero (empty cells).
  void generateEmptyBoard(GameDifficulty difficulty) {
    this.difficulty = difficulty;
    board = List.generate(
      difficulty.rows,
      (row) => List.generate(
        difficulty.cols,
        (col) => CellModel(row: row, col: col),
      ),
    );
    gameState = GameState.idle;
  }

  /// Places mines randomly on the board, ensuring the first tapped cell
  /// and its 8 adjacent neighbors are completely free of mines.
  /// This guarantees a safe and fair start for the player.
  void initializeMines(int firstRow, int firstCol) {
    if (gameState != GameState.idle) return;

    final random = Random();
    int minesPlaced = 0;
    final totalMines = difficulty.mineCount;
    final rows = difficulty.rows;
    final cols = difficulty.cols;

    while (minesPlaced < totalMines) {
      final r = random.nextInt(rows);
      final c = random.nextInt(cols);

      // Check if the random position is in the safe zone (first tap + 8 neighbors)
      final isSafeZone = (r >= firstRow - 1 && r <= firstRow + 1) &&
          (c >= firstCol - 1 && c <= firstCol + 1);

      if (!isSafeZone && !board[r][c].hasMine) {
        board[r][c] = board[r][c].copyWith(hasMine: true);
        minesPlaced++;
      }
    }

    _calculateAdjacentMines();
    gameState = GameState.playing;
  }

  /// Iterates over the board after mines are placed and calculates
  /// the correct number of surrounding mines for each cell.
  void _calculateAdjacentMines() {
    final rows = difficulty.rows;
    final cols = difficulty.cols;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].hasMine) continue;

        int mines = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            final nr = r + i;
            final nc = c + j;

            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              if (board[nr][nc].hasMine) {
                mines++;
              }
            }
          }
        }
        
        board[r][c] = board[r][c].copyWith(adjacentMines: mines);
      }
    }
  }

  /// Reveals a cell.
  /// - If the cell is already revealed or flagged, it does nothing.
  /// - If it's a mine, it changes the game state to 'lost'.
  /// - If adjacentMines == 0, it executes a Flood Fill algorithm to
  ///   recursively reveal all empty cells and their connected numbered borders.
  void revealCell(int row, int col) {
    if (gameState == GameState.idle) {
      initializeMines(row, col);
    }

    if (gameState != GameState.playing) return;

    final cell = board[row][col];
    if (cell.isRevealed || cell.isFlagged) return;

    if (cell.hasMine) {
      gameState = GameState.lost;
      _revealAllMines();
      return;
    }

    _floodFillReveal(row, col);
    _checkWinCondition();
  }

  /// Flood Fill algorithm (BFS approach using a queue) to efficiently reveal 
  /// contiguous empty cells and their immediate numbered borders.
  void _floodFillReveal(int startRow, int startCol) {
    final rows = difficulty.rows;
    final cols = difficulty.cols;
    final queue = <Point<int>>[Point(startRow, startCol)];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final r = current.x;
      final c = current.y;

      final cell = board[r][c];
      if (cell.isRevealed || cell.isFlagged) continue;

      board[r][c] = cell.copyWith(isRevealed: true);

      // If the cell has 0 adjacent mines, add neighbors to the queue
      if (board[r][c].adjacentMines == 0) {
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            if (i == 0 && j == 0) continue;

            final nr = r + i;
            final nc = c + j;

            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              if (!board[nr][nc].isRevealed && !board[nr][nc].isFlagged) {
                queue.add(Point(nr, nc));
              }
            }
          }
        }
      }
    }
  }

  /// Toggles the flag state of a cell if it is not revealed.
  void toggleFlag(int row, int col) {
    if (gameState != GameState.playing) return;

    final cell = board[row][col];
    if (!cell.isRevealed) {
      board[row][col] = cell.copyWith(isFlagged: !cell.isFlagged);
    }
  }

  void _revealAllMines() {
    for (int r = 0; r < difficulty.rows; r++) {
      for (int c = 0; c < difficulty.cols; c++) {
        if (board[r][c].hasMine) {
          board[r][c] = board[r][c].copyWith(isRevealed: true);
        }
      }
    }
  }

  void _checkWinCondition() {
    int unrevealedCells = 0;
    for (int r = 0; r < difficulty.rows; r++) {
      for (int c = 0; c < difficulty.cols; c++) {
        if (!board[r][c].isRevealed) {
          unrevealedCells++;
        }
      }
    }

    if (unrevealedCells == difficulty.mineCount) {
      gameState = GameState.won;
    }
  }
}
