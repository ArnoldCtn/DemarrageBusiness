import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/widgets/custom_input_field.dart';
import 'package:demarrage_business/core/widgets/custom_rounded_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  Future<void> _signup() async {
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
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        String errorMessage = "Erreur d'inscription";
        if (e is FirebaseAuthException) {
          errorMessage = e.message ?? errorMessage;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage))
        );
      }
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
            CustomInputField(controller: _nameController, hint: "Nom complet"),
            CustomInputField(controller: _emailController, hint: "Email"),
            CustomInputField(controller: _passController, hint: "Mot de passe", obscure: true),
            CustomRoundedButton(text: "Créer mon compte", onPressed: _signup),
          ],
        ),
      ),
    );
  }
}
