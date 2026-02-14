# ⚡ SZYBKI START - 5 KROKÓW

## 1️⃣ GitHub (2 min)
```bash
# Utwórz repo na https://github.com (New repository)
# Nazwa: VoiceAvatarApp

# W terminalu:
cd CodemagicPackage
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/TWOJE_KONTO/VoiceAvatarApp.git
git push -u origin main
```

## 2️⃣ Codemagic (3 min)
1. https://codemagic.io/signup
2. Sign up with GitHub
3. Add application → GitHub → VoiceAvatarApp

## 3️⃣ Apple Developer (5 min)
1. https://developer.apple.com/account
2. Certificates → "+" → iOS Distribution
3. Profiles → "+" → Ad Hoc → Bundle: com.voiceavatar.app

## 4️⃣ Upload Certyfikatów (2 min)
1. Codemagic → App settings → Code signing
2. Upload certificate (.p12)
3. Upload provisioning profile

## 5️⃣ BUILD! (1 min)
1. Start new build
2. Czekaj ~10 min
3. Pobierz .ipa
4. Zainstaluj na iPhone

---

**GOTOWE!** Masz aplikację na iPhone bez Maca! 🎉

Pełna instrukcja → README.md
