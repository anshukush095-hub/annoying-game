import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/super_powers.dart';

/// Advanced 3D-Shaded Cartoon "Punch Uncle" with Realistic Directional Shading & Lighting
class UncleCharacterWidget extends StatelessWidget {
  static const List<String> allSkinTypes = [
    'default',
    'red_hair',
    'blue',
    'police',
    'clown',
    'gold',
    'ninja',
    'boss',
    'pirate',
    'vampire',
    'alien',
    'chef',
    'disco',
    'superhero',
    'scientist',
    'zombie',
    'boxer',
    'robot',
    'bomb',
    'dizzy',
    'astronaut',
    'caveman',
    'farmer',
  ];

  static String getSkinForLevel(int level) {
    if (level < 1) return 'default';
    final index = (level - 1) % allSkinTypes.length;
    return allSkinTypes[index];
  }

  static String getCharacterNameForSkin(String skin) {
    switch (skin) {
      case 'default':
        return 'Grandpa Uncle';
      case 'red_hair':
        return 'Punk Rocker Uncle';
      case 'blue':
        return 'Athlete Uncle';
      case 'police':
        return 'Inspector Uncle';
      case 'clown':
        return 'Joker Clown Uncle';
      case 'gold':
      case 'king':
        return 'Golden King Uncle';
      case 'ninja':
        return 'Shadow Ninja Uncle';
      case 'boss':
        return 'Mafia Boss Uncle';
      case 'pirate':
        return 'Pirate Captain Uncle';
      case 'vampire':
        return 'Count Dracula Uncle';
      case 'alien':
        return 'Cosmic Alien Uncle';
      case 'chef':
        return 'Master Chef Uncle';
      case 'disco':
        return 'Disco Star Uncle';
      case 'superhero':
        return 'Superhero Uncle';
      case 'scientist':
        return 'Mad Scientist Uncle';
      case 'zombie':
        return 'Zombie Uncle';
      case 'boxer':
        return 'Rival Boxer Uncle';
      case 'robot':
        return 'Cyber Cyborg Uncle';
      case 'bomb':
        return 'Bomb Head Uncle';
      case 'dizzy':
        return 'Dizzy Uncle';
      case 'astronaut':
        return 'Astronaut Uncle';
      case 'caveman':
        return 'Caveman Uncle';
      case 'farmer':
        return 'Farmer Uncle';
      default:
        return 'Annoying Uncle';
    }
  }

  final double size;
  final String skin;
  final bool isHit;
  final double hitOffset;
  final bool showDizzyStars;
  final int hp;
  final int maxHp;
  final bool isElectrified;
  final bool isWebbed;
  final bool isFrozen;
  final double recoilAngle; // backward head/body snap on punch

