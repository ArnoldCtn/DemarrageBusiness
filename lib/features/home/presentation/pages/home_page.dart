import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';
import 'package:demarrage_business/core/widgets/tag_chip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _tags = [
    "football", "cuisine", "code", "musique", "photo", 
    "voyage", "basket", "vente", "art", "services"
  ];
  final List<String> _selected = [];
  bool _isGenerating = false;
  List<Map<String, dynamic>> _generatedIdeas = [];

  final Map<String, List<Map<String, dynamic>>> _businessData = {
    "football": [
      {"title": "Coach de foot de quartier", "price": "5,000 FCFA / séance", "desc": "Organise des séances d'entraînement intensives pour les jeunes talents de ton quartier. C'est un excellent moyen de renforcer la cohésion sociale tout en générant des revenus stables chaque week-end."},
      {"title": "Vente d'équipements sportifs", "price": "15,000 FCFA min", "desc": "Spécialise-toi dans l'importation de maillots authentiques et de chaussures de football de qualité. Le marché local demande des produits durables à des prix compétitifs."},
      {"title": "Arbitre pour tournois locaux", "price": "3,000 FCFA / match", "desc": "Deviens l'arbitre officiel des tournois de vacances. C'est un rôle respecté qui te permet de rester actif dans le milieu du football."}
    ],
    "cuisine": [
      {"title": "Service de livraison", "price": "2,500 FCFA / plat", "desc": "Prépare des repas équilibrés pour les employés de bureau qui n'ont pas le temps de cuisiner. Mettre en avant la qualité et la rapidité pour fidéliser ta clientèle."},
      {"title": "Traiteur événementiel", "price": "50,000 FCFA min", "desc": "Propose des services de traiteur pour les mariages, baptêmes et réunions familiales. La cuisine camerounaise revisitée est très demandée pour ce type d'événements."},
      {"title": "Vente de jus naturels", "price": "500 FCFA / bouteille", "desc": "Produis des jus de fruits locaux (bissap, gingembre) avec un emballage moderne. Vends-les dans les espaces publics ou auprès des commerçants."}
    ],
    "code": [
      {"title": "Création de sites web", "price": "100,000 FCFA / site", "desc": "Conçois des sites vitrines pour les entreprises locales à Douala ou Yaoundé. Une présence en ligne professionnelle est essentielle pour leur croissance."},
      {"title": "Maintenance informatique", "price": "10,000 FCFA / intervention", "desc": "Offre des services de dépannage, installation de logiciels et nettoyage de virus pour les particuliers et petites entreprises."},
      {"title": "Gestionnaire de réseaux sociaux", "price": "30,000 FCFA / mois", "desc": "Aide les boutiques à gérer leur page Facebook et Instagram pour attirer plus de clients avec du contenu visuel attractif."}
    ],
  };

  Future<void> _toggleTag(String tag) async {
    setState(() {
      if (_selected.contains(tag)) {
        _selected.remove(tag);
      } else {
        _selected.add(tag);
      }
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'preferences': _selected});
    } catch (e) {
      debugPrint("Erreur Firestore: $e");
    }
  }

  void _generateBusiness() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Choisis au moins une passion !"))
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedIdeas = [];
    });

    Future.delayed(const Duration(seconds: 2), () {
      List<Map<String, dynamic>> results = [];
      for (String tag in _selected) {
        if (_businessData.containsKey(tag)) {
          results.addAll(_businessData[tag]!);
        }
      }

      // Limiter à 3 suggestions max
      if (results.length > 3) {
        results = results.sublist(0, 3);
      }

      setState(() {
        _generatedIdeas = results;
        _isGenerating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil"), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          final userName = snapshot.data?.get('name') ?? 'Utilisateur';
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenue $userName, prêt à créer des business ? 🇨🇲", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textColor)
                ),
                const SizedBox(height: 10),
                const Text("Transforme tes passions en argent grâce à nos conseils locaux."),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10, runSpacing: 10, 
                  children: _tags.map((t) => TagChip(
                    label: t, 
                    selected: _selected.contains(t), 
                    onTap: () => _toggleTag(t)
                  )).toList()
                ),
                const SizedBox(height: 20),
                Center(
                  child: CustomRoundedButton(
                    text: _isGenerating ? "Génération..." : "Générer mes idées", 
                    onPressed: _isGenerating ? null : _generateBusiness
                  )
                ),
                const SizedBox(height: 30),
                if (_generatedIdeas.isNotEmpty) ...[
                  const Text("Tes opportunités :", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ..._generatedIdeas.map((idea) => Card(
                    margin: const EdgeInsets.only(top: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(idea['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text(idea['desc'], style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 10),
                          Text("Prix estimé : ${idea['price']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  )),
                ],
                const SizedBox(height: 40),
                const Text("FAQ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const ExpansionTile(title: Text("Comment débuter ?"), children: [Padding(padding: EdgeInsets.all(10), child: Text("Sélectionne tes passions et clique sur générer."))]),
                const SizedBox(height: 20),
                const Center(child: Text("© Demarrage Business 2026", style: TextStyle(color: Colors.grey))),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      ),
    );
  }
}
