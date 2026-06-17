import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';
import 'package:demarrage_business/features/auth/presentation/pages/login_page.dart';
import 'package:demarrage_business/features/navigation/presentation/pages/main_app_container.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() => _isLoading = true);
    try {
      UserCredential creds = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passController.text.trim()
      );
      await FirebaseFirestore.instance.collection('users').doc(creds.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'preferences': []
      });
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (_) => MainAppContainer())
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
        );
      }
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
            Container(
              width: 120, height: 120,
              decoration: const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/images/app_logo.jpg'), fit: BoxFit.cover)),
            ),
            const SizedBox(height: 20),
            const Text("Créer un compte", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            CustomInputField(controller: _nameController, hint: "Nom complet"),
            CustomInputField(controller: _emailController, hint: "Email"),
            CustomInputField(controller: _passController, hint: "Mot de passe", obscure: true),
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