  const UncleCharacterWidget({
    super.key,
    this.size = 120,
    this.skin = 'default',
    this.isHit = false,
    this.hitOffset = 0.0,
    this.showDizzyStars = false,
    this.hp = 1,
    this.maxHp = 1,
    this.isElectrified = false,
    this.isWebbed = false,
    this.isFrozen = false,
    this.recoilAngle = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base 3D Shaded Character
          Transform.rotate(
            angle: recoilAngle,
            child: CustomPaint(
              size: Size(size, size * 1.15),
              painter: _Uncle3DPainter(
                skin: skin,
                isHit: isHit,
                hitOffset: hitOffset,
                showDizzyStars: showDizzyStars || skin == 'dizzy',
              ),
            ),
          ),

          // ⚡ Electric Shock Overlay
          if (isElectrified)
            CustomPaint(
              size: Size(size, size * 1.15),
              painter: _ElectricShockOverlayPainter(),
            ),

          // 🕸️ Spider-Man Web Overlay
          if (isWebbed)
            CustomPaint(
              size: Size(size, size * 1.15),
              painter: _SpiderWebOverlayPainter(),
            ),

          // ❄️ Frost Freeze Ice Block
          if (isFrozen)
            Container(
              width: size * 0.9,
              height: size * 1.05,
              decoration: BoxDecoration(
                color: const Color(0xFF80D8FF).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.ac_unit, color: Colors.white, size: 36),
            ),

          // Boss Health Bar
          if (maxHp > 1 && !isHit)
            Positioned(
              top: 0,
              child: Container(
                width: size * 0.75,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (hp / maxHp).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hp > 1
                            ? [const Color(0xFF66BB6A), const Color(0xFF2E7D32)]
                            : [const Color(0xFFFF5252), const Color(0xFFC62828)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Uncle3DPainter extends CustomPainter {
  final String skin;
  final bool isHit;
  final double hitOffset;
  final bool showDizzyStars;

  _Uncle3DPainter({
    required this.skin,
    required this.isHit,
    required this.hitOffset,
    required this.showDizzyStars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.54 + hitOffset);
    final scale = size.width / 120.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);

    // 3D Color Palettes (Base, Highlight, Shadow)
    Color baseColor = const Color(0xFF7CB342); // Green
    Color lightColor = const Color(0xFFAED581);
    Color darkColor = const Color(0xFF33691E);

    Color hairBase = const Color(0xFFC62828); // Red
    Color hairLight = const Color(0xFFEF5350);
    Color hairDark = const Color(0xFF8E0000);

    if (skin == 'red_hair') {
      baseColor = const Color(0xFFE53935);
      lightColor = const Color(0xFFFF8A80);
      darkColor = const Color(0xFFB71C1C);
    } else if (skin == 'blue') {
      baseColor = const Color(0xFF1E88E5);
      lightColor = const Color(0xFF64B5F6);
      darkColor = const Color(0xFF0D47A1);
    } else if (skin == 'gold' || skin == 'king') {
      baseColor = const Color(0xFFFFB300);
      lightColor = const Color(0xFFFFF176);
      darkColor = const Color(0xFFFF6F00);
    } else if (skin == 'police') {
      baseColor = const Color(0xFF283593);
      lightColor = const Color(0xFF5C6BC0);
      darkColor = const Color(0xFF1A237E);
    } else if (skin == 'clown') {
      baseColor = const Color(0xFFECEFF1);
      lightColor = Colors.white;
      darkColor = const Color(0xFFB0BEC5);
      hairBase = const Color(0xFFE91E63);
      hairLight = const Color(0xFFFF4081);
    } else if (skin == 'ninja') {
      baseColor = const Color(0xFF263238);
      lightColor = const Color(0xFF455A64);
      darkColor = const Color(0xFF102027);
    } else if (skin == 'boss') {
      baseColor = const Color(0xFF6D4C41);
      lightColor = const Color(0xFFA1887F);
      darkColor = const Color(0xFF3E2723);
    } else if (skin == 'bomb') {
      baseColor = const Color(0xFF37474F);
      lightColor = const Color(0xFF546E7A);
      darkColor = const Color(0xFF212121);
    } else if (skin == 'pirate') {
      baseColor = const Color(0xFF3E2723);
      lightColor = const Color(0xFF6D4C41);
      darkColor = const Color(0xFF1B0000);
      hairBase = const Color(0xFF212121);
      hairLight = const Color(0xFF424242);
    } else if (skin == 'vampire') {
      baseColor = const Color(0xFF311B92);
      lightColor = const Color(0xFF512DA8);
      darkColor = const Color(0xFF12005E);
      hairBase = const Color(0xFF212121);
      hairLight = const Color(0xFF424242);
    } else if (skin == 'alien') {
      baseColor = const Color(0xFF00E676);
      lightColor = const Color(0xFFB9F6CA);
      darkColor = const Color(0xFF00A152);
      hairBase = const Color(0xFF69F0AE);
      hairLight = const Color(0xFFE8F5E9);
    } else if (skin == 'chef') {
      baseColor = const Color(0xFFFAFAFA);
      lightColor = Colors.white;
      darkColor = const Color(0xFFBDBDBD);
      hairBase = const Color(0xFF5D4037);
      hairLight = const Color(0xFF8D6E63);
    } else if (skin == 'disco') {
      baseColor = const Color(0xFFFF007F);
      lightColor = const Color(0xFFFF80AB);
      darkColor = const Color(0xFFC51162);
      hairBase = const Color(0xFF3E2723);
      hairLight = const Color(0xFF5D4037);
    } else if (skin == 'superhero') {
      baseColor = const Color(0xFF00B0FF);
      lightColor = const Color(0xFF80D8FF);
      darkColor = const Color(0xFF0081CB);
      hairBase = const Color(0xFFFFD600);
      hairLight = const Color(0xFFFFF59D);
    } else if (skin == 'scientist') {
      baseColor = const Color(0xFFE0F7FA);
      lightColor = Colors.white;
      darkColor = const Color(0xFF80DEEA);
      hairBase = const Color(0xFFECEFF1);
      hairLight = Colors.white;
    } else if (skin == 'zombie') {
      baseColor = const Color(0xFF8BC34A);
      lightColor = const Color(0xFFDCEDC8);
      darkColor = const Color(0xFF558B2F);
      hairBase = const Color(0xFF37474F);
      hairLight = const Color(0xFF546E7A);
    } else if (skin == 'boxer') {
      baseColor = const Color(0xFFFF6F00);
      lightColor = const Color(0xFFFFB74D);
      darkColor = const Color(0xFFE65100);
      hairBase = const Color(0xFF212121);
      hairLight = const Color(0xFF424242);
    } else if (skin == 'robot') {
      baseColor = const Color(0xFF78909C);
      lightColor = const Color(0xFFCFD8DC);
      darkColor = const Color(0xFF37474F);
      hairBase = const Color(0xFF455A64);
      hairLight = const Color(0xFF90A4AE);
    } else if (skin == 'astronaut') {
      baseColor = const Color(0xFFECEFF1);
      lightColor = Colors.white;
      darkColor = const Color(0xFF90A4AE);
      hairBase = const Color(0xFF37474F);
      hairLight = const Color(0xFF546E7A);
    } else if (skin == 'caveman') {
      baseColor = const Color(0xFFD7CCC8);
      lightColor = const Color(0xFFEFEBE9);
      darkColor = const Color(0xFF8D6E63);
      hairBase = const Color(0xFF3E2723);
      hairLight = const Color(0xFF5D4037);
    } else if (skin == 'farmer') {
      baseColor = const Color(0xFF1976D2);
      lightColor = const Color(0xFF64B5F6);
      darkColor = const Color(0xFF0D47A1);
      hairBase = const Color(0xFF4E342E);
      hairLight = const Color(0xFF6D4C41);
    }

    if (isHit) {
      baseColor = const Color(0xFFFF5252);
      lightColor = const Color(0xFFFF8A80);
      darkColor = const Color(0xFFB71C1C);
    }

    final strokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;

    // 1. Shoes / Boots (3D Shaded Dark Gray)
    final shoePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF546E7A), Color(0xFF263238)],
      ).createShader(const Rect.fromLTWH(-24, 58, 48, 14));

    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-24, 58, 18, 12), const Radius.circular(5)), shoePaint);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-24, 58, 18, 12), const Radius.circular(5)), strokePaint);

    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(6, 58, 18, 12), const Radius.circular(5)), shoePaint);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(6, 58, 18, 12), const Radius.circular(5)), strokePaint);

    // 2. Legs with 3D Radial Cylinder Gradient
    final leftLegShader = RadialGradient(
      center: const Alignment(-0.4, -0.4),
      radius: 0.8,
      colors: [lightColor, baseColor, darkColor],
    ).createShader(const Rect.fromLTWH(-20, 34, 14, 28));

    final rightLegShader = RadialGradient(
      center: const Alignment(-0.2, -0.4),
      radius: 0.8,
      colors: [lightColor, baseColor, darkColor],
    ).createShader(const Rect.fromLTWH(6, 34, 14, 28));

    final leftLeg = RRect.fromRectAndRadius(const Rect.fromLTWH(-20, 34, 14, 28), const Radius.circular(6));
    canvas.drawRRect(leftLeg, Paint()..shader = leftLegShader);
    canvas.drawRRect(leftLeg, strokePaint);

    final rightLeg = RRect.fromRectAndRadius(const Rect.fromLTWH(6, 34, 14, 28), const Radius.circular(6));
    canvas.drawRRect(rightLeg, Paint()..shader = rightLegShader);
    canvas.drawRRect(rightLeg, strokePaint);

    // 3. 3D Chubby Torso / Belly (Spherical 3D Shader)
    final double bodyWidth = skin == 'boss' ? 72.0 : 62.0;
    final bodyRect = Rect.fromCenter(center: const Offset(0, 18), width: bodyWidth, height: 50);

    final bodyShader = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      radius: 0.9,
      colors: [lightColor, baseColor, darkColor],
      stops: const [0.0, 0.6, 1.0],
    ).createShader(bodyRect);

    final rBodyRect = RRect.fromRectAndRadius(bodyRect, const Radius.circular(22));
    canvas.drawRRect(rBodyRect, Paint()..shader = bodyShader);
    canvas.drawRRect(rBodyRect, strokePaint);

    // Belly Button / Chest Contour
    final contourPaint = Paint()
      ..color = darkColor.withValues(alpha: 0.45)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(const Rect.fromLTWH(-8, 20, 16, 10), 0, math.pi, false, contourPaint);

    // 4. Arms with 3D Shading
    // Left Arm (Raised)
    final leftArmShader = RadialGradient(
      center: const Alignment(-0.5, -0.5),
      radius: 0.8,
      colors: [lightColor, baseColor, darkColor],
    ).createShader(const Rect.fromLTWH(-48, -26, 28, 42));

    final leftArm = Path()
      ..moveTo(-26, 0)
      ..quadraticBezierTo(-46, -10, -40, -26)
      ..quadraticBezierTo(-34, -28, -30, -18)
      ..quadraticBezierTo(-22, -10, -22, 12);
    canvas.drawPath(leftArm, Paint()..shader = leftArmShader);
    canvas.drawPath(leftArm, strokePaint);

    // Right Arm (Hip)
    final rightArmShader = RadialGradient(
      center: const Alignment(-0.2, -0.4),
      radius: 0.8,
      colors: [lightColor, baseColor, darkColor],
    ).createShader(const Rect.fromLTWH(24, 0, 24, 30));

    final rightArm = Path()
      ..moveTo(26, 0)
      ..quadraticBezierTo(46, 8, 40, 24)
      ..quadraticBezierTo(32, 26, 26, 18);
    canvas.drawPath(rightArm, Paint()..shader = rightArmShader);
    canvas.drawPath(rightArm, strokePaint);

    // 5. Costume Decals (Police Badge, Clown Collar, Bomb Fuse)
    if (skin == 'police') {
      // Golden Badge
      final badgePaint = Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFF9C4), Color(0xFFFFB300), Color(0xFFFF8F00)],
        ).createShader(const Rect.fromLTWH(-16, 8, 12, 12));
      canvas.drawCircle(const Offset(-10, 14), 6, badgePaint);
      canvas.drawCircle(const Offset(-10, 14), 6, strokePaint);
    } else if (skin == 'clown') {
      final collarPaint = Paint()..color = const Color(0xFFE91E63);
      canvas.drawOval(const Rect.fromLTWH(-24, -9, 48, 14), collarPaint);
      canvas.drawOval(const Rect.fromLTWH(-24, -9, 48, 14), strokePaint);
    } else if (skin == 'bomb') {
      final warnPaint = Paint()..color = Colors.amber..strokeWidth = 3;
      canvas.drawLine(const Offset(-8, 14), const Offset(8, 28), warnPaint);
      canvas.drawLine(const Offset(8, 14), const Offset(-8, 28), warnPaint);
    } else if (skin == 'superhero') {
      // Golden Lightning Emblem on Chest
      final emblemPaint = Paint()..color = const Color(0xFFFFD600);
      final p = Path()
        ..moveTo(2, 6)
        ..lineTo(-8, 18)
        ..lineTo(-1, 18)
        ..lineTo(-4, 30)
        ..lineTo(8, 16)
        ..lineTo(1, 16)
        ..close();
      canvas.drawPath(p, emblemPaint);
      canvas.drawPath(p, strokePaint..strokeWidth = 1.5);
      strokePaint.strokeWidth = 3.2;
    } else if (skin == 'vampire') {
      // Red Vampire Medallion
      canvas.drawCircle(const Offset(0, 10), 6, Paint()..color = const Color(0xFFD50000));
      canvas.drawCircle(const Offset(0, 10), 3, Paint()..color = const Color(0xFFFFD54F));
    } else if (skin == 'disco') {
      // Gold Chain Medallion
      final chainPaint = Paint()..color = const Color(0xFFFFD54F)..strokeWidth = 2.5..style = PaintingStyle.stroke;
      canvas.drawArc(const Rect.fromLTWH(-16, 2, 32, 18), 0, math.pi, false, chainPaint);
      canvas.drawCircle(const Offset(0, 20), 5, Paint()..color = const Color(0xFFFFD54F));
    } else if (skin == 'boxer') {
      // Champion Belt
      final beltPaint = Paint()..color = const Color(0xFFFFB300);
      canvas.drawRect(const Rect.fromLTWH(-20, 26, 40, 10), beltPaint);
      canvas.drawCircle(const Offset(0, 31), 6, Paint()..color = const Color(0xFFFFF9C4));
      canvas.drawCircle(const Offset(0, 31), 6, strokePaint..strokeWidth = 1.5);
      strokePaint.strokeWidth = 3.2;
    } else if (skin == 'astronaut') {
      final packPaint = Paint()..color = const Color(0xFFB0BEC5);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-14, 6, 28, 20), const Radius.circular(5)), packPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-14, 6, 28, 20), const Radius.circular(5)), strokePaint..strokeWidth = 1.5);
      canvas.drawCircle(const Offset(-6, 12), 3, Paint()..color = const Color(0xFF00E676));
      canvas.drawCircle(const Offset(6, 12), 3, Paint()..color = const Color(0xFFFF1744));
      strokePaint.strokeWidth = 3.2;
    } else if (skin == 'farmer') {
      final strapPaint = Paint()..color = const Color(0xFF0D47A1)..strokeWidth = 6;
      canvas.drawLine(const Offset(-12, -5), const Offset(-12, 30), strapPaint);
      canvas.drawLine(const Offset(12, -5), const Offset(12, 30), strapPaint);
      canvas.drawCircle(const Offset(-12, 10), 3.5, Paint()..color = const Color(0xFFFFD54F));
      canvas.drawCircle(const Offset(12, 10), 3.5, Paint()..color = const Color(0xFFFFD54F));
    }

    // 6. 3D Head (Directional Spherical Gradient with Specular Light)
    final headRect = const Rect.fromLTWH(-28, -52, 56, 52);
    final headShader = RadialGradient(
      center: const Alignment(-0.35, -0.4),
      radius: 0.85,
      colors: [lightColor, baseColor, darkColor],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(headRect);

    final rHead = RRect.fromRectAndRadius(headRect, const Radius.circular(24));
    canvas.drawRRect(rHead, Paint()..shader = headShader);
    canvas.drawRRect(rHead, strokePaint);

    // 7. 3D Textured Hair Puffs (Spherical Shaded Spheres with Highlights)
    if (skin == 'bomb') {
      final fusePaint = Paint()..color = const Color(0xFF795548)..strokeWidth = 4;
      canvas.drawLine(const Offset(0, -52), const Offset(6, -68), fusePaint);
      canvas.drawCircle(const Offset(6, -68), 5, Paint()..color = Colors.orange);
      canvas.drawCircle(const Offset(6, -68), 2.5, Paint()..color = Colors.yellow);
    } else {
      void draw3DHairBall(Offset pos, double radius) {
        final hairShader = RadialGradient(
          center: const Alignment(-0.4, -0.4),
          radius: 0.8,
          colors: [hairLight, hairBase, hairDark],
        ).createShader(Rect.fromCircle(center: pos, radius: radius));

        canvas.drawCircle(pos, radius, Paint()..shader = hairShader);
        canvas.drawCircle(pos, radius, strokePaint);

        // Specular glint on hair
        canvas.drawCircle(
          Offset(pos.dx - radius * 0.3, pos.dy - radius * 0.3),
          radius * 0.25,
          Paint()..color = Colors.white.withValues(alpha: 0.4),
        );
      }

      // Left Hair Puffs
      draw3DHairBall(const Offset(-28, -42), 11);
      draw3DHairBall(const Offset(-28, -30), 10);
      draw3DHairBall(const Offset(-23, -20), 8);

      // Right Hair Puffs
      draw3DHairBall(const Offset(28, -42), 11);
      draw3DHairBall(const Offset(28, -30), 10);
      draw3DHairBall(const Offset(23, -20), 8);
    }

    // 8. 3D Hats (Police Visor, Ninja Band, Golden Crown with Gems)
    if (skin == 'police') {
      final capShader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
      ).createShader(const Rect.fromLTWH(-32, -68, 64, 25));

      final capPath = Path()
        ..moveTo(-26, -50)
        ..quadraticBezierTo(0, -68, 26, -50)
        ..lineTo(32, -45)
        ..lineTo(-32, -45)
        ..close();
      canvas.drawPath(capPath, Paint()..shader = capShader);
      canvas.drawPath(capPath, strokePaint);
      canvas.drawCircle(const Offset(0, -53), 4.5, Paint()..color = const Color(0xFFFFD54F));
    } else if (skin == 'ninja') {
      final bandPaint = Paint()..color = const Color(0xFFC62828);
      canvas.drawRect(const Rect.fromLTWH(-28, -46, 56, 14), bandPaint);
      canvas.drawRect(const Rect.fromLTWH(-28, -46, 56, 14), strokePaint);
    } else if (skin == 'king' || skin == 'gold') {
      // 3D Golden Crown with Glowing Ruby
      final crownShader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF59D), Color(0xFFFFD54F), Color(0xFFFF8F00)],
      ).createShader(const Rect.fromLTWH(-22, -72, 44, 24));

      final crownP = Path()
        ..moveTo(-20, -50)
        ..lineTo(-22, -68)
        ..lineTo(-10, -58)
        ..lineTo(0, -72)
        ..lineTo(10, -58)
        ..lineTo(22, -68)
        ..lineTo(20, -50)
        ..close();
      canvas.drawPath(crownP, Paint()..shader = crownShader);
      canvas.drawPath(crownP, strokePaint);

      // Ruby jewel
      canvas.drawCircle(const Offset(0, -58), 3.5, Paint()..color = Colors.redAccent);
      canvas.drawCircle(const Offset(0, -58), 3.5, strokePaint);
    } else if (skin == 'clown') {
      // 3D Red Clown Nose
      final noseShader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [Color(0xFFFF8A80), Color(0xFFD50000)],
      ).createShader(const Rect.fromLTWH(-6, -32, 12, 12));
      canvas.drawCircle(const Offset(0, -26), 6, Paint()..shader = noseShader);
      canvas.drawCircle(const Offset(0, -26), 6, strokePaint);
    } else if (skin == 'pirate') {
      // Pirate Captain Hat
      final hatShader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF424242), Color(0xFF212121)],
      ).createShader(const Rect.fromLTWH(-36, -76, 72, 28));
      final hatPath = Path()
        ..moveTo(-34, -48)
        ..quadraticBezierTo(-20, -78, 0, -70)
        ..quadraticBezierTo(20, -78, 34, -48)
        ..quadraticBezierTo(0, -56, -34, -48);
      canvas.drawPath(hatPath, Paint()..shader = hatShader);
      canvas.drawPath(hatPath, strokePaint);
      // Gold trim
      canvas.drawCircle(const Offset(0, -60), 4, Paint()..color = const Color(0xFFFFD54F));
    } else if (skin == 'chef') {
      // Tall Puffy White Chef Hat
      final chefShader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Color(0xFFECEFF1)],
      ).createShader(const Rect.fromLTWH(-26, -82, 52, 34));
      final puffPath = Path()
        ..moveTo(-22, -48)
        ..lineTo(-22, -60)
        ..quadraticBezierTo(-30, -75, -12, -82)
        ..quadraticBezierTo(0, -86, 12, -82)
        ..quadraticBezierTo(30, -75, 22, -60)
        ..lineTo(22, -48)
        ..close();
      canvas.drawPath(puffPath, Paint()..shader = chefShader);
      canvas.drawPath(puffPath, strokePaint);
    } else if (skin == 'alien') {
      // Glowing Neon Alien Antennae
      final antPaint = Paint()..color = const Color(0xFF00E676)..strokeWidth = 3.5;
      canvas.drawLine(const Offset(-12, -50), const Offset(-20, -70), antPaint);
      canvas.drawLine(const Offset(12, -50), const Offset(20, -70), antPaint);
      canvas.drawCircle(const Offset(-20, -70), 5, Paint()..color = const Color(0xFF76FF03));
      canvas.drawCircle(const Offset(20, -70), 5, Paint()..color = const Color(0xFF76FF03));
      canvas.drawCircle(const Offset(-20, -70), 5, strokePaint..strokeWidth = 1.5);
      canvas.drawCircle(const Offset(20, -70), 5, strokePaint..strokeWidth = 1.5);
      strokePaint.strokeWidth = 3.2;
    } else if (skin == 'disco') {
      // 70s Star Sunglasses
      final glassPaint = Paint()..color = const Color(0xFFFF4081);
      canvas.drawRect(const Rect.fromLTWH(-24, -38, 20, 12), glassPaint);
      canvas.drawRect(const Rect.fromLTWH(4, -38, 20, 12), glassPaint);
      canvas.drawLine(const Offset(-4, -32), const Offset(4, -32), Paint()..color = Colors.black..strokeWidth = 2);
    } else if (skin == 'boxer') {
      // Red Boxer Headgear Band & Nose Tape
      canvas.drawRect(const Rect.fromLTWH(-28, -52, 56, 12), Paint()..color = const Color(0xFFD50000));
      canvas.drawRect(const Rect.fromLTWH(-28, -52, 56, 12), strokePaint);
      // Nose tape
      canvas.drawRect(const Rect.fromLTWH(-6, -26, 12, 5), Paint()..color = Colors.white);
    } else if (skin == 'scientist') {
      // Scientist Brass/Cyan Lab Goggles
      final gogglePaint = Paint()..color = const Color(0xFF00E5FF)..strokeWidth = 3..style = PaintingStyle.stroke;
      canvas.drawCircle(const Offset(-13, -33), 11, Paint()..color = const Color(0xFF263238));
      canvas.drawCircle(const Offset(13, -33), 11, Paint()..color = const Color(0xFF263238));
      canvas.drawCircle(const Offset(-13, -33), 11, gogglePaint);
      canvas.drawCircle(const Offset(13, -33), 11, gogglePaint);
      canvas.drawLine(const Offset(-2, -33), const Offset(2, -33), Paint()..color = Colors.white..strokeWidth = 3);
    } else if (skin == 'robot') {
      // Cyborg Metal Plate on left side of face
      final platePaint = Paint()..color = const Color(0xFF90A4AE);
      canvas.drawRect(const Rect.fromLTWH(-28, -52, 28, 48), platePaint);
      canvas.drawLine(const Offset(0, -52), const Offset(0, -4), strokePaint);
    } else if (skin == 'astronaut') {
      final helmetRect = const Rect.fromLTWH(-28, -62, 56, 44);
      final visorShader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF80D8FF), Color(0xFF0091EA)],
      ).createShader(helmetRect);
      canvas.drawRRect(RRect.fromRectAndRadius(helmetRect, const Radius.circular(22)), Paint()..shader = visorShader);
      canvas.drawRRect(RRect.fromRectAndRadius(helmetRect, const Radius.circular(22)), strokePaint);
      canvas.drawLine(const Offset(-18, -52), const Offset(-8, -42), Paint()..color = Colors.white.withValues(alpha: 0.7)..strokeWidth = 3);
    } else if (skin == 'farmer') {
      final hatPaint = Paint()..color = const Color(0xFFFFD54F);
      canvas.drawOval(const Rect.fromLTWH(-36, -58, 72, 18), hatPaint);
      canvas.drawOval(const Rect.fromLTWH(-36, -58, 72, 18), strokePaint);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-18, -72, 36, 18), const Radius.circular(8)), hatPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-18, -72, 36, 18), const Radius.circular(8)), strokePaint);
      canvas.drawRect(const Rect.fromLTWH(-18, -56, 36, 4), Paint()..color = Colors.red);
    } else if (skin == 'caveman') {
      final bonePaint = Paint()..color = const Color(0xFFFFFDE7);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-16, -62, 32, 8), const Radius.circular(4)), bonePaint);
      canvas.drawCircle(const Offset(-16, -58), 5.5, bonePaint);
      canvas.drawCircle(const Offset(16, -58), 5.5, bonePaint);
      canvas.drawCircle(const Offset(-16, -58), 5.5, strokePaint..strokeWidth = 1.5);
      canvas.drawCircle(const Offset(16, -58), 5.5, strokePaint..strokeWidth = 1.5);
      strokePaint.strokeWidth = 3.2;
    }

    // 9. Advanced 3D Cartoon Googly Eyes with Layered Depth
    if (showDizzyStars || skin == 'dizzy') {
      final xPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 3.5;
      canvas.drawLine(const Offset(-18, -38), const Offset(-8, -28), xPaint);
      canvas.drawLine(const Offset(-8, -38), const Offset(-18, -28), xPaint);
      canvas.drawLine(const Offset(8, -38), const Offset(18, -28), xPaint);
      canvas.drawLine(const Offset(18, -38), const Offset(8, -28), xPaint);

      final starPaint = Paint()..color = const Color(0xFFFFD54F);
      _drawStar(canvas, const Offset(-36, -65), 8, starPaint);
      _drawStar(canvas, const Offset(0, -75), 10, starPaint);
      _drawStar(canvas, const Offset(36, -65), 8, starPaint);
    } else {
      void draw3DEye(Offset pos, double pupilXOffset) {
        // Eye White with 3D spherical shadow
        final eyeShader = const RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [Colors.white, Color(0xFFECEFF1), Color(0xFFCFD8DC)],
        ).createShader(Rect.fromCircle(center: pos, radius: 9.5));

        canvas.drawCircle(pos, 9.5, Paint()..shader = eyeShader);
        canvas.drawCircle(pos, 9.5, strokePaint);

        // Pupil with Iris border
        final pupilPos = Offset(pos.dx + pupilXOffset, pos.dy);
        canvas.drawCircle(pupilPos, 4.5, Paint()..color = Colors.black);

        // Double Specular Glints (Anime / 3D Cartoon Shine)
        canvas.drawCircle(Offset(pupilPos.dx - 1.5, pupilPos.dy - 1.5), 1.6, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(pupilPos.dx + 1.5, pupilPos.dy + 1.5), 0.8, Paint()..color = Colors.white);
      }

      draw3DEye(const Offset(-13, -33), 2.0);
      draw3DEye(const Offset(13, -33), -2.0);

      // Pirate Eyepatch
      if (skin == 'pirate') {
        canvas.drawCircle(const Offset(13, -33), 10.5, Paint()..color = Colors.black);
        canvas.drawLine(const Offset(-4, -46), const Offset(28, -20), Paint()..color = Colors.black..strokeWidth = 3);
      }

      // Robot Cyborg Sensor Eye
      if (skin == 'robot') {
        canvas.drawCircle(const Offset(-13, -33), 10.5, Paint()..color = const Color(0xFFD50000));
        canvas.drawCircle(const Offset(-13, -33), 5, Paint()..color = const Color(0xFFFF8A80));
        canvas.drawCircle(const Offset(-13, -33), 2, Paint()..color = Colors.white);
      }

      // Zombie Stitches
      if (skin == 'zombie') {
        final stitchPaint = Paint()..color = const Color(0xFF1B5E20)..strokeWidth = 2;
        canvas.drawLine(const Offset(-18, -46), const Offset(-6, -46), stitchPaint);
        canvas.drawLine(const Offset(-15, -49), const Offset(-15, -43), stitchPaint);
        canvas.drawLine(const Offset(-9, -49), const Offset(-9, -43), stitchPaint);
      }

      // Mustache for Boss & Chef
      if (skin == 'boss' || skin == 'chef') {
        final stache = Path()
          ..moveTo(-16, -20)
          ..quadraticBezierTo(0, -24, 16, -20)
          ..quadraticBezierTo(0, -12, -16, -20);
        canvas.drawPath(stache, Paint()..color = skin == 'chef' ? const Color(0xFF5D4037) : const Color(0xFF3E2723));
        canvas.drawPath(stache, strokePaint);
      } else {
        // 3D Mouth with Shaded Tongue
        final mouthPath = Path()
          ..moveTo(-12, -18)
          ..quadraticBezierTo(0, -9, 12, -18)
          ..quadraticBezierTo(0, -5, -12, -18);
        canvas.drawPath(mouthPath, Paint()..color = const Color(0xFFB71C1C));
        canvas.drawPath(mouthPath, strokePaint);

        // Vampire Fangs
        if (skin == 'vampire') {
          final fangPaint = Paint()..color = Colors.white;
          final fang1 = Path()..moveTo(-8, -17)..lineTo(-5, -9)..lineTo(-2, -17)..close();
          final fang2 = Path()..moveTo(2, -17)..lineTo(5, -9)..lineTo(8, -17)..close();
          canvas.drawPath(fang1, fangPaint);
          canvas.drawPath(fang2, fangPaint);
        } else {
          // Tongue
          canvas.drawCircle(const Offset(0, -13), 3.5, Paint()..color = const Color(0xFFFF8A80));
        }
      }
    }

    canvas.restore();
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = -math.pi / 2 + (i * 4 * math.pi / 5);
      double x = center.dx + radius * math.cos(angle);
      double y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, Paint()..style = PaintingStyle.stroke..strokeWidth = 2..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant _Uncle3DPainter oldDelegate) {
    return oldDelegate.skin != skin ||
        oldDelegate.isHit != isHit ||
        oldDelegate.hitOffset != hitOffset ||
        oldDelegate.showDizzyStars != showDizzyStars;
  }
}

