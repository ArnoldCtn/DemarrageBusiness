import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';
import 'package:demarrage_business/features/auth/presentation/pages/login_page.dart';
import 'package:demarrage_business/features/navigation/presentation/pages/main_app_container.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nationalityController = TextEditingController();
  DateTime? _dob;
  File? _profileImage;
  final _imagePicker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) setState(() => _profileImage = File(image.path));
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _signup() async {
    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez sélectionner votre date de naissance")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      String? base64Image;
      if (_profileImage != null) {
        final bytes = await _profileImage!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      UserCredential creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passController.text.trim()
      );
      await FirebaseFirestore.instance.collection('users').doc(creds.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'nationality': _nationalityController.text.trim(),
        'dob': _dob!.toIso8601String(),
        'profilePicture': base64Image,
        'preferences': []
      });
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainAppContainer()));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text("Démarrage Business", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),
            CustomInputField(controller: _nameController, hint: "Nom complet"),
            CustomInputField(controller: _emailController, hint: "Email"),
            CustomInputField(controller: _nationalityController, hint: "Nationalité (ex: Cameroun)"),
            CustomInputField(controller: _passController, hint: "Mot de passe", obscure: true),
            ListTile(
              title: Text(_dob == null ? "Date de naissance" : DateFormat('dd/MM/yyyy').format(_dob!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            CustomRoundedButton(text: _isLoading ? "Chargement..." : "Créer mon compte", onPressed: _isLoading ? null : _signup),
            TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text("Déjà un compte ? Connectez-vous")
            ),
          ],
        ),
      ),
    );
  }
}
