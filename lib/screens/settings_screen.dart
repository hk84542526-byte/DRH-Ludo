import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/wallet.dart';
import '../widgets/top_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  bool _music = true;
  bool _vibrate = true;
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: Wallet.instance.playerName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'SETTINGS'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: AppTheme.gold.withValues(alpha: .5)),
                    ),
                    child: Column(
                      children: [
                        const Text('Player Name',
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _name,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(color: Colors.white38)),
                          onSubmitted: (v) =>
                              Wallet.instance.setPlayerName(v),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Wallet.instance.setPlayerName(_name.text),
                            child: const Text('SAVE'),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _toggle('Sound Effects', _sound,
                      (v) => setState(() => _sound = v)),
                  _toggle('Background Music', _music,
                      (v) => setState(() => _music = v)),
                  _toggle('Vibration', _vibrate,
                      (v) => setState(() => _vibrate = v)),
                  const SizedBox(height: 12),
                  const Text(
                    'DRH LUDO — v1.0.0\n© 2026 DRH Games. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.gold.withValues(alpha: .3)),
      ),
      child: SwitchListTile(
        title:
            Text(label, style: const TextStyle(color: Colors.white)),
        value: value,
        activeThumbColor: AppTheme.gold,
        onChanged: onChanged,
      ),
    );
  }
}