/// ⚡ Electric Shock Overlay
class _ElectricShockOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final boltPaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xFFFFEA00).withValues(alpha: 0.6)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final random = math.Random();
    for (int i = 0; i < 4; i++) {
      final p = Path();
      p.moveTo(size.width * 0.2 + random.nextDouble() * size.width * 0.6, 10);
      for (int step = 0; step < 5; step++) {
        p.lineTo(
          size.width * 0.2 + random.nextDouble() * size.width * 0.6,
          (step + 1) * (size.height / 5),
        );
      }
      canvas.drawPath(p, glowPaint);
      canvas.drawPath(p, boltPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 🕸️ Spider-Man Web Overlay
class _SpiderWebOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final webPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      canvas.drawLine(
        center,
        Offset(center.dx + math.cos(angle) * size.width * 0.45, center.dy + math.sin(angle) * size.height * 0.45),
        webPaint,
      );
    }

    for (double r = 15; r < size.width * 0.45; r += 16) {
      canvas.drawCircle(center, r, webPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Standalone Boxing Glove
class BoxingGloveWidget extends StatelessWidget {
  final double size;
  final Color gloveColor;
  final double extensionRatio;
  final double angle;

  const BoxingGloveWidget({
    super.key,
    this.size = 110,
    this.gloveColor = const Color(0xFFE53935),
    this.extensionRatio = 0.0,
    this.angle = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * (1.2 + extensionRatio * 0.8),
      child: CustomPaint(
        painter: _BoxingGlovePainter(
          gloveColor: gloveColor,
          extensionRatio: extensionRatio,
          angle: angle,
        ),
      ),
    );
  }
}

class _BoxingGlovePainter extends CustomPainter {
  final Color gloveColor;
  final double extensionRatio;
  final double angle;

  _BoxingGlovePainter({
    required this.gloveColor,
    required this.extensionRatio,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final scale = size.width / 110.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.scale(scale);

    final strokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final springLength = 40.0 + (extensionRatio * 70.0);
    final springPaint = Paint()
      ..color = const Color(0xFFFFB300)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(0, -springLength), springPaint);

    final coilPaint = Paint()
      ..color = const Color(0xFF757575)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    for (double y = -10; y > -springLength; y -= 12) {
      canvas.drawOval(Rect.fromCenter(center: Offset(0, y), width: 22, height: 8), coilPaint);
    }

    final cuffRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, -springLength - 10), width: 34, height: 16),
      const Radius.circular(5),
    );
    canvas.drawRRect(cuffRect, Paint()..color = Colors.white);
    canvas.drawRRect(cuffRect, strokePaint);

    final gloveCenter = Offset(0, -springLength - 36);
    final gloveRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: gloveCenter, width: 56, height: 50),
      const Radius.circular(20),
    );
    final glovePaint = Paint()..color = gloveColor;
    canvas.drawRRect(gloveRect, glovePaint);
    canvas.drawRRect(gloveRect, strokePaint);

    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(gloveCenter.dx - 22, gloveCenter.dy + 8), width: 20, height: 26),
      const Radius.circular(10),
    );
    canvas.drawRRect(thumbRect, glovePaint);
    canvas.drawRRect(thumbRect, strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BoxingGlovePainter oldDelegate) => true;
}

