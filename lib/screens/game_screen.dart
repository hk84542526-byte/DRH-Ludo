import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/game_models.dart';
import '../core/game_state.dart';
import '../core/wallet.dart';
import '../widgets/dice_widget.dart';
import '../widgets/ludo_board.dart';
import '../widgets/top_bar.dart';

/// The active gameplay screen — 4-quadrant Ludo board with dice, current-turn
/// indicator, coin pot, and move log. Supports Offline-vs-Computer (a single
/// human vs 3 AI) and Local Multiplayer (any human/AI mix).
class GameScreen extends StatefulWidget {
  const GameScreen._({required this.state, required this.title});

  final LudoGameState state;
  final String title;

  factory GameScreen.vsComputer() {
    // One human (Red) vs three AI opponents — classical Ludo default.
    final players = [
      LudoPlayer(
          color: PlayerColor.red,
          name: Wallet.instance.playerName,
          kind: PlayerKind.human),
      LudoPlayer(
          color: PlayerColor.green, name: 'Computer 1', kind: PlayerKind.ai),
      LudoPlayer(
          color: PlayerColor.yellow, name: 'Computer 2', kind: PlayerKind.ai),
      LudoPlayer(
          color: PlayerColor.blue, name: 'Computer 3', kind: PlayerKind.ai),
    ];
    return GameScreen._(
      title: 'OFFLINE VS COMPUTER',
      state: LudoGameState(players: players)..setCoinsPot(200),
    );
  }

  factory GameScreen.local({
    required List<PlayerColor> seatOrder,
    required Map<PlayerColor, PlayerKind> kinds,
  }) {
    var humanCount = 1;
    var aiCount = 1;
    final players = <LudoPlayer>[];
    for (final c in seatOrder) {
      final kind = kinds[c] ?? PlayerKind.human;
      final name = kind == PlayerKind.human
          ? (humanCount == 1 && seatOrder.first == c
              ? Wallet.instance.playerName
              : 'Player ${humanCount++}')
          : 'Computer ${aiCount++}';
      players.add(LudoPlayer(color: c, name: name, kind: kind));
    }
    return GameScreen._(
      title: 'LOCAL MULTIPLAYER',
      state: LudoGameState(players: players)..setCoinsPot(100),
    );
  }

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _resolvedWin = false;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.state.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    setState(() {});
    if (widget.state.phase == TurnPhase.gameOver && !_resolvedWin) {
      _resolvedWin = true;
      final winner = widget.state.players.firstWhere((p) => p.finished);
      final humanWon = winner.kind == PlayerKind.human &&
          winner.name == Wallet.instance.playerName;
      final reward = humanWon ? widget.state.coinsPot : 0;
      if (reward > 0) Wallet.instance.reportWin(reward);
      WidgetsBinding.instance.addPostFrameCallback((_) => _showResult(winner, reward));
    }
  }

  Future<void> _showResult(LudoPlayer winner, int reward) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgPanel,
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: AppTheme.gold),
            const SizedBox(width: 8),
            Text('${winner.name} WINS!',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          reward > 0
              ? 'बधाई हो! You won $reward coins 🎉'
              : '${winner.name} took the crown this time.\nAap agli baar zaroor jeetenge!',
          style: const TextStyle(color: Colors.white, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('BACK TO MENU'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              TopBar(showBack: true, title: widget.title),
              _playerStrip(state),
              const SizedBox(height: 6),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: LudoBoard(
                        state: state,
                        onTokenTap: (c, i) {
                          if (state.currentPlayer.color == c &&
                              state.currentPlayer.kind == PlayerKind.human) {
                            state.selectToken(i);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              _bottomBar(state),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playerStrip(LudoGameState state) {
    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: state.players.length,
        itemBuilder: (context, i) {
          final p = state.players[i];
          final isCurrent = i == state.currentSeat;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent ? AppTheme.gold : p.color.uiColor,
                width: isCurrent ? 2.5 : 1.4,
              ),
              boxShadow: [
                if (isCurrent)
                  BoxShadow(
                    color: AppTheme.gold.withValues(alpha: .35),
                    blurRadius: 12,
                  ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: p.color.uiColor,
                  radius: 16,
                  child: Icon(
                    p.kind == PlayerKind.ai ? Icons.smart_toy : Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(p.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12)),
                    Text('Home: ${p.finishedTokens}/4',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: .7),
                            fontSize: 10)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomBar(LudoGameState state) {
    final phase = state.phase;
    final canRoll = phase == TurnPhase.rolling &&
        state.currentPlayer.kind == PlayerKind.human;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.gold.withValues(alpha: .5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: AppTheme.gold, size: 18),
                      const SizedBox(width: 6),
                      Text('Pot: ${state.coinsPot}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_statusText(state),
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          DiceWidget(
            value: state.lastDie,
            rolling: phase == TurnPhase.animating,
            enabled: canRoll,
            onTap: () => state.rollDie(),
          ),
        ],
      ),
    );
  }

  String _statusText(LudoGameState state) {
    switch (state.phase) {
      case TurnPhase.rolling:
        return '${state.currentPlayer.name}: tap dice to roll';
      case TurnPhase.animating:
        return 'Rolling...';
      case TurnPhase.choosingToken:
        return '${state.currentPlayer.name}: pick a token to move (${state.lastDie})';
      case TurnPhase.gameOver:
        return 'Game Over';
    }
  }
}
