import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'board_models.dart';
import 'minesweeper_engine.dart';
import 'minesweeper_storage.dart';

class MinesweeperController extends ChangeNotifier {
  final MinesweeperEngine _engine = MinesweeperEngine();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final MinesweeperStorage _storage = MinesweeperStorage();
  
  Timer? _timer;
  int _elapsedTime = 0;
  int _flagsPlaced = 0;

  NumberStyle _currentNumberStyle = NumberStyle.clasico;

  // Propiedades públicas expuestas a la UI
  List<List<CellModel>> get board => _engine.board;
  GameState get gameState => _engine.gameState;
  int get elapsedTime => _elapsedTime;
  int get remainingMines => _engine.difficulty.mineCount - _flagsPlaced;
  GameDifficulty get difficulty => _engine.difficulty;
  NumberStyle get currentNumberStyle => _currentNumberStyle;

  MinesweeperController() {
    _initStyle();
    startGame(GameDifficulty.easy);
  }

  Future<void> _initStyle() async {
    _currentNumberStyle = await _storage.getNumberStyle();
    notifyListeners();
  }

  /// Actualiza el estilo de los números, lo guarda localmente y notifica a la UI
  Future<void> updateNumberStyle(NumberStyle newStyle) async {
    if (_currentNumberStyle == newStyle) return;
    _currentNumberStyle = newStyle;
    notifyListeners();
    await _storage.saveNumberStyle(newStyle);
  }

  /// Inicia o reinicia el juego con la dificultad seleccionada.
  void startGame(GameDifficulty difficulty) {
    _stopTimer();
    _elapsedTime = 0;
    _flagsPlaced = 0;
    _engine.generateEmptyBoard(difficulty);
    notifyListeners();
  }

  /// Reproduce un efecto de sonido local sin bloquear la UI
  Future<void> _playSound(String fileName) async {
    try {
      // audioplayers busca automáticamente en la carpeta 'assets/' al usar AssetSource
      await _audioPlayer.play(AssetSource('audios/$fileName'));
    } catch (e) {
      if (kDebugMode) {
        print('Error al reproducir audio: $e');
      }
    }
  }

  /// Maneja el evento de tocar (revelar) una celda.
  void tapCell(int row, int col) {
    // Si el juego ya terminó, no hacemos nada.
    if (gameState == GameState.won || gameState == GameState.lost) return;

    final wasIdle = gameState == GameState.idle;
    final wasRevealed = board[row][col].isRevealed;

    // Llama al motor lógico para procesar la jugada.
    _engine.revealCell(row, col);

    // Si era el primer tap y ahora estamos jugando, iniciamos el cronómetro.
    if (wasIdle && gameState == GameState.playing) {
      _startTimer();
    }
    
    // Evaluar sonidos según el cambio de estado de la partida
    if (gameState == GameState.won) {
      _playSound('victory.wav');
      // Guardar el récord automáticamente de forma asíncrona
      _storage.saveHighScore(difficulty, _elapsedTime);
    } else if (gameState == GameState.lost) {
      _playSound('defeat.wav');
    } else if (!wasRevealed && board[row][col].isRevealed) {
      // Si el juego sigue jugando y la celda fue efectivamente revelada
      _playSound('reveal.wav');
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

  /// Retorna la lista de los mejores tiempos guardados
  Future<List<HighScore>> loadHighScores(GameDifficulty difficulty) {
    return _storage.getHighScores(difficulty);
  }

  @override
  void dispose() {
    _stopTimer();
    _audioPlayer.dispose();
    super.dispose();
  }
}
