import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Represents dynamic environment visual themes per level
class LevelEnvironment {
  final int level;
  final String name;
  final LinearGradient backgroundGradient;
  final Color furnitureMainColor;
  final Color furnitureLegColor;
  final Color chairColor;
  final Widget? ambientOverlay;

  const LevelEnvironment({
    required this.level,
    required this.name,
    required this.backgroundGradient,
    required this.furnitureMainColor,
    required this.furnitureLegColor,
    required this.chairColor,
    this.ambientOverlay,
  });

  static LevelEnvironment getForLevel(int level) {
    switch (level) {
      case 1:
        return const LevelEnvironment(
          level: 1,
          name: 'Daylight Arena',
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF29B6F6), Color(0xFF81D4FA), Color(0xFFE1F5FE)],
          ),
          furnitureMainColor: Color(0xFF8D6E63),
          furnitureLegColor: Color(0xFF5D4037),
          chairColor: Color(0xFF42A5F5),
        );
      case 2:
        return const LevelEnvironment(
          level: 2,
          name: 'Sunset Beach',
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF7043), Color(0xFFFFAB91), Color(0xFFFFE0B2)],
          ),
          furnitureMainColor: Color(0xFFA1887F),
          furnitureLegColor: Color(0xFF6D4C41),
          chairColor: Color(0xFFFFB300),
          ambientOverlay: _SunsetAmbientWidget(),
        );
      case 3:
        return const LevelEnvironment(
          level: 3,
          name: 'Night City Rooftop',
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D47A1), Color(0xFF1A237E), Color(0xFF311B92)],
          ),
          furnitureMainColor: Color(0xFF546E7A),
          furnitureLegColor: Color(0xFF37474F),
          chairColor: Color(0xFF00E676),
          ambientOverlay: _NightCityAmbientWidget(),
        );
      case 4:
        return const LevelEnvironment(
          level: 4,
          name: 'Cyberpunk Neon',
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A148C), Color(0xFF880E4F), Color(0xFF006064)],
          ),
          furnitureMainColor: Color(0xFF00E5FF),
          furnitureLegColor: Color(0xFF00B0FF),
          chairColor: Color(0xFFFF007F),
          ambientOverlay: _CyberGridAmbientWidget(),
        );
      case 5:
        return const LevelEnvironment(
          level: 5,
          name: 'Volcanic Lava Cave',
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF212121), Color(0xFFB71C1C), Color(0xFFE65100)],
          ),
          furnitureMainColor: Color(0xFF263238),
          furnitureLegColor: Color(0xFF212121),
          chairColor: Color(0xFFFF3D00),
          ambientOverlay: _LavaEmbersAmbientWidget(),
        );
      default:
        return const LevelEnvironment(
          level: 6,
          name: 'Thunder Storm Arena',
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF263238), Color(0xFF37474F), Color(0xFF1A237E)],
          ),
          furnitureMainColor: Color(0xFF455A64),
          furnitureLegColor: Color(0xFF263238),
          chairColor: Color(0xFFFFD600),
          ambientOverlay: _StormAmbientWidget(),
        );
    }
  }
}

/// Sunset Palm Silhouettes & Sun
class _SunsetAmbientWidget extends StatelessWidget {
  const _SunsetAmbientWidget();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Glowing Sun
          Positioned(
            top: 50,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFF9C4), Color(0xFFFFB74D), Colors.transparent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Night City Skyline & Glowing Moon
class _NightCityAmbientWidget extends StatelessWidget {
  const _NightCityAmbientWidget();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Moon
          Positioned(
            top: 45,
            left: 35,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFFDE7),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          // Skyscraper silhouettes in background
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBuilding(50, 120),
                _buildBuilding(45, 160),
                _buildBuilding(60, 140),
                _buildBuilding(55, 180),
                _buildBuilding(50, 130),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(double w, double h) {
    return Container(
      width: w,
      height: h,
      color: Colors.black.withValues(alpha: 0.35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          (h / 30).toInt(),
          (_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 6, height: 8, color: const Color(0xFFFFD54F).withValues(alpha: 0.5)),
              Container(width: 6, height: 8, color: const Color(0xFFFFD54F).withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cyberpunk Neon Grid
class _CyberGridAmbientWidget extends StatelessWidget {
  const _CyberGridAmbientWidget();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _CyberGridPainter(),
      ),
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.2)
      ..strokeWidth = 1.5;

    // Horizon line
    final horizonY = size.height * 0.55;
    canvas.drawLine(Offset(0, horizonY), Offset(size.width, horizonY), linePaint);

    // Perspective grid lines
    final vp = Offset(size.width / 2, horizonY);
    for (double x = -size.width; x <= size.width * 2; x += 50) {
      canvas.drawLine(vp, Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Volcanic Lava Cavern Embers
class _LavaEmbersAmbientWidget extends StatelessWidget {
  const _LavaEmbersAmbientWidget();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // Magma glow at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, const Color(0xFFFF3D00).withValues(alpha: 0.4)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thunder Storm Rain & Lightning Ambient
class _StormAmbientWidget extends StatelessWidget {
  const _StormAmbientWidget();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _RainPainter(),
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rainPaint = Paint()
      ..color = Colors.lightBlueAccent.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    final random = math.Random(42);
    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawLine(Offset(x, y), Offset(x - 4, y + 16), rainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
