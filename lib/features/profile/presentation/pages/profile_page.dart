import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text("Non connecté"));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snap.hasError) {
              return Center(child: Text("Erreur: ${snap.error}"));
            }

            final data = snap.data?.data() as Map<String, dynamic>?;

            return Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  width: 120, 
                  height: 120, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    border: Border.all(color: AppColors.borderColor, width: 2), 
                    color: AppColors.whiteColor,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/app_logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Nom: ${data?['name'] ?? 'Chargement...'}", 
                  style: const TextStyle(fontSize: 18, color: AppColors.textColor, fontWeight: FontWeight.bold)
                ),
                Text(
                  "Email: ${data?['email'] ?? user.email ?? 'Non renseigné'}", 
                  style: const TextStyle(fontSize: 16, color: AppColors.textLightColor)
                ),
                const SizedBox(height: 40),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: AppColors.primary),
                  title: const Text("Mode Sombre"),
                  trailing: Switch(
                    value: _darkMode, 
                    onChanged: (v) => setState(() => _darkMode = v)
                  ),
                ),
                const Divider(),
                const SizedBox(height: 40),
                CustomRoundedButton(
                  text: "Se déconnecter", 
                  onPressed: () => FirebaseAuth.instance.signOut()
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
