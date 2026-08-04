import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'game_models.dart';
import 'ludo_rules.dart';

enum TurnPhase { rolling, choosingToken, animating, gameOver }

/// Central mutable game state used by the offline / local-multiplayer game
/// screen. Broadcasts changes via [ChangeNotifier] to redraw the UI.
class LudoGameState extends ChangeNotifier {
  LudoGameState({
    required this.players,
    this.aiThinkDelay = const Duration(milliseconds: 700),
  }) {
    assert(players.length >= 2 && players.length <= 4);
    _currentSeat = 0;
  }

  final List<LudoPlayer> players;
  final Duration aiThinkDelay;
  final Random _rng = Random();

  int _currentSeat = 0;
  int? _lastDie;
  TurnPhase _phase = TurnPhase.rolling;
  int _sixesInARow = 0;
  final List<String> _log = [];
  int _coinsPot = 0;

  int get currentSeat => _currentSeat;
  LudoPlayer get currentPlayer => players[_currentSeat];
  int? get lastDie => _lastDie;
  TurnPhase get phase => _phase;
  List<String> get log => List.unmodifiable(_log);
  int get coinsPot => _coinsPot;

  bool get isCurrentAI => currentPlayer.kind == PlayerKind.ai;

  void setCoinsPot(int value) {
    _coinsPot = value;
    notifyListeners();
  }

  /// Roll the die for the current player.
  Future<void> rollDie() async {
    if (_phase != TurnPhase.rolling) return;
    _phase = TurnPhase.animating;
    notifyListeners();
    // brief dice animation delay
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final die = LudoRules.rollDie(_rng);
    _lastDie = die;
    _log.insert(0, '${currentPlayer.name} rolled $die');
    if (die == 6) {
      _sixesInARow++;
    } else {
      _sixesInARow = 0;
    }

    // Three consecutive 6s → forfeit turn (traditional variant rule)
    if (_sixesInARow >= 3) {
      _log.insert(0, '${currentPlayer.name}: three 6s → turn skipped');
      _sixesInARow = 0;
      _lastDie = null;
      _advanceSeat();
      _phase = TurnPhase.rolling;
      notifyListeners();
      return;
    }

    final canMove = LudoRules.hasAnyMove(currentPlayer, die);
    if (!canMove) {
      _log.insert(0, '${currentPlayer.name}: no legal move for $die');
      _lastDie = null;
      _advanceSeat();
      _phase = TurnPhase.rolling;
      notifyListeners();
      if (isCurrentAI) {
        scheduleMicrotask(_runAiTurn);
      }
      return;
    }
    _phase = TurnPhase.choosingToken;
    notifyListeners();
    if (isCurrentAI) {
      scheduleMicrotask(_pickAiToken);
    }
  }

  /// Human taps a token to move it.
  Future<void> selectToken(int tokenIdx) async {
    if (_phase != TurnPhase.choosingToken || _lastDie == null) return;
    if (!LudoRules.canMoveToken(currentPlayer, tokenIdx, _lastDie!)) return;
    await _executeMove(tokenIdx);
  }

  Future<void> _executeMove(int tokenIdx) async {
    _phase = TurnPhase.animating;
    notifyListeners();
    final die = _lastDie!;
    final beforePos = currentPlayer.tokens[tokenIdx];
    final captured = LudoRules.applyMove(
      current: currentPlayer,
      allPlayers: players,
      tokenIdx: tokenIdx,
      die: die,
    );
    final afterPos = currentPlayer.tokens[tokenIdx];
    final finished = afterPos == 58 && beforePos != 58;
    if (captured.isNotEmpty) {
      _log.insert(0,
          '${currentPlayer.name} captured ${captured.length} opponent token(s)');
    }
    if (finished) {
      _log.insert(0, '${currentPlayer.name} moved a token home');
    }

    // Game over?
    if (currentPlayer.finished) {
      _log.insert(0, '${currentPlayer.name} WINS!');
      _phase = TurnPhase.gameOver;
      _lastDie = null;
      notifyListeners();
      return;
    }

    final extra = LudoRules.earnsExtraTurn(die,
        captured: captured.isNotEmpty, finished: finished);
    _lastDie = null;
    if (!extra) {
      _advanceSeat();
    }
    _phase = TurnPhase.rolling;
    notifyListeners();

    if (isCurrentAI && _phase == TurnPhase.rolling) {
      await Future<void>.delayed(aiThinkDelay);
      await _runAiTurn();
    }
  }

  Future<void> _runAiTurn() async {
    if (_phase != TurnPhase.rolling || !isCurrentAI) return;
    await Future<void>.delayed(aiThinkDelay);
    await rollDie();
  }

  Future<void> _pickAiToken() async {
    if (_phase != TurnPhase.choosingToken || !isCurrentAI) return;
    await Future<void>.delayed(aiThinkDelay);
    final die = _lastDie!;
    final tokenIdx = _chooseBestAiToken(die);
    if (tokenIdx == null) {
      _advanceSeat();
      _phase = TurnPhase.rolling;
      _lastDie = null;
      notifyListeners();
      return;
    }
    await _executeMove(tokenIdx);
  }

  /// A lightweight heuristic AI:
  /// 1) finish a token if possible
  /// 2) capture if possible
  /// 3) launch from yard on a 6 if fewer than 2 tokens are out
  /// 4) otherwise move the token furthest along.
  int? _chooseBestAiToken(int die) {
    final legal = <int>[];
    for (var i = 0; i < 4; i++) {
      if (LudoRules.canMoveToken(currentPlayer, i, die)) legal.add(i);
    }
    if (legal.isEmpty) return null;

    // 1) finish
    for (final i in legal) {
      final p = currentPlayer.tokens[i];
      if (p != -1 && p + die == 58) return i;
    }
    // 2) capture: simulate to check
    for (final i in legal) {
      final snapshot = List<int>.from(currentPlayer.tokens);
      final beforeSum =
          _opponentActiveCount(exclude: currentPlayer.color);
      LudoRules.applyMove(
        current: currentPlayer,
        allPlayers: players,
        tokenIdx: i,
        die: die,
      );
      final afterSum =
          _opponentActiveCount(exclude: currentPlayer.color);
      // undo (best effort — no rollback of opponent tokens; approximate)
      currentPlayer.tokens
        ..clear()
        ..addAll(snapshot);
      if (afterSum < beforeSum) return i;
    }
    // 3) launch on 6
    if (die == 6) {
      final outCount =
          currentPlayer.tokens.where((p) => p >= 0 && p < 58).length;
      final yardIdx = currentPlayer.tokens.indexOf(-1);
      if (outCount < 2 && yardIdx != -1) return yardIdx;
    }
    // 4) furthest advanced
    legal.sort((a, b) =>
        (currentPlayer.tokens[b]).compareTo(currentPlayer.tokens[a]));
    return legal.first;
  }

  int _opponentActiveCount({required PlayerColor exclude}) {
    var n = 0;
    for (final p in players) {
      if (p.color == exclude) continue;
      n += p.activeTokens;
    }
    return n;
  }

  void _advanceSeat() {
    _currentSeat = (_currentSeat + 1) % players.length;
    _sixesInARow = 0;
  }
}
