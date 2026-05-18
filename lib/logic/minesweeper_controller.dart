import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'board_models.dart';
import 'minesweeper_engine.dart';
import 'minesweeper_storage.dart';

class MinesweeperController extends ChangeNotifier {
  final MinesweeperEngine _engine = MinesweeperEngine();
  AudioPlayer? _audioPlayer;
  final MinesweeperStorage _storage = MinesweeperStorage();
  
  Timer? _timer;
  int _elapsedTime = 0;
  int _flagsPlaced = 0;
  int _correctFlags = 0;
  bool _soundEnabled = true;

  NumberStyle _currentNumberStyle = NumberStyle.clasico;

  // Propiedades públicas
  List<List<CellModel>> get board => _engine.board;
  GameState get gameState => _engine.gameState;
  int get elapsedTime => _elapsedTime;
  int get remainingMines => _engine.difficulty.mineCount - _correctFlags;
  int get totalMines => _engine.difficulty.mineCount;  
  GameDifficulty get difficulty => _engine.difficulty;
  NumberStyle get currentNumberStyle => _currentNumberStyle;

  MinesweeperController() {
    _initStyle();
    _initAudio();
    startGame(GameDifficulty.easy);
  }

  Future<void> _initStyle() async {
    _currentNumberStyle = await _storage.getNumberStyle();
    notifyListeners();
  }

  void _initAudio() {
    _audioPlayer = AudioPlayer();
    _loadSoundSetting();
  }

  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sonido') ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sonido', enabled);
  }

  Future<void> updateNumberStyle(NumberStyle newStyle) async {
    if (_currentNumberStyle == newStyle) return;
    _currentNumberStyle = newStyle;
    notifyListeners();
    await _storage.saveNumberStyle(newStyle);
  }

  void startGame(GameDifficulty difficulty) {
    _stopTimer();
    _elapsedTime = 0;
    _flagsPlaced = 0;
    _correctFlags = 0;
    _engine.generateEmptyBoard(difficulty);
    notifyListeners();
  }

  Future<void> _playSound(String fileName) async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer?.play(AssetSource('audios/$fileName'));
    } catch (e) {
      if (kDebugMode) {
        print('Error al reproducir audio: $e');
      }
    }
  }

  Future<void> tapCell(int row, int col) async {
    // Si el juego ya terminó, no hacer nada
    if (gameState == GameState.won || gameState == GameState.lost) return;

    final wasIdle = gameState == GameState.idle;
    final wasRevealed = board[row][col].isRevealed;

    _engine.revealCell(row, col);

    if (wasIdle && gameState == GameState.playing) {
      _startTimer();
    }
    
    if (gameState == GameState.won) {
      _stopTimer();  // detener cronómetro al ganar
      _playSound('victory.wav');
      final esNuevoRecord = await _storage.saveHighScore(difficulty, _elapsedTime);
      notifyListeners();
      _onGameWon?.call(_elapsedTime, esNuevoRecord);
    } else if (gameState == GameState.lost) {
      _stopTimer();  // detener cronómetro al perder
      _playSound('defeat.wav');
      _onGameLost?.call();
    } else if (!wasRevealed && board[row][col].isRevealed) {
      _playSound('reveal.wav');
    }

    notifyListeners();
  }

  Function(int tiempo, bool esNuevoRecord)? _onGameWon;
  Function()? _onGameLost;

  void setOnGameWon(Function(int, bool) callback) {
    _onGameWon = callback;
  }

  void setOnGameLost(Function() callback) {
    _onGameLost = callback;
  }

  /// Poner/quitar bandera con límite 
  void flagCell(int row, int col) {
    // Si el juego ya terminó, no hacer nada
    if (gameState != GameState.playing) return;

    final cell = board[row][col];
    
    if (!cell.isRevealed) {
      final wasFlagged = cell.isFlagged;
      final tieneMina = cell.hasMine;
      
      // Si intenta poner una bandera y ya llegó al límite de minas, no permitir
      if (!wasFlagged && _flagsPlaced >= totalMines) {
        // No se puede poner más banderas que minas totales
        return;
      }
      
      _engine.toggleFlag(row, col);
      
      final isNowFlagged = board[row][col].isFlagged;
      
      if (wasFlagged != isNowFlagged) {
        if (isNowFlagged) {
          _flagsPlaced++;
          if (tieneMina) {
            _correctFlags++;
          }
          _playSound('flag.wav');
        } else {
          _flagsPlaced--;
          if (tieneMina) {
            _correctFlags--;
          }
          _playSound('flag.wav');
        }
        notifyListeners();
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Solo incrementar si el juego está activo
      if (gameState == GameState.playing) {
        _elapsedTime++;
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<List<HighScore>> loadHighScores(GameDifficulty difficulty) {
    return _storage.getHighScores(difficulty);
  }

  @override
  void dispose() {
    _stopTimer();
    _audioPlayer?.dispose();
    super.dispose();
  }
}