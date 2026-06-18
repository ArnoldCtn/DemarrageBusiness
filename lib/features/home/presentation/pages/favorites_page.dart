import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demarrage_business/features/home/presentation/providers/favorites_provider.dart';
import 'package:demarrage_business/features/home/presentation/pages/idea_detail_page.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/providers/language_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
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

  Widget _buildIdeaCard(Map<String, dynamic> idea, FavoritesProvider favProvider, LanguageProvider lang) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
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
                  Expanded(child: Text(idea['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.primary))),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => favProvider.toggleFavorite(idea),
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
    return Consumer<FavoritesProvider>(
      builder: (context, favProvider, child) {
        final favorites = favProvider.favorites;
        if (favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text("Aucun business en favoris pour le moment.", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            return _buildIdeaCard(favorites[index], favProvider, lang);
          },
        );
      },
    );
  }
}
