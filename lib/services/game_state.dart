import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import 'audio_manager.dart';

class GameState extends ChangeNotifier {
  static final GameState _instance = GameState._internal();
  factory GameState() => _instance;
  GameState._internal();

  // Currency & Progress
  int _coins = 1250;
  int _lives = 3;
  final int _maxLives = 3;
  int _currentLevelNumber = 1;
  int _highScore = 3480;
  List<LevelData> _levels = [];

  // Characters & Gloves
  String _equippedSkinId = 'default';
  final Set<String> _unlockedSkins = {'default'};

  String _equippedGloveId = 'classic_red';
  final Set<String> _unlockedGloves = {'classic_red'};

  String _equippedWeaponId = 'classic_glove';
  final Map<String, int> _weaponLevels = {};

  String _selectedBackgroundId = 'rooftop';

  // Settings
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  bool _vibrationEnabled = true;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _graphicsQuality = 'High';
  bool _hasSeenDemo = false;

  // Daily Reward & Lucky Spin
  int _dailyStreak = 1;
  int _lastClaimDay = 0;
  String? _lastDailyClaimDate;
  String? _lastSpinDate;

  // Achievements
  List<AchievementItem> _achievements = [];

  // Getters
  int get coins => _coins;
  int get lives => _lives;
  int get maxLives => _maxLives;
  int get currentLevelNumber => _currentLevelNumber;
  int get highScore => _highScore;
  List<LevelData> get levels => _levels;
  String get equippedSkinId => _equippedSkinId;
  String get equippedGloveId => _equippedGloveId;
  String get equippedWeaponId => _equippedWeaponId;
  String get selectedBackgroundId => _selectedBackgroundId;
  int getWeaponLevel(String weaponId) => _weaponLevels[weaponId] ?? 1;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get selectedLanguage => _selectedLanguage;
  String get graphicsQuality => _graphicsQuality;
  bool get hasSeenDemo => _hasSeenDemo;

  void completeDemo() {
    _hasSeenDemo = true;
    _saveToPrefs();
    notifyListeners();
  }

  int get dailyStreak => _dailyStreak;
  int get lastClaimDay => _lastClaimDay;
  String? get lastDailyClaimDate => _lastDailyClaimDate;

  String getTodayDateString() {
    final now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  String getYesterdayDateString() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return "${yesterday.year.toString().padLeft(4, '0')}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
  }

  bool get isDailyRewardClaimedToday {
    if (_lastDailyClaimDate == null || _lastDailyClaimDate!.isEmpty) return false;
    return _lastDailyClaimDate == getTodayDateString();
  }

  bool get canClaimDailyReward => !isDailyRewardClaimedToday;
  bool get canFreeSpin => _lastSpinDate != getTodayDateString();

  void performSpin() {
    _lastSpinDate = getTodayDateString();
    _saveToPrefs();
    notifyListeners();
  }

