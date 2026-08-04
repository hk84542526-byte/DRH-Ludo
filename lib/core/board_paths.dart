import 'game_models.dart';

/// Maps every logical position of every colour to a (row, col) on a 15×15
/// board grid. This is the classical Ludo layout used across popular apps.
///
/// Grid coordinates:  row 0 = top,  col 0 = left,  values in 0..14.
///
/// Ring cells are numbered 0..51 clockwise, starting from the RED start
/// square (row 6, col 1). Home columns are 6 cells each, leading into the
/// centre (7,7).
class BoardPaths {
  /// The shared clockwise outer ring (52 cells).
  static const List<(int, int)> ring = [
    // Red start (index 0) -> up along the left cross
    (6, 1), (6, 2), (6, 3), (6, 4), (6, 5),
    (5, 6), (4, 6), (3, 6), (2, 6), (1, 6), (0, 6),
    (0, 7),
    // Green start entry (index 12)
    (0, 8),
    (1, 8), (2, 8), (3, 8), (4, 8), (5, 8),
    (6, 9), (6, 10), (6, 11), (6, 12), (6, 13), (6, 14),
    (7, 14),
    // Yellow start entry (index 25)
    (8, 14),
    (8, 13), (8, 12), (8, 11), (8, 10), (8, 9),
    (9, 8), (10, 8), (11, 8), (12, 8), (13, 8), (14, 8),
    (14, 7),
    // Blue start entry (index 38)
    (14, 6),
    (13, 6), (12, 6), (11, 6), (10, 6), (9, 6),
    (8, 5), (8, 4), (8, 3), (8, 2), (8, 1), (8, 0),
    (7, 0),
    // back to Red start via (6,0)
    (6, 0),
  ];

  /// Home column (6 cells) leading into the centre for each colour.
  /// Index 52..57 in the token position corresponds to homeColumn[color][0..5].
  static const Map<PlayerColor, List<(int, int)>> homeColumn = {
    PlayerColor.red: [
      (7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6),
    ],
    PlayerColor.green: [
      (1, 7), (2, 7), (3, 7), (4, 7), (5, 7), (6, 7),
    ],
    PlayerColor.yellow: [
      (7, 13), (7, 12), (7, 11), (7, 10), (7, 9), (7, 8),
    ],
    PlayerColor.blue: [
      (13, 7), (12, 7), (11, 7), (10, 7), (9, 7), (8, 7),
    ],
  };

  /// The four yard "slots" (four tokens per colour) displayed inside each
  /// coloured base square.
  static const Map<PlayerColor, List<(int, int)>> yardSlots = {
    PlayerColor.red: [(1, 1), (1, 4), (4, 1), (4, 4)],
    PlayerColor.green: [(1, 10), (1, 13), (4, 10), (4, 13)],
    PlayerColor.yellow: [(10, 10), (10, 13), (13, 10), (13, 13)],
    PlayerColor.blue: [(10, 1), (10, 4), (13, 1), (13, 4)],
  };

  /// The centre square (all tokens converge here on finish).
  static const (int, int) center = (7, 7);

  /// For a colour, convert a token's local position (as stored) to a (row,col).
  /// -1 → yard slot index must be supplied via [yardIndex].
  static (int, int) positionOf(PlayerColor color, int pos, {int yardIndex = 0}) {
    if (pos == -1) return yardSlots[color]![yardIndex];
    if (pos < 52) {
      final start = _startIndex(color);
      return ring[(start + pos) % 52];
    }
    if (pos < 58) return homeColumn[color]![pos - 52];
    return center;
  }

  static int _startIndex(PlayerColor color) {
    switch (color) {
      case PlayerColor.red:
        return 0;
      case PlayerColor.green:
        return 13;
      case PlayerColor.yellow:
        return 26;
      case PlayerColor.blue:
        return 39;
    }
  }

  /// Cells that should be drawn with a coloured "star" (safe) marker.
  /// These are traditional star cells (colour-start cells + midway squares).
  static const List<(int, int)> starCells = [
    (6, 2),   // near red start
    (8, 12),  // near yellow start
    (2, 6),   // between red-green
    (12, 8),  // between yellow-blue
    (6, 1),   // red start
    (1, 8),   // green start
    (8, 13),  // yellow start
    (13, 6),  // blue start
  ];
}
