enum GameDifficulty {
  easy,
  medium,
  hard;

  int get rows {
    switch (this) {
      case GameDifficulty.easy:
        return 6;
      case GameDifficulty.medium:
        return 8;
      case GameDifficulty.hard:
        return 10;
    }
  }

  int get cols {
    switch (this) {
      case GameDifficulty.easy:
        return 6;
      case GameDifficulty.medium:
        return 8;
      case GameDifficulty.hard:
        return 10;
    }
  }

  int get mineCount {
    switch (this) {
      case GameDifficulty.easy:
        return 10;
      case GameDifficulty.medium:
        return 20;
      case GameDifficulty.hard:
        return 30;
    }
  }
}

enum GameState {
  idle,
  playing,
  won,
  lost,
}

class CellModel {
  final int row;
  final int col;
  final bool hasMine;
  final bool isRevealed;
  final bool isFlagged;
  final int adjacentMines;

  const CellModel({
    required this.row,
    required this.col,
    this.hasMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.adjacentMines = 0,
  });

  CellModel copyWith({
    int? row,
    int? col,
    bool? hasMine,
    bool? isRevealed,
    bool? isFlagged,
    int? adjacentMines,
  }) {
    return CellModel(
      row: row ?? this.row,
      col: col ?? this.col,
      hasMine: hasMine ?? this.hasMine,
      isRevealed: isRevealed ?? this.isRevealed,
      isFlagged: isFlagged ?? this.isFlagged,
      adjacentMines: adjacentMines ?? this.adjacentMines,
    );
  }
}
