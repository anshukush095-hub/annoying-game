import 'package:flutter/material.dart';

class CharacterSkin {
  final String id;
  final String name;
  final int price;
  final String skinType; // 'default', 'red_hair', 'blue', 'police', 'clown', 'gold'

  const CharacterSkin({
    required this.id,
    required this.name,
    required this.price,
    required this.skinType,
  });
}

class GloveSkin {
  final String id;
  final String name;
  final int price;
  final Color color;

  const GloveSkin({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
  });
}

class BackgroundTheme {
  final String id;
  final String name;
  final int price;
  final String desc;

  const BackgroundTheme({
    required this.id,
    required this.name,
    required this.price,
    required this.desc,
  });
}

class LevelData {
  final int levelNumber;
  final int targetScore;
  final int timeLimit;
  final int stars;
  final bool isUnlocked;
  final int highScore;

  const LevelData({
    required this.levelNumber,
    required this.targetScore,
    required this.timeLimit,
    this.stars = 0,
    this.isUnlocked = false,
    this.highScore = 0,
  });

  LevelData copyWith({
    int? stars,
    bool? isUnlocked,
    int? highScore,
  }) {
    return LevelData(
      levelNumber: levelNumber,
      targetScore: targetScore,
      timeLimit: timeLimit,
      stars: stars ?? this.stars,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      highScore: highScore ?? this.highScore,
    );
  }
}

class DailyRewardItem {
  final int day;
  final int coins;
  final bool isSpecial;

  const DailyRewardItem({
    required this.day,
    required this.coins,
    this.isSpecial = false,
  });
}

class AchievementItem {
  final String id;
  final String title;
  final String description;
  final int rewardCoins;
  final IconData icon;
  final int currentProgress;
  final int maxProgress;
  final bool isUnlocked;

  const AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardCoins,
    required this.icon,
    required this.currentProgress,
    required this.maxProgress,
    this.isUnlocked = false,
  });

  AchievementItem copyWith({
    int? currentProgress,
    bool? isUnlocked,
  }) {
    return AchievementItem(
      id: id,
      title: title,
      description: description,
      rewardCoins: rewardCoins,
      icon: icon,
      currentProgress: currentProgress ?? this.currentProgress,
      maxProgress: maxProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
