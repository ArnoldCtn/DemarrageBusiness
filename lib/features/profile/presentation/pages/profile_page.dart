import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demarrage_business/core/services/currency_service.dart';
import 'package:demarrage_business/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:demarrage_business/core/providers/language_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final lang = Provider.of<LanguageProvider>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        final name = data['name'] ?? "Entrepreneur";
        final email = data['email'] ?? user?.email ?? "";
        final country = data['nationality'] ?? "Cameroun";
        final profilePic = data['profilePicture'];
        final dobStr = data['dob'];
        final dob = dobStr != null ? DateTime.parse(dobStr) : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF0277BD),
                backgroundImage: profilePic != null ? MemoryImage(base64Decode(profilePic)) : null,
                child: profilePic == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
              ),
              const SizedBox(height: 15),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Chip(
                label: Text("$country ${CurrencyService.getFlag(country)}"),
                backgroundColor: const Color(0xFF0277BD).withValues(alpha: 0.1),
              ),
              const SizedBox(height: 30),
              _buildInfoTile(Icons.cake, "Date de naissance", dob != null ? "${dob.day}/${dob.month}/${dob.year}" : "Non renseignée"),
              _buildInfoTile(Icons.language, lang.translate('language'), lang.isFrench ? "Français" : "English"),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditPage())),
                icon: const Icon(Icons.edit),
                label: const Text("Modifier mon profil"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0277BD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0277BD)),
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
