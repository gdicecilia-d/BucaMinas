import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'board_models.dart';

class HighScore {
  final int duration;
  final DateTime date;

  HighScore({required this.duration, required this.date});

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'date': date.toIso8601String(),
      };

  factory HighScore.fromJson(Map<String, dynamic> json) => HighScore(
        duration: json['duration'] as int,
        date: DateTime.parse(json['date'] as String),
      );
}

class MinesweeperStorage {
  static const String _difficultyKey = 'default_difficulty';
  static const String _highScoresPrefix = 'high_scores_';

  /// Obtiene la instancia de SharedPreferences
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Guarda la dificultad por defecto
  Future<void> saveDefaultDifficulty(GameDifficulty difficulty) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_difficultyKey, difficulty.name);
    } catch (e) {
      // Manejo básico de excepciones
      print('Error al guardar la dificultad por defecto: $e');
    }
  }

  /// Obtiene la dificultad por defecto, retorna 'easy' si no hay una guardada o hay error
  Future<GameDifficulty> getDefaultDifficulty() async {
    try {
      final prefs = await _getPrefs();
      final difficultyName = prefs.getString(_difficultyKey);
      
      if (difficultyName != null) {
        return GameDifficulty.values.firstWhere(
          (d) => d.name == difficultyName,
          orElse: () => GameDifficulty.easy,
        );
      }
    } catch (e) {
      print('Error al obtener la dificultad por defecto: $e');
    }
    return GameDifficulty.easy;
  }

  /// Guarda un nuevo récord si es lo suficientemente bueno para entrar al Top 5
  Future<void> saveHighScore(GameDifficulty difficulty, int seconds) async {
    try {
      final prefs = await _getPrefs();
      final key = '$_highScoresPrefix${difficulty.name}';
      
      // 1. Obtener la lista actual de récords
      List<HighScore> scores = await getHighScores(difficulty);
      
      // 2. Agregar el nuevo récord
      scores.add(HighScore(duration: seconds, date: DateTime.now()));
      
      // 3. Ordenar de menor a mayor tiempo
      scores.sort((a, b) => a.duration.compareTo(b.duration));
      
      // 4. Truncar la lista a un máximo de 5 elementos
      if (scores.length > 5) {
        scores = scores.sublist(0, 5);
      }
      
      // 5. Convertir a String JSON y guardar
      final List<Map<String, dynamic>> jsonList = scores.map((s) => s.toJson()).toList();
      await prefs.setString(key, jsonEncode(jsonList));
    } catch (e) {
      print('Error al guardar el récord: $e');
    }
  }

  /// Retorna la lista ordenada de los 5 mejores tiempos para la dificultad dada
  Future<List<HighScore>> getHighScores(GameDifficulty difficulty) async {
    try {
      final prefs = await _getPrefs();
      final key = '$_highScoresPrefix${difficulty.name}';
      final scoresString = prefs.getString(key);
      
      if (scoresString != null) {
        final List<dynamic> decodedList = jsonDecode(scoresString);
        final scores = decodedList.map((json) => HighScore.fromJson(json)).toList();
        
        // Aseguramos que retorne ordenado en caso de manipulación externa
        scores.sort((a, b) => a.duration.compareTo(b.duration));
        return scores;
      }
    } catch (e) {
      print('Error al obtener los récords: $e');
    }
    return [];
  }
}
