import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCacheService {
  static const String _cacheKey = 'business_search_cache';

  Future<void> saveToCache(String query, String country, List<dynamic> ideas) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString(_cacheKey);
    Map<String, dynamic> cache = existingData != null ? jsonDecode(existingData) : {};
    
    // Key is a combination of lowercase query and country
    String key = "${query.toLowerCase()}_${country.toLowerCase()}";
    cache[key] = {
      'ideas': ideas,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await prefs.setString(_cacheKey, jsonEncode(cache));
  }

  Future<List<dynamic>?> getFromCache(String query, String country) async {
    final prefs = await SharedPreferences.getInstance();
    final String? existingData = prefs.getString(_cacheKey);
    if (existingData == null) return null;
    
    Map<String, dynamic> cache = jsonDecode(existingData);
    String key = "${query.toLowerCase()}_${country.toLowerCase()}";
    
    if (cache.containsKey(key)) {
      return cache[key]['ideas'];
    }
    return null;
  }
}
