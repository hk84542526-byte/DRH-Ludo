import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/wallet.dart';
import '../widgets/gradient_button.dart';
import '../widgets/top_bar.dart';
import 'game_screen.dart';
import 'local_multiplayer_setup.dart';
import 'online_mode_screen.dart';
import 'settings_screen.dart';
import 'store_screen.dart';
import 'how_to_play_screen.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(
              onSettings: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DrhLogo(size: 40),
            ),
            const SizedBox(height: 4),
            const Text('★ खेलो और बनो LUDO चैंपियन! ★',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    GradientButton(
                      label: 'OFFLINE',
                      subtitle: 'VS COMPUTER (AI)',
                      icon: Icons.smart_toy,
                      gradientTop: AppTheme.orangeBtnTop,
                      gradientBot: AppTheme.orangeBtnBot,
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => GameScreen.vsComputer())),
                    ),
                    GradientButton(
                      label: 'LOCAL MULTIPLAYER',
                      subtitle: '2 - 4 PLAYERS · एक ही मोबाइल पर खेलें',
                      icon: Icons.group,
                      gradientTop: AppTheme.greenBtnTop,
                      gradientBot: AppTheme.greenBtnBot,
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const LocalMultiplayerSetup())),
                    ),
                    GradientButton(
                      label: 'ONLINE PLAY',
                      subtitle: 'PLAY WITH FRIENDS (Coming Soon)',
                      icon: Icons.public,
                      gradientTop: AppTheme.blueBtnTop,
                      gradientBot: AppTheme.blueBtnBot,
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const OnlineModeScreen())),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SmallIconButton(
                          icon: Icons.emoji_events,
                          label: 'LEADERBOARD',
                          color: AppTheme.purpleBtnBot,
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const LeaderboardScreen())),
                        ),
                        SmallIconButton(
                          icon: Icons.shopping_cart,
                          label: 'STORE',
                          color: AppTheme.orangeBtnBot,
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const StoreScreen())),
                        ),
                        SmallIconButton(
                          icon: Icons.card_giftcard,
                          label: 'DAILY REWARD',
                          color: AppTheme.blueBtn,
                          onTap: () => _claimDaily(context),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SmallIconButton(
                          icon: Icons.menu_book,
                          label: 'HOW TO PLAY',
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const HowToPlayScreen())),
                        ),
                        SmallIconButton(
                          icon: Icons.share,
                          label: 'SHARE',
                          onTap: () => _showSnack(
                              context, 'Share DRH LUDO with friends!'),
                        ),
                        SmallIconButton(
                          icon: Icons.star,
                          label: 'RATE US',
                          onTap: () => _showSnack(
                              context, 'Rate DRH LUDO on the Play Store ⭐'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _FeaturesPanel(),
                    const SizedBox(height: 16),
                    _TokenLegend(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _claimDaily(BuildContext context) async {
    if (!Wallet.instance.dailyAvailable) {
      _showSnack(context,
          'Daily reward already claimed today. Come back tomorrow!');
      return;
    }
    final coins = await Wallet.instance.claimDaily();
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgPanel,
        title: const Text('🎁 Daily Reward',
            style: TextStyle(color: Colors.white)),
        content: Text('You received $coins coins!',
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK')),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }
}

class _FeaturesPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.group, '2 - 4 खिलाड़ी', 'एक ही मोबाइल पर खेलें'),
      (Icons.smart_toy, 'कंप्यूटर (AI)', 'के साथ खेलें'),
      (Icons.public, 'दोस्तों के साथ', 'ऑनलाइन खेलें'),
      (Icons.shield_moon, 'प्राइवेट रूम', 'बनाकर खेलें'),
      (Icons.casino, 'रियल पासा', '(Dice) सिस्टम'),
      (Icons.emoji_events, 'जीतने पर सिक्के', 'और इनाम पाएं'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.gold.withValues(alpha: .5)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: AppTheme.gold, size: 16),
              SizedBox(width: 6),
              Text('FEATURES',
                  style: TextStyle(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
              SizedBox(width: 6),
              Icon(Icons.star, color: AppTheme.gold, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.bgDeep,
                    radius: 15,
                    child: Icon(item.$1, size: 16, color: AppTheme.gold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        children: [
                          TextSpan(
                              text: '${item.$2}   ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: item.$3,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TokenLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      (AppTheme.red, 'लाल'),
      (AppTheme.blue, 'नीला'),
      (AppTheme.green, 'हरा'),
      (AppTheme.yellow, 'पीला'),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final t in items)
          Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: t.$1,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              const SizedBox(height: 4),
              Text(t.$2, style: const TextStyle(color: Colors.white)),
            ],
          ),
      ],
    );
  }
}
