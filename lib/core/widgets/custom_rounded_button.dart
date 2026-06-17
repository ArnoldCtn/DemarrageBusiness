import 'package:flutter/material.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class CustomRoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  
  const CustomRoundedButton({
    super.key, 
    required this.text, 
    this.onPressed
  });
  
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10), 
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, 
        foregroundColor: AppColors.whiteColor, 
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
      ), 
      onPressed: onPressed, 
      child: Text(text)
    )
  );
}
