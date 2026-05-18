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
  static const String _numberStyleKey = 'number_style';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveDefaultDifficulty(GameDifficulty difficulty) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_difficultyKey, difficulty.name);
    } catch (e) {
      print('Error al guardar la dificultad por defecto: $e');
    }
  }

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

  Future<void> saveNumberStyle(NumberStyle style) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_numberStyleKey, style.name);
    } catch (e) {
      print('Error al guardar el estilo de números: $e');
    }
  }

  Future<NumberStyle> getNumberStyle() async {
    try {
      final prefs = await _getPrefs();
      final styleName = prefs.getString(_numberStyleKey);
      
      if (styleName != null) {
        return NumberStyle.values.firstWhere(
          (s) => s.name == styleName,
          orElse: () => NumberStyle.clasico,
        );
      }
    } catch (e) {
      print('Error al obtener el estilo de números: $e');
    }
    return NumberStyle.clasico;
  }

  /// Guarda un nuevo récord. True si es nuevo récord (entró al top 5)
  Future<bool> saveHighScore(GameDifficulty difficulty, int seconds) async {
    try {
      final prefs = await _getPrefs();
      final key = '$_highScoresPrefix${difficulty.name}';
      
      List<HighScore> scores = await getHighScores(difficulty);
      
      // Verifica si es mejor que el peor del top 5
      if (scores.length >= 5) {
        scores.sort((a, b) => a.duration.compareTo(b.duration));
        final worstScore = scores.last.duration;
        if (seconds >= worstScore && scores.length >= 5) {
          return false;
        }
      }
      
      scores.add(HighScore(duration: seconds, date: DateTime.now()));
      scores.sort((a, b) => a.duration.compareTo(b.duration));
      
      if (scores.length > 5) {
        scores = scores.sublist(0, 5);
      }
      
      final List<Map<String, dynamic>> jsonList = scores.map((s) => s.toJson()).toList();
      await prefs.setString(key, jsonEncode(jsonList));
      
      return true;
    } catch (e) {
      print('Error al guardar el récord: $e');
      return false;
    }
  }

  Future<List<HighScore>> getHighScores(GameDifficulty difficulty) async {
    try {
      final prefs = await _getPrefs();
      final key = '$_highScoresPrefix${difficulty.name}';
      final scoresString = prefs.getString(key);
      
      if (scoresString != null) {
        final List<dynamic> decodedList = jsonDecode(scoresString);
        final scores = decodedList.map((json) => HighScore.fromJson(json)).toList();
        scores.sort((a, b) => a.duration.compareTo(b.duration));
        return scores;
      }
    } catch (e) {
      print('Error al obtener los récords: $e');
    }
    return [];
  }

  Future<void> clearAllHighScores() async {
    try {
      final prefs = await _getPrefs();
      for (var d in GameDifficulty.values) {
        await prefs.remove('$_highScoresPrefix${d.name}');
      }
    } catch (e) {
      print('Error al borrar los récords: $e');
    }
  }
}