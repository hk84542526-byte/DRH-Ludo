import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Big glossy gradient button used across the main menu / online lobby / room
/// creation screens (matches the reference mockup buttons).
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.gradientTop,
    required this.gradientBot,
    required this.onTap,
    this.height = 68,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color gradientTop;
  final Color gradientBot;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: AppTheme.btnGradient(gradientTop, gradientBot),
              border: Border.all(color: Colors.white24, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: gradientBot.withValues(alpha: .55),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            )),
                        Text(subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .85),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SmallIconButton extends StatelessWidget {
  const SmallIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: (color ?? AppTheme.bgCard),
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Icon(icon, color: Colors.white, size: 26),
                  const SizedBox(height: 6),
                  Text(label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DrhLogo extends StatelessWidget {
  const DrhLogo({super.key, this.size = 46});
  final double size;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _letter('D', AppTheme.gold, size),
        _letter('R', AppTheme.red, size),
        _letter('H', AppTheme.green, size),
        SizedBox(width: size * 0.18),
        _letter('L', AppTheme.red, size),
        _letter('U', AppTheme.blue, size),
        _letter('D', AppTheme.green, size),
        _letter('O', AppTheme.yellow, size),
      ],
    );
  }

  Widget _letter(String c, Color color, double size) {
    return Text(
      c,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w900,
        height: 1.0,
        shadows: const [
          Shadow(offset: Offset(1, 2), color: Colors.black54, blurRadius: 2),
        ],
      ),
    );
  }
}
