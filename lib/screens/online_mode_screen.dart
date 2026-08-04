import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/top_bar.dart';
import 'create_room_screen.dart';
import 'join_room_screen.dart';

/// The Online Mode lobby (mirrors the second panel in the reference mockup).
/// Full Firebase-based online play will be added in the next update; this
/// screen shows the intended flow (Quick Play / Create Room / Join Room /
/// Friends) so the finished app already ships with the correct navigation.
class OnlineModeScreen extends StatelessWidget {
  const OnlineModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'ONLINE MODE'),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    GradientButton(
                      label: 'QUICK PLAY',
                      subtitle: 'PLAY WITH RANDOM PLAYER',
                      icon: Icons.flash_on,
                      gradientTop: AppTheme.purpleBtnTop,
                      gradientBot: AppTheme.purpleBtnBot,
                      onTap: () => _comingSoon(context, 'Quick Play matchmaking'),
                    ),
                    GradientButton(
                      label: 'CREATE ROOM',
                      subtitle: 'CREATE PRIVATE ROOM',
                      icon: Icons.add_box,
                      gradientTop: AppTheme.greenBtnTop,
                      gradientBot: AppTheme.greenBtnBot,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const CreateRoomScreen()),
                      ),
                    ),
                    GradientButton(
                      label: 'JOIN ROOM',
                      subtitle: 'JOIN WITH ROOM CODE',
                      icon: Icons.login,
                      gradientTop: AppTheme.blueBtnTop,
                      gradientBot: AppTheme.blueBtnBot,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const JoinRoomScreen()),
                      ),
                    ),
                    GradientButton(
                      label: 'FRIENDS',
                      subtitle: 'PLAY WITH YOUR FRIENDS',
                      icon: Icons.people_alt,
                      gradientTop: AppTheme.orangeBtnTop,
                      gradientBot: AppTheme.orangeBtnBot,
                      onTap: () => _comingSoon(context, 'Friends list'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SmallIconButton(
                          icon: Icons.share,
                          label: 'INVITE',
                          onTap: () => _comingSoon(context, 'Invite friends'),
                        ),
                        SmallIconButton(
                          icon: Icons.history,
                          label: 'HISTORY',
                          onTap: () => _comingSoon(context, 'Match history'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.bgCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.gold.withValues(alpha: .5)),
                      ),
                      child: const Text(
                        'Online multiplayer (Firebase Realtime) '
                        'will unlock in the next update. Version 1 is fully '
                        'playable Offline vs Computer and Local 2–4 Players. '
                        'Room code + private room UI is ready — the backend '
                        'wiring will ship in v1.1.',
                        style: TextStyle(color: Colors.white, height: 1.4),
                      ),
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

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$feature — coming in the next update'),
      duration: const Duration(seconds: 2),
    ));
  }
}
