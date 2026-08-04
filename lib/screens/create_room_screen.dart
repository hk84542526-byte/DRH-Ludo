import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';
import '../core/game_models.dart';
import '../widgets/gradient_button.dart';
import '../widgets/top_bar.dart';

/// Private room creator — matches the "Create Room" panel in the reference.
/// Generates a shareable code and lists the picked colour set. The full
/// realtime hosting will come with the online update.
class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});
  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  int _players = 4;
  final Set<PlayerColor> _selected = {
    PlayerColor.red,
    PlayerColor.blue,
    PlayerColor.green,
    PlayerColor.yellow,
  };
  final TextEditingController _roomName =
      TextEditingController(text: 'DRH ROOM');
  late String _roomCode;

  @override
  void initState() {
    super.initState();
    _roomCode = _generateCode();
  }

  String _generateCode() {
    final rng = Random.secure();
    return 'DRH${1000 + rng.nextInt(9000)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Column(
          children: [
            TopBar(showBack: true, title: 'CREATE ROOM'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('ROOM NAME'),
                    _textField(_roomName),
                    const SizedBox(height: 14),
                    _label('SELECT PLAYERS'),
                    Row(
                      children: [
                        for (final n in [2, 3, 4])
                          _pill('$n PLAYERS', _players == n,
                              () => setState(() => _players = n)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _label('CHOOSE COLOR'),
                    Row(
                      children: [
                        for (final c in PlayerColor.values)
                          _colorTile(c, _selected.contains(c), () {
                            setState(() {
                              if (_selected.contains(c)) {
                                if (_selected.length > 2) _selected.remove(c);
                              } else {
                                if (_selected.length < _players) {
                                  _selected.add(c);
                                }
                              }
                            });
                          }),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _label('ROOM CODE'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.gold, width: 1.4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_roomCode,
                                style: const TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                )),
                          ),
                          IconButton(
                              icon:
                                  const Icon(Icons.copy, color: Colors.white),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: _roomCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Room code copied'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }),
                          IconButton(
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
                              onPressed: () =>
                                  setState(() => _roomCode = _generateCode())),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'CREATE ROOM',
                      subtitle: 'Waiting for players to join…',
                      icon: Icons.add_box,
                      gradientTop: AppTheme.greenBtnTop,
                      gradientBot: AppTheme.greenBtnBot,
                      onTap: () => _showWaiting(context),
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

  void _showWaiting(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgPanel,
        title: const Text('Room Created',
            style: TextStyle(color: Colors.white)),
        content: Text(
            'Room "${_roomName.text}" created with code $_roomCode.\n\n'
            'Realtime matchmaking will ship in v1.1. Share this code with '
            'friends — they will be able to join once the online update is live.',
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }

  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(s,
            style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
      );

  Widget _textField(TextEditingController c) => Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.gold.withValues(alpha: .6)),
        ),
        child: TextField(
          controller: c,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      );

  Widget _pill(String label, bool selected, VoidCallback onTap) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppTheme.blueBtn : AppTheme.bgCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.gold.withValues(alpha: .5)),
              ),
              alignment: Alignment.center,
              child: Text(label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ),
        ),
      );

  Widget _colorTile(PlayerColor color, bool selected, VoidCallback onTap) =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: color.uiColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: selected ? Colors.white : Colors.black26,
                    width: selected ? 3 : 1),
              ),
              child: Center(
                child: selected
                    ? const Icon(Icons.check_circle,
                        color: Colors.white, size: 28)
                    : null,
              ),
            ),
          ),
        ),
      );
}
