class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "🇺🇸", "English", "en"),
      Language(2, "🇸🇦", "اَلْعَرَبِيَّةُ‎", "ar"),
      Language(3, "🇵🇰", "اردو", "ur"),
      Language(4, "🇮🇳", "हिंदी", "hi"),
      Language(5, "🇩🇪", "Deutsch", "de"),
      Language(6, "🇪🇸", "Spanisch", "es"),
      Language(7, "🇫🇷", "Französisch", "fr"),
      Language(8, "🇯🇵", "JAPANISCH", "es"),
      Language(9, "🇮🇳", "ಕನ್ನಡ", "kn"),
      Language(10, "🇰🇷", "한국인", "ko"),
      Language(11, "🇷🇺", "РУССКИЙ", "ru"),
      Language(12, "🇮🇳", "தமிழ்", "ta"),
      Language(13, "🇮🇳", "తెలుగు", "te"),
      Language(14, "🇹🇭", "ไทย", "th"),
      Language(15, "🇨🇳", "中國人", "zh"),
    ];
  }
}
