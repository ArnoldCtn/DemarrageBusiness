import 'package:flutter/material.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  
  const TagChip({
    super.key, 
    required this.label, 
    required this.selected, 
    required this.onTap
  });
  
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap, 
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.borderColor, 
        borderRadius: BorderRadius.circular(30)
      ), 
      child: Text(
        label, 
        style: TextStyle(color: selected ? AppColors.whiteColor : AppColors.textColor)
      )
    )
  );
}