/// Dynamic Full-Screen Flying Spring Boxing Glove Custom Painter with 3D Leather Seams
class FlyingSpringPunchPainter extends CustomPainter {
  final Offset baseOrigin;
  final Offset currentGlovePos;
  final Color gloveColor;
  final bool isVisible;
  final GlovePowerType powerType;
  final double punchImpactSquash; // squashes glove on contact

  FlyingSpringPunchPainter({
    required this.baseOrigin,
    required this.currentGlovePos,
    required this.gloveColor,
    required this.isVisible,
    this.powerType = GlovePowerType.normal,
    this.punchImpactSquash = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isVisible) return;

    final strokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final dx = currentGlovePos.dx - baseOrigin.dx;
    final dy = currentGlovePos.dy - baseOrigin.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final angle = math.atan2(dy, dx);

    // 1. Heavy Launcher Mount
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: baseOrigin, width: 54, height: 38),
      const Radius.circular(12),
    );
    final baseShader = const LinearGradient(
      colors: [Color(0xFF546E7A), Color(0xFF263238)],
    ).createShader(const Rect.fromLTWH(-27, -19, 54, 38));
    canvas.drawRRect(baseRect, Paint()..shader = baseShader);
    canvas.drawRRect(baseRect, strokePaint);

    // 2. Heavy Spring Coils
    if (distance > 20) {
      final springPath = Path();
      springPath.moveTo(baseOrigin.dx, baseOrigin.dy);

      final steps = (distance / 20).clamp(4, 25).toInt();
      final perpAngle = angle + math.pi / 2;

      for (int i = 1; i < steps; i++) {
        final t = i / steps;
        final px = baseOrigin.dx + dx * t;
        final py = baseOrigin.dy + dy * t;
        final waveOffset = (i % 2 == 0 ? 1 : -1) * 15.0;
        final cx = px + math.cos(perpAngle) * waveOffset;
        final cy = py + math.sin(perpAngle) * waveOffset;
        springPath.lineTo(cx, cy);
      }
      springPath.lineTo(currentGlovePos.dx, currentGlovePos.dy);

      Color springArmColor = const Color(0xFFFFB300);
      if (powerType == GlovePowerType.electric) {
        springArmColor = const Color(0xFF00E5FF);
      } else if (powerType == GlovePowerType.spiderWeb) {
        springArmColor = Colors.white;
      } else if (powerType == GlovePowerType.fireball) {
        springArmColor = const Color(0xFFFF3D00);
      }

      canvas.drawPath(
        springPath,
        Paint()
          ..color = springArmColor
          ..strokeWidth = 7
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        springPath,
        Paint()
          ..color = Colors.black87
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
      );

      // Electric Current Sparks
      if (powerType == GlovePowerType.electric) {
        final sparkPaint = Paint()
          ..color = const Color(0xFFFFEA00)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        for (int i = 0; i < 4; i++) {
          final t = (i + 1) / 5.0;
          final pos = Offset.lerp(baseOrigin, currentGlovePos, t)!;
          canvas.drawLine(pos, Offset(pos.dx + (i % 2 == 0 ? 14 : -14), pos.dy - 12), sparkPaint);
        }
      }
    }

    // 3. 3D Shaded Boxing Glove Fist with Impact Squash
    canvas.save();
    canvas.translate(currentGlovePos.dx, currentGlovePos.dy);
    canvas.rotate(angle - math.pi / 2);
    canvas.scale(1.0 + (1.0 - punchImpactSquash) * 0.3, punchImpactSquash);

    // White wrist cuff
    final cuffRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-20, 0, 40, 16),
      const Radius.circular(5),
    );
    canvas.drawRRect(cuffRect, Paint()..color = Colors.white);
    canvas.drawRRect(cuffRect, strokePaint);

    // Power Aura Glow
    if (powerType == GlovePowerType.electric) {
      canvas.drawCircle(
        const Offset(0, -24),
        42,
        Paint()..color = const Color(0xFF00E5FF).withValues(alpha: 0.45),
      );
    } else if (powerType == GlovePowerType.fireball) {
      canvas.drawCircle(
        const Offset(0, -24),
        44,
        Paint()..color = const Color(0xFFFF3D00).withValues(alpha: 0.5),
      );
    }

    // 3D Shaded Glove Fist
    Color baseGlove = gloveColor;
    Color lightGlove = const Color(0xFFFF8A80);
    Color darkGlove = const Color(0xFFB71C1C);

    if (powerType == GlovePowerType.electric) {
      baseGlove = const Color(0xFF00E5FF);
      lightGlove = const Color(0xFF84FFFF);
      darkGlove = const Color(0xFF0097A7);
    } else if (powerType == GlovePowerType.fireball) {
      baseGlove = const Color(0xFFFF3D00);
      lightGlove = const Color(0xFFFF8A65);
      darkGlove = const Color(0xFFBF360C);
    } else if (powerType == GlovePowerType.freeze) {
      baseGlove = const Color(0xFF80D8FF);
      lightGlove = Colors.white;
      darkGlove = const Color(0xFF0091EA);
    }

    final fistRect = const Rect.fromLTWH(-30, -50, 60, 52);
    final fistShader = RadialGradient(
      center: const Alignment(-0.35, -0.4),
      radius: 0.9,
      colors: [lightGlove, baseGlove, darkGlove],
    ).createShader(fistRect);

    final rFist = RRect.fromRectAndRadius(fistRect, const Radius.circular(22));
    canvas.drawRRect(rFist, Paint()..shader = fistShader);
    canvas.drawRRect(rFist, strokePaint);

    // Thumb
    final thumbRect = const Rect.fromLTWH(-38, -30, 20, 26);
    final thumbShader = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: [lightGlove, baseGlove, darkGlove],
    ).createShader(thumbRect);

    final rThumb = RRect.fromRectAndRadius(thumbRect, const Radius.circular(9));
    canvas.drawRRect(rThumb, Paint()..shader = thumbShader);
    canvas.drawRRect(rThumb, strokePaint);

    // Leather Seam Lines & Shiny Highlight
    final seamPaint = Paint()
      ..color = darkGlove.withValues(alpha: 0.5)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawArc(const Rect.fromLTWH(-20, -42, 40, 36), -math.pi * 0.8, math.pi * 0.6, false, seamPaint);

    canvas.drawOval(
      const Rect.fromLTWH(6, -44, 16, 8),
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FlyingSpringPunchPainter oldDelegate) {
    return oldDelegate.currentGlovePos != currentGlovePos ||
        oldDelegate.isVisible != isVisible ||
        oldDelegate.gloveColor != gloveColor ||
        oldDelegate.powerType != powerType ||
        oldDelegate.punchImpactSquash != punchImpactSquash;
  }
}

