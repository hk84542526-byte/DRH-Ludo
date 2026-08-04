import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/wallet.dart';
import '../widgets/top_bar.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = Wallet.instance.playerName;
    final myCoins = Wallet.instance.coins;
    final rows = <(int, String, int)>[
      (1, 'Arjun',    120500),
      (2, 'Priya',    98450),
      (3, 'Rahul',    87200),
      (4, 'Neha',     71100),
      (5, me,         myCoins),
      (6, 'Amit',     54000),
      (7, 'Zara',     41250),
      (8, 'Kabir',    30800),
    ]..sort((a, b) => b.$3.compareTo(a.$3));

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'LEADERBOARD'),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemCount: rows.length,
                itemBuilder: (context, i) {
                  final r = rows[i];
                  final isMe = r.$2 == me;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppTheme.blueBtn.withValues(alpha: .35)
                          : AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isMe
                              ? AppTheme.gold
                              : AppTheme.gold.withValues(alpha: .2),
                          width: isMe ? 1.6 : 1),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              i < 3 ? AppTheme.gold : AppTheme.bgDeep,
                          child: Text('${i + 1}',
                              style: TextStyle(
                                  color: i < 3
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(r.$2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: isMe
                                      ? FontWeight.w800
                                      : FontWeight.w600)),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: AppTheme.gold, size: 18),
                            const SizedBox(width: 4),
                            Text('${r.$3}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ],
                        )
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
