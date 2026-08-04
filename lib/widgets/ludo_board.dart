import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/board_paths.dart';
import '../core/game_models.dart';
import '../core/game_state.dart';
import '../core/ludo_rules.dart';

/// Draws the 15x15 Ludo board with quadrants, ring, home columns, safe
/// stars and centre triangle, then overlays player tokens.
class LudoBoard extends StatelessWidget {
  const LudoBoard({
    super.key,
    required this.state,
    required this.onTokenTap,
  });

  final LudoGameState state;
  final void Function(PlayerColor color, int tokenIdx) onTokenTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final side = box.maxWidth < box.maxHeight ? box.maxWidth : box.maxHeight;
      final cell = side / 15.0;
      return SizedBox(
        width: side,
        height: side,
        child: Stack(
          children: [
            CustomPaint(size: Size(side, side), painter: _BoardPainter()),
            ..._buildTokens(cell),
          ],
        ),
      );
    });
  }

  List<Widget> _buildTokens(double cell) {
    final widgets = <Widget>[];
    for (final p in state.players) {
      for (var t = 0; t < 4; t++) {
        final pos = p.tokens[t];
        final (row, col) = BoardPaths.positionOf(p.color, pos, yardIndex: t);
        // Slight offset when multiple tokens share the same cell
        final tokensHere = _countTokensAt(row, col);
        final idx = _indexAt(row, col, p.color, t);
        final ox = tokensHere > 1 ? (idx.isEven ? -0.15 : 0.15) : 0.0;
        final oy = tokensHere > 1 ? (idx < 2 ? -0.15 : 0.15) : 0.0;
        final die = state.lastDie;
        final canMove = die != null &&
            state.phase == TurnPhase.choosingToken &&
            state.currentPlayer.color == p.color &&
            LudoRules.canMoveToken(p, t, die);
        widgets.add(Positioned(
          left: (col + ox) * cell,
          top: (row + oy) * cell,
          width: cell,
          height: cell,
          child: GestureDetector(
            onTap: canMove ? () => onTokenTap(p.color, t) : null,
            child: _TokenIcon(color: p.color.uiColor, highlight: canMove),
          ),
        ));
      }
    }
    return widgets;
  }

  int _countTokensAt(int row, int col) {
    var n = 0;
    for (final p in state.players) {
      for (var t = 0; t < 4; t++) {
        final pos = p.tokens[t];
        final (r, c) = BoardPaths.positionOf(p.color, pos, yardIndex: t);
        if (r == row && c == col) n++;
      }
    }
    return n;
  }

  int _indexAt(int row, int col, PlayerColor pc, int tIdx) {
    var n = 0;
    for (final p in state.players) {
      for (var t = 0; t < 4; t++) {
        final pos = p.tokens[t];
        final (r, c) = BoardPaths.positionOf(p.color, pos, yardIndex: t);
        if (r == row && c == col) {
          if (p.color == pc && t == tIdx) return n;
          n++;
        }
      }
    }
    return n;
  }
}

