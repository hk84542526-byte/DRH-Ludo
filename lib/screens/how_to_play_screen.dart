import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/top_bar.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rules = [
      ('🎯', 'Objective',
          'Move all 4 of your tokens from the home base into the centre before your opponents do.'),
      ('🎲', 'Rolling',
          'Tap the dice on your turn. A 6 lets you launch a token out of the yard AND grants an extra turn.'),
      ('➡️', 'Moving',
          'Tokens move clockwise around the outer ring, then enter the home column matching your colour.'),
      ('🛡️', 'Safe Stars',
          'Cells marked with a star are safe — opponents cannot capture you there.'),
      ('⚔️', 'Capture',
          'Landing on an opponent\'s token (not on a safe star) sends it back to their yard.'),
      ('🏁', 'Finishing',
          'A token needs an EXACT roll to reach the centre. Overshooting is not allowed.'),
      ('⚠️', 'Three 6s',
          'Rolling three 6s in a row forfeits the turn — no free ride!'),
      ('🏆', 'Winning',
          'First player to get all four tokens home wins the coin pot.'),
    ];
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'HOW TO PLAY'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(14),
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemCount: rules.length,
                itemBuilder: (context, i) {
                  final r = rules[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.gold.withValues(alpha: .4)),
                    ),
                    child: Row(
                      children: [
                        Text(r.$1, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.$2,
                                  style: const TextStyle(
                                      color: AppTheme.gold,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15)),
                              const SizedBox(height: 3),
                              Text(r.$3,
                                  style: const TextStyle(
                                      color: Colors.white, height: 1.35)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
