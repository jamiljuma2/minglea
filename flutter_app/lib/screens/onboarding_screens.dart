import 'package:flutter/material.dart';
import 'onboarding_advanced.dart';

class OnboardingFeaturesScreen extends StatelessWidget {
  const OnboardingFeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Features')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.purple, Colors.amber],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                  value: 0.2, minHeight: 6, color: Colors.pink),
              const SizedBox(height: 24),
              Hero(
                tag: 'onboarding_features',
                child: Image.asset('assets/images/onboarding_features.png',
                    height: 120),
              ),
              const SizedBox(height: 24),
              const Text('What makes Apex special?',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation) => SlideTransition(
                  position:
                      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                          .animate(animation),
                  child: child,
                ),
                child: Column(
                  key: const ValueKey('features'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.pink),
                      title: const Text('Smart matching algorithm',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat, color: Colors.purple),
                      title: const Text('Real-time chat & media sharing',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.security, color: Colors.blue),
                      title: const Text('Safe & secure profiles',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.amber),
                      title: const Text('Premium features & subscriptions',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          const OnboardingSafetyScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Next',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingSafetyScreen extends StatelessWidget {
  const OnboardingSafetyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Tips')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.purple, Colors.amber],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                  value: 0.4, minHeight: 6, color: Colors.pink),
              const SizedBox(height: 24),
              Hero(
                tag: 'onboarding_safety',
                child: Image.asset('assets/images/onboarding_safety.png',
                    height: 120),
              ),
              const SizedBox(height: 24),
              const Text('Stay safe while dating!',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                transitionBuilder: (child, animation) => SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(-1, 0), end: Offset.zero)
                      .animate(animation),
                  child: child,
                ),
                child: Column(
                  key: const ValueKey('safety'),
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.verified_user, color: Colors.green),
                      title: const Text('Never share sensitive info',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: const Text('Meet in public places',
                          style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.report, color: Colors.orange),
                      title: const Text('Report suspicious activity',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => OnboardingInterestsScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                    ),
                  );
                },
                child: const Text('Next',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
