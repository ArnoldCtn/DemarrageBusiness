import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class GeminiClient {
  GenerativeModel? _model;

  GeminiClient() {
    _initialize();
  }

  void _initialize() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      debugPrint("CRITICAL: GEMINI_API_KEY is not defined.");
      return;
    }
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> generateBusinessIdeas({
    required String userInput,
    required String country,
    required List<dynamic> localContext,
    required String language,
    required String currency,
  }) async {
    if (_model == null) {
      debugPrint("AI ERROR: Generative model not initialized.");
      return jsonEncode({"error": "offline"});
    }

    final langInstruct = language == 'fr' 
        ? "Réponds exclusivement en FRANÇAIS. Ne mentionne jamais l'IA ou Gemini." 
        : "Respond exclusively in ENGLISH. Never mention AI or Gemini.";

    final prompt = """
    $langInstruct
    Tu es un expert en entrepreneuriat à $country. 
    L'utilisateur a la vision suivante : '$userInput'.
    
    Inspiration locale : ${jsonEncode(localContext)}

    MISSION : Générer 5 idées de business uniques et adaptées au marché de $country.
    INTERDICTION ABSOLUE : Pas de 'N/A'. Invente des détails réalistes.
    MONNAIE : Utilise uniquement $currency.
    
    Format JSON strict (sans préambule) :
    {
      "ideas": [
        {
          "title": "...",
          "description": "...",
          "why_match": "...",
          "revenue_model": "...",
          "startup_budget": "...",
          "difficulty": 4,
          "first_action": "...",
          "marketing_strategy": "...",
          "problem_solved": "..."
        }
      ]
    }
    """;

    try {
      debugPrint("Gemini Prompt: $prompt");
      final response = await _model!.generateContent([Content.text(prompt)]);
      debugPrint("Gemini Raw Response: ${response.text}");
      
      String text = response.text ?? "";
      if (text.isEmpty) return jsonEncode({"error": "no_data"});
      
      // Clean up markdown
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      return text;
    } catch (e) {
      debugPrint("AI EXCEPTION: $e");
      return jsonEncode({"error": e.toString()});
    }
  }
}
