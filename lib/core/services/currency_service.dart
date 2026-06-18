class CurrencyService {
  static String getCurrency(String country) {
    switch (country.toLowerCase()) {
      case 'cameroun':
      case 'sénégal':
      case 'côte d\'ivoire':
      case 'gabon':
      case 'congo':
        return 'FCFA';
      case 'france':
      case 'allemagne':
      case 'belgique':
        return '€ (Euro)';
      case 'usa':
      case 'états-unis':
        return '\$ (USD)';
      case 'canada':
        return 'CAD';
      case 'nigeria':
        return 'Naira';
      case 'ghana':
        return 'Cedi';
      default:
        return 'Unité locale';
    }
  }

  static String getFlag(String country) {
    switch (country.toLowerCase()) {
      case 'cameroun': return '🇨🇲';
      case 'france': return '🇫🇷';
      case 'usa':
      case 'états-unis': return '🇺🇸';
      case 'canada': return '🇨🇦';
      case 'sénégal': return '🇸🇳';
      case 'nigeria': return '🇳🇬';
      default: return '🌍';
    }
  }
}
