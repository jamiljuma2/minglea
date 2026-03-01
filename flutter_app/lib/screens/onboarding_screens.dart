import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'onboarding_advanced.dart';

class OnboardingFeaturesScreen extends StatelessWidget {
  const OnboardingFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Features')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.romantic,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: 0.2,
                minHeight: 6,
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.15),
              ),
              const SizedBox(height: 32),
              Hero(
                tag: 'onboarding_features',
                child: Image.asset('assets/images/onboarding_features.png', height: 140),
              ),
              const SizedBox(height: 32),
              Text(
                'What makes Minglea special?',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
                  child: child,
                ),
                child: Column(
                  key: const ValueKey('features'),
                  children: [
                    ListTile(
                      leading: Icon(Icons.favorite, color: AppColors.primary),
                      title: const Text('Smart matching algorithm', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                    ListTile(
                      leading: Icon(Icons.chat, color: AppColors.secondary),
                      title: const Text('Real-time chat & media sharing', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                    ListTile(
                      leading: Icon(Icons.security, color: AppColors.secondary),
                      title: const Text('Safe & secure profiles', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                    ListTile(
                      leading: Icon(Icons.star, color: AppColors.gold),
                      title: const Text('Premium features & subscriptions', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppFonts.mainFont),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const OnboardingSafetyScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSafetyScreen extends StatelessWidget {
  const OnboardingSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Tips')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.romantic,
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: 0.4,
                minHeight: 6,
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.15),
              ),
              const SizedBox(height: 32),
              Hero(
                tag: 'onboarding_safety',
                child: Image.asset('assets/images/onboarding_safety.png', height: 140),
              ),
              const SizedBox(height: 32),
              Text(
                'Stay safe while dating!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(animation),
                  child: child,
                ),
                child: Column(
                  key: const ValueKey('safety'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.verified_user, color: Colors.green),
                      title: const Text('Never share sensitive info', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: const Text('Meet in public places', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.report, color: Colors.orange),
                      title: const Text('Report suspicious activity', style: TextStyle(color: Colors.white, fontFamily: AppFonts.mainFont)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                  elevation: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppFonts.mainFont),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => OnboardingInterestsScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
