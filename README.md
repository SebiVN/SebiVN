# Calculator Pensionare 🎯

O aplicație Flutter care te ajută să urmărești cât timp mai ai până la pensionare, bazată pe legile din țara ta și data ta de naștere.

## Caracteristici ✨

- **Calcul precis al pensionării** bazat pe vârsta legală de pensionare din diferite țări
- **Countdown personalizabil** - alege să vezi timpul rămas în:
  - Zile 📅
  - Luni 📆
  - Ani 🗓️
- **Widget pentru home screen** - vezi countdown-ul direct pe ecranul principal al telefonului (Android)
- **Suport pentru multiple țări**:
  - România 🇷🇴
  - Germania 🇩🇪
  - Franța 🇫🇷
  - Italia 🇮🇹
  - Spania 🇪🇸
  - Regatul Unit 🇬🇧
  - Statele Unite 🇺🇸
  - Canada 🇨🇦
  - Australia 🇦🇺
  - Olanda 🇳🇱
  - Belgia 🇧🇪
  - Austria 🇦🇹
  - Elveția 🇨🇭
- **Afișare detaliată** - vezi timpul rămas defalcat pe ani, luni și zile
- **Interfață modernă** cu Material Design 3
- **Mod întunecat** - se adaptează automat la tema sistemului

## Capturi de ecran 📱

_Aplicația va arăta:_
- Ecran principal cu selecție dată nașterii și țară
- Countdown vizual colorat
- Opțiuni pentru tipul de afișare (zile/luni/ani)
- Widget pe home screen

## Instalare 🚀

### Cerințe

- Flutter SDK (>= 3.0.0)
- Android Studio sau Xcode (pentru iOS)
- Dart SDK

### Pași de instalare

1. Clonează repository-ul:
```bash
git clone https://github.com/yourusername/retirement_calculator.git
cd retirement_calculator
```

2. Instalează dependințele:
```bash
flutter pub get
```

3. Rulează aplicația:
```bash
flutter run
```

## Utilizare 📖

### Configurare inițială

1. **Selectează data nașterii**: Apasă pe "Data nașterii" și alege data ta de naștere din calendar
2. **Selectează țara**: Apasă pe "Țara" și alege țara în care te afli
3. **Selectează sexul**: Alege între Bărbat și Femeie (vârsta de pensionare poate diferi)
4. **Alege tipul de countdown**: Selectează dacă vrei să vezi timpul rămas în zile, luni sau ani

### Adăugarea widget-ului (Android)

1. Menține apăsat pe ecranul principal al telefonului
2. Selectează "Widgets"
3. Caută "Calculator Pensionare"
4. Trage widget-ul pe ecranul principal
5. Widget-ul va afișa automat countdown-ul bazat pe setările din aplicație

**Notă**: Widget-ul se actualizează automat la fiecare oră.

## Tehnologii utilizate 🛠️

- **Flutter** - Framework UI cross-platform
- **Dart** - Limbaj de programare
- **shared_preferences** - Pentru salvarea datelor locale
- **intl** - Pentru formatarea datelor și localizare
- **home_widget** - Pentru suportul widget-urilor native
- **Material Design 3** - Pentru interfața modernă

## Structura proiectului 📁

```
lib/
├── main.dart                          # Punctul de intrare al aplicației
├── models/
│   └── country_retirement.dart        # Model pentru datele țărilor
├── screens/
│   └── home_screen.dart               # Ecranul principal
├── services/
│   └── retirement_service.dart        # Logica de calcul
└── widgets/
    └── countdown_widget.dart          # Widget-ul de countdown

android/
└── app/src/main/
    ├── kotlin/com/retirement/calculator/
    │   ├── MainActivity.kt            # Activity principal Android
    │   └── RetirementWidgetProvider.kt # Provider pentru widget
    └── res/
        ├── layout/
        │   └── retirement_widget.xml   # Layout widget Android
        ├── drawable/
        │   └── widget_background.xml   # Background widget
        └── xml/
            └── retirement_widget_info.xml # Configurare widget
```

## Vârste de pensionare suportate 👴👵

| Țară | Bărbați | Femei |
|------|---------|-------|
| România | 65 | 63 |
| Germania | 67 | 67 |
| Franța | 64 | 64 |
| Italia | 67 | 67 |
| Spania | 66 | 66 |
| Regatul Unit | 66 | 66 |
| Statele Unite | 67 | 67 |
| Canada | 65 | 65 |
| Australia | 67 | 67 |
| Olanda | 67 | 67 |
| Belgia | 66 | 66 |
| Austria | 65 | 60 |
| Elveția | 65 | 64 |

**Notă**: Acestea sunt vârste standard și pot varia în funcție de circumstanțe specifice (ani de contribuție, profesie, etc.).

## Funcționalități viitoare 🔮

- [ ] Suport pentru iOS widgets
- [ ] Adăugare mai multe țări
- [ ] Notificări personalizabile (ex: "Mai ai 1000 de zile!")
- [ ] Grafice cu progresul
- [ ] Export statistici
- [ ] Calculare bazată pe ani de contribuție
- [ ] Teme personalizabile pentru widget
- [ ] Suport pentru pensionare anticipată

## Contribuții 🤝

Contribuțiile sunt binevenite! Dacă vrei să adaugi o țară nouă sau să îmbunătățești aplicația:

1. Fork repository-ul
2. Creează un branch nou (`git checkout -b feature/amazing-feature`)
3. Commit modificările (`git commit -m 'Add amazing feature'`)
4. Push la branch (`git push origin feature/amazing-feature`)
5. Deschide un Pull Request

## Licență 📄

Acest proiect este open-source și disponibil sub licența MIT.

## Disclaimer ⚠️

Această aplicație oferă informații orientative bazate pe vârste standard de pensionare. Vârsta efectivă de pensionare poate varia în funcție de:
- Legislația specifică a țării tale
- Ani de contribuție la sistemul de pensii
- Tipul de muncă (ex: condiții speciale de muncă)
- Schimbări legislative viitoare

Pentru informații oficiale, consultă autoritățile de pensii din țara ta.

## Contact 📧

Pentru întrebări, sugestii sau probleme, deschide un issue pe GitHub.

---

**Dezvoltat cu ❤️ folosind Flutter**
