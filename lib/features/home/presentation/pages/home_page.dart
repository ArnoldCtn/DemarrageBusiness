import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarrage_business/core/services/gemini_client.dart';
import 'package:demarrage_business/core/services/business_data.dart';
import 'package:demarrage_business/core/services/currency_service.dart';
import 'package:demarrage_business/core/services/search_cache_service.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/providers/language_provider.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';
import 'package:demarrage_business/features/home/presentation/pages/idea_detail_page.dart';
import 'package:demarrage_business/features/home/presentation/pages/search_results_page.dart';
import 'package:demarrage_business/features/home/presentation/providers/favorites_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _localResults = [];
  final List<String> _selectedIds = [];
  final GeminiClient _gemini = GeminiClient();
  final SearchCacheService _cache = SearchCacheService();
  late AnimationController _pulseController;

  final List<Map<String, String>> _displayCategories = [
    {"name": "Agriculture", "id": "agriculture", "icon": "🌱"},
    {"name": "Mécanique", "id": "mechanic", "icon": "🔧"},
    {"name": "Digital", "id": "digital_services", "icon": "💻"},
    {"name": "Sport", "id": "sports", "icon": "⚽"},
    {"name": "E-Commerce", "id": "ecommerce", "icon": "🛍️"},
    {"name": "IA & Tech", "id": "intelligence_artificielle", "icon": "🤖"},
    {"name": "Événement", "id": "event_planning", "icon": "🎊"},
    {"name": "Animaux", "id": "pet_services", "icon": "🐶"},
    {"name": "Nettoyage", "id": "cleaning_services", "icon": "🧼"},
    {"name": "Tourisme", "id": "tourism_travel", "icon": "✈️"},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting(LanguageProvider lang) {
    final hour = DateTime.now().hour;
    if (hour < 12) return lang.translate('greeting_morning');
    if (hour < 18) return lang.translate('greeting_afternoon');
    return lang.translate('greeting_evening');
  }

  List<dynamic> _getFilteredLocalData({bool all = false}) {
    List<dynamic> results = [];
    final dynamic rawData = BusinessData.data['categories'];
    final List<dynamic> categories = rawData is List ? rawData : [];
    
    for (var cat in categories) {
      if (all || _selectedIds.contains(cat['id'])) {
        final ideas = cat['ideas'];
        if (ideas is List) results.addAll(ideas);
      }
    }
    return results;
  }

  void _searchCatalogue() {
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez sélectionner au moins une catégorie")));
      return;
    }
    List<dynamic> results = _getFilteredLocalData();
    
    // Ensure we always have 5
    final allIdeas = _getFilteredLocalData(all: true);
    allIdeas.shuffle();
    while (results.length < 5 && allIdeas.isNotEmpty) {
      final idea = allIdeas.removeAt(0);
      if (!results.contains(idea)) results.add(idea);
    }

    final shuffled = List.from(results)..shuffle();
    setState(() => _localResults = shuffled.take(5).toList());
  }

  Future<void> _searchAdvanced(String country, LanguageProvider lang) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez décrire votre projet")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final localContext = _getFilteredLocalData(all: true);
      final currency = CurrencyService.getCurrency(country);

      final cached = await _cache.getFromCache(query, country);
      if (cached != null) {
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsPage(results: cached, query: query)));
        return;
      }

      final response = await _gemini.generateBusinessIdeas(
        userInput: query,
        country: country,
        localContext: localContext,
        language: lang.locale.languageCode,
        currency: currency,
      );

      final decoded = jsonDecode(response);
      if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
        debugPrint("AI Search Error: ${decoded['error']}");
        if (mounted) {
          final results = _getFilteredLocalData(all: true)..shuffle();
          Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsPage(results: results.take(5).toList(), query: query)));
        }
      } else if (decoded is Map<String, dynamic>) {
        final ideas = decoded['ideas'] ?? [];
        await _cache.saveToCache(query, country, ideas);
        if (mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsPage(results: ideas, query: query)));
      }
    } catch (e) {
       debugPrint("Search Exception: $e");
       final results = _getFilteredLocalData(all: true)..shuffle();
       if (mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => SearchResultsPage(results: results.take(5).toList(), query: query)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSupport(LanguageProvider lang) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF0277BD), Color(0xFF01579B)]),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(lang.translate('support'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 25),
            const TextField(decoration: InputDecoration(labelText: "Email", labelStyle: TextStyle(color: Colors.white70))),
            const SizedBox(height: 10),
            const TextField(maxLines: 3, decoration: InputDecoration(labelText: "Message", labelStyle: TextStyle(color: Colors.white70))),
            const SizedBox(height: 15),
            CustomRoundedButton(text: "Envoyer", onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeaCard(Map<String, dynamic> idea, LanguageProvider lang) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IdeaDetailPage(idea: idea))),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(idea['title'] ?? "Sans titre", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.primary))),
                  Consumer<FavoritesProvider>(
                    builder: (context, fav, _) => IconButton(
                      icon: Icon(fav.isFavorite(idea['title'] ?? "") ? Icons.favorite : Icons.favorite_border, color: fav.isFavorite(idea['title'] ?? "") ? Colors.red : Colors.grey),
                      onPressed: () => fav.toggleFavorite(idea),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(idea['description'] ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
              const SizedBox(height: 12),
              Center(
                child: FadeTransition(
                  opacity: Tween(begin: 0.4, end: 1.0).animate(_pulseController),
                  child: Text("${lang.translate('click_full')} ➔", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final Map<String, dynamic> data = (snapshot.data?.data() as Map<String, dynamic>?) ?? {};
        final name = data['name'] ?? "Entrepreneur";
        final country = data['nationality'] ?? "Cameroun";
        final profilePic = data['profilePicture'];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${_getGreeting(lang)} $name,", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text("${lang.translate('ready_to_conquer')} $country ${CurrencyService.getFlag(country)}", style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              const SizedBox(height: 30),
              Text(lang.translate('categories'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.5),
                itemCount: _displayCategories.length,
                itemBuilder: (context, index) {
                  final cat = _displayCategories[index];
                  final isSelected = _selectedIds.contains(cat['id']);
                  return InkWell(
                    onTap: () => setState(() => isSelected ? _selectedIds.remove(cat['id']!) : _selectedIds.add(cat['id']!)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat['icon'] ?? "🏢", style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(cat['name'] ?? "", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(child: CustomRoundedButton(text: "Catalogue", onPressed: _searchCatalogue)),
                  const SizedBox(width: 10),
                  Expanded(child: ElevatedButton(
                    onPressed: () {
                       showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(25))),
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 20, right: 20, top: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                              const SizedBox(height: 20),
                              const Text("Vision de projet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15),
                              CustomInputField(controller: _searchController, hint: "Décrivez votre projet ici..."),
                              const SizedBox(height: 20),
                              _isLoading 
                                ? const CircularProgressIndicator(color: Color(0xFF0277BD))
                                : CustomRoundedButton(text: "Analyser ma vision", onPressed: () {
                                    Navigator.pop(context);
                                    _searchAdvanced(country, lang);
                                  }),
                            ],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text("Ma Vision", style: TextStyle(fontWeight: FontWeight.bold)),
                  )),
                ],
              ),
              const SizedBox(height: 30),
              if (_isLoading) const Center(child: CircularProgressIndicator()),
              
              if (_localResults.isNotEmpty) ...[
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text("Résultats Catalogue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  TextButton(onPressed: () => setState(() => _localResults = []), child: const Text("Fermer")),
                ]),
                const SizedBox(height: 10),
                ..._localResults.map((idea) => _buildIdeaCard(idea as Map<String, dynamic>, lang)),
                const SizedBox(height: 20),
              ],

              const Text("Tendances globales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildIdeaCard({"title": "Ferme Solaire Intelligente", "description": "Énergie propre pour les zones rurales.", "difficulty": 4}, lang),
              _buildIdeaCard({"title": "École de Codage Mobile", "description": "Formation itinérante pour jeunes.", "difficulty": 3}, lang),
              _buildIdeaCard({"title": "Pisciculture Hors-Sol", "description": "Élevage de poissons en bacs plastiques.", "difficulty": 2}, lang),
              _buildIdeaCard({"title": "Consultant en Exportation", "description": "Aide aux PME pour vendre à l'étranger.", "difficulty": 4}, lang),
              _buildIdeaCard({"title": "Nettoyage Industriel", "description": "Expertise pro en nettoyage chantiers.", "difficulty": 3}, lang),
              const SizedBox(height: 40),
              const Divider(),
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0277BD), Color(0xFF4FC3F7)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text("Besoin d'aide ?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      const Text("Notre équipe est là pour vous accompagner.", style: TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _showSupport(lang),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0277BD), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text("Contacter le support"),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
