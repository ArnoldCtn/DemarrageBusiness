import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demarrage_business/core/providers/language_provider.dart';
import 'package:demarrage_business/core/theme/theme_provider.dart';
import 'package:demarrage_business/features/home/presentation/pages/favorites_page.dart';
import 'package:demarrage_business/features/auth/presentation/pages/login_page.dart';
import 'package:demarrage_business/core/services/currency_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final name = data['name'] ?? "Entrepreneur";
          final email = data['email'] ?? user?.email ?? "";
          final country = data['nationality'] ?? "Cameroun";
          final profilePic = data['profilePicture'];

          return Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: profilePic != null ? MemoryImage(base64Decode(profilePic)) : null,
                  child: profilePic == null ? const Icon(Icons.person, size: 40) : null,
                ),
                decoration: const BoxDecoration(color: Color(0xFF0277BD)),
                otherAccountsPictures: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Text(CurrencyService.getFlag(country), style: const TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.public, color: Color(0xFF0277BD)),
                title: Text(country),
                subtitle: const Text("Pays de résidence"),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: Text(lang.translate('home')),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline),
                      title: Text(lang.translate('favorites')),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
                      },
                    ),
                    SwitchListTile(
                      secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFF0277BD)),
                      title: Text(lang.translate('dark_mode')),
                      value: themeProvider.isDarkMode,
                      onChanged: (val) => themeProvider.toggleTheme(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.redAccent),
                      title: Text(lang.translate('logout'), style: const TextStyle(color: Colors.redAccent)),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("v1.0.0 Alpha", style: TextStyle(color: Colors.grey, fontSize: 10)),
              )
            ],
          );
        },
      ),
    );
  }
}