/// Furniture Stack
class FurnitureStackWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color woodColor;
  final Color legColor;
  final Color chairColor;

  const FurnitureStackWidget({
    super.key,
    this.width = 280,
    this.height = 180,
    this.woodColor = const Color(0xFF8D6E63),
    this.legColor = const Color(0xFF5D4037),
    this.chairColor = const Color(0xFF42A5F5),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _FurnitureStackPainter(
          woodColor: woodColor,
          legColor: legColor,
          chairColor: chairColor,
        ),
      ),
    );
  }
}

class _FurnitureStackPainter extends CustomPainter {
  final Color woodColor;
  final Color legColor;
  final Color chairColor;

  _FurnitureStackPainter({
    required this.woodColor,
    required this.legColor,
    required this.chairColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // 1. Table Top with 3D wood bevel
    final tableTop = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.45, size.width * 0.7, 14),
      const Radius.circular(4),
    );
    canvas.drawRRect(tableTop, Paint()..color = woodColor);
    canvas.drawRRect(tableTop, strokePaint);

    // Table legs
    final legPaint = Paint()
      ..color = legColor
      ..strokeWidth = 6;
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.45 + 14),
      Offset(size.width * 0.20, size.height * 0.95),
      legPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.78, size.height * 0.45 + 14),
      Offset(size.width * 0.80, size.height * 0.95),
      legPaint,
    );

    // 2. Chairs
    final chairPaint = Paint()..color = chairColor;
    _drawChair(canvas, Offset(size.width * 0.1, size.height * 0.65), chairPaint, strokePaint);
    _drawChair(canvas, Offset(size.width * 0.35, size.height * 0.65), chairPaint, strokePaint);
    _drawChair(canvas, Offset(size.width * 0.55, size.height * 0.65), chairPaint, strokePaint);
    _drawChair(canvas, Offset(size.width * 0.8, size.height * 0.65), chairPaint, strokePaint);
  }

  void _drawChair(Canvas canvas, Offset pos, Paint paint, Paint stroke) {
    final seat = RRect.fromRectAndRadius(
      Rect.fromCenter(center: pos, width: 34, height: 8),
      const Radius.circular(2),
    );
    canvas.drawRRect(seat, paint);
    canvas.drawRRect(seat, stroke);

    final legP = Paint()..color = const Color(0xFFB0BEC5)..strokeWidth = 3;
    canvas.drawLine(Offset(pos.dx - 12, pos.dy + 4), Offset(pos.dx - 15, pos.dy + 40), legP);
    canvas.drawLine(Offset(pos.dx + 12, pos.dy + 4), Offset(pos.dx + 15, pos.dy + 40), legP);
  }

  @override
  bool shouldRepaint(covariant _FurnitureStackPainter oldDelegate) {
    return oldDelegate.woodColor != woodColor ||
        oldDelegate.legColor != legColor ||
        oldDelegate.chairColor != chairColor;
  }
}

