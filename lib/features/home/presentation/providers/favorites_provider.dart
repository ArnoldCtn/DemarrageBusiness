import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('favorites');
    if (data != null) {
      _favorites = List<Map<String, dynamic>>.from(jsonDecode(data));
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> idea) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favorites.any((f) => f['title'] == idea['title'])) {
      _favorites.removeWhere((f) => f['title'] == idea['title']);
    } else {
      _favorites.add(idea);
    }
    await prefs.setString('favorites', jsonEncode(_favorites));
    notifyListeners();
  }

  bool isFavorite(String title) {
    return _favorites.any((f) => f['title'] == title);
  }
}
