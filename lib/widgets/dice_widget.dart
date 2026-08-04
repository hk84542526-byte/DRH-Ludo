import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// A tappable 3D-ish dice that shakes / rolls between values.
class DiceWidget extends StatefulWidget {
  const DiceWidget({
    super.key,
    required this.value,
    required this.onTap,
    required this.rolling,
    this.enabled = true,
    this.size = 62,
  });

  final int? value;
  final bool rolling;
  final bool enabled;
  final double size;
  final VoidCallback onTap;

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final _rng = Random();
  int _face = 1;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
          ..addListener(() {
            if (_ctrl.isAnimating) {
              setState(() => _face = _rng.nextInt(6) + 1);
            }
          });
    _face = widget.value ?? 1;
  }

  @override
  void didUpdateWidget(covariant DiceWidget old) {
    super.didUpdateWidget(old);
    if (widget.rolling && !_ctrl.isAnimating) {
      _ctrl.forward(from: 0).then((_) {
        if (mounted) setState(() => _face = widget.value ?? _face);
      });
    } else if (!widget.rolling && widget.value != null) {
      _face = widget.value!;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFDDE6F0)],
          ),
          border: Border.all(
              color: widget.enabled ? AppTheme.gold : Colors.grey, width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ],
        ),
        child: CustomPaint(painter: _DiceFacePainter(_face)),
      ),
    );
  }
}

class _DiceFacePainter extends CustomPainter {
  _DiceFacePainter(this.face);
  final int face;

  static const positions = {
    1: [Offset(0.5, 0.5)],
    2: [Offset(0.25, 0.25), Offset(0.75, 0.75)],
    3: [Offset(0.25, 0.25), Offset(0.5, 0.5), Offset(0.75, 0.75)],
    4: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
    5: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.5, 0.5),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
    6: [
      Offset(0.25, 0.25),
      Offset(0.75, 0.25),
      Offset(0.25, 0.5),
      Offset(0.75, 0.5),
      Offset(0.25, 0.75),
      Offset(0.75, 0.75),
    ],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0B1B3D);
    final r = size.shortestSide * 0.08;
    for (final o in positions[face]!) {
      canvas.drawCircle(
          Offset(o.dx * size.width, o.dy * size.height), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DiceFacePainter old) => old.face != face;
}
