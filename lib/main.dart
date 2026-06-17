import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/features/navigation/presentation/pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DemarrageBusinessApp());
}

class DemarrageBusinessApp extends StatelessWidget {
  const DemarrageBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demarrage Business',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Arial',
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.whiteColor,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLightColor,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
