import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demarrage_business/features/home/presentation/providers/favorites_provider.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class IdeaDetailPage extends StatelessWidget {
  final Map<String, dynamic> idea;

  const IdeaDetailPage({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de l'idée"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favProvider, child) {
              final isFav = favProvider.isFavorite(idea['title'] ?? "");
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.white),
                onPressed: () => favProvider.toggleFavorite(idea),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(idea['title'] ?? "Sans titre", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 20),
            _buildSection(Icons.summarize, "Résumé", idea['description'] ?? "N/A"),
            _buildSection(Icons.person, "Pourquoi pour vous ?", idea['why_match'] ?? "Cette idée correspond à votre profil."),
            _buildSection(Icons.monetization_on, "Comment gagner de l'argent ?", idea['revenue_model'] ?? "N/A"),
            _buildSection(Icons.account_balance_wallet, "Budget de démarrage", idea['startup_budget'] ?? "N/A"),
            _buildDifficultySection(idea['difficulty']),
            _buildSection(Icons.flash_on, "Actions immédiates", idea['first_action'] ?? "N/A"),
            _buildSection(Icons.campaign, "Stratégie Marketing", idea['marketing_strategy'] ?? "N/A"),
            _buildSection(Icons.bug_report, "Problème résolu", idea['problem_solved'] ?? "N/A"),
            const SizedBox(height: 30),
            const Divider(),
            const Center(
              child: Text("Lancez-vous dès aujourd'hui !", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(content, style: const TextStyle(fontSize: 16, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection(dynamic difficulty) {
    int stars = 0;
    if (difficulty is int) {
      stars = difficulty;
    } else if (difficulty is String) {
      stars = int.tryParse(difficulty) ?? 0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text("Difficulté", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Row(
              children: List.generate(5, (index) => Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.orange,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