/// ⚡ Finger Lightning Strike: Electric current visibly emanating from touch point to target!
class FingerLightningStrikeWidget extends StatelessWidget {
  final Offset start;
  final Offset target;
  final double progress;

  const FingerLightningStrikeWidget({
    super.key,
    required this.start,
    required this.target,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _FingerLightningStrikePainter(start: start, target: target, progress: progress),
    );
  }
}

class _FingerLightningStrikePainter extends CustomPainter {
  final Offset start;
  final Offset target;
  final double progress;

  _FingerLightningStrikePainter({
    required this.start,
    required this.target,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final diff = target - start;
    final currentEnd = start + (diff * progress.clamp(0.0, 1.0));
    final random = math.Random(1337);

    // Corona at finger origin (touch point)
    final fingerCorona = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00E5FF),
          const Color(0xFF76FF03).withValues(alpha: 0.6),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: start, radius: 24));
    canvas.drawCircle(start, 24, fingerCorona);
    canvas.drawCircle(start, 7, Paint()..color = Colors.white);

    // Glowing main bolt
    final glowPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.7)
      ..strokeWidth = 7.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final corePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()..moveTo(start.dx, start.dy);
    const int segments = 10;
    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final point = Offset.lerp(start, currentEnd, t)!;
      final jitterX = (random.nextDouble() - 0.5) * 28;
      final jitterY = (random.nextDouble() - 0.5) * 28;
      path.lineTo(point.dx + jitterX, point.dy + jitterY);
    }
    path.lineTo(currentEnd.dx, currentEnd.dy);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, corePaint);

    // Secondary forks
    for (int fork = 0; fork < 3; fork++) {
      final forkPath = Path();
      final forkStartT = 0.2 + (fork * 0.25);
      final forkOrigin = Offset.lerp(start, currentEnd, forkStartT)!;
      forkPath.moveTo(forkOrigin.dx, forkOrigin.dy);

      for (int step = 0; step < 4; step++) {
        final jx = (random.nextDouble() - 0.5) * 45;
        final jy = (random.nextDouble() - 0.5) * 45;
        forkPath.lineTo(forkOrigin.dx + jx, forkOrigin.dy + jy);
      }
      canvas.drawPath(
        forkPath,
        Paint()
          ..color = const Color(0xFF76FF03).withValues(alpha: 0.8)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }

    // Sparks at target
    if (progress >= 0.8) {
      final sparkPaint = Paint()..color = const Color(0xFFFFEA00);
      for (int s = 0; s < 6; s++) {
        final angle = s * math.pi / 3;
        final sparkPos = currentEnd + Offset(math.cos(angle) * 16, math.sin(angle) * 16);
        canvas.drawCircle(sparkPos, 3.5, sparkPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FingerLightningStrikePainter oldDelegate) => true;
}

/// 🌀 Rolling Tornado Punch: High-speed spinning drill boxing glove
class RollingTornadoPunchWidget extends StatelessWidget {
  final double size;
  final double spinAngle;
  final Color gloveColor;

  const RollingTornadoPunchWidget({
    super.key,
    this.size = 75,
    required this.spinAngle,
    this.gloveColor = const Color(0xFFFF9800),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RollingTornadoPunchPainter(spinAngle: spinAngle, gloveColor: gloveColor),
      ),
    );
  }
}

class _RollingTornadoPunchPainter extends CustomPainter {
  final double spinAngle;
  final Color gloveColor;

  _RollingTornadoPunchPainter({required this.spinAngle, required this.gloveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(spinAngle);

    // 1. Spinning Wind Vortex Rings
    final vortexPaint = Paint()
      ..color = const Color(0xFFFFF9C4).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int ring = 1; ring <= 3; ring++) {
      final r = radius * (0.6 + ring * 0.25);
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: r),
        ring * 0.8,
        math.pi * 1.2,
        false,
        vortexPaint,
      );
    }

    // 2. 3D Drill Head Cone with Spiral Grooves
    final drillPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFF176), gloveColor, const Color(0xFFE65100)],
      ).createShader(Rect.fromCircle(center: const Alignment(-0.3, -0.3).alongSize(size), radius: radius));

    final drillPath = Path()
      ..moveTo(-radius * 0.7, -radius * 0.7)
      ..lineTo(radius * 0.8, 0)
      ..lineTo(-radius * 0.7, radius * 0.7)
      ..close();
    canvas.drawPath(drillPath, drillPaint);
    canvas.drawPath(drillPath, Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.black87);

    // Spiral Ridges
    final groovePaint = Paint()
      ..color = const Color(0xFFBF360C)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromLTWH(-radius * 0.4, -radius * 0.5, radius * 0.8, radius), -0.5, 2.5, false, groovePaint);
    canvas.drawArc(Rect.fromLTWH(-radius * 0.1, -radius * 0.4, radius * 0.6, radius * 0.8), -0.5, 2.5, false, groovePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RollingTornadoPunchPainter oldDelegate) => true;
}

