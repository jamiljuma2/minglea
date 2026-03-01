import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'screens/phone_auth_screen.dart';
import 'screens/auth_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'constants/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await dotenv.load();
    NotificationService.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Minglea',
            theme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                secondary: AppColors.secondary,
                onSecondary: AppColors.white,
                background: AppColors.background,
                onBackground: AppColors.black,
                surface: AppColors.white,
                onSurface: AppColors.black,
                error: AppColors.error,
                onError: AppColors.white,
              ),
              fontFamily: AppFonts.mainFont,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 4,
                ),
              ),
              cardTheme: CardThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.card),
                ),
                elevation: 8,
                color: AppColors.white,
                shadowColor: AppColors.primary.withOpacity(0.08),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 2,
                titleTextStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                ),
              ),
              chipTheme: ChipThemeData(
                backgroundColor: AppColors.secondary.withOpacity(0.08),
                labelStyle: const TextStyle(fontFamily: AppFonts.mainFont),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.dark,
                primary: AppColors.primary,
                onPrimary: AppColors.white,
                secondary: AppColors.secondary,
                onSecondary: AppColors.white,
                background: AppColors.darkBackground,
                onBackground: AppColors.white,
                surface: AppColors.darkBackground,
                onSurface: AppColors.white,
                error: AppColors.error,
                onError: AppColors.white,
              ),
              fontFamily: AppFonts.mainFont,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const AuthScreen(),
            debugShowCheckedModeBanner: false,
          );
        }
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
              },
              child: const Text('Email/Password Auth'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
                );
              },
              child: const Text('Phone OTP Auth'),
            ),
          ],
        ),
      ),
    );
  }
}

// ...existing code...
