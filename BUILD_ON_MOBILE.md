# 📱 DRH LUDO — Build APK/AAB Fully from Your Mobile

Bhai, aapke paas PC/laptop nahi hai, koi baat nahi. Yeh guide GitHub +
GitHub Actions ka use karta hai — sab kuch mobile browser (Chrome / Firefox)
se ho jayega. Total time: **~15 min setup + 8 min build**.

---

## ⚡ Fastest path (5 steps)

### Step 1 — GitHub par account banao
1. Open [github.com](https://github.com) in mobile browser
2. Sign up (email + password + username)
3. Email verify karo

### Step 2 — Naya repository create karo
1. github.com par top-right `+` icon → **New repository**
2. Repository name: `drh-ludo`
3. Visibility: **Private** (recommended) ya Public — dono chalega
4. **DO NOT** initialize with README/gitignore/license (khali repo chahiye)
5. **Create repository**

### Step 3 — DRH LUDO source upload karo
1. Naye repo page par: **"uploading an existing file"** link tap karo
   (ya URL mein `/upload/main` add karo)
2. Downloaded `drh_ludo_flutter_source.zip` ko phone mein **extract** karo:
   - Chrome/Files app se ZIP open karo → "Extract all" ya "Unzip"
   - Ya third-party app: **ZArchiver** (Play Store, free)
3. Extract hone ke baad ek `drh_ludo/` folder banega — us folder ke
   **andar ki saari files/folders** (`android/`, `lib/`, `pubspec.yaml`,
   `.github/`, etc.) ko select karke GitHub upload page par drag/tap-select karo
4. Neeche commit message: `Initial commit`
5. **Commit changes** tap karo

> ⚠️ IMPORTANT: `.github/workflows/build.yml` file zaroor upload ho — yehi
> file automatic build trigger karti hai. GitHub kabhi-kabhi hidden dot-folders
> chhod deta hai; agar `.github` folder upload nahi hua toh manually
> `/upload/main/.github/workflows/` URL open karke `build.yml` alag se upload karo.

### Step 4 — Build trigger karo
1. Upload complete hote hi GitHub automatically build shuru kar deta hai
   (kyunki workflow `push` par bhi trigger hoti hai)
2. Repo page par tap → **Actions** tab (top navigation mein)
3. "Build DRH LUDO Android" workflow ka latest run tap karo
4. Wait 6–10 minutes (Flutter SDK download + build)
5. Progress dots green ✅ ho jayen toh **done**!

### Step 5 — APK/AAB download karo
Successful run page ke neeche **Artifacts** section mein 3 downloads honge:

| Artifact | File Inside | Use case |
|----------|------------|----------|
| `drh-ludo-debug-apk` | `app-debug.apk` | Sideload / apne phone par test |
| `drh-ludo-release-apks` | `app-arm64-v8a-release.apk`, etc. | Modern phones ko de sakte ho |
| `drh-ludo-release-aab` | `app-release.aab` | Google Play Store upload |

- Artifact ZIP tap karke download karo
- Files/ZArchiver app se extract karo → APK milega
- APK par tap → phone ka installer khulega → Install
  - Pehli baar "Install from unknown sources" allow karna padega (Settings prompt)

**Ho gaya! DRH LUDO aapke phone par install ho gaya.** 🎉

---

## 🔐 Play Store upload ke liye SIGNED build

Jab aap Play Store par publish karna chahen, aapko ek **upload keystore**
banana hoga aur GitHub Secrets mein add karna hoga.

### Keystore mobile par kaise banayein

Mobile par keystore banane ka easiest tarika:

**Option A — Termux app (free, Play Store / F-Droid)**
```bash
pkg install openjdk-17
keytool -genkey -v \
  -keystore drh-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias drh-upload
# Password, name, org, etc. daalne padenge — remember them!
```

**Option B — Online tool** (only if you trust the site)
- keytool-online se avoid karo, security risk hai
- Termux tarika safest hai

### Keystore ko base64 mein convert karo (mobile-friendly)
Termux mein:
```bash
base64 drh-upload.jks > drh-upload.b64
cat drh-upload.b64
```
Poori base64 string copy karo.

### GitHub Secrets mein add karo
GitHub repo par:
1. **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret** → add these 4 secrets:

| Secret Name | Value |
|------------|-------|
| `KEYSTORE_BASE64` | poori base64 string (upar wali) |
| `KEYSTORE_PASSWORD` | keystore banate waqt jo password diya |
| `KEY_PASSWORD` | key password (usually same as keystore password) |
| `KEY_ALIAS` | `drh-upload` (ya jo alias diya) |

### Signed build trigger karo
1. Repo → **Actions** tab
2. Left sidebar mein "Build DRH LUDO Android" workflow tap
3. Top right: **Run workflow** button → main branch → **Run workflow**
4. `release-signed` job ka artifact `drh-ludo-SIGNED-playstore` download karo
5. Us AAB ko Google Play Console par upload karo

---

## 🛠️ Common issues

**Q: Build fail ho raha hai, "flutter analyze" error dikh raha hai**
A: `flutter analyze` project mein clean pass hota hai. Agar aapne code
   badla hai aur break kiya, revert karo ya error line dekh ke fix karo.

**Q: Artifact "drh-ludo-release-aab" download button nahi dikh raha**
A: Aap GitHub par logged in ho? Artifacts sirf logged-in users ke liye
   download hote hain.

**Q: APK install par "App not installed" error**
A: Pehle purani debug APK uninstall karo, phir release APK install karo
   (dono ka signature different hota hai).

**Q: Play Store "Upload failed, key mismatch" error**
A: Play Console mein pehli baar hi keystore lock ho jaata hai. Ek hi
   keystore hamesha use karo — Termux mein banaya `drh-upload.jks` ko
   Google Drive par backup rakho.

---

## 📸 Screenshot checklist for Play Store

Play Store listing ke liye chahiye:
- [ ] Feature graphic (1024 × 500 px)
- [ ] App icon (already generated: `assets/branding/app_icon.png`, 1024×1024)
- [ ] Screenshots: minimum 2, ideally 4–8 phone screenshots
- [ ] Privacy policy URL (required — even for coin-based games)
- [ ] Short description (80 chars), full description (4000 chars)

Aap apne phone se app khol ke screenshot le sakte ho (Power + Volume Down).

---

## 🎯 Next update (v1.1) — Online Multiplayer

Jab aap ready ho, mujhe bolo aur main Firebase Realtime Database integration
add kar dunga:
- Quick Play matchmaking (random opponent)
- Private room hosting via room code (`DRH1234`)
- Live turn sync, disconnection handling
- Anonymous Firebase Auth (no email/password required)

Iske liye Firebase project banana hoga aur `google-services.json` file
`android/app/` mein rakhni hogi. Bilkul mobile-friendly setup hai, main
step-by-step guide dunga.

Enjoy! 🎲
