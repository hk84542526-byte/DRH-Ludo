import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/game_models.dart';
import '../widgets/gradient_button.dart';
import '../widgets/top_bar.dart';
import 'game_screen.dart';

/// Pass-and-play setup: choose player count (2/3/4) and which colours are
/// human vs computer.
class LocalMultiplayerSetup extends StatefulWidget {
  const LocalMultiplayerSetup({super.key});
  @override
  State<LocalMultiplayerSetup> createState() => _LocalMultiplayerSetupState();
}

class _LocalMultiplayerSetupState extends State<LocalMultiplayerSetup> {
  int _count = 4;
  final Map<PlayerColor, PlayerKind> _kinds = {
    PlayerColor.red: PlayerKind.human,
    PlayerColor.green: PlayerKind.human,
    PlayerColor.yellow: PlayerKind.human,
    PlayerColor.blue: PlayerKind.human,
  };

  List<PlayerColor> get _seated {
    // Traditional 2/3/4-player Ludo uses the diagonals for a 2-player game.
    if (_count == 2) return [PlayerColor.red, PlayerColor.yellow];
    if (_count == 3) return [PlayerColor.red, PlayerColor.green, PlayerColor.yellow];
    return PlayerColor.values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'LOCAL MULTIPLAYER'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('Number of Players',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700)),
                    ),
                    Row(
                      children: [
                        for (final n in [2, 3, 4])
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () => setState(() => _count = n),
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _count == n
                                        ? AppTheme.blueBtn
                                        : AppTheme.bgCard,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppTheme.gold
                                            .withValues(alpha: .4)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('$n PLAYERS',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Assign Seats',
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    for (final c in _seated) _seatRow(c),
                    const SizedBox(height: 24),
                    GradientButton(
                      label: 'START GAME',
                      subtitle: 'Roll the dice and win!',
                      icon: Icons.play_arrow,
                      gradientTop: AppTheme.greenBtnTop,
                      gradientBot: AppTheme.greenBtnBot,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => GameScreen.local(
                              seatOrder: _seated,
                              kinds: {for (final c in _seated) c: _kinds[c]!},
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatRow(PlayerColor c) {
    final kind = _kinds[c]!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.uiColor.withValues(alpha: .8), width: 1.4),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
                color: c.uiColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2)),
          ),
          const SizedBox(width: 10),
          Text('${c.englishName} (${c.hindiName})',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          const Spacer(),
          ToggleButtons(
            isSelected: [
              kind == PlayerKind.human,
              kind == PlayerKind.ai,
            ],
            onPressed: (i) => setState(() => _kinds[c] =
                i == 0 ? PlayerKind.human : PlayerKind.ai),
            borderRadius: BorderRadius.circular(8),
            fillColor: AppTheme.blueBtn,
            selectedColor: Colors.white,
            color: Colors.white70,
            constraints: const BoxConstraints(minHeight: 32, minWidth: 60),
            children: const [Text('Human'), Text('AI')],
          )
        ],
      ),
    );
  }
}
