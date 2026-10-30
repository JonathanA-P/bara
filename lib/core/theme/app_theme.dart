import 'package:flutter/material.dart';

class AppColors {
  // --- WHITE ALFA ---
  static const Color white = Colors.white;
  static Color whiteAlfa90 = Colors.white.withOpacity(0.90);
  static Color whiteAlfa80 = Colors.white.withOpacity(0.80);
  static Color whiteAlfa70 = Colors.white.withOpacity(0.70);
  static Color whiteAlfa60 = Colors.white.withOpacity(0.60);
  static Color whiteAlfa50 = Colors.white.withOpacity(0.50);
  static Color whiteAlfa40 = Colors.white.withOpacity(0.40);
  static Color whiteAlfa30 = Colors.white.withOpacity(0.30);
  static Color whiteAlfa20 = Colors.white.withOpacity(0.20);
  static Color whiteAlfa10 = Colors.white.withOpacity(0.10);

  // --- PRIMARY #1 (HiGavi Blue) ---
  static const Color primary1_900 = Color(0xFF1E2F4D);
  static const Color primary1_800 = Color(0xFF283E66);
  static const Color primary1_700 = Color(0xFF334F80);
  static const Color primary1_600 = Color(0xFF41629E);
  static const Color primary1_500 = Color(0xFF5382C1); // Main Primary
  static const Color primary1 = Color(
    0xFF2163AE,
  ); // Color awalmu tetap disimpan
  static const Color primary1_400 = Color(0xFF6B95CB);
  static const Color primary1_300 = Color(0xFF88A9D6);
  static const Color primary1_200 = Color(0xFFCBD8EB);
  static const Color primary1_100 = Color(0xFFE5ECF5);
  static const Color primary1_50 = Color(0xFFF4F7FA);

  // --- PRIMARY #2 (Dark Slate / Navy) ---
  static const Color primary2_900 = Color(0xFF0F172A);
  static const Color primary2_800 = Color(0xFF131C31);
  static const Color primary2_700 = Color(0xFF1A2640);
  static const Color primary2_600 = Color(0xFF223150);
  static const Color primary2_500 = Color(0xFF2A3C60);
  static const Color primary2_400 = Color(0xFF3B4E75);
  static const Color primary2_300 = Color(0xFF4C618A);
  static const Color primary2_200 = Color(0xFFCBD2E1);
  static const Color primary2_100 = Color(0xFFE2E6F0);
  static const Color primary2_50 = Color(0xFFF1F3F8);

  // --- GREY / NEUTRAL ---
  static const Color grey900 = Color(0xFF475569);
  static const Color grey800 = Color(0xFF64748B);
  static const Color grey700 = Color(0xFF7D8FA9);
  static const Color grey600 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFFB0BDD1);
  static const Color grey400 = Color(0xFFC3CEDF);
  static const Color grey300 = Color(0xFFD6E0EE);
  static const Color grey200 = Color(0xFFE8EEF5);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey50 = Color(0xFFF8FAFC); // Main Canvas Background

  // --- GREEN / SUCCESS ---
  static const Color success900 = Color(0xFF14532D);
  static const Color success800 = Color(0xFF166534);
  static const Color success700 = Color(0xFF15803D);
  static const Color success600 = Color(0xFF16A34A);
  static const Color success500 = Color(0xFF22C55E);
  static const Color success400 = Color(0xFF4ADE80);
  static const Color success300 = Color(0xFF86EFAC);
  static const Color success200 = Color(0xFFBBF7D0);
  static const Color success100 = Color(0xFFDCFCE7);
  static const Color success50 = Color(0xFFF0FDF4);

  // --- RED / DANGER ---
  static const Color danger900 = Color(0xFF7F1D1D);
  static const Color danger800 = Color(0xFF991B1B);
  static const Color danger700 = Color(0xFFB91C1C);
  static const Color danger600 = Color(0xFFDC2626);
  static const Color danger500 = Color(0xFFEF4444);
  static const Color danger400 = Color(0xFFF87171);
  static const Color danger300 = Color(0xFFFCA5A5);
  static const Color danger200 = Color(0xFFFECACA);
  static const Color danger100 = Color(0xFFFEE2E2);
  static const Color danger50 = Color(0xFFFEF2F2);

  // --- YELLOW / WARNING ---
  static const Color warning900 = Color(0xFF78350F);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning300 = Color(0xFFFDE047);
  static const Color warning200 = Color(0xFFFEF08A);
  static const Color warning100 = Color(0xFFFEF9C3);
  static const Color warning50 = Color(0xFFFFFBEB);

  // --- BLUE / INFO ---
  static const Color info900 = Color(0xFF0C4A6E);
  static const Color info800 = Color(0xFF075985);
  static const Color info700 = Color(0xFF0369A1);
  static const Color info600 = Color(0xFF0284C7);
  static const Color info500 = Color(0xFF0EA5E9);
  static const Color info400 = Color(0xFF38BDF8);
  static const Color info300 = Color(0xFF7DD3FC);
  static const Color info200 = Color(0xFFBAE6FD);
  static const Color info100 = Color(0xFFE0F2FE);
  static const Color info50 = Color(0xFFF0F9FF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary1_500,
      scaffoldBackgroundColor: AppColors.grey50,
      fontFamily: 'Poppins',
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary1_500,
        primary: AppColors.primary1_500,
        surface: AppColors.grey50,
      ),
    );
  }
}
