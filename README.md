# 🚀 Voice Avatar App - Gotowe do Codemagic!

## 📦 Ten Package Zawiera:

```
CodemagicPackage/
├── VoiceAvatarApp.xcodeproj/     ← Projekt Xcode
│   └── project.pbxproj
├── VoiceAvatarApp/               ← Kod źródłowy
│   ├── VoiceAvatarApp.swift
│   ├── ContentView.swift
│   ├── AvatarSceneView.swift
│   ├── VoiceManager.swift
│   ├── OpenAIManager.swift
│   ├── SettingsView.swift
│   └── Info.plist
├── codemagic.yaml                ← Konfiguracja kompilacji
├── .gitignore                    ← Git ignore
└── README.md                     ← Ta instrukcja
```

---

## 🎯 INSTRUKCJA KROK PO KROKU

### **KROK 1: Utwórz Repozytorium na GitHub** (5 min)

1. **Przejdź do:** https://github.com
2. **Zaloguj się** (lub utwórz konto)
3. **Kliknij:** "+" (góra prawa) → "New repository"
4. **Wypełnij:**
   ```
   Repository name: VoiceAvatarApp
   Description: Voice Assistant with 3D Avatar for iOS
   ☐ Public (możesz wybrać Private jeśli chcesz)
   ☐ Initialize with README (odznacz!)
   ```
5. **Kliknij:** "Create repository"
6. **SKOPIUJ** URL (będzie wyglądać jak: `https://github.com/TWOJE_KONTO/VoiceAvatarApp.git`)

---

### **KROK 2: Wrzuć Kod na GitHub** (3 min)

**Opcja A: Przez Terminal (Mac)**

```bash
# Przejdź do folderu CodemagicPackage
cd /ścieżka/do/CodemagicPackage

# Zainicjuj Git
git init

# Dodaj wszystkie pliki
git add .

# Commit
git commit -m "Initial commit - Voice Avatar App"

# Dodaj remote (ZAMIEŃ na swój URL)
git remote add origin https://github.com/TWOJE_KONTO/VoiceAvatarApp.git

# Push
git branch -M main
git push -u origin main
```

**Opcja B: Przez GitHub Desktop (łatwiejsze)**

1. Pobierz GitHub Desktop: https://desktop.github.com
2. File → Add Local Repository → Wybierz folder CodemagicPackage
3. Publish repository → Wybierz konto → Publish

**Opcja C: Przez przeglądarkę (najprostsze)**

1. W repozytorium GitHub kliknij "uploading an existing file"
2. Przeciągnij WSZYSTKIE pliki z CodemagicPackage
3. Commit changes

---

### **KROK 3: Połącz Codemagic** (5 min)

1. **Przejdź do:** https://codemagic.io/signup
2. **Zaloguj się przez GitHub** (kliknij "Sign up with GitHub")
3. **Autoryzuj** Codemagic (kliknij "Authorize Codemagic")
4. **Pierwsza konfiguracja:**
   - Kliknij "Add application"
   - Wybierz "GitHub" jako źródło
   - Znajdź "VoiceAvatarApp" na liście
   - Kliknij "Select"

---

### **KROK 4: Skonfiguruj Code Signing** (10 min)

⚠️ **WAŻNE:** Bez tego nie zbudujesz .ipa

**4.1: Utwórz App ID w Apple Developer**

1. Przejdź do: https://developer.apple.com/account
2. Certificates, Identifiers & Profiles → Identifiers
3. "+" (nowy identifier)
4. App IDs → Continue
5. Bundle ID: `com.voiceavatar.app` (lub własny)
6. Capabilities: 
   - ✅ Siri (dla Speech)
7. Register

**4.2: Utwórz Certificate**

1. Certificates → "+" (nowy certificate)
2. iOS Distribution → Continue
3. Wygeneruj CSR:
   - Mac: Keychain Access → Certificate Assistant → Request from CA
   - Email: twój email
   - Common Name: VoiceAvatar
   - Save to disk
4. Upload CSR → Download certificate
5. Zainstaluj (double-click)

**4.3: Utwórz Provisioning Profile**

1. Profiles → "+" (nowy profile)
2. Ad Hoc → Continue
3. App ID: wybierz `com.voiceavatar.app`
4. Certificate: wybierz swój
5. Devices: wybierz iPhone (najpierw dodaj w Devices)
6. Name: VoiceAvatar AdHoc
7. Generate → Download

**4.4: Dodaj do Codemagic**

1. W Codemagic: App settings → Code signing identities
2. iOS code signing:
   - Upload certificate (.p12)
   - Upload provisioning profile (.mobileprovision)
3. Save

---

### **KROK 5: Uruchom Build!** 🎉 (2 min)

1. W Codemagic aplikacji:
2. **Start new build**
3. Workflow: `ios-workflow`
4. Branch: `main`
5. **Start build**

⏱️ **Czas kompilacji:** ~10-15 minut

---

### **KROK 6: Pobierz .ipa** (1 min)

Po zakończeniu build:

1. Kliknij na build (zielony ✓)
2. Scroll w dół → **Artifacts**
3. **Pobierz:** `VoiceAvatarApp.ipa`

