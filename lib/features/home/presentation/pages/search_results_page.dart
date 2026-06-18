import 'package:flutter/material.dart';
import 'package:demarrage_business/features/home/presentation/pages/idea_detail_page.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class SearchResultsPage extends StatefulWidget {
  final List<dynamic> results;
  final String query;

  const SearchResultsPage({super.key, required this.results, required this.query});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Résultats: ${widget.query}"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: widget.results.isEmpty 
        ? const Center(child: Text("Aucun résultat trouvé."))
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: widget.results.length,
            itemBuilder: (context, index) {
              final idea = widget.results[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => IdeaDetailPage(idea: idea))),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(idea['title'] ?? "Sans titre", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                        const SizedBox(height: 5),
                        Text(idea['description'] ?? "Pas de description disponible.", maxLines: 3, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Center(
                          child: FadeTransition(
                            opacity: Tween(begin: 0.4, end: 1.0).animate(_pulseController),
                            child: const Text("Voir l'analyse complète ➔", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
