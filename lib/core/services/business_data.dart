class BusinessData {
  static const Map<String, dynamic> data = {
    "categories": [
      {
        "id": "agriculture",
        "display_name": "Agriculture & Élevage",
        "icon": "🌱",
        "ideas": [
          {"title": "Ferme de Volaille Bio", "description": "Production de poulets de chair nourris aux céréales locales.", "why_match": "Demande forte et constante.", "revenue_model": "Vente directe.", "startup_budget": "500k FCFA", "difficulty": 3, "first_action": "Trouver terrain.", "marketing_strategy": "WhatsApp.", "problem_solved": "Viande saine."},
          {"title": "Serre Maraîchère", "description": "Tomates et poivrons toute l'année.", "why_match": "Indépendant des saisons.", "revenue_model": "Vente supermarchés.", "startup_budget": "1.5M FCFA", "difficulty": 4, "first_action": "Acheter kit serre.", "marketing_strategy": "Hôtels.", "problem_solved": "Pénuries."},
          {"title": "Élevage Porcin Moderne", "description": "Exploitation porcine hygiénique.", "why_match": "Haute rentabilité.", "revenue_model": "Vente charcuterie.", "startup_budget": "800k FCFA", "difficulty": 3, "first_action": "Bâtir porcherie.", "marketing_strategy": "Bouchers.", "problem_solved": "Qualité viande."},
          {"title": "Pisciculture en Bacs", "description": "Élevage intensif Silures/Tilapias.", "why_match": "Peu d'espace requis.", "revenue_model": "Vente poisson frais.", "startup_budget": "300k FCFA", "difficulty": 2, "first_action": "Installer bacs.", "marketing_strategy": "Vente quartier.", "problem_solved": "Importations."},
          {"title": "Transformation de Manioc", "description": "Production de farine et gari.", "why_match": "Valorisation locale.", "revenue_model": "Vente produits emballés.", "startup_budget": "600k FCFA", "difficulty": 3, "first_action": "Acheter râpeuse.", "marketing_strategy": "Packaging pro.", "problem_solved": "Pertes récoltes."}
        ]
      },
      {
        "id": "mechanic",
        "display_name": "Mécanique & Ingénierie",
        "icon": "🔧",
        "ideas": [
          {"title": "Diagnostic Automobile Mobile", "description": "Scanneur à domicile.", "why_match": "Gain de temps client.", "revenue_model": "Forfait diagnostic.", "startup_budget": "300k FCFA", "difficulty": 3, "first_action": "Acheter scanneur.", "marketing_strategy": "Facebook.", "problem_solved": "Arnaques mécaniques."},
          {"title": "Maintenance de Drones", "description": "Réparation drones agricoles/civils.", "why_match": "Marché explosion.", "revenue_model": "Forfait maintenance.", "startup_budget": "1M FCFA", "difficulty": 5, "first_action": "Formation DJI.", "marketing_strategy": "Agences com.", "problem_solved": "Manque SAV."},
          {"title": "Soudure de Précision", "description": "Portails et meubles industriels.", "why_match": "Besoin bâtiment.", "revenue_model": "Facturation projet.", "startup_budget": "500k FCFA", "difficulty": 3, "first_action": "Acheter Inverter.", "marketing_strategy": "Instagram.", "problem_solved": "Finitions bâclées."},
          {"title": "Réparation Groupes Électrogènes", "description": "Entretien générateurs.", "why_match": "Délestages fréquents.", "revenue_model": "Contrats maintenance.", "startup_budget": "200k FCFA", "difficulty": 4, "first_action": "Prospection PME.", "marketing_strategy": "Direct.", "problem_solved": "Arrêts production."},
          {"title": "Impression 3D de Pièces", "description": "Pièces rechange plastiques.", "why_match": "Innovation réparation.", "revenue_model": "Vente à la pièce.", "startup_budget": "400k FCFA", "difficulty": 4, "first_action": "Acheter imprimante.", "marketing_strategy": "Dépanneurs.", "problem_solved": "Pièces introuvables."}
        ]
      },
      {
        "id": "digital_services",
        "display_name": "Services Digitaux",
        "icon": "💻",
        "ideas": [
          {"title": "Agence Social Media", "description": "Gestion FB/TikTok pour PME.", "why_match": "Besoin visibilité.", "revenue_model": "Abonnement mensuel.", "startup_budget": "50k FCFA.", "difficulty": 2, "first_action": "Portfolio.", "marketing_strategy": "Prospection.", "problem_solved": "Absence digitale."},
          {"title": "Formation Codage Enfants", "description": "Cours Python/HTML ludiques.", "why_match": "Compétence futur.", "revenue_model": "Frais inscription.", "startup_budget": "0 FCFA.", "difficulty": 3, "first_action": "Programme.", "marketing_strategy": "Écoles.", "problem_solved": "Lacune numérique."},
          {"title": "Studio Design Logos", "description": "Identité visuelle marques.", "why_match": "Image pro.", "revenue_model": "Forfait création.", "startup_budget": "0 FCFA.", "difficulty": 2, "first_action": "Tuto Canva/Figma.", "marketing_strategy": "Upwork.", "problem_solved": "Amateurisme."},
          {"title": "Assistance Virtuelle", "description": "Support administratif distant.", "why_match": "Délégation coût.", "revenue_model": "Tarif horaire.", "startup_budget": "0 FCFA.", "difficulty": 2, "first_action": "Se lister sites AV.", "marketing_strategy": "LinkedIn.", "problem_solved": "Surcharge patrons."},
          {"title": "Rédaction SEO", "description": "Articles blog optimisés.", "why_match": "Vente par contenu.", "revenue_model": "Paiement article.", "startup_budget": "0 FCFA.", "difficulty": 3, "first_action": "Base SEO.", "marketing_strategy": "Blog témoin.", "problem_solved": "Invisibilité Google."}
        ]
      },
      {
        "id": "ecommerce",
        "display_name": "E-Commerce",
        "icon": "🛍️",
        "ideas": [
          {"title": "Boutique Tech en Ligne", "description": "Écouteurs, montres, câbles.", "why_match": "Facile livraison.", "revenue_model": "Marge vente.", "startup_budget": "200k FCFA.", "difficulty": 2, "first_action": "AliExpress.", "marketing_strategy": "TikTok ads.", "problem_solved": "Accès gadgets."},
          {"title": "Friperie de Luxe", "description": "Sélection habits premium.", "why_match": "Style petit prix.", "revenue_model": "Marge par pièce.", "startup_budget": "50k FCFA.", "difficulty": 1, "first_action": "Balle 1er choix.", "marketing_strategy": "WhatsApp Status.", "problem_solved": "Coût vêtements."},
          {"title": "Épicerie Fine Bio", "description": "Miel, poivre, huiles.", "why_match": "Digitalisation manger.", "revenue_model": "Commission vente.", "startup_budget": "150k FCFA.", "difficulty": 3, "first_action": "Partenariats.", "marketing_strategy": "Instagram.", "problem_solved": "Produits terroir."},
          {"title": "Dropshipping Local", "description": "Vendre stock grossistes.", "why_match": "Zéro stock risque.", "revenue_model": "Marge négo.", "startup_budget": "0 FCFA.", "difficulty": 3, "first_action": "Négo grossistes.", "marketing_strategy": "Catalogue PDF.", "problem_solved": "Visibilité grossistes."},
          {"title": "Cadeaux Personnalisés", "description": "Mugs, t-shirts sur mesure.", "why_match": "Fêtes et anniversaires.", "revenue_model": "Prix objet.", "startup_budget": "300k FCFA.", "difficulty": 2, "first_action": "Machine presse.", "marketing_strategy": "Promos évents.", "problem_solved": "Cadeaux uniques."}
        ]
      },
      {
        "id": "intelligence_artificielle",
        "display_name": "IA & Tech",
        "icon": "🤖",
        "ideas": [
          {"title": "Agence Automation IA", "description": "Automatisation tâches répétitives.", "why_match": "Gain productivité.", "revenue_model": "Forfait mensuel.", "startup_budget": "0 FCFA.", "difficulty": 4, "first_action": "Apprendre Make/Zapier.", "marketing_strategy": "LinkedIn.", "problem_solved": "Lenteur humaine."},
          {"title": "Consultant en Chatbots", "description": "IA pour service client.", "why_match": "Réponse 24/7.", "revenue_model": "Prix par bot.", "startup_budget": "50k FCFA.", "difficulty": 3, "first_action": "Tester Botpress.", "marketing_strategy": "Démarchage sites.", "problem_solved": "Surcharge support."},
          {"title": "Création Images Pro IA", "description": "Visuels marketing générés.", "why_match": "Coût shooting bas.", "revenue_model": "Prix par pack.", "startup_budget": "100k FCFA.", "difficulty": 2, "first_action": "Maîtriser Midjourney.", "marketing_strategy": "Portfolio Insta.", "problem_solved": "Budget photo élevé."},
          {"title": "Formation IA pour PME", "description": "Ateliers outils productivité.", "why_match": "Tendance incontournable.", "revenue_model": "Ticket formation.", "startup_budget": "0 FCFA.", "difficulty": 3, "first_action": "Webinaire gratuit.", "marketing_strategy": "Groupes Business.", "problem_solved": "Retard technologique."},
          {"title": "Analyse Données Ventes", "description": "Prédiction stocks via IA.", "why_match": "Zéro gaspillage.", "revenue_model": "Contrat annuel.", "startup_budget": "0 FCFA.", "difficulty": 5, "first_action": "Certif Data Science.", "marketing_strategy": "Supermarchés.", "problem_solved": "Pertes stocks."}
        ]
      },
      {
        "id": "event_planning",
        "display_name": "Événementiel",
        "icon": "🎊",
        "ideas": [
          {"title": "Organisateur Anniversaires", "description": "Fêtes clés en main.", "why_match": "Parents occupés.", "revenue_model": "Marge sur prestation.", "startup_budget": "50k FCFA.", "difficulty": 2, "first_action": "Dossier déco.", "marketing_strategy": "Facebook Ads.", "problem_solved": "Stress organisation."},
          {"title": "Location Matériel Fête", "description": "Chaises, tentes, sono.", "why_match": "Demande récurrente.", "revenue_model": "Prix location/jour.", "startup_budget": "1M FCFA.", "difficulty": 3, "first_action": "Achat pack sono.", "marketing_strategy": "Panneaux quartier.", "problem_solved": "Coût achat matériel."},
          {"title": "Décoration Ballons Pro", "description": "Arches et murs de ballons.", "why_match": "Visuel impactant.", "revenue_model": "Forfait déco.", "startup_budget": "100k FCFA.", "difficulty": 2, "first_action": "Kit gonflage.", "marketing_strategy": "TikTok.", "problem_solved": "Déco amateur."},
          {"title": "Wedding Planner", "description": "Mariages de rêve.", "why_match": "Budget mariage élevé.", "revenue_model": "% budget global.", "startup_budget": "0 FCFA.", "difficulty": 4, "first_action": "Réseau traiteurs.", "marketing_strategy": "Salons mariage.", "problem_solved": "Conflits familiaux."},
          {"title": "Photobooth Mobile", "description": "Location borne photo.", "why_match": "Animation fun.", "revenue_model": "Forfait soirée.", "startup_budget": "800k FCFA.", "difficulty": 2, "first_action": "Acheter borne.", "marketing_strategy": "Partenariat DJ.", "problem_solved": "Souvenirs fades."}
        ]
      },
      {
        "id": "pet_services",
        "display_name": "Services Animaux",
        "icon": "🐶",
        "ideas": [
          {"title": "Pension pour Chiens", "description": "Garde durant les vacances.", "why_match": "Propriétaires voyagent.", "revenue_model": "Prix par nuitée.", "startup_budget": "200k FCFA.", "difficulty": 3, "first_action": "Espace clôturé.", "marketing_strategy": "Vétérinaires.", "problem_solved": "Abandon temporaire."},
          {"title": "Toilettage Mobile", "description": "Lavage et coupe à domicile.", "why_match": "Pratique client.", "revenue_model": "Prix prestation.", "startup_budget": "150k FCFA.", "difficulty": 2, "first_action": "Kit tonte/shampoo.", "marketing_strategy": "Flyers parcs.", "problem_solved": "Transport animal."},
          {"title": "Vente Croquettes Bio", "description": "Alimentation saine animaux.", "why_match": "Santé animale.", "revenue_model": "Marge sac.", "startup_budget": "300k FCFA.", "difficulty": 2, "first_action": "Partenariat local.", "marketing_strategy": "Groupe FB Chiens.", "problem_solved": "Maladies digestives."},
          {"title": "Dressage Obéissance", "description": "Éducation chiots.", "why_match": "Chiens indisciplinés.", "revenue_model": "Heure dressage.", "startup_budget": "0 FCFA.", "difficulty": 4, "first_action": "Vidéo démo.", "marketing_strategy": "WhatsApp.", "problem_solved": "Agressivité/Dégâts."},
          {"title": "Accessoires Personnalisés", "description": "Colliers gravés.", "why_match": "Amour animal.", "revenue_model": "Prix accessoire.", "startup_budget": "50k FCFA.", "difficulty": 1, "first_action": "Gravure laser.", "marketing_strategy": "Insta Pets.", "problem_solved": "Perte animal."}
        ]
      },
      {
        "id": "cleaning_services",
        "display_name": "Nettoyage",
        "icon": "🧼",
        "ideas": [
          {"title": "Nettoyage Canapés/Tapis", "description": "Injection/Extraction pro.", "why_match": "Saleté incrustée.", "revenue_model": "Prix par m2/place.", "startup_budget": "400k FCFA.", "difficulty": 2, "first_action": "Acheter machine.", "marketing_strategy": "Stickers.", "problem_solved": "Allergies/Taches."},
          {"title": "Ménage Bureau PME", "description": "Entretien régulier locaux.", "why_match": "Image entreprise.", "revenue_model": "Contrat mensuel.", "startup_budget": "100k FCFA.", "difficulty": 2, "first_action": "Équipe 2 pers.", "marketing_strategy": "Prospection.", "problem_solved": "Locaux insalubres."},
          {"title": "Nettoyage Vitres Vitrines", "description": "Spécialiste commerces.", "why_match": "Visibilité rayons.", "revenue_model": "Forfait passage.", "startup_budget": "50k FCFA.", "difficulty": 1, "first_action": "Raclettes pro.", "marketing_strategy": "Tournée centre-ville.", "problem_solved": "Vitrines sales."},
          {"title": "Lavage Auto Sans Eau", "description": "Service écologique mobile.", "why_match": "Économie eau.", "revenue_model": "Prix par voiture.", "startup_budget": "150k FCFA.", "difficulty": 2, "first_action": "Produits bio.", "marketing_strategy": "Parking supermarché.", "problem_solved": "Gaspillage eau."},
          {"title": "Désinfection nuisibles", "description": "Traitement insectes/rats.", "why_match": "Santé publique.", "revenue_model": "Forfait intervention.", "startup_budget": "300k FCFA.", "difficulty": 4, "first_action": "Agréments/Produits.", "marketing_strategy": "Restaurateurs.", "problem_solved": "Invasions nuisibles."}
        ]
      },
      {
        "id": "tourism_travel",
        "display_name": "Tourisme & Voyage",
        "icon": "✈️",
        "ideas": [
          {"title": "Guide Touristique Local", "description": "Visites insolites villes.", "why_match": "Besoin authenticité.", "revenue_model": "Prix par personne.", "startup_budget": "0 FCFA.", "difficulty": 2, "first_action": "Circuit thématique.", "marketing_strategy": "Airbnb Experience.", "problem_solved": "Tourisme classique."},
          {"title": "Location Appart Meublé", "description": "Gestion type Airbnb.", "why_match": "Alternative hôtel.", "revenue_model": "Loyer par nuit.", "startup_budget": "500k FCFA.", "difficulty": 3, "first_action": "Bail locatif.", "marketing_strategy": "Booking.com.", "problem_solved": "Hébergement cher."},
          {"title": "Agence Excursions Week-end", "description": "Sorties nature organisées.", "why_match": "Besoin évasion.", "revenue_model": "Ticket tout compris.", "startup_budget": "0 FCFA.", "difficulty": 3, "first_action": "Contrat bus.", "marketing_strategy": "Groupes WhatsApp.", "problem_solved": "Ennui week-end."},
          {"title": "Conciergerie Voyageurs", "description": "Accueil et services aéroport.", "why_match": "Sérénité arrivée.", "revenue_model": "Frais service.", "startup_budget": "0 FCFA.", "difficulty": 2, "first_action": "Site simple.", "marketing_strategy": "Forums expats.", "problem_solved": "Arnaques taxi."},
          {"title": "Vente Valises/Accessoires", "description": "Équipement complet voyage.", "why_match": "Prêt au départ.", "revenue_model": "Marge vente.", "startup_budget": "200k FCFA.", "difficulty": 2, "first_action": "Stock qualité.", "marketing_strategy": "Près agences voyage.", "problem_solved": "Bagages fragiles."}
        ]
      }
    ]
  };
}
