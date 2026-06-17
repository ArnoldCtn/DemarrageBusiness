import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';
import 'package:demarrage_business/features/auth/presentation/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String _error = "";

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passController.text.trim()
      );
    } catch (e) {
      setState(() => _error = "Identifiants invalides.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 80),
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
            const SizedBox(height: 30),
            const Text(
              "Connexion", 
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: AppColors.textColor
              )
            ),
            const SizedBox(height: 40),
            CustomInputField(controller: _emailController, hint: "Email"),
            CustomInputField(controller: _passController, hint: "Mot de passe", obscure: true),
            if (_error.isNotEmpty) Padding(
              padding: const EdgeInsets.all(8.0), 
              child: Text(_error, style: const TextStyle(color: Colors.red))
            ),
            CustomRoundedButton(text: "Se connecter", onPressed: _login),
            TextButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const SignupPage())
              ), 
              child: const Text("Créer un compte", style: TextStyle(color: AppColors.textColor))
            ),
          ],
        ),
      ),
    );
  }
}
