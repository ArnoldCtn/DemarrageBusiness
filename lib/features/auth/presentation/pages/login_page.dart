import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';
import 'package:demarrage_business/features/auth/presentation/pages/signup_page.dart';
import 'package:demarrage_business/features/navigation/presentation/pages/main_app_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passController.text.trim()
      );
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
          const SnackBar(content: Text("Email ou mot de passe incorrect"))
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
            const Text("Connexion", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            CustomInputField(controller: _emailController, hint: "Email"),
            CustomInputField(controller: _passController, hint: "Mot de passe", obscure: true),
            CustomRoundedButton(text: _isLoading ? "Connexion..." : "Se connecter", onPressed: _isLoading ? null : _login),
            TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignupPage())), 
              child: const Text("Pas encore de compte ? Inscrivez-vous")
            ),
          ],
        ),
      ),
    );
  }
}
