import 'dart:math';

import 'game_models.dart';

/// Pure game-logic layer for a classical 4-colour Ludo:
/// 15×15 grid, shared 52-cell outer ring, 6-cell coloured home column,
/// safe stars, capture-back-to-yard, six-doubles, three-sixes forfeit,
/// exact-to-finish rule.
///
/// A single "position index" is used in [LudoPlayer.tokens]:
///   -1 → in the yard (base)
///   0..51 → outer ring, measured from THIS player's own start cell
///   52..57 → 6 home-column squares
///   58 → reached the centre (finished)
class LudoRules {
  /// Board-absolute start cell (0..51) for each colour on the shared ring.
  /// Order round the ring: Red (0) → Green (13) → Yellow (26) → Blue (39).
  static const Map<PlayerColor, int> startCell = {
    PlayerColor.red: 0,
    PlayerColor.green: 13,
    PlayerColor.yellow: 26,
    PlayerColor.blue: 39,
  };

  /// Traditional "star / safe" squares on the shared ring (board-absolute).
  /// A token sitting on one of these cannot be captured.
  static const Set<int> safeCells = {0, 8, 13, 21, 26, 34, 39, 47};

  /// Fixed turn order (clockwise around the board), independent of seat count.
  static const List<PlayerColor> turnOrder = [
    PlayerColor.red,
    PlayerColor.green,
    PlayerColor.yellow,
    PlayerColor.blue,
  ];

  /// Convert a token's local position (as stored in [LudoPlayer.tokens]) to a
  /// board-absolute ring cell 0..51, or null if the token is in the yard or
  /// already inside its home column / centre.
  static int? absoluteRingCell(PlayerColor color, int local) {
    if (local < 0 || local >= 52) return null;
    return (startCell[color]! + local) % 52;
  }

  /// Roll a single fair d6.
  static int rollDie([Random? rng]) => (rng ?? Random()).nextInt(6) + 1;

  /// Can this token legally move by [die] pips?
  static bool canMoveToken(LudoPlayer p, int tokenIdx, int die) {
    final pos = p.tokens[tokenIdx];
    if (pos == 58) return false; // already finished
    if (pos == -1) return die == 6; // only a 6 leaves the yard
    // exact-to-finish
    return pos + die <= 58;
  }

  /// Does this player have ANY legal move for this die?
  static bool hasAnyMove(LudoPlayer p, int die) {
    for (var i = 0; i < 4; i++) {
      if (canMoveToken(p, i, die)) return true;
    }
    return false;
  }

  /// Apply a move for [tokenIdx] of [current], given the whole seated list.
  /// Returns the list of (opponentColor, opponentTokenIdx) tokens that were
  /// captured back to their yard as a side effect of this move.
  static List<(PlayerColor, int)> applyMove({
    required LudoPlayer current,
    required List<LudoPlayer> allPlayers,
    required int tokenIdx,
    required int die,
  }) {
    assert(canMoveToken(current, tokenIdx, die));
    final captured = <(PlayerColor, int)>[];
    final oldPos = current.tokens[tokenIdx];
    int newPos;
    if (oldPos == -1) {
      newPos = 0; // enter start cell on a 6
    } else {
      newPos = oldPos + die;
    }
    current.tokens[tokenIdx] = newPos;

    // Capture check only applies while still on the shared ring.
    if (newPos < 52) {
      final absLanding = absoluteRingCell(current.color, newPos)!;
      final isSafe = safeCells.contains(absLanding);
      if (!isSafe) {
        for (final opp in allPlayers) {
          if (opp.color == current.color) continue;
          for (var i = 0; i < 4; i++) {
            final oppPos = opp.tokens[i];
            if (oppPos < 0 || oppPos >= 52) continue;
            final oppAbs = absoluteRingCell(opp.color, oppPos)!;
            if (oppAbs == absLanding) {
              opp.tokens[i] = -1; // send back to yard
              captured.add((opp.color, i));
            }
          }
        }
      }
    }
    return captured;
  }

  /// A player earns an extra turn on a 6, on capture, or on finishing a token.
  static bool earnsExtraTurn(int die, {required bool captured, required bool finished}) {
    return die == 6 || captured || finished;
  }
}
