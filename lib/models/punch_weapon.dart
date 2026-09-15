import 'package:flutter/material.dart';

enum PunchWeaponType {
  classicGlove,
  fingerLightning,
  rollingDrill,
  thunderKnuckles,
  squeakyHammer,
  spikedGlove,
  cyberFist,
  dragonGauntlet,
  frostFreeze,
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
  final int tier;
  final int baseDamage;
  final int critRate;
  final String secondaryStatName;
  final int secondaryStatValue;
  final int upgradeCost;
  final String rarity;

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
    this.tier = 1,
    this.baseDamage = 1000,
    this.critRate = 15,
    this.secondaryStatName = 'SPEED',
    this.secondaryStatValue = 50,
    this.upgradeCost = 1000,
    this.rarity = 'COMMON',
  });

  /// Weapons matching Google Play Store Armory Shop (Screenshot 4)
  static List<PunchWeapon> getAllWeapons() {
    return const [
      // 1. Golden Dragon Gauntlet (Tier 5 - Mythic)
      PunchWeapon(
        type: PunchWeaponType.dragonGauntlet,
        id: 'dragon_gauntlet',
        name: 'Golden Dragon Gauntlet',
        shortName: 'Dragon 🐉',
        icon: Icons.local_fire_department,
        unlockLevel: 15,
        description: 'Blazing dragon head gauntlet breathing mythological blue flames!',
        primaryColor: Color(0xFFFFB300),
        glowColor: Color(0xFF00E5FF),
        comicBurst: '🐉 DRAGON BLAZE! +28500',
        bonusDamage: 28500,
        tier: 5,
        baseDamage: 28500,
        critRate: 65,
        secondaryStatName: 'SPEED',
        secondaryStatValue: 70,
        upgradeCost: 50000,
        rarity: 'MYTHIC',
      ),

      // 2. Cyber Mecha Rocket Drill (Tier 5 - Legendary)
      PunchWeapon(
        type: PunchWeaponType.rollingDrill,
        id: 'cyber_fist',
        name: 'Cyber Mecha Rocket Drill',
        shortName: 'Mecha 🚀',
        icon: Icons.rocket_launch,
        unlockLevel: 3,
        description: 'Twin rocket thrusters propelled high-velocity titanium drill fist!',
        primaryColor: Color(0xFF42A5F5),
        glowColor: Color(0xFFFF1744),
        comicBurst: '🚀 ROCKET DRILL! +25100',
        bonusDamage: 25100,
        tier: 5,
        baseDamage: 25100,
        critRate: 55,
        secondaryStatName: 'AOE',
        secondaryStatValue: 80,
        upgradeCost: 45000,
        rarity: 'LEGENDARY',
      ),

      // 3. Electric Thunder Knuckles (Tier 4 - Epic)
      PunchWeapon(
        type: PunchWeaponType.fingerLightning,
        id: 'thunder_knuckles',
        name: 'Electric Thunder Knuckles',
        shortName: 'Current ⚡',
        icon: Icons.flash_on,
        unlockLevel: 2,
        description: 'Twin electrified brass knuckles crackling with 10,000 Volts!',
        primaryColor: Color(0xFF00E5FF),
        glowColor: Color(0xFFFFEA00),
        comicBurst: '⚡ THUNDER ZAP! +21500',
        bonusDamage: 21500,
        tier: 4,
        baseDamage: 21500,
        critRate: 45,
        secondaryStatName: 'SHOCK',
        secondaryStatValue: 75,
        upgradeCost: 40000,
        rarity: 'EPIC',
      ),

      // 4. Giant Toy Squeaky Hammer (Tier 3 - Rare)
      PunchWeapon(
        type: PunchWeaponType.squeakyHammer,
        id: 'squeaky_hammer',
        name: 'Giant Toy Squeaky Hammer',
        shortName: 'Hammer 🔨',
        icon: Icons.gavel,
        unlockLevel: 4,
        description: 'Comical giant rainbow mallet that screams SQUEAK on impact!',
        primaryColor: Color(0xFF00E676),
        glowColor: Color(0xFFFFD54F),
        comicBurst: '🔨 SQUEAK! +14200',
        bonusDamage: 14200,
        tier: 3,
        baseDamage: 14200,
        critRate: 30,
        secondaryStatName: 'KNOCKBACK',
        secondaryStatValue: 90,
        upgradeCost: 25000,
        rarity: 'RARE',
      ),

      // 5. Cryo Frost Freeze Ray (Tier 3 - Rare)
      PunchWeapon(
        type: PunchWeaponType.frostFreeze,
        id: 'frost_freeze',
        name: 'Cryo Frost Freeze Ray',
        shortName: 'Freeze ❄️',
        icon: Icons.ac_unit,
        unlockLevel: 5,
        description: 'Sub-zero cryo blaster that flash-freezes targets in thick solid ice!',
        primaryColor: Color(0xFF80D8FF),
        glowColor: Color(0xFF00B0FF),
        comicBurst: '❄️ FREEZE POP! +16500',
        bonusDamage: 16500,
        tier: 3,
        baseDamage: 16500,
        critRate: 35,
        secondaryStatName: 'FREEZE',
        secondaryStatValue: 85,
        upgradeCost: 28000,
        rarity: 'RARE',
      ),

      // 6. Spiked Neon Boxing Glove (Tier 4 - Epic)
      PunchWeapon(
        type: PunchWeaponType.spikedGlove,
        id: 'spiked_neon',
        name: 'Spiked Neon Boxing Glove',
        shortName: 'Spikes 🥊',
        icon: Icons.sports_mma,
        unlockLevel: 8,
        description: 'Hardened leather glove embedded with glowing magenta neon spikes!',
        primaryColor: Color(0xFFE91E63),
        glowColor: Color(0xFF7C4DFF),
        comicBurst: '💥 CRITICAL HIT! +19800',
        bonusDamage: 19800,
        tier: 4,
        baseDamage: 19800,
        critRate: 40,
        secondaryStatName: 'SPEED',
        secondaryStatValue: 60,
        upgradeCost: 38000,
        rarity: 'EPIC',
      ),

      // 7. Hyper Plasma Laser Cannon (Tier 4 - Epic)
      PunchWeapon(
        type: PunchWeaponType.plasmaLaser,
        id: 'plasma_laser',
        name: 'Hyper Plasma Laser Cannon',
        shortName: 'Laser 🔫',
        icon: Icons.offline_bolt,
        unlockLevel: 10,
        description: 'High-density coherent neon energy beam piercing through all defenses!',
        primaryColor: Color(0xFFFF4081),
        glowColor: Color(0xFFFFD54F),
        comicBurst: '⚡ LASER BLAST! +24000',
        bonusDamage: 24000,
        tier: 4,
        baseDamage: 24000,
        critRate: 50,
        secondaryStatName: 'PIERCE',
        secondaryStatValue: 70,
        upgradeCost: 42000,
        rarity: 'EPIC',
      ),

      // 8. Classic Spring Boxing Glove (Tier 1 - Common)
      PunchWeapon(
        type: PunchWeaponType.classicGlove,
        id: 'classic_glove',
        name: 'Classic Spring Glove',
        shortName: 'Glove 🥊',
        icon: Icons.sports_mma,
        unlockLevel: 1,
        description: 'The iconic spring-loaded accordion boxing glove!',
        primaryColor: Color(0xFFE53935),
        glowColor: Color(0xFFFF5252),
        comicBurst: 'POW! +1000',
        bonusDamage: 1000,
        tier: 1,
        baseDamage: 1000,
        critRate: 15,
        secondaryStatName: 'SPEED',
        secondaryStatValue: 50,
        upgradeCost: 5000,
        rarity: 'COMMON',
      ),
    ];
  }
}
