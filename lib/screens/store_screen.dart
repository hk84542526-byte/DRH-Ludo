import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/wallet.dart';
import '../widgets/top_bar.dart';

/// Coins + rewards only monetization (no ads, no IAP): the store only lists
/// cosmetic tokens/boards paid for with earned coins.
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  static const items = [
    ('🎲', 'Gold Dice Skin', 5000),
    ('♟️', 'Neon Token Set', 8000),
    ('🏆', 'VIP Trophy Frame', 15000),
    ('🎨', 'Royal Board Skin', 20000),
    ('🔥', 'Fire Trail (Tokens)', 12000),
    ('💎', 'Diamond Dice', 25000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'STORE'),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final it = items[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.gold.withValues(alpha: .5)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(it.$1, style: const TextStyle(fontSize: 44)),
                        Text(it.$2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () => _buy(it.$2, it.$3),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.gold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.monetization_on),
                          label: Text('${it.$3}'),
                        ),
                        const SizedBox(height: 10),
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

  Future<void> _buy(String name, int price) async {
    final ok = await Wallet.instance.spendCoins(price);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? 'Purchased "$name" for $price coins!'
          : 'Not enough coins for "$name".'),
      duration: const Duration(seconds: 2),
    ));
  }
}