---

## 📱 INSTALACJA .ipa NA iPHONE

### **Opcja A: Przez TestFlight** (POLECAM)

1. W App Store Connect:
   - Utwórz aplikację
   - Upload .ipa przez Transporter
2. TestFlight → Dodaj testerów
3. Zainstaluj przez TestFlight na iPhone

### **Opcja B: Przez Xcode** (szybsze do testów)

1. Podłącz iPhone kablem
2. Xcode → Window → Devices and Simulators
3. Przeciągnij .ipa na iPhone
4. Trust developer (Settings → General → Device Management)

### **Opcja C: Przez trzecie strony**

- **AltStore:** https://altstore.io (darmowe)
- **Sideloadly:** https://sideloadly.io (darmowe)
- **Diawi:** https://www.diawi.com (instalacja przez link)

---

## ⚙️ EDYCJA KONFIGURACJI

### Zmień Bundle ID:

**Plik:** `codemagic.yaml`, linia 8:
```yaml
BUNDLE_ID: "com.TWOJA_NAZWA.app"
```

**ORAZ** w pliku projektu: `VoiceAvatarApp.xcodeproj/project.pbxproj`:
```
PRODUCT_BUNDLE_IDENTIFIER = com.TWOJA_NAZWA.app;
```

### Zmień email powiadomień:

**Plik:** `codemagic.yaml`, linia 35:
```yaml
recipients:
  - twoj-prawdziwy-email@example.com
```

### Zmień wersję Xcode:

**Plik:** `codemagic.yaml`, linia 11:
```yaml
xcode: 14.3.1  # Możesz zmienić na 13.x lub 14.x
```

---

## 🔧 ROZWIĄZYWANIE PROBLEMÓW

### Problem: "Build failed - Code signing"

**Rozwiązanie:**
1. Sprawdź czy uploado certificate i provisioning profile
2. Sprawdź czy Bundle ID się zgadza
3. Sprawdź czy urządzenie jest dodane (dla Ad Hoc)

### Problem: "Build failed - No such file or directory"

**Rozwiązanie:**
1. Sprawdź czy wszystkie pliki .swift są w repozytorium
2. Sprawdź strukturę folderów (musi być jak w README)

### Problem: "Workflow not found"

**Rozwiązanie:**
1. Sprawdź czy `codemagic.yaml` jest w głównym katalogu
2. Sprawdź czy nazwa workflow to `ios-workflow`

### Problem: "No devices selected"

**Rozwiązanie:**
1. Apple Developer → Devices → Dodaj iPhone (UDID)
2. Wygeneruj nowy provisioning profile z tym urządzeniem

---

## 💰 KOSZTY

### Codemagic:
- ✅ **Free tier:** 500 minut/miesiąc (wystarczy na ~30 buildów)
- 💵 **Paid:** $40/miesiąc (unlimited)

### Apple Developer:
- 💵 **$99/rok** (potrzebne do dystrybucji)
- ✅ Darmowe konto: tylko na własne urządzenia (max 3)

### GitHub:
- ✅ **Darmowe** dla public repos
- ✅ **Darmowe** dla private repos (do 2000 minut Actions)

---

## 🚀 AUTOMATYCZNE BUILDY

Po skonfigurowaniu, **każdy push na GitHub = automatyczny build!**

```bash
# Zmień coś w kodzie
git add .
git commit -m "Updated avatar color"
git push

# Codemagic automatycznie zacznie budować!
```

---

## 📚 DODATKOWE ZASOBY

- **Codemagic Docs:** https://docs.codemagic.io/yaml-quick-start/building-a-native-ios-app/
- **Apple Developer:** https://developer.apple.com
- **TestFlight:** https://developer.apple.com/testflight/

---

## ✅ CHECKLIST

- [ ] Utworzone repo na GitHub
- [ ] Kod wrzucony (git push)
- [ ] Konto Codemagic (połączone z GitHub)
- [ ] App ID utworzony w Apple Developer
- [ ] Certificate utworzony i zainstalowany
- [ ] Provisioning Profile utworzony
- [ ] Certificate i Profile wrzucone do Codemagic
- [ ] Build uruchomiony
- [ ] .ipa pobrane
- [ ] Aplikacja zainstalowana na iPhone
- [ ] Klucz API OpenAI skonfigurowany
- [ ] Działa! ✅

---

## 🎉 GRATULACJE!

Masz teraz:
- ✅ Automatyczny build pipeline
- ✅ Aplikację działającą na iPhone
- ✅ Możliwość update bez Maca

**Każda zmiana w kodzie → Push → Nowa wersja automatycznie!**

---

## 🆘 POMOC

Jeśli coś nie działa:
1. Sprawdź logi w Codemagic (zakładka "Build")
2. Sprawdź sekcję Rozwiązywanie Problemów
3. Dokumentacja Codemagic: https://docs.codemagic.io

---

**Powodzenia!** 🚀

Twoja aplikacja Voice Avatar z 3D awatarem jest gotowa do zdalnej kompilacji!
