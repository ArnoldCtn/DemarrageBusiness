import 'package:flutter/material.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: TextField(
          controller: widget.controller,
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  )
                : null,
          ),
        ),
      );
}
