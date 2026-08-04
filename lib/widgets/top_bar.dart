import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/wallet.dart';

/// Top bar with player avatar (with name), coin balance and a settings gear —
/// mirrors the header of the reference dashboard mockup.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.showBack = false,
    this.title,
    this.onSettings,
    this.trailing,
  });

  final bool showBack;
  final String? title;
  final VoidCallback? onSettings;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Wallet.instance,
      builder: (context, _) {
        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                if (showBack)
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).maybePop(),
                  )
                else
                  _AvatarChip(name: Wallet.instance.playerName),
                const SizedBox(width: 8),
                if (title != null)
                  Expanded(
                    child: Text(title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.8,
                        )),
                  )
                else
                  const Spacer(),
                _CoinChip(coins: Wallet.instance.coins),
                const SizedBox(width: 8),
                if (trailing != null)
                  trailing!
                else
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 26),
                    onPressed: onSettings,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvatarChip extends StatelessWidget {
  const _AvatarChip({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.gold, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.bgDeep,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 6),
          Text(name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              )),
        ],
      ),
    );
  }
}

class _CoinChip extends StatelessWidget {
  const _CoinChip({required this.coins});
  final int coins;

  @override
  Widget build(BuildContext context) {
    String fmt(int n) {
      final s = n.toString();
      final buf = StringBuffer();
      for (var i = 0; i < s.length; i++) {
        buf.write(s[i]);
        final left = s.length - i - 1;
        if (left > 0 && left % 3 == 0) buf.write(',');
      }
      return buf.toString();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.gold, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppTheme.gold,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('₵',
                style: TextStyle(
                  color: AppTheme.goldDark,
                  fontWeight: FontWeight.w900,
                )),
          ),
          const SizedBox(width: 6),
          Text(fmt(coins),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(width: 6),
          const Icon(Icons.add_circle, color: AppTheme.green, size: 20),
        ],
      ),
    );
  }
}
