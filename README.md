# 🎮 DRH LUDO — Flutter Android App

A Play Store–ready 4-colour classical Ludo built with Flutter, designed to match
the DRH LUDO brand from the reference mockup (deep-navy + gold, red/blue/green/
yellow tokens, Hindi + English labels).

> **📱 No PC? No problem.** See [**BUILD_ON_MOBILE.md**](./BUILD_ON_MOBILE.md)
> for a step-by-step mobile-only guide to build APK/AAB via GitHub Actions.

---

## What's in v1.0.0

- **Splash + Home dashboard** — DRH LUDO wordmark, coin balance (25,000 starting),
  player avatar, settings gear
- **Offline vs Computer** — 1 human (Red) vs 3 heuristic AI opponents
- **Local Multiplayer 2 – 4 players** — pass-and-play, any Human/AI mix
- **Online Mode lobby** — Quick Play / Create Room / Join Room / Friends
  (UI + private-room-code generator; Firebase realtime backend arrives in v1.1)
- **Full Ludo rules engine** — 52-cell shared ring, 6-cell home column, safe stars,
  capture, exact-to-finish, six grants extra turn, three-6s forfeits
- **Coins + Rewards** — persistent wallet (`shared_preferences`), daily reward,
  in-game store (coin-only, no ads, no IAP), leaderboard
- **Settings** — player name, sound/music/vibrate toggles
- **How to Play** — bilingual rules card
- **Custom branding** — generated `assets/branding/app_icon.png`, adaptive
  launcher icon (`flutter_launcher_icons`), app label "DRH LUDO",
  package `com.drhgames.drh_ludo`
- **Portrait-locked**, Material 3 dark theme, Google Fonts (Poppins)

---

## Project layout

```
lib/
  main.dart                    # App entry, theme, splash boot
  core/
    app_theme.dart             # Colour + gradient tokens
    game_models.dart           # PlayerColor / LudoPlayer
    ludo_rules.dart            # Pure rules engine (moves, capture, safe stars)
    board_paths.dart           # 15x15 grid mapping for ring / home / yards
    game_state.dart            # ChangeNotifier controller + AI turn scheduling
    wallet.dart                # Persistent coin wallet + daily reward
  widgets/
    gradient_button.dart       # Big glossy menu buttons + small utility tiles
    top_bar.dart               # Avatar + coin chip + settings
    dice_widget.dart           # 3D dice with shake / roll animation
    ludo_board.dart            # CustomPainter board + token overlay
  screens/
    splash_screen.dart
    home_screen.dart
    online_mode_screen.dart
    create_room_screen.dart
    join_room_screen.dart
    local_multiplayer_setup.dart
    game_screen.dart
    settings_screen.dart
    store_screen.dart
    how_to_play_screen.dart
    leaderboard_screen.dart
assets/branding/app_icon.png   # source PNG for launcher icons
.github/workflows/build.yml    # GitHub Actions: builds APK + AAB in cloud
```

---

## Build (local, if you have Flutter installed)

```bash
# 1. Get dependencies
flutter pub get

# 2. Generate launcher icons (already committed, re-run if you swap the source PNG)
dart run flutter_launcher_icons

# 3. Static analysis (should be "No issues found!")
flutter analyze

# 4. Debug APK — install with USB or share the file
flutter build apk --debug

# 5. Release APK / AAB — remember to add your own upload keystore
flutter build apk --release --split-per-abi
flutter build appbundle --release
```

---

## Build (from mobile, via GitHub Actions)

See [**BUILD_ON_MOBILE.md**](./BUILD_ON_MOBILE.md) — the entire process
(create GitHub account, upload source, trigger build, download APK/AAB)
can be done from a phone browser in under 20 minutes.

---

## Signing (for Play Store)

1. Generate an upload keystore (in Termux on your phone):
   ```bash
   pkg install openjdk-17
   keytool -genkey -v -keystore drh-upload.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias drh-upload
   ```
2. Base64-encode it:
   ```bash
   base64 drh-upload.jks > drh-upload.b64
   ```
3. Add these 4 secrets to your GitHub repo
   (Settings → Secrets and variables → Actions):
   - `KEYSTORE_BASE64` — contents of `drh-upload.b64`
   - `KEYSTORE_PASSWORD` — the keystore password
   - `KEY_PASSWORD` — the key password (usually same as keystore password)
   - `KEY_ALIAS` — `drh-upload`
4. Actions tab → "Build DRH LUDO Android" → **Run workflow** →
   the `release-signed` job's `drh-ludo-SIGNED-playstore` artifact contains
   your signed `.aab` for Play Store upload.

The `android/app/build.gradle.kts` already reads `android/key.properties`
and switches to your upload keystore when present, otherwise falls back to
debug signing so CI builds keep working without secrets.

---

## v1.1 roadmap

- Firebase Realtime Database + Anonymous Auth for Online Mode
  (Quick Play matchmaking + Private room join via code)
- Sound & music tracks (currently placeholder toggles)
- Cloud-synced leaderboard + friend invites
- Play Games Services (games_services) for achievements

---

© 2026 DRH Games. All rights reserved.