/// ❄️ Frost Freeze Ray: Icy sub-zero beam
class FrostBeamWidget extends StatelessWidget {
  final Offset start;
  final Offset target;
  final double progress;

  const FrostBeamWidget({
    super.key,
    required this.start,
    required this.target,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _FrostBeamPainter(start: start, target: target, progress: progress),
    );
  }
}

class _FrostBeamPainter extends CustomPainter {
  final Offset start;
  final Offset target;
  final double progress;

  _FrostBeamPainter({required this.start, required this.target, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;
    final currentEnd = Offset.lerp(start, target, progress.clamp(0.0, 1.0))!;

    // Outer Ice Mist Glow
    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF00E5FF).withValues(alpha: 0.8), const Color(0xFFE0F7FA)],
      ).createShader(Rect.fromPoints(start, currentEnd))
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, currentEnd, glowPaint);

    // Inner Solid Ice Core
    final corePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, currentEnd, corePaint);

    // Snowflake Crystals along the beam
    final random = math.Random(77);
    final crystalPaint = Paint()..color = const Color(0xFF80D8FF);
    for (int i = 0; i < 7; i++) {
      final t = i / 7.0;
      if (t <= progress) {
        final pos = Offset.lerp(start, target, t)!;
        final jx = (random.nextDouble() - 0.5) * 16;
        final jy = (random.nextDouble() - 0.5) * 16;
        canvas.drawCircle(pos + Offset(jx, jy), 3.5, crystalPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FrostBeamPainter oldDelegate) => true;
}

/// 🔥 Rocket Fire Thruster Glove
class RocketFireGloveWidget extends StatelessWidget {
  final double size;
  final double angle;

  const RocketFireGloveWidget({super.key, this.size = 75, this.angle = 0.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RocketFireGlovePainter(angle: angle),
      ),
    );
  }
}

