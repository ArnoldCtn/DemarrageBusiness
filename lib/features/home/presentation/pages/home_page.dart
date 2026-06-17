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
      {"title": "Service de livraison de plats locaux", "price": "2,500 FCFA / plat", "desc": "Prépare des repas authentiques (Ndolé, Eru, Koki) pour les employés de bureau qui n'ont pas le temps de cuisiner. Mettre en avant la qualité 'comme au village'."},
      {"title": "Traiteur pour cérémonies", "price": "50,000 FCFA min", "desc": "Propose des services de traiteur pour les mariages, baptêmes et réunions familiales. La cuisine camerounaise revisitée est très demandée pour ces moments forts."},
      {"title": "Vente de jus naturels 'made in Cameroon'", "price": "500 FCFA / bouteille", "desc": "Produis des jus (Bissap, Gingembre, Baobab) avec un emballage moderne et hygiénique. Vends-les dans les espaces publics ou auprès des commerçants."}
    ],
    "code": [
      {"title": "Création de sites web pour PME", "price": "100,000 FCFA / site", "desc": "Conçois des sites vitrines pour les boutiques et petites entreprises locales. Une présence en ligne professionnelle est essentielle pour qu'elles se démarquent."},
      {"title": "Maintenance et réparation informatique", "price": "10,000 FCFA / intervention", "desc": "Offre des services de dépannage, installation de logiciels et nettoyage de virus pour les particuliers qui ont souvent du mal à trouver des techniciens de confiance."},
      {"title": "Community Management", "price": "30,000 FCFA / mois", "desc": "Aide les commerçants de ton quartier à gérer leur page Facebook et Instagram pour attirer plus de clients avec du contenu visuel attractif."}
    ],
    "musique": [
      {"title": "DJ pour soirées et événements", "price": "25,000 FCFA / soirée", "desc": "Anime les anniversaires, mariages et soirées privées avec un mix de sons locaux (Bikutsi, Makossa) et hits internationaux. Une ambiance garantie qui fidélise."},
      {"title": "Cours de musique à domicile", "price": "15,000 FCFA / mois", "desc": "Enseigne le piano, la guitare ou le chant aux enfants ou adultes passionnés de ton voisinage."},
      {"title": "Studio d'enregistrement amateur", "price": "5,000 FCFA / heure", "desc": "Propose un petit studio de qualité pour permettre aux artistes locaux de poser leurs voix sur des maquettes sans se ruiner."}
    ],
    "photo": [
      {"title": "Photographe événementiel", "price": "15,000 FCFA / événement", "desc": "Capture les moments forts des fêtes de quartier, anniversaires et remises de diplômes. La qualité de tes retouches fera toute la différence."},
      {"title": "Service de portraits pour réseaux sociaux", "price": "5,000 FCFA / séance", "desc": "Propose des séances photos en extérieur pour aider les jeunes entrepreneurs ou influenceurs à avoir des images professionnelles pour leur profil."},
      {"title": "Impression photo instantanée", "price": "500 FCFA / photo", "desc": "Utilise une imprimante portable lors de grandes fêtes pour offrir des souvenirs immédiats aux invités."}
    ],
    "voyage": [
      {"title": "Guide touristique local", "price": "10,000 FCFA / jour", "desc": "Fais découvrir les trésors cachés de ta ville ou de ta région aux nouveaux arrivants ou aux touristes curieux d'authenticité."},
      {"title": "Service de réservation de bus/hôtels", "price": "2,000 FCFA / réservation", "desc": "Aide les gens qui ne maîtrisent pas Internet à réserver leurs billets ou leurs hôtels en ligne en toute sécurité."},
      {"title": "Vente d'accessoires de voyage", "price": "3,000 FCFA min", "desc": "Vends des cadenas de sécurité, des oreillers de voyage, ou des chargeurs portables aux voyageurs qui partent des gares routières."}
    ],
    "basket": [
      {"title": "Organisateur de tournois de rue", "price": "50,000 FCFA / tournoi", "desc": "Organise des tournois de 3x3 dans ton quartier. En vendant des boissons et de la nourriture aux spectateurs, tu démultiplies tes gains."},
      {"title": "Vente de vêtements 'Streetwear'", "price": "10,000 FCFA min", "desc": "Importe ou crée des t-shirts et shorts de style basket. La culture urbaine est en pleine expansion au Cameroun."},
      {"title": "Coach technique", "price": "4,000 FCFA / séance", "desc": "Apprends les fondamentaux du basket aux jeunes débutants qui rêvent de faire carrière dans ce sport."}
    ],
    "vente": [
      {"title": "Vente de friperie de luxe", "price": "2,000 FCFA min", "desc": "Sélectionne des pièces uniques dans les balles de friperie ('foh') et revends-les après un bon lavage et un repassage soigné. La présentation augmente la valeur."},
      {"title": "Service de commissionnaire (Achat pour autrui)", "price": "1,000 FCFA / course", "desc": "Propose de faire les courses difficiles ou volumineuses pour les personnes occupées au marché central ou dans les grands magasins."},
      {"title": "Vente de produits cosmétiques naturels", "price": "3,000 FCFA min", "desc": "Revends des beurres de karité, huiles essentielles ou savons artisanaux. Les Camerounais sont de plus en plus soucieux de leur peau."}
    ],
    "art": [
      {"title": "Peinture décorative d'intérieur", "price": "20,000 FCFA / mur", "desc": "Décore les salons ou les chambres avec des fresques murales personnalisées ou des motifs modernes."},
      {"title": "Création de bijoux artisanaux", "price": "5,000 FCFA min", "desc": "Fabrique des colliers et bracelets avec des matériaux locaux (perles, bois, cuir). Le 'made in Cameroon' est très tendance."},
      {"title": "Atelier d'art pour enfants", "price": "10,000 FCFA / mois", "desc": "Organise des ateliers de dessin ou de poterie pendant les vacances pour occuper les enfants de manière créative."}
    ],
    "services": [
      {"title": "Nettoyage à domicile", "price": "15,000 FCFA / intervention", "desc": "Propose un service de ménage complet pour les maisons ou bureaux avec des produits écologiques. La rigueur et la confiance sont tes atouts."},
      {"title": "Service d'aide administrative", "price": "2,000 FCFA / document", "desc": "Aide les personnes âgées ou occupées à remplir leurs formulaires, constituer des dossiers ou faire des photocopies légalisées."},
      {"title": "Coiffure et esthétique à domicile", "price": "5,000 FCFA min", "desc": "Déplace-toi chez tes clientes pour des tresses ou des soins. Le confort du domicile est un service très recherché."}
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
