import 'package:flutter/material.dart';

enum PunchWeaponType {
  classicGlove,
  fingerLightning,
  rollingDrill,
  frostFreeze,
  rocketFire,
  spiderWeb,
  sledgeHammer,
  plasmaLaser,
}

class PunchWeapon {
  final PunchWeaponType type;
  final String id;
  final String name;
  final String shortName;
  final IconData icon;
  final int unlockLevel;
  final String description;
  final Color primaryColor;
  final Color glowColor;
  final String comicBurst;
  final int bonusDamage;

  const PunchWeapon({
    required this.type,
    required this.id,
    required this.name,
    required this.shortName,
    required this.icon,
    required this.unlockLevel,
    required this.description,
    required this.primaryColor,
    required this.glowColor,
    required this.comicBurst,
    this.bonusDamage = 0,
  });

  /// 8 Progressive Weapons unlocked across levels
  static List<PunchWeapon> getAllWeapons() {
    return const [
      // 1. Level 1: Classic Spring Boxing Glove
      PunchWeapon(
        type: PunchWeaponType.classicGlove,
        id: 'classic_glove',
        name: 'Spring Glove',
        shortName: 'Glove',
        icon: Icons.sports_mma,
        unlockLevel: 1,
        description: 'Classic spring-loaded accordion boxing glove!',
        primaryColor: Color(0xFFE53935),
        glowColor: Color(0xFFFF5252),
        comicBurst: 'POW! +100',
        bonusDamage: 0,
      ),

      // 2. Level 2: Finger Lightning Arc ("ungli se current nikalna")
      PunchWeapon(
        type: PunchWeaponType.fingerLightning,
        id: 'finger_lightning',
        name: 'Finger Lightning',
        shortName: 'Current ⚡',
        icon: Icons.flash_on,
        unlockLevel: 2,
        description: 'Electric current shoots directly from your fingertip!',
        primaryColor: Color(0xFF00E5FF),
        glowColor: Color(0xFF76FF03),
        comicBurst: '⚡ ZAP! +150',
        bonusDamage: 50,
      ),

      // 3. Level 3: Rolling Tornado Drill ("rolling option")
      PunchWeapon(
        type: PunchWeaponType.rollingDrill,
        id: 'rolling_drill',
        name: 'Rolling Drill',
        shortName: 'Roll 🌀',
        icon: Icons.cyclone,
        unlockLevel: 3,
        description: 'High-speed spinning corkscrew drill punch with wind vortex!',
        primaryColor: Color(0xFFFF9800),
        glowColor: Color(0xFFFFD54F),
        comicBurst: '🌀 DRILL! +200',
        bonusDamage: 80,
      ),

      // 4. Level 5: Glacier Frost Freeze Ray ("freeze option")
      PunchWeapon(
        type: PunchWeaponType.frostFreeze,
        id: 'frost_freeze',
        name: 'Frost Freeze',
        shortName: 'Freeze ❄️',
        icon: Icons.ac_unit,
        unlockLevel: 5,
        description: 'Sub-zero glacier ray that turns uncles into solid ice!',
        primaryColor: Color(0xFF80D8FF),
        glowColor: Color(0xFF00B0FF),
        comicBurst: '❄️ FROZEN! +220',
        bonusDamage: 100,
      ),

      // 5. Level 7: Rocket Thruster Fire Fist
      PunchWeapon(
        type: PunchWeaponType.rocketFire,
        id: 'rocket_fire',
        name: 'Rocket Meteor',
        shortName: 'Rocket 🔥',
        icon: Icons.local_fire_department,
        unlockLevel: 7,
        description: 'Jet-powered rocket fist blasting with flames & smoke!',
        primaryColor: Color(0xFFFF3D00),
        glowColor: Color(0xFFFF9100),
        comicBurst: '🔥 BOOM! +260',
        bonusDamage: 120,
      ),

      // 6. Level 10: Spider Web Slinger
      PunchWeapon(
        type: PunchWeaponType.spiderWeb,
        id: 'spider_web',
        name: 'Spider Web',
        shortName: 'Web 🕸️',
        icon: Icons.all_inclusive,
        unlockLevel: 10,
        description: 'Entangles uncles in a sticky web so they cannot dodge!',
        primaryColor: Color(0xFFE91E63),
        glowColor: Color(0xFFFF4081),
        comicBurst: '🕸️ WEBBED! +280',
        bonusDamage: 140,
      ),

      // 7. Level 15: Megaton Comic Sledgehammer
      PunchWeapon(
        type: PunchWeaponType.sledgeHammer,
        id: 'sledge_hammer',
        name: 'Megaton Mallet',
        shortName: 'Hammer 🔨',
        icon: Icons.gavel,
        unlockLevel: 15,
        description: 'Giant squeaky comic mallet slamming down with BONK!',
        primaryColor: Color(0xFFFFB300),
        glowColor: Color(0xFFFFF9C4),
        comicBurst: '🔨 BONK! +350',
        bonusDamage: 200,
      ),

      // 8. Level 20: Plasma Laser Blaster
      PunchWeapon(
        type: PunchWeaponType.plasmaLaser,
        id: 'plasma_laser',
        name: 'Plasma Laser',
        shortName: 'Laser 💥',
        icon: Icons.light_mode,
        unlockLevel: 20,
        description: 'Futuristic sci-fi neon laser cutting through the screen!',
        primaryColor: Color(0xFFD500F9),
        glowColor: Color(0xFFF50057),
        comicBurst: '💥 LASER! +400',
        bonusDamage: 250,
      ),
    ];
  }
}
