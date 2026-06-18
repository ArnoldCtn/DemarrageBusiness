import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('fr', 'FR');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  bool get isFrench => _locale.languageCode == 'fr';
  
  String translate(String key) {
    final Map<String, Map<String, String>> localizedValues = {
      'en': {
        'home': 'Home',
        'greeting_morning': 'Good Morning',
        'greeting_afternoon': 'Good Afternoon',
        'greeting_evening': 'Good Evening',
        'ready_to_conquer': 'Ready to conquer the market of',
        'categories': 'Business Categories',
        'explain_vision': 'Describe your vision',
        'find_ideas': 'Find ideas',
        'reset': 'Reset',
        'trending': 'Trending Now',
        'favorites': 'My Favorites',
        'profile': 'Profile & Settings',
        'dark_mode': 'Dark Mode',
        'language': 'Language',
        'logout': 'Logout',
        'save': 'Save changes',
        'support': 'Support',
        'contact_us': 'Contact Admin',
        'click_full': 'Click to view full idea',
      },
      'fr': {
        'home': 'Accueil',
        'greeting_morning': 'Bonjour',
        'greeting_afternoon': 'Bon après-midi',
        'greeting_evening': 'Bonsoir',
        'ready_to_conquer': 'Prêt à conquérir le marché de',
        'categories': 'Catégories de business',
        'explain_vision': 'Décrivez votre vision',
        'find_ideas': 'Trouver des idées',
        'reset': 'Réinitialiser',
        'trending': 'Top du moment',
        'favorites': 'Mes Favoris',
        'profile': 'Profil & Paramètres',
        'dark_mode': 'Mode Sombre',
        'language': 'Langue',
        'logout': 'Déconnexion',
        'save': 'Enregistrer les modifications',
        'support': 'Support Client',
        'contact_us': 'Contacter l\'administrateur',
        'click_full': 'Cliquer pour voir l\'idée complète',
      },
    };
    return localizedValues[_locale.languageCode]?[key] ?? key;
  }
}
