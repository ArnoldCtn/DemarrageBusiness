import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:demarrage_business/core/theme/app_colors.dart';
import 'package:demarrage_business/core/theme/theme_provider.dart';
import 'package:demarrage_business/core/providers/language_provider.dart';
import 'package:demarrage_business/features/home/presentation/providers/favorites_provider.dart';
import 'package:demarrage_business/features/navigation/presentation/pages/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // CRITICAL: Ensure .env is loaded before model initialization
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("SUCCESS: .env file loaded.");
    debugPrint("API KEY STATUS: ${dotenv.env['GEMINI_API_KEY'] != null ? 'Present' : 'MISSING'}");
  } catch (e) {
    debugPrint("ERROR: Could not load .env file: $e");
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const DemarrageBusinessApp(),
    ),
  );
}

class DemarrageBusinessApp extends StatelessWidget {
  const DemarrageBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, langProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Demarrage Business',
          themeMode: themeProvider.themeMode,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppColors.backgroundColor,
            primaryColor: AppColors.primary,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: AppColors.primary,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
          locale: langProvider.locale,
          home: const AuthWrapper(),
        );
      },
    );
  }
}
