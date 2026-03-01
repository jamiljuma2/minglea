import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF4D8D); // Rose pink
  static const Color secondary = Color(0xFF9B5CFF); // Soft purple
  static const Color accent = Color(0xFFFF7A5C); // Coral glow
  static const Color background = Color(0xFFFFF5F8); // Light warm neutral
  static const Color darkBackground = Color(0xFF1E1E2E); // Dark mode
  static const Color gold = Color(0xFFFFD700); // Gold for premium
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color error = Colors.red;
}

class AppGradients {
  static const LinearGradient romantic = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premium = LinearGradient(
    colors: [AppColors.gold, AppColors.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.08),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> neumorphismLight = [
    BoxShadow(
      color: Color(0xFFE5D1D8),
      blurRadius: 24,
      offset: Offset(8, 8),
    ),
    BoxShadow(
      color: AppColors.white,
      blurRadius: 24,
      offset: Offset(-8, -8),
    ),
  ];

  static List<BoxShadow> neumorphismDark = [
    BoxShadow(
      color: Color(0xFF181828),
      blurRadius: 24,
      offset: Offset(8, 8),
    ),
    BoxShadow(
      color: Color(0xFF23233A),
      blurRadius: 24,
      offset: Offset(-8, -8),
    ),
  ];
}

class AppRadii {
  static const double card = 24.0;
  static const double button = 28.0;
  static const double chip = 20.0;
}

class AppFonts {
  static const String mainFont = 'Poppins';
  static const String altFont = 'Inter';
}
