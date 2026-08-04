import 'package:flutter/material.dart';

/// Central color/typography tokens matching the DRH LUDO reference mockup:
/// deep-navy background with gold accents, and four token colours
/// Red, Blue, Green, Yellow.
class AppTheme {
  static const Color bgDeep = Color(0xFF071634);
  static const Color bgPanel = Color(0xFF0E2456);
  static const Color bgCard = Color(0xFF102A63);
  static const Color gold = Color(0xFFFFC732);
  static const Color goldDark = Color(0xFFC98A00);

  // Ludo player colours
  static const Color red = Color(0xFFE23B3B);
  static const Color blue = Color(0xFF2D7BF4);
  static const Color green = Color(0xFF2FB84C);
  static const Color yellow = Color(0xFFF4C518);

  // Big-button gradients (top → bottom)
  static const orangeBtnTop = Color(0xFFFFA228);
  static const orangeBtnBot = Color(0xFFEA6A00);
  static const greenBtnTop = Color(0xFF3FE267);
  static const greenBtnBot = Color(0xFF10A233);
  static const blueBtnTop = Color(0xFF3FB0FF);
  static const blueBtn = Color(0xFF157DE0);
  static const blueBtnBot = Color(0xFF0B4CB8);
  static const purpleBtnTop = Color(0xFFB37AFF);
  static const purpleBtnBot = Color(0xFF6D2CD7);
  static const redBtnTop = Color(0xFFFF6A6A);
  static const redBtnBot = Color(0xFFC72424);

  static LinearGradient btnGradient(Color top, Color bot) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [top, bot],
      );

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A1E4B), Color(0xFF040B22)],
  );
}
