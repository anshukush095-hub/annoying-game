import 'package:flutter/material.dart';

class GameTheme {
  // Primary Palette matching reference image
  static const Color skyBlue = Color(0xFF4FC3F7);
  static const Color skyBlueDark = Color(0xFF0288D1);
  static const Color grassGreen = Color(0xFF7CB342);
  static const Color grassGreenDark = Color(0xFF558B2F);
  static const Color brightGreen = Color(0xFF4CAF50);
  static const Color brightGreenDark = Color(0xFF2E7D32);
  static const Color goldYellow = Color(0xFFFFD54F);
  static const Color goldYellowDark = Color(0xFFFFA000);
  static const Color orangeAction = Color(0xFFFF9800);
  static const Color orangeActionDark = Color(0xFFE65100);
  static const Color purpleAction = Color(0xFFAB47BC);
  static const Color purpleActionDark = Color(0xFF6A1B9A);
  static const Color blueAction = Color(0xFF42A5F5);
  static const Color blueActionDark = Color(0xFF1565C0);
  static const Color comicRed = Color(0xFFEF5350);
  static const Color comicRedDark = Color(0xFFC62828);

  // Background Gradients
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF29B6F6),
      Color(0xFF81D4FA),
      Color(0xFFE1F5FE),
    ],
  );

  static const LinearGradient nightSkyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D47A1),
      Color(0xFF1A237E),
      Color(0xFF311B92),
    ],
  );

  static const LinearGradient candySkyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF80AB),
      Color(0xFFFF4081),
      Color(0xFFC2185B),
    ],
  );

  // Card / Dialog Background
  static const Color cardBg = Color(0xFF0D47A1);
  static const Color cardBorder = Color(0xFF42A5F5);
  static const Color dialogBg = Color(0xFF1565C0);

  // Text Styles
  static TextStyle comicTitle({double fontSize = 28, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
      fontFamily: 'Roboto',
      letterSpacing: 1.2,
      shadows: const [
        Shadow(offset: Offset(0, 3), blurRadius: 4, color: Colors.black45),
        Shadow(offset: Offset(0, 6), blurRadius: 10, color: Colors.black26),
      ],
    );
  }

  static TextStyle comicSubtitle({double fontSize = 18, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      shadows: const [
        Shadow(offset: Offset(0, 2), blurRadius: 2, color: Colors.black38),
      ],
    );
  }

  static TextStyle buttonText({double fontSize = 20, Color color = Colors.white}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
      letterSpacing: 1.5,
      shadows: const [
        Shadow(offset: Offset(0, 2), blurRadius: 2, color: Colors.black45),
      ],
    );
  }

  // Modern Glassmorphic & Neon Styling Tokens
  static BoxDecoration modernGlassCard({
    Color tint = const Color(0xFF0D47A1),
    double opacity = 0.85,
    Color borderColor = const Color(0xFF64B5F6),
    double borderWidth = 2.0,
    double radius = 24.0,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: tint.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
      boxShadow: shadows ?? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.45),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration modernNeonPill({
    required Color color,
    bool isActive = false,
    double radius = 20.0,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isActive
            ? [color, color.withValues(alpha: 0.75)]
            : [Colors.black54, Colors.black87],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isActive ? Colors.white : color.withValues(alpha: 0.4),
        width: isActive ? 2.5 : 1.2,
      ),
      boxShadow: isActive
          ? [
              BoxShadow(
                color: color.withValues(alpha: 0.7),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
          : null,
    );
  }
}
