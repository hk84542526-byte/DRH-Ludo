import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/top_bar.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});
  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'JOIN ROOM'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Enter Room Code',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _code,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 22,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w800),
                    decoration: InputDecoration(
                      hintText: 'DRH1234',
                      hintStyle: TextStyle(color: Colors.white24, letterSpacing: 3),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.gold, width: 1.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    label: 'JOIN',
                    subtitle: 'CONNECT TO PRIVATE ROOM',
                    icon: Icons.login,
                    gradientTop: AppTheme.blueBtnTop,
                    gradientBot: AppTheme.blueBtnBot,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Trying room ${_code.text.trim()} — Online backend arrives in v1.1'),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
