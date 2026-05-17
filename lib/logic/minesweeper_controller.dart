import 'dart:async';
import 'package:flutter/foundation.dart';
import 'board_models.dart';
import 'minesweeper_engine.dart';

class MinesweeperController extends ChangeNotifier {
  final MinesweeperEngine _engine = MinesweeperEngine();
  
  Timer? _timer;
  int _elapsedTime = 0;
  int _flagsPlaced = 0;

  // Propiedades públicas expuestas a la UI
  List<List<CellModel>> get board => _engine.board;
  GameState get gameState => _engine.gameState;
  int get elapsedTime => _elapsedTime;
  int get remainingMines => _engine.difficulty.mineCount - _flagsPlaced;
  GameDifficulty get difficulty => _engine.difficulty;

  MinesweeperController() {
    startGame(GameDifficulty.easy);
  }

  /// Inicia o reinicia el juego con la dificultad seleccionada.
  void startGame(GameDifficulty difficulty) {
    _stopTimer();
    _elapsedTime = 0;
    _flagsPlaced = 0;
    _engine.generateEmptyBoard(difficulty);
    notifyListeners();
  }

  /// Maneja el evento de tocar (revelar) una celda.
  void tapCell(int row, int col) {
    // Si el juego ya terminó, no hacemos nada.
    if (gameState == GameState.won || gameState == GameState.lost) return;

    final wasIdle = gameState == GameState.idle;

    // Llama al motor lógico para procesar la jugada.
    _engine.revealCell(row, col);

    // Si era el primer tap y ahora estamos jugando, iniciamos el cronómetro.
    if (wasIdle && gameState == GameState.playing) {
      _startTimer();
    }

    _checkGameStateChanges();
    notifyListeners();
  }

  /// Maneja el evento de colocar o quitar una bandera.
  void flagCell(int row, int col) {
    // Solo permitimos banderas si el juego está activo (playing).
    if (gameState != GameState.playing) return;

    final cell = board[row][col];
    
    // Solo podemos interactuar con celdas no reveladas.
    if (!cell.isRevealed) {
      final wasFlagged = cell.isFlagged;
      
      _engine.toggleFlag(row, col);
      
      final isNowFlagged = board[row][col].isFlagged;
      
      // Si el estado de la bandera cambió, actualizamos el contador.
      if (wasFlagged != isNowFlagged) {
        if (isNowFlagged) {
          _flagsPlaced++;
        } else {
          _flagsPlaced--;
        }
      }
      
      notifyListeners();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime++;
      notifyListeners(); // Notificamos cada segundo para actualizar la UI.
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Verifica si el juego ha terminado para detener el cronómetro.
  void _checkGameStateChanges() {
    if (gameState == GameState.won || gameState == GameState.lost) {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
