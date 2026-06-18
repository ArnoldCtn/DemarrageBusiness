import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:demarrage_business/core/theme/theme_provider.dart';
import 'package:demarrage_business/core/providers/language_provider.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _dob;
  File? _profileImage;
  String? _existingBase64;
  final _imagePicker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _nationalityController.text = data['nationality'] ?? '';
        _emailController.text = data['email'] ?? user.email ?? '';
        final dobStr = data['dob'];
        _dob = dobStr != null ? DateTime.parse(dobStr) : null;
        _existingBase64 = data['profilePicture'];
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) setState(() => _profileImage = File(image.path));
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);
    try {
      if (_emailController.text.trim() != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Un email de vérification a été envoyé."))
          );
        }
      }

      String? base64Image = _existingBase64;
      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'nationality': _nationalityController.text.trim(),
        'email': _emailController.text.trim(),
        'dob': _dob?.toIso8601String(),
        'profilePicture': base64Image,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil mis à jour")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('profile')), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null 
                  ? FileImage(_profileImage!) 
                  : (_existingBase64 != null ? MemoryImage(base64Decode(_existingBase64!)) : null) as ImageProvider?,
                child: (_profileImage == null && _existingBase64 == null) ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),
            CustomInputField(controller: _nameController, hint: "Nom complet"),
            CustomInputField(controller: _emailController, hint: "Email"),
            CustomInputField(controller: _nationalityController, hint: "Nationalité"),
            ListTile(
              title: Text(_dob == null ? "Date de naissance" : DateFormat('dd/MM/yyyy').format(_dob!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dob ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now()
                );
                if (picked != null) setState(() => _dob = picked);
              },
            ),
            const Divider(),
            SwitchListTile(
              title: Text(lang.translate('dark_mode')),
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(),
            ),
            ListTile(
              title: Text(lang.translate('language')),
              trailing: Text(lang.isFrench ? "Français 🇫🇷" : "English 🇺🇸"),
              onTap: () {
                lang.setLocale(lang.isFrench ? const Locale('en', 'US') : const Locale('fr', 'FR'));
              },
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator(color: Color(0xFF0277BD))
              : CustomRoundedButton(
                  text: lang.translate('save'), 
                  onPressed: _saveProfile
                ),
          ],
        ),
      ),
    );
  }
}
