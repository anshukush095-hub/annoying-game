import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../services/audio_manager.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late AnimationController _progressController;
  Timer? _navTimer;
  Timer? _soundTimer;

  final List<String> _loadingTips = [
    'Polishing Boxing Gloves... 🥊',
    'Waking up Annoying Uncle... 😴',
    'Charging Finger Lightning... ⚡',
    'Preparing 2000 Levels... 🏆',
    'Ready for Knockout! 💥',
  ];

  @override
  void initState() {
    super.initState();

    _logoAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _logoAnimController,
      curve: Curves.elasticOut,
    );

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(
        parent: _logoAnimController,
        curve: Curves.easeInOutSine,
      ),
    );

    _logoAnimController.forward();

    // Play punch / comic impact audio safely with tracked timer
    _soundTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        AudioManager().playHit();
      }
    });

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    _navTimer = Timer(const Duration(milliseconds: 2900), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _soundTimer?.cancel();
    _navTimer?.cancel();
    _logoAnimController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  String _getCurrentTip(double progress) {
    int index = (progress * (_loadingTips.length - 1)).clamp(0, _loadingTips.length - 1).toInt();
    return _loadingTips[index];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: GameTheme.skyGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),

                // Center: 3D Game Logo with Animated Punch Bounce
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: screenHeight * 0.35 > 270 ? 270 : screenHeight * 0.35,
                                  height: screenHeight * 0.35 > 270 ? 270 : screenHeight * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                    border: Border.all(
                                      color: const Color(0xFFFFD54F),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withValues(alpha: 0.5),
                                        blurRadius: 28,
                                        spreadRadius: 4,
                                      ),
                                      const BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(0, 12),
                                        blurRadius: 18,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: Image.asset(
                                      'assets/images/app_logo.png',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: const Color(0xFF0D47A1),
                                          child: const Center(
                                            child: Icon(
                                              Icons.sports_mma,
                                              size: 80,
                                              color: Color(0xFFFFD54F),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // App Subtitle / Tagline
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D47A1).withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFFD54F),
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            '🥊 3D ARCADE PUNCH ACTION 💥',
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom: Progress Bar & Dynamic Tips
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, _) {
                        final progress = _progressController.value;
                        return Column(
                          children: [
                            // Progress Bar
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFFFD54F),
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFFD54F),
                                              Color(0xFFFF9800),
                                              Color(0xFF00E676),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '${(progress * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 11,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 3,
                                              color: Colors.black87,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Current Loading Tip
                            Text(
                              _getCurrentTip(progress),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Studio Brand Footer
                    const Text(
                      '⚡ ANNOYING STUDIOS 3D ⚡',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

