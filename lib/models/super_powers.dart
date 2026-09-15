import 'package:flutter/material.dart';

enum GlovePowerType {
  normal,
  electric,
  spiderWeb,
  fireball,
  freeze,
}

class SuperPower {
  final GlovePowerType type;
  final String name;
  final IconData icon;
  final Color primaryColor;
  final Color glowColor;
  final String description;
  final int unlockLevel;
  int charges;

  SuperPower({
    required this.type,
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.glowColor,
    required this.description,
    required this.unlockLevel,
    this.charges = 3,
  });

  static List<SuperPower> getInitialPowers() {
    return [
      SuperPower(
        type: GlovePowerType.electric,
        name: 'Electric Current',
        icon: Icons.bolt,
        primaryColor: const Color(0xFF00E5FF),
        glowColor: const Color(0xFFFFEA00),
        description: 'Electrifies the punch! Lightning jumps and zaps nearby uncles!',
        unlockLevel: 1,
        charges: 3,
      ),
      SuperPower(
        type: GlovePowerType.spiderWeb,
        name: 'Spider-Man Web',
        icon: Icons.all_inclusive,
        primaryColor: const Color(0xFFE53935),
        glowColor: Colors.white,
        description: 'Fires sticky spider webs that immobilize moving/dodging ninjas!',
        unlockLevel: 2,
        charges: 3,
      ),
      SuperPower(
        type: GlovePowerType.fireball,
        name: 'Fire Meteor',
        icon: Icons.local_fire_department,
        primaryColor: const Color(0xFFFF3D00),
        glowColor: const Color(0xFFFF9100),
        description: 'Explosive fiery blast that smashes clusters of uncles!',
        unlockLevel: 3,
        charges: 2,
      ),
      SuperPower(
        type: GlovePowerType.freeze,
        name: 'Frost Freeze',
        icon: Icons.ac_unit,
        primaryColor: const Color(0xFF40C4FF),
        glowColor: const Color(0xFFE0F7FA),
        description: 'Freezes moving uncles into solid ice blocks!',
        unlockLevel: 4,
        charges: 2,
      ),
    ];
  }
}
