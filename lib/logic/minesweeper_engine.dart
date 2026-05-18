import 'dart:math';
import 'board_models.dart';

class MinesweeperEngine {
  List<List<CellModel>> board = [];
  GameState gameState = GameState.idle;
  GameDifficulty difficulty = GameDifficulty.easy;

  // Crea una matriz bidimensional con celdas vacías
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

  // Coloca minas aleatoriamente en el tablero, asegurando que la primera celda tocada
  // y sus 8 vecinos adyacentes estén completamente libres de minas
  // garantizando un inicio seguro y justo para el jugador
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

      // Verifica si la posición aleatoria está en la zona segura 
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

  // Recorre el tablero después de colocar las minas y calcula
  // el número correcto de minas circundantes para cada celda
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

  ///Revela una celda
  // - Si la celda ya está revelada o tiene bandera, no hace nada
  // - Si es una mina, cambia el estado del juego a 'perdido'
  // - Si adjacentMines == 0, ejecuta un algoritmo de Flood Fill para
  //   revelar recursivamente todas las celdas vacías y sus bordes numerados
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

  // Usando BFS con una cola para revelar eficientemente
  // celdas vacías contiguas y sus bordes numerados inmediatos
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

      // Si la celda tiene 0 minas adyacentes, agregar vecinos a la cola
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

  // Cambia el estado de la bandera de una celda si no está revelada
  void toggleFlag(int row, int col) {
    if (gameState != GameState.playing) return;

    final cell = board[row][col];
    if (!cell.isRevealed) {
      board[row][col] = cell.copyWith(isFlagged: !cell.isFlagged);
    }
  }

  // Revela todas las minas del tablero (cuando pierde)
  void _revealAllMines() {
    for (int r = 0; r < difficulty.rows; r++) {
      for (int c = 0; c < difficulty.cols; c++) {
        if (board[r][c].hasMine) {
          board[r][c] = board[r][c].copyWith(isRevealed: true);
        }
      }
    }
  }

  // Verifica si el jugador gana la partida
  // Gana cuando todas las celdas sin mina han sido reveladas
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