class _RocketFireGlovePainter extends CustomPainter {
  final double angle;

  _RocketFireGlovePainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    // 1. Roaring Exhaust Jet Flames behind glove
    final flamePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFFFFD54F), Color(0xFFFF5722), Colors.transparent],
      ).createShader(const Rect.fromLTWH(-35, -12, 35, 24));

    final flamePath = Path()
      ..moveTo(0, -10)
      ..lineTo(-32, 0)
      ..lineTo(0, 10)
      ..close();
    canvas.drawPath(flamePath, flamePaint);

    // 2. Rocket Boxing Glove
    final glovePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFFF8A80), Color(0xFFD50000), Color(0xFF8E0000)],
      ).createShader(const Rect.fromLTWH(-10, -18, 36, 36));

    final gloveR = RRect.fromRectAndRadius(const Rect.fromLTWH(-8, -16, 32, 32), const Radius.circular(10));
    canvas.drawRRect(gloveR, glovePaint);
    canvas.drawRRect(gloveR, Paint()..style = PaintingStyle.stroke..strokeWidth = 2.5..color = Colors.black87);

    // Jet Exhaust Nozzle
    final nozzlePaint = Paint()..color = const Color(0xFF455A64);
    canvas.drawRect(const Rect.fromLTWH(-12, -8, 5, 16), nozzlePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RocketFireGlovePainter oldDelegate) => true;
}

/// 🔨 Comic Megaton Mallet Sledgehammer
class ComicHammerWidget extends StatelessWidget {
  final double size;
  final double swingAngle;

  const ComicHammerWidget({super.key, this.size = 85, this.swingAngle = 0.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ComicHammerPainter(swingAngle: swingAngle),
      ),
    );
  }
}

class _ComicHammerPainter extends CustomPainter {
  final double swingAngle;

  _ComicHammerPainter({required this.swingAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.4, size.height * 0.75);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(swingAngle);

    final stroke = Paint()..style = PaintingStyle.stroke..strokeWidth = 3..color = Colors.black87;

    // Wooden Handle
    final handlePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFD7CCC8), Color(0xFF8D6E63), Color(0xFF4E342E)],
      ).createShader(const Rect.fromLTWH(-4, -65, 8, 70));

    final handle = RRect.fromRectAndRadius(const Rect.fromLTWH(-4, -65, 8, 70), const Radius.circular(3));
    canvas.drawRRect(handle, handlePaint);
    canvas.drawRRect(handle, stroke);

    // Massive Golden/Stone Hammer Head
    final headPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFF9C4), Color(0xFFFFB300), Color(0xFFE65100)],
      ).createShader(const Rect.fromLTWH(-28, -78, 56, 28));

    final head = RRect.fromRectAndRadius(const Rect.fromLTWH(-28, -78, 56, 28), const Radius.circular(8));
    canvas.drawRRect(head, headPaint);
    canvas.drawRRect(head, stroke);

    // Comic "100t" inscription on head
    canvas.drawCircle(const Offset(0, -64), 8, Paint()..color = const Color(0xFFFFD54F));
    canvas.drawCircle(const Offset(0, -64), 8, stroke..strokeWidth = 1.5);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ComicHammerPainter oldDelegate) => true;
}

