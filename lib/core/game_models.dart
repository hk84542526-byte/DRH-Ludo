import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Colours are also seat identifiers. Board rotation order is Red → Blue → Yellow → Green
/// (clockwise), which matches the reference image quadrants:
///   TL = Red, TR = Green, BR = Yellow, BL = Blue.
/// Turn order in a full 4-seat game is Red, Green, Yellow, Blue.
enum PlayerColor { red, green, yellow, blue }

extension PlayerColorX on PlayerColor {
  Color get uiColor {
    switch (this) {
      case PlayerColor.red:
        return AppTheme.red;
      case PlayerColor.green:
        return AppTheme.green;
      case PlayerColor.yellow:
        return AppTheme.yellow;
      case PlayerColor.blue:
        return AppTheme.blue;
    }
  }

  String get hindiName {
    switch (this) {
      case PlayerColor.red:
        return 'लाल';
      case PlayerColor.green:
        return 'हरा';
      case PlayerColor.yellow:
        return 'पीला';
      case PlayerColor.blue:
        return 'नीला';
    }
  }

  String get englishName {
    switch (this) {
      case PlayerColor.red:
        return 'Red';
      case PlayerColor.green:
        return 'Green';
      case PlayerColor.yellow:
        return 'Yellow';
      case PlayerColor.blue:
        return 'Blue';
    }
  }
}

enum PlayerKind { human, ai }

class LudoPlayer {
  final PlayerColor color;
  final String name;
  final PlayerKind kind;

  /// Position of each of the four tokens.
  /// -1 → still in home base (yard);
  /// 0..51 → position on shared outer ring (measured from the color's own start);
  /// 52..57 → 6 squares of home column;
  /// 58 → reached the centre (finished).
  final List<int> tokens;

  LudoPlayer({
    required this.color,
    required this.name,
    required this.kind,
    List<int>? tokens,
  }) : tokens = tokens ?? List<int>.filled(4, -1);

  bool get finished => tokens.every((t) => t == 58);
  int get finishedTokens => tokens.where((t) => t == 58).length;
  int get activeTokens =>
      tokens.where((t) => t >= 0 && t < 58).length;
}
