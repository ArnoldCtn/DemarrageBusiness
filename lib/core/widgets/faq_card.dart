import 'package:flutter/material.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';

class FaqCard extends StatelessWidget {
  final String q, a;
  
  const FaqCard({
    super.key, 
    required this.q, 
    required this.a
  });
  
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10), 
    padding: const EdgeInsets.all(15), 
    decoration: BoxDecoration(
      color: AppColors.cardColor, 
      borderRadius: BorderRadius.circular(15), 
      boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 5)]
    ), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Text(q, style: const TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold)), 
        Text(a, style: const TextStyle(color: Colors.black))
      ]
    )
  );
}
