import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple persistent coin wallet + daily reward tracking.
/// Because monetization is coins/rewards only (no ads, no IAP), the wallet
/// only grows through gameplay, daily reward, and gifts.
class Wallet extends ChangeNotifier {
  Wallet._();
  static final Wallet instance = Wallet._();

  static const _kCoins = 'wallet_coins_v1';
  static const _kLastDaily = 'wallet_last_daily_v1';
  static const _kBestScore = 'wallet_best_v1';
  static const _kPlayerName = 'wallet_player_name_v1';

  int _coins = 25000;
  int _best = 0;
  DateTime? _lastDaily;
  String _playerName = 'Player';

  int get coins => _coins;
  int get best => _best;
  String get playerName => _playerName;
  DateTime? get lastDaily => _lastDaily;

  bool get dailyAvailable {
    if (_lastDaily == null) return true;
    final now = DateTime.now();
    return now.difference(_lastDaily!).inHours >= 20;
  }

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    _coins = sp.getInt(_kCoins) ?? 25000;
    _best = sp.getInt(_kBestScore) ?? 0;
    _playerName = sp.getString(_kPlayerName) ?? 'Player';
    final ts = sp.getInt(_kLastDaily);
    if (ts != null) _lastDaily = DateTime.fromMillisecondsSinceEpoch(ts);
  }

  Future<void> setPlayerName(String name) async {
    _playerName = name.trim().isEmpty ? 'Player' : name.trim();
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kPlayerName, _playerName);
    notifyListeners();
  }

  Future<void> addCoins(int amount) async {
    _coins += amount;
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kCoins, _coins);
    notifyListeners();
  }

  Future<bool> spendCoins(int amount) async {
    if (_coins < amount) return false;
    _coins -= amount;
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kCoins, _coins);
    notifyListeners();
    return true;
  }

  Future<int> claimDaily() async {
    if (!dailyAvailable) return 0;
    const reward = 500;
    _lastDaily = DateTime.now();
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kLastDaily, _lastDaily!.millisecondsSinceEpoch);
    await addCoins(reward);
    return reward;
  }

  Future<void> reportWin(int coinsWon) async {
    await addCoins(coinsWon);
    if (coinsWon > _best) {
      _best = coinsWon;
      final sp = await SharedPreferences.getInstance();
      await sp.setInt(_kBestScore, _best);
      notifyListeners();
    }
  }
}