  Duration get timeUntilNextDailyReward {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  List<AchievementItem> get achievements => _achievements;

  bool isSkinUnlocked(String skinId) => _unlockedSkins.contains(skinId);
  bool isGloveUnlocked(String gloveId) => _unlockedGloves.contains(gloveId);

  // Available Character Skins (Exact match to reference Screen 8 & 10)
  final List<CharacterSkin> allSkins = const [
    CharacterSkin(
      id: 'default',
      name: 'Default',
      price: 0,
      skinType: 'default',
    ),
    CharacterSkin(
      id: 'red_hair',
      name: 'Red Hair',
      price: 500,
      skinType: 'red_hair',
    ),
    CharacterSkin(
      id: 'blue',
      name: 'Blue',
      price: 750,
      skinType: 'blue',
    ),
    CharacterSkin(
      id: 'police',
      name: 'Police',
      price: 1000,
      skinType: 'police',
    ),
    CharacterSkin(
      id: 'clown',
      name: 'Clown',
      price: 1500,
      skinType: 'clown',
    ),
    CharacterSkin(
      id: 'gold',
      name: 'Gold',
      price: 2000,
      skinType: 'gold',
    ),
    CharacterSkin(
      id: 'ninja',
      name: 'Ninja',
      price: 2500,
      skinType: 'ninja',
    ),
    CharacterSkin(
      id: 'boss',
      name: 'Mafia Boss',
      price: 3000,
      skinType: 'boss',
    ),
    CharacterSkin(
      id: 'pirate',
      name: 'Pirate Captain',
      price: 3200,
      skinType: 'pirate',
    ),
    CharacterSkin(
      id: 'vampire',
      name: 'Count Dracula',
      price: 3500,
      skinType: 'vampire',
    ),
    CharacterSkin(
      id: 'alien',
      name: 'Cosmic Alien',
      price: 3800,
      skinType: 'alien',
    ),
    CharacterSkin(
      id: 'chef',
      name: 'Master Chef',
      price: 4000,
      skinType: 'chef',
    ),
    CharacterSkin(
      id: 'disco',
      name: 'Disco Star',
      price: 4200,
      skinType: 'disco',
    ),
    CharacterSkin(
      id: 'superhero',
      name: 'Superhero',
      price: 4500,
      skinType: 'superhero',
    ),
    CharacterSkin(
      id: 'scientist',
      name: 'Mad Scientist',
      price: 4800,
      skinType: 'scientist',
    ),
    CharacterSkin(
      id: 'zombie',
      name: 'Zombie',
      price: 5000,
      skinType: 'zombie',
    ),
    CharacterSkin(
      id: 'boxer',
      name: 'Rival Boxer',
      price: 5200,
      skinType: 'boxer',
    ),
    CharacterSkin(
      id: 'robot',
      name: 'Cyborg Robot',
      price: 5500,
      skinType: 'robot',
    ),
    CharacterSkin(
      id: 'bomb',
      name: 'Bomb Guy',
      price: 6000,
      skinType: 'bomb',
    ),
    CharacterSkin(
      id: 'dizzy',
      name: 'Dizzy Uncle',
      price: 6500,
      skinType: 'dizzy',
    ),
    CharacterSkin(
      id: 'astronaut',
      name: 'Astronaut',
      price: 7000,
      skinType: 'astronaut',
    ),
    CharacterSkin(
      id: 'caveman',
      name: 'Caveman',
      price: 7200,
      skinType: 'caveman',
    ),
    CharacterSkin(
      id: 'farmer',
      name: 'Farmer',
      price: 7500,
      skinType: 'farmer',
    ),
  ];

  // Available Glove Skins
  final List<GloveSkin> allGloves = const [
    GloveSkin(
      id: 'classic_red',
      name: 'Classic Red',
      price: 0,
      color: Color(0xFFE53935),
    ),
    GloveSkin(
      id: 'gold_fist',
      name: 'Gold Fist',
      price: 800,
      color: Color(0xFFFFD54F),
    ),
    GloveSkin(
      id: 'blue_fury',
      name: 'Blue Fury',
      price: 600,
      color: Color(0xFF1E88E5),
    ),
    GloveSkin(
      id: 'shadow_black',
      name: 'Shadow Black',
      price: 1000,
      color: Color(0xFF212121),
    ),
  ];

  // Available Backgrounds
  final List<BackgroundTheme> allBackgrounds = const [
    BackgroundTheme(
      id: 'rooftop',
      name: 'Rooftop Arena',
      price: 0,
      desc: 'Skyline view with cool breeze',
    ),
    BackgroundTheme(
      id: 'gym',
      name: 'Boxing Gym',
      price: 500,
      desc: 'Classic workout boxing gym',
    ),
    BackgroundTheme(
      id: 'warehouse',
      name: 'Secret Warehouse',
      price: 800,
      desc: 'Industrial underground setting',
    ),
  ];

  // Daily Rewards List (Day 1 to Day 7)
  final List<DailyRewardItem> dailyRewards = const [
    DailyRewardItem(day: 1, coins: 100),
    DailyRewardItem(day: 2, coins: 200),
    DailyRewardItem(day: 3, coins: 300),
    DailyRewardItem(day: 4, coins: 400),
    DailyRewardItem(day: 5, coins: 500),
    DailyRewardItem(day: 6, coins: 600),
    DailyRewardItem(day: 7, coins: 1000, isSpecial: true),
  ];

  Future<void> init() async {
    _initLevels();
    _initAchievements();
    await _loadFromPrefs();
  }

  void _initLevels() {
    _levels = List.generate(2000, (index) {
      final lvl = index + 1;
      return LevelData(
        levelNumber: lvl,
        targetScore: 40 + (lvl * 15),
        timeLimit: math.max(25, 60 - (lvl ~/ 30)),
        stars: lvl == 1 ? 3 : (lvl == 2 ? 2 : 0),
        isUnlocked: lvl <= 3,
        highScore: lvl == 1 ? 2480 : 0,
      );
    });
  }

  void _initAchievements() {
    _achievements = [
      const AchievementItem(
        id: 'first_hit',
        title: 'First Hit',
        description: 'Hit 10 uncles',
        rewardCoins: 100,
        icon: Icons.star,
        currentProgress: 10,
        maxProgress: 10,
        isUnlocked: true,
      ),
      const AchievementItem(
        id: 'coin_collector',
        title: 'Coin Collector',
        description: 'Collect 1000 coins',
        rewardCoins: 200,
        icon: Icons.monetization_on,
        currentProgress: 750,
        maxProgress: 1000,
        isUnlocked: false,
      ),
      const AchievementItem(
        id: 'level_master',
        title: 'Level Master',
        description: 'Complete 5 levels',
        rewardCoins: 300,
        icon: Icons.military_tech,
        currentProgress: 3,
        maxProgress: 5,
        isUnlocked: false,
      ),
      const AchievementItem(
        id: 'no_internet',
        title: 'No Internet',
        description: 'Play 1 level offline',
        rewardCoins: 150,
        icon: Icons.wifi_off,
        currentProgress: 0,
        maxProgress: 1,
        isUnlocked: false,
      ),
    ];
  }

  // Currency Actions
  void addCoins(int amount) {
    _coins += amount;
    AudioManager().playCoin();
    _saveToPrefs();
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    return false;
  }

  void decrementLife() {
    if (_lives > 0) {
      _lives--;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void refillLives() {
    _lives = _maxLives;
    _saveToPrefs();
    notifyListeners();
  }

  // Skin Management
  bool unlockSkin(String skinId, int price) {
    if (spendCoins(price)) {
      _unlockedSkins.add(skinId);
      _equippedSkinId = skinId;
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipSkin(String skinId) {
    if (_unlockedSkins.contains(skinId)) {
      _equippedSkinId = skinId;
      _saveToPrefs();
      notifyListeners();
    }
  }

  // Glove Management
  bool unlockGlove(String gloveId, int price) {
    if (spendCoins(price)) {
      _unlockedGloves.add(gloveId);
      _equippedGloveId = gloveId;
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipGlove(String gloveId) {
    if (_unlockedGloves.contains(gloveId)) {
      _equippedGloveId = gloveId;
      _saveToPrefs();
      notifyListeners();
    }
  }

  void equipWeapon(String weaponId) {
    _equippedWeaponId = weaponId;
    _saveToPrefs();
    notifyListeners();
  }

  bool upgradeWeapon(String weaponId, int cost) {
    if (spendCoins(cost)) {
      _weaponLevels[weaponId] = getWeaponLevel(weaponId) + 1;
      _saveToPrefs();
      notifyListeners();
      return true;
    }
    return false;
  }

  void setBackground(String bgId) {
    _selectedBackgroundId = bgId;
    _saveToPrefs();
    notifyListeners();
  }

  // Settings Toggles
  void toggleSound(bool value) {
    _soundEnabled = value;
    AudioManager().soundEnabled = value;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleMusic(bool value) {
    _musicEnabled = value;
    AudioManager().musicEnabled = value;
    _saveToPrefs();
    notifyListeners();
  }

  void setMusicVolume(double value) {
    _musicVolume = value;
    AudioManager().musicVolume = value;
    _saveToPrefs();
    notifyListeners();
  }

  void setSfxVolume(double value) {
    _sfxVolume = value;
    AudioManager().sfxVolume = value;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    AudioManager().vibrationEnabled = value;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _saveToPrefs();
    notifyListeners();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    _saveToPrefs();
    notifyListeners();
  }

  void setGraphics(String quality) {
    _graphicsQuality = quality;
    _saveToPrefs();
    notifyListeners();
  }

  void setCurrentLevel(int level) {
    _currentLevelNumber = level;
    notifyListeners();
  }

  void completeLevel(int levelNumber, int score, int stars) {
    final index = levelNumber - 1;
    if (index >= 0 && index < _levels.length) {
      final current = _levels[index];
      final newStars = stars > current.stars ? stars : current.stars;
      final newHigh = score > current.highScore ? score : current.highScore;

      _levels[index] = current.copyWith(
        stars: newStars,
        highScore: newHigh,
        isUnlocked: true,
      );

      final nextUnlocked = levelNumber + 1;
      if (levelNumber < _levels.length) {
        final nextIndex = levelNumber;
        _levels[nextIndex] = _levels[nextIndex].copyWith(isUnlocked: true);
      }

      if (score > _highScore) {
        _highScore = score;
      }

      addCoins(200); // +200 coins as shown in reference Screen 7
      _saveLevelProgress(levelNumber, newStars, newHigh, nextUnlocked);
      _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> _saveLevelProgress(int lvl, int stars, int high, int nextUnlocked) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lvl_${lvl}_stars', stars);
      await prefs.setInt('lvl_${lvl}_high', high);
      final currentUnlocked = prefs.getInt('unlockedLevelCount') ?? 3;
      if (nextUnlocked > currentUnlocked) {
        await prefs.setInt('unlockedLevelCount', nextUnlocked);
      }
    } catch (_) {}
  }

  bool claimDailyReward([int? day]) {
    if (isDailyRewardClaimedToday) {
      return false; // Ek din me keval ek baar hi reward mile!
    }

    final todayStr = getTodayDateString();
    final yesterdayStr = getYesterdayDateString();

    // Check consecutive day streak
    if (_lastDailyClaimDate != null && _lastDailyClaimDate == yesterdayStr) {
      if (_dailyStreak < 7) {
        _dailyStreak++;
      } else {
        _dailyStreak = 1;
      }
    } else if (_lastDailyClaimDate == null) {
      _dailyStreak = 1;
    } else {
      // Skipped 1 or more days, reset streak to Day 1
      _dailyStreak = 1;
    }

    final item = dailyRewards.firstWhere(
      (r) => r.day == _dailyStreak,
      orElse: () => dailyRewards.first,
    );
    addCoins(item.coins);

    _lastClaimDay = _dailyStreak;
    _lastDailyClaimDate = todayStr;

    _saveToPrefs();
    notifyListeners();
    return true;
  }

  // Persistence
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _coins = prefs.getInt('coins') ?? 1250;
      _highScore = prefs.getInt('highScore') ?? 3480;
      _equippedSkinId = prefs.getString('equippedSkin') ?? 'default';
      _equippedGloveId = prefs.getString('equippedGlove') ?? 'classic_red';
      _selectedBackgroundId = prefs.getString('background') ?? 'rooftop';

      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _musicEnabled = prefs.getBool('musicEnabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
      _hasSeenDemo = prefs.getBool('hasSeenDemo') ?? false;

      _lastDailyClaimDate = prefs.getString('lastDailyClaimDate');
      _lastSpinDate = prefs.getString('lastSpinDate');
      _dailyStreak = prefs.getInt('dailyStreak') ?? 1;
      _lastClaimDay = prefs.getInt('lastClaimDay') ?? 0;

      AudioManager().soundEnabled = _soundEnabled;
      AudioManager().musicEnabled = _musicEnabled;
      AudioManager().vibrationEnabled = _vibrationEnabled;
      if (_musicEnabled) {
        AudioManager().startBackgroundMusic();
      }

      // Restore 2000 levels progress
      final unlockedCount = prefs.getInt('unlockedLevelCount') ?? 3;
      for (int i = 0; i < math.min(unlockedCount, _levels.length); i++) {
        final lvl = i + 1;
        final stars = prefs.getInt('lvl_${lvl}_stars');
        final high = prefs.getInt('lvl_${lvl}_high');
        _levels[i] = _levels[i].copyWith(
          isUnlocked: true,
          stars: stars ?? _levels[i].stars,
          highScore: high ?? _levels[i].highScore,
        );
      }

      final skins = prefs.getStringList('unlockedSkins');
      if (skins != null) _unlockedSkins.addAll(skins);

      final gloves = prefs.getStringList('unlockedGloves');
      if (gloves != null) _unlockedGloves.addAll(gloves);

      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('coins', _coins);
      await prefs.setInt('highScore', _highScore);
      await prefs.setString('equippedSkin', _equippedSkinId);
      await prefs.setString('equippedGlove', _equippedGloveId);
      await prefs.setString('background', _selectedBackgroundId);
      await prefs.setBool('soundEnabled', _soundEnabled);
      await prefs.setBool('musicEnabled', _musicEnabled);
      await prefs.setBool('vibrationEnabled', _vibrationEnabled);
      await prefs.setBool('hasSeenDemo', _hasSeenDemo);
      if (_lastDailyClaimDate != null) {
        await prefs.setString('lastDailyClaimDate', _lastDailyClaimDate!);
      }
      if (_lastSpinDate != null) {
        await prefs.setString('lastSpinDate', _lastSpinDate!);
      }
      await prefs.setInt('dailyStreak', _dailyStreak);
      await prefs.setInt('lastClaimDay', _lastClaimDay);
      await prefs.setStringList('unlockedSkins', _unlockedSkins.toList());
      await prefs.setStringList('unlockedGloves', _unlockedGloves.toList());
    } catch (_) {}
  }
}
