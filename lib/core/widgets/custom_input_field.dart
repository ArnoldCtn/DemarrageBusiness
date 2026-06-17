import 'package:flutter/material.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  
  const CustomInputField({
    super.key, 
    required this.controller, 
    required this.hint, 
    this.obscure = false
  });
  
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 15), 
    child: TextField(
      controller: controller, 
      obscureText: obscure, 
      decoration: InputDecoration(
        hintText: hint, 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), 
          borderSide: const BorderSide(color: AppColors.borderColor)
        )
      )
    )
  );
}
