import 'package:flutter/material.dart';

class L10nl {
  static final all = [
    const Locale('zu'),
    const Locale('zh'),
    const Locale('en'),
    const Locale('es'),
    const Locale('fr'),
    const Locale('sv'),
    const Locale('hi'),
    const Locale('ko'),
    const Locale('pa'),
    const Locale('pt'),
    const Locale('ru'),
    const Locale('sw'),
    const Locale('ar'),
    const Locale('ja'),
  ];

  static String getLanguage(String code) {
    switch (code) {
      case 'zu':
        return '🇧🇮 Kirundi';
      case 'zh':
        return '🇨🇳 Mandarin';
      case 'en':
        return '🇬🇧 English';
      case 'es':
        return '🇪🇸 Spanish';
      case 'fr':
        return '🇫🇷 French';
      case 'sv':
        return '🇳🇪 Haussa';
      case 'hi':
        return '🇮🇳 Hindi';
      case 'ko':
        return '🇨🇩 Lingala';
      case 'pa':
        return '🇵🇰 Panjabi';
      case 'pt':
        return '🇵🇹 Portuguese';
      case 'ru':
        return '🇷🇺 Russian';
      case 'sw':
        return '🇹🇿 Swahili';
      case 'ar':
        return '🇳🇬 Yoruba';
      case 'ja':
        return '🇨🇳 Cantonese';
    }
    return '🇬🇧 English';
  }
}