class _TokenIcon extends StatelessWidget {
  const _TokenIcon({required this.color, required this.highlight});
  final Color color;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: .95), color.withValues(alpha: .7)],
          ),
          border: Border.all(
            color: highlight ? Colors.white : Colors.black54,
            width: highlight ? 2.5 : 1.4,
          ),
          boxShadow: [
            if (highlight)
              BoxShadow(
                color: Colors.white.withValues(alpha: .9),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.circle, color: Colors.white, size: 6),
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  static const Map<PlayerColor, (int, int)> _quadTopLeft = {
    PlayerColor.red: (0, 0),
    PlayerColor.green: (0, 9),
    PlayerColor.yellow: (9, 9),
    PlayerColor.blue: (9, 0),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 15.0;
    final bg = Paint()..color = Colors.white;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(8)),
        bg);

    // Coloured 6x6 base quadrants
    for (final entry in _quadTopLeft.entries) {
      final color = entry.key.uiColor;
      final (r, c) = entry.value;
      final rect =
          Rect.fromLTWH(c * cell, r * cell, cell * 6, cell * 6);
      canvas.drawRect(rect, Paint()..color = color);
      // Inner white pad
      final pad = Rect.fromLTWH(
          (c + 1) * cell, (r + 1) * cell, cell * 4, cell * 4);
      canvas.drawRect(pad, Paint()..color = Colors.white);
      // Yard slots (4 coloured circles)
      for (final slot in BoardPaths.yardSlots[entry.key]!) {
        final (yr, yc) = slot;
        final center =
            Offset((yc + 0.5) * cell, (yr + 0.5) * cell);
        canvas.drawCircle(
            center, cell * 0.42, Paint()..color = color.withValues(alpha: .18));
        canvas.drawCircle(
            center, cell * 0.42, Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
      }
    }

    // Draw shared ring cells
    final gridPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for (var i = 0; i < BoardPaths.ring.length; i++) {
      final (r, c) = BoardPaths.ring[i];
      final rect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
      canvas.drawRect(rect, Paint()..color = Colors.white);
      canvas.drawRect(rect, gridPaint);
    }

    // Colour the starting cells and safe stars
    for (final entry in LudoRules.startCell.entries) {
      final (r, c) = BoardPaths.ring[entry.value];
      final rect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
      canvas.drawRect(rect, Paint()..color = entry.key.uiColor.withValues(alpha: .35));
    }
    for (final cellIdx in LudoRules.safeCells) {
      final (r, c) = BoardPaths.ring[cellIdx];
      _drawStar(canvas, Offset((c + 0.5) * cell, (r + 0.5) * cell), cell * 0.32);
    }

    // Home columns (coloured strip toward centre)
    for (final entry in BoardPaths.homeColumn.entries) {
      for (final (r, c) in entry.value) {
        final rect = Rect.fromLTWH(c * cell, r * cell, cell, cell);
        canvas.drawRect(rect, Paint()..color = entry.key.uiColor);
        canvas.drawRect(rect, gridPaint);
      }
    }

    // Centre triangle (finish area)
    _drawCenter(canvas, cell);
  }

  void _drawStar(Canvas canvas, Offset center, double r) {
    final paint = Paint()..color = Colors.black87;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -3.14159 / 2 + i * 3.14159 / 5;
      final radius = i.isEven ? r : r * 0.4;
      final x = center.dx + radius * mathCos(angle);
      final y = center.dy + radius * mathSin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCenter(Canvas canvas, double cell) {
    final cx = 7.5 * cell;
    final cy = 7.5 * cell;
    final size = cell * 3;
    final left = cx - size / 2;
    final top = cy - size / 2;
    final rect = Rect.fromLTWH(left, top, size, size);
    canvas.drawRect(rect, Paint()..color = Colors.white);
    // Four coloured triangles meeting at centre.
    final triangles = <(PlayerColor, List<Offset>)>[
      (PlayerColor.red,
          [rect.topLeft, rect.centerLeft, Offset(cx, cy)]),
      (PlayerColor.green,
          [rect.topLeft, rect.topCenter, Offset(cx, cy)]),
      (PlayerColor.yellow,
          [rect.topCenter, rect.topRight, Offset(cx, cy)]),
      (PlayerColor.blue,
          [rect.bottomLeft, rect.centerLeft, Offset(cx, cy)]),
    ];
    final full = <(PlayerColor, List<Offset>)>[
      (PlayerColor.red, [rect.topLeft, Offset(cx, cy), rect.bottomLeft]),
      (PlayerColor.green, [rect.topLeft, Offset(cx, cy), rect.topRight]),
      (PlayerColor.yellow, [rect.topRight, Offset(cx, cy), rect.bottomRight]),
      (PlayerColor.blue, [rect.bottomLeft, Offset(cx, cy), rect.bottomRight]),
    ];
    for (final t in full) {
      final path = Path()..moveTo(t.$2[0].dx, t.$2[0].dy);
      for (var i = 1; i < t.$2.length; i++) {
        path.lineTo(t.$2[i].dx, t.$2[i].dy);
      }
      path.close();
      canvas.drawPath(path, Paint()..color = t.$1.uiColor);
    }
    // ignore: unused_local_variable
    final _ = triangles;
    // Gold star at centre
    _drawStar(
        canvas, Offset(cx, cy), cell * 0.65)
      ;
    canvas.drawCircle(Offset(cx, cy), cell * 0.35, Paint()..color = AppTheme.gold);
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) => false;
}

double mathCos(double a) => _fastCos(a);
double mathSin(double a) => _fastSin(a);
double _fastCos(double a) {
  return _polyCos(a);
}

double _fastSin(double a) => _polyCos(a - 1.57079632679);
double _polyCos(double a) {
  // Reduce to -pi..pi
  const twoPi = 6.28318530718;
  a = a % twoPi;
  if (a > 3.14159265359) a -= twoPi;
  if (a < -3.14159265359) a += twoPi;
  final a2 = a * a;
  return 1 - a2 / 2 + a2 * a2 / 24 - a2 * a2 * a2 / 720;
}
