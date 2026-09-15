import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../theme/level_environments.dart';
import '../models/punch_weapon.dart';
import '../services/game_state.dart';
import '../services/audio_manager.dart';
import '../dialogs/pause_dialog.dart';
import '../dialogs/game_over_dialog.dart';
import '../dialogs/level_complete_dialog.dart';
import '../dialogs/interactive_demo_dialog.dart';

class GameplayScreen extends StatefulWidget {
  final int level;

  const GameplayScreen({super.key, required this.level});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _TargetUncle {
  final int id;
  double x;
  double y;
  double scale;
  final String skin;
  int hp;
  final int maxHp;
  bool isHit = false;
  bool isBomb;
  bool isElectrified = false;
  bool isWebbed = false;
  bool isFrozen = false;
  double wobbleAngle = 0.0;
  double recoilAngle = 0.0;
  double hitFlyX = 0.0;
  double hitFlyY = 0.0;
  double moveSpeed;
  int moveDirection;

  _TargetUncle({
    required this.id,
    required this.x,
    required this.y,
    this.scale = 0.95,
    required this.skin,
    this.hp = 1,
    this.maxHp = 1,
    this.isBomb = false,
    this.moveSpeed = 0.0,
    this.moveDirection = 1,
  });
}

class _GameplayScreenState extends State<GameplayScreen>
    with TickerProviderStateMixin {
  final GameState gameState = GameState();
  final AudioManager audioManager = AudioManager();
  final math.Random _random = math.Random();

  late LevelEnvironment _environment;
  late int _score;
  late int _targetScore;
  int _hitsRemaining = 5;
  bool _isGameOver = false;

  // Progressive Punch Weapon System
  late PunchWeapon _activeWeapon;
  final List<PunchWeapon> _weapons = PunchWeapon.getAllWeapons();

  // Attack Visual States
  // 1. Spring / Rolling / Rocket Glove Flight
  late AnimationController _flightController;
  Offset _flightStart = Offset.zero;
  Offset _flightTarget = Offset.zero;
  Offset _currentGloveTip = Offset.zero;
  bool _isGloveFlying = false;
  double _punchImpactSquash = 1.0;
  double _drillSpinAngle = 0.0;

  // 2. ⚡ Finger Lightning ("ungli se current nikalna")
  bool _isFingerLightningActive = false;
  Offset _fingerTouchPoint = Offset.zero;
  Offset _fingerTargetPoint = Offset.zero;

  // 3. ❄️ Frost Beam
  bool _isFrostBeamActive = false;
  Offset _frostBeamStart = Offset.zero;
  Offset _frostBeamTarget = Offset.zero;

  // 4. 🔨 Comic Sledgehammer
  bool _isHammerSwinging = false;
  Offset _hammerPosition = Offset.zero;

  // 5. 💥 Plasma Laser
  bool _isLaserActive = false;
  Offset _laserStart = Offset.zero;
  Offset _laserEnd = Offset.zero;

  // Screen Shake on Impact
  double _screenShakeOffset = 0.0;

  // Drag Slingshot Aiming
  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;
  double _aimAngle = 0.0;

  final List<_TargetUncle> _uncles = [];
  final List<Offset> _punchSparks = [];
  final List<String> _floatingTexts = [];

  Timer? _gameLoopTimer;

  @override
  void initState() {
    super.initState();
    _score = 0;
    _environment = LevelEnvironment.getForLevel(widget.level);
    _setupLevelDifficulty();
    audioManager.startBackgroundMusic();

    // Default weapon: highest unlocked or classic
    _activeWeapon = _weapons.first;
    for (var w in _weapons) {
      if (widget.level >= w.unlockLevel) {
        _activeWeapon = w;
      }
    }

    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // Game loop for uncle movement, wobbles, and spinning animations
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 20), (_) {
      if (!mounted || _isGameOver) return;
      _updateUnclePositions();
    });

    if (widget.level == 1 && !gameState.hasSeenDemo) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const InteractiveDemoDialog(),
        );
      });
    }
  }

  bool get _allTargetsDefeated {
    final nonBombs = _uncles.where((u) => !u.isBomb).toList();
    return nonBombs.isNotEmpty && nonBombs.every((u) => u.isHit || u.hp <= 0);
  }

  void _setupLevelDifficulty() {
    _uncles.clear();
    final lvl = widget.level;
    final mainSkin = UncleCharacterWidget.getSkinForLevel(lvl);
    final secondarySkin = UncleCharacterWidget.getSkinForLevel(lvl + 1);
    final tertiarySkin = UncleCharacterWidget.getSkinForLevel(lvl + 2);
    final isBossLevel = (lvl % 5 == 0);

    if (lvl == 1) {
      _hitsRemaining = 5;
      _uncles.add(_TargetUncle(id: 1, x: 0.5, y: 0.36, scale: 1.05, skin: mainSkin));
    } else if (lvl == 2) {
      _hitsRemaining = 6;
      _uncles.add(_TargetUncle(id: 1, x: 0.36, y: 0.36, scale: 1.0, skin: mainSkin));
      _uncles.add(_TargetUncle(id: 2, x: 0.66, y: 0.36, scale: 0.95, skin: secondarySkin));
    } else if (lvl == 3) {
      _hitsRemaining = 7;
      _uncles.add(_TargetUncle(id: 1, x: 0.5, y: 0.24, scale: 1.0, skin: mainSkin));
      _uncles.add(_TargetUncle(id: 2, x: 0.3, y: 0.42, scale: 0.95, skin: secondarySkin));
      _uncles.add(_TargetUncle(id: 3, x: 0.7, y: 0.42, scale: 0.95, skin: tertiarySkin));
    } else if (isBossLevel) {
      final bossHp = 2 + (lvl ~/ 25).clamp(0, 5);
      final totalHp = bossHp + 2;
      _hitsRemaining = totalHp + 5;
      _uncles.add(_TargetUncle(
        id: 1,
        x: 0.5,
        y: 0.28,
        scale: 1.35,
        skin: mainSkin,
        hp: bossHp,
        maxHp: bossHp,
        moveSpeed: 0.0025 + (lvl * 0.00001).clamp(0.0, 0.003),
        moveDirection: 1,
      ));
      _uncles.add(_TargetUncle(
        id: 2,
        x: 0.22,
        y: 0.46,
        scale: 0.85,
        skin: secondarySkin,
        moveSpeed: 0.0035,
        moveDirection: -1,
      ));
      _uncles.add(_TargetUncle(
        id: 3,
        x: 0.78,
        y: 0.46,
        scale: 0.85,
        skin: tertiarySkin,
        moveSpeed: 0.0035,
        moveDirection: 1,
      ));
      if (lvl >= 10) {
        _uncles.add(_TargetUncle(
          id: 4,
          x: 0.5,
          y: 0.48,
          scale: 0.8,
          skin: 'bomb',
          isBomb: true,
          moveSpeed: 0.002,
          moveDirection: -1,
        ));
      }
    } else {
      final uncleCount = math.min(3 + (lvl % 3), 5);
      _hitsRemaining = uncleCount + 5;
      final speed = 0.002 + ((lvl % 8) * 0.0004);

      _uncles.add(_TargetUncle(
        id: 1,
        x: 0.5,
        y: 0.26,
        scale: 1.05,
        skin: mainSkin,
        moveSpeed: speed,
        moveDirection: 1,
      ));

      if (uncleCount >= 2) {
        _uncles.add(_TargetUncle(
          id: 2,
          x: 0.25,
          y: 0.38,
          scale: 0.9,
          skin: secondarySkin,
          moveSpeed: speed * 0.9,
          moveDirection: -1,
        ));
      }
      if (uncleCount >= 3) {
        _uncles.add(_TargetUncle(
          id: 3,
          x: 0.75,
          y: 0.38,
          scale: 0.9,
          skin: tertiarySkin,
          moveSpeed: speed * 1.1,
          moveDirection: 1,
        ));
      }
      if (uncleCount >= 4) {
        final hasBomb = (lvl % 4 == 0);
        _uncles.add(_TargetUncle(
          id: 4,
          x: 0.35,
          y: 0.48,
          scale: 0.85,
          skin: hasBomb ? 'bomb' : UncleCharacterWidget.getSkinForLevel(lvl + 3),
          isBomb: hasBomb,
          moveSpeed: speed * 0.8,
          moveDirection: -1,
        ));
      }
      if (uncleCount >= 5) {
        _uncles.add(_TargetUncle(
          id: 5,
          x: 0.65,
          y: 0.48,
          scale: 0.85,
          skin: UncleCharacterWidget.getSkinForLevel(lvl + 4),
          moveSpeed: speed * 1.0,
          moveDirection: 1,
        ));
      }
    }

    final totalTargetHp = _uncles.where((u) => !u.isBomb).fold(0, (sum, u) => sum + u.hp);
    _targetScore = totalTargetHp * 100;
  }

  void _updateUnclePositions() {
    setState(() {
      _drillSpinAngle += 0.4;
      for (var u in _uncles) {
        if (!u.isHit) {
          if (!u.isWebbed && !u.isFrozen && u.moveSpeed > 0) {
            u.x += u.moveSpeed * u.moveDirection;
            if (u.x > 0.85) {
              u.x = 0.85;
              u.moveDirection = -1;
            } else if (u.x < 0.15) {
              u.x = 0.15;
              u.moveDirection = 1;
            }
          }
          u.wobbleAngle = (_random.nextDouble() - 0.5) * 0.12;
          u.recoilAngle *= 0.85;
        } else {
          u.hitFlyX *= 0.96;
          u.hitFlyY -= 3.0;
          u.recoilAngle += 0.2;
        }
      }
    });
  }

  void _selectWeapon(PunchWeapon weapon) {
    if (widget.level < weapon.unlockLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🔒 ${weapon.name} unlocks at Level ${weapon.unlockLevel}! Keep playing to unlock!'),
          backgroundColor: const Color(0xFF0D47A1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    audioManager.playTap();
    setState(() {
      _activeWeapon = weapon;
    });
  }

  void _triggerScreenShake({double magnitude = 8.0}) {
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || timer.tick > 7) {
        timer.cancel();
        if (mounted) setState(() => _screenShakeOffset = 0.0);
        return;
      }
      setState(() {
        _screenShakeOffset = (timer.tick % 2 == 0 ? magnitude : -magnitude) * (1.0 - timer.tick / 7);
      });
    });
  }

  _TargetUncle? _findUncleAt(Offset point, Size size) {
    for (var u in _uncles.where((u) => !u.isHit)) {
      final uCenter = Offset(u.x * size.width, u.y * size.height);
      final uRect = Rect.fromCenter(center: uCenter, width: 90 * u.scale, height: 120 * u.scale);
      if (uRect.contains(point) || (uCenter - point).distance < 70) {
        return u;
      }
    }
    return null;
  }

  // Multi-Weapon Attack Execution
  void _executeAttackAt(Offset destination, {_TargetUncle? targetedUncle}) {
    if (_isGameOver) return;
    final size = MediaQuery.of(context).size;
    final hitUncle = targetedUncle ?? _findUncleAt(destination, size);

    switch (_activeWeapon.type) {
      case PunchWeaponType.fingerLightning:
        _launchFingerLightning(destination, hitUncle, size);
        break;
      case PunchWeaponType.rollingDrill:
        _launchRollingDrillPunch(destination, hitUncle);
        break;
      case PunchWeaponType.frostFreeze:
        _launchFrostFreezeBeam(destination, hitUncle, size);
        break;
      case PunchWeaponType.rocketFire:
        _launchRocketPunch(destination, hitUncle);
        break;
      case PunchWeaponType.spiderWeb:
        _launchSpiderWebShot(destination, hitUncle);
        break;
      case PunchWeaponType.sledgeHammer:
        _launchSledgeHammer(destination, hitUncle, size);
        break;
      case PunchWeaponType.plasmaLaser:
        _launchPlasmaLaser(destination, hitUncle, size);
        break;
      case PunchWeaponType.classicGlove:
        _launchPunchTowards(destination, targetedUncle: hitUncle);
        break;
    }
  }

  void _recordMiss() {
    setState(() {
      _hitsRemaining--;
      _floatingTexts.add('MISS! 💨');
    });
    if (_hitsRemaining <= 0 && !_allTargetsDefeated) {
      Timer(const Duration(milliseconds: 400), () {
        if (mounted && !_isGameOver && !_allTargetsDefeated) {
          _handleGameOver();
        }
      });
    }
  }

  // 1. ⚡ FINGER LIGHTNING ("ungli se current nikalna")
  void _launchFingerLightning(Offset touchOrigin, _TargetUncle? hitUncle, Size size) {
    final targetPos = hitUncle != null
        ? Offset(hitUncle.x * size.width, hitUncle.y * size.height)
        : touchOrigin;

    audioManager.playZap();
    _triggerScreenShake(magnitude: 6.0);

    setState(() {
      _fingerTouchPoint = touchOrigin;
      _fingerTargetPoint = targetPos;
      _isFingerLightningActive = true;
      if (hitUncle != null) {
        if (hitUncle.isHit || hitUncle.hp <= 0) return;
        if (hitUncle.isBomb) {
          audioManager.playGameOver();
          gameState.decrementLife();
          hitUncle.isHit = true;
          hitUncle.hp = 0;
          _punchSparks.add(targetPos);
          _floatingTexts.add('BOOM! -50 💣');
          _score = math.max(0, _score - 50);
          _hitsRemaining--;
          if (gameState.lives <= 0 || (_hitsRemaining <= 0 && !_allTargetsDefeated)) {
            _handleGameOver();
          }
          return;
        }
        hitUncle.isElectrified = true;
        hitUncle.recoilAngle = -0.45;
        _punchSparks.add(targetPos);
        _floatingTexts.add(_activeWeapon.comicBurst);
        _applyUncleDamage(hitUncle, 150 + _activeWeapon.bonusDamage);
      } else {
        _recordMiss();
      }
    });

    Timer(const Duration(milliseconds: 380), () {
      if (mounted) {
        setState(() {
          _isFingerLightningActive = false;
          if (hitUncle != null) hitUncle.isElectrified = false;
        });
      }
    });
  }

  // 2. 🌀 ROLLING TORNADO DRILL PUNCH
  void _launchRollingDrillPunch(Offset destination, _TargetUncle? hitUncle) {
    audioManager.playDrill();
    _launchPunchTowards(destination, targetedUncle: hitUncle, isDrill: true);
  }

  // 3. ❄️ GLACIER FROST FREEZE BEAM
  void _launchFrostFreezeBeam(Offset destination, _TargetUncle? hitUncle, Size size) {
    final start = Offset(size.width * 0.75, size.height * 0.88);
    audioManager.playFreeze();
    _triggerScreenShake(magnitude: 5.0);

    setState(() {
      _frostBeamStart = start;
      _frostBeamTarget = destination;
      _isFrostBeamActive = true;
      if (hitUncle != null) {
        if (hitUncle.isHit || hitUncle.hp <= 0) return;
        if (hitUncle.isBomb) {
          audioManager.playGameOver();
          gameState.decrementLife();
          hitUncle.isHit = true;
          hitUncle.hp = 0;
          _punchSparks.add(destination);
          _floatingTexts.add('BOOM! -50 💣');
          _score = math.max(0, _score - 50);
          _hitsRemaining--;
          if (gameState.lives <= 0 || (_hitsRemaining <= 0 && !_allTargetsDefeated)) {
            _handleGameOver();
          }
          return;
        }
        hitUncle.isFrozen = true;
        hitUncle.recoilAngle = -0.3;
        _punchSparks.add(destination);
        _floatingTexts.add(_activeWeapon.comicBurst);
        _applyUncleDamage(hitUncle, 160 + _activeWeapon.bonusDamage);
      } else {
        _recordMiss();
      }
    });

    Timer(const Duration(milliseconds: 360), () {
      if (mounted) {
        setState(() => _isFrostBeamActive = false);
      }
    });

    if (hitUncle != null) {
      Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => hitUncle.isFrozen = false);
      });
    }
  }

  // 4. 🔥 ROCKET METEOR PUNCH
  void _launchRocketPunch(Offset destination, _TargetUncle? hitUncle) {
    audioManager.playRocket();
    _launchPunchTowards(destination, targetedUncle: hitUncle, isRocket: true);
  }

  // 5. 🕸️ SPIDER WEB SLINGER
  void _launchSpiderWebShot(Offset destination, _TargetUncle? hitUncle) {
    audioManager.playWhoosh();
    _launchPunchTowards(destination, targetedUncle: hitUncle, isWeb: true);
  }

  // 6. 🔨 MEGATON SLEDGEHAMMER
  void _launchSledgeHammer(Offset destination, _TargetUncle? hitUncle, Size size) {
    audioManager.playHammer();
    _triggerScreenShake(magnitude: 10.0);

    setState(() {
      _hammerPosition = destination;
      _isHammerSwinging = true;
      if (hitUncle != null) {
        if (hitUncle.isHit || hitUncle.hp <= 0) return;
        if (hitUncle.isBomb) {
          audioManager.playGameOver();
          gameState.decrementLife();
          hitUncle.isHit = true;
          hitUncle.hp = 0;
          _punchSparks.add(destination);
          _floatingTexts.add('BOOM! -50 💣');
          _score = math.max(0, _score - 50);
          _hitsRemaining--;
          if (gameState.lives <= 0 || (_hitsRemaining <= 0 && !_allTargetsDefeated)) {
            _handleGameOver();
          }
          return;
        }
        hitUncle.recoilAngle = -0.55;
        hitUncle.scale = 0.75;
        _punchSparks.add(destination);
        _floatingTexts.add(_activeWeapon.comicBurst);
        _applyUncleDamage(hitUncle, 200 + _activeWeapon.bonusDamage);
      } else {
        _recordMiss();
      }
    });

    Timer(const Duration(milliseconds: 320), () {
      if (mounted) {
        setState(() {
          _isHammerSwinging = false;
          if (hitUncle != null) hitUncle.scale = 1.0;
        });
      }
    });
  }

  // 7. 💥 PLASMA LASER BEAM
  void _launchPlasmaLaser(Offset destination, _TargetUncle? hitUncle, Size size) {
    final start = Offset(size.width * 0.75, size.height * 0.88);
    audioManager.playLaser();
    _triggerScreenShake(magnitude: 7.0);

    setState(() {
      _laserStart = start;
      _laserEnd = destination;
      _isLaserActive = true;
      if (hitUncle != null) {
        if (hitUncle.isHit || hitUncle.hp <= 0) return;
        if (hitUncle.isBomb) {
          audioManager.playGameOver();
          gameState.decrementLife();
          hitUncle.isHit = true;
          hitUncle.hp = 0;
          _punchSparks.add(destination);
          _floatingTexts.add('BOOM! -50 💣');
          _score = math.max(0, _score - 50);
          _hitsRemaining--;
          if (gameState.lives <= 0 || (_hitsRemaining <= 0 && !_allTargetsDefeated)) {
            _handleGameOver();
          }
          return;
        }
        hitUncle.recoilAngle = -0.45;
        _punchSparks.add(destination);
        _floatingTexts.add(_activeWeapon.comicBurst);
        _applyUncleDamage(hitUncle, 220 + _activeWeapon.bonusDamage);
      } else {
        _recordMiss();
      }
    });

    Timer(const Duration(milliseconds: 260), () {
      if (mounted) {
        setState(() => _isLaserActive = false);
      }
    });
  }

  // Standard / Flying Glove Trajectory
  void _launchPunchTowards(
    Offset destination, {
    _TargetUncle? targetedUncle,
    bool isDrill = false,
    bool isRocket = false,
    bool isWeb = false,
  }) {
    if (_isGloveFlying) return;
    final size = MediaQuery.of(context).size;
    _flightStart = Offset(size.width * 0.75, size.height * 0.88);
    _flightTarget = destination;
    _currentGloveTip = _flightStart;
    _punchImpactSquash = 1.0;

    setState(() {
      _isGloveFlying = true;
    });

    if (!isDrill && !isRocket) {
      audioManager.playWhoosh();
    }

    _flightController.reset();
    _flightController.duration = Duration(milliseconds: isRocket ? 180 : 250);

    final animation = CurvedAnimation(
      parent: _flightController,
      curve: Curves.easeInQuad,
    );

    animation.addListener(() {
      setState(() {
        _currentGloveTip = Offset.lerp(_flightStart, _flightTarget, animation.value)!;
      });
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _handlePunchImpactAt(_flightTarget, targetedUncle, isWeb: isWeb);

        Timer(const Duration(milliseconds: 90), () {
          if (!mounted) return;
          _flightController.duration = const Duration(milliseconds: 160);
          _flightController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _isGloveFlying = false;
                _currentGloveTip = _flightStart;
                _punchImpactSquash = 1.0;
              });
            }
          });
        });
      }
    });

    _flightController.forward();
  }

  void _handlePunchImpactAt(Offset impactPoint, _TargetUncle? explicitUncle, {bool isWeb = false}) {
    final size = MediaQuery.of(context).size;
    final hitUncle = explicitUncle ?? _findUncleAt(impactPoint, size);

    if (hitUncle != null) {
      if (hitUncle.isHit || hitUncle.hp <= 0) return;

      audioManager.playWhack();
      _triggerScreenShake(magnitude: 8.0);
      _punchImpactSquash = 0.75;
      hitUncle.recoilAngle = -0.45;

      if (isWeb) {
        hitUncle.isWebbed = true;
        Timer(const Duration(seconds: 5), () {
          if (mounted) setState(() => hitUncle.isWebbed = false);
        });
      }

      if (hitUncle.isBomb) {
        audioManager.playGameOver();
        gameState.decrementLife();
        setState(() {
          hitUncle.isHit = true;
          hitUncle.hp = 0;
          _punchSparks.add(impactPoint);
          _floatingTexts.add('BOOM! -50 💣');
          _score = math.max(0, _score - 50);
          _hitsRemaining--;
        });

        if (gameState.lives <= 0 || (_hitsRemaining <= 0 && !_allTargetsDefeated)) {
          _handleGameOver();
          return;
        }
      } else {
        setState(() {
          _punchSparks.add(impactPoint);
          _floatingTexts.add(_activeWeapon.comicBurst);
        });
        _applyUncleDamage(hitUncle, 100 + _activeWeapon.bonusDamage);
      }
    } else {
      _recordMiss();
    }
  }

  void _applyUncleDamage(_TargetUncle uncle, int points) {
    if (uncle.isHit || uncle.hp <= 0) return;

    uncle.hp--;
    if (uncle.hp <= 0) {
      uncle.isHit = true;
      uncle.hitFlyX = (_random.nextDouble() - 0.5) * 120;
      uncle.hitFlyY = -60;
    }

    setState(() {
      _score += points;
      _hitsRemaining--;
    });

    if (_allTargetsDefeated) {
      Timer(const Duration(milliseconds: 500), () {
        if (mounted && !_isGameOver) _handleVictory();
      });
    } else if (_hitsRemaining <= 0) {
      Timer(const Duration(milliseconds: 400), () {
        if (mounted && !_isGameOver) {
          if (_allTargetsDefeated) {
            _handleVictory();
          } else {
            _handleGameOver();
          }
        }
      });
    }
  }

  void _handleVictory() {
    _isGameOver = true;
    _gameLoopTimer?.cancel();
    audioManager.playWin();
    final starsEarned = _score >= _targetScore ? 3 : (_score >= (_targetScore * 0.7) ? 2 : 1);
    gameState.completeLevel(widget.level, _score, starsEarned);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LevelCompleteDialog(
        level: widget.level,
        score: _score,
        stars: starsEarned,
        coinsEarned: 200,
        onNextLevel: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameplayScreen(level: widget.level + 1),
            ),
          );
        },
        onHome: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _handleGameOver() {
    _isGameOver = true;
    _gameLoopTimer?.cancel();
    audioManager.playGameOver();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameOverDialog(
        score: _score,
        highScore: math.max(gameState.highScore, _score),
        onRetry: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameplayScreen(level: widget.level),
            ),
          );
        },
        onHome: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _openPauseMenu() {
    showDialog(
      context: context,
      builder: (_) => PauseDialog(
        onContinue: () {},
        onRestart: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => GameplayScreen(level: widget.level),
            ),
          );
        },
        onHome: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    _flightController.dispose();
    _gameLoopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final levelTargetSkin = UncleCharacterWidget.getSkinForLevel(widget.level);
    final levelTargetName = UncleCharacterWidget.getCharacterNameForSkin(levelTargetSkin);

    return Scaffold(
      body: Transform.translate(
        offset: Offset(_screenShakeOffset, _screenShakeOffset * 0.5),
        child: GestureDetector(
          onPanStart: (details) {
            if (_isGloveFlying || _isGameOver) return;
            setState(() {
              _isDragging = true;
              _dragPosition = details.localPosition;
            });
          },
          onPanUpdate: (details) {
            if (!_isDragging || _isGloveFlying || _isGameOver) return;
            setState(() {
              _dragPosition = details.localPosition;
              final gloveBase = Offset(size.width * 0.75, size.height * 0.88);
              final diff = _dragPosition - gloveBase;
              _aimAngle = math.atan2(diff.dx, -diff.dy).clamp(-0.85, 0.85);
            });
          },
          onPanEnd: (details) {
            if (!_isDragging || _isGloveFlying || _isGameOver) return;
            final gloveBase = Offset(size.width * 0.75, size.height * 0.88);
            final aimDistance = size.height * 0.65;
            final targetX = (gloveBase.dx + math.sin(_aimAngle) * aimDistance).clamp(40.0, size.width - 40.0);
            final targetY = (gloveBase.dy - math.cos(_aimAngle) * aimDistance).clamp(80.0, size.height * 0.6);

            setState(() => _isDragging = false);
            _executeAttackAt(Offset(targetX, targetY));
          },
          onTapDown: (details) {
            _executeAttackAt(details.localPosition);
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: _environment.backgroundGradient,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // 1. Dynamic Arena Ambient
                  if (_environment.ambientOverlay != null)
                    Positioned.fill(child: _environment.ambientOverlay!),

                  // 2. Stacked Furniture Pyramid
                  Positioned(
                    bottom: size.height * 0.28,
                    left: size.width * 0.5 - 140,
                    child: FurnitureStackWidget(
                      width: 280,
                      height: 180,
                      woodColor: _environment.furnitureMainColor,
                      legColor: _environment.furnitureLegColor,
                      chairColor: _environment.chairColor,
                    ),
                  ),

                  // 3. Uncles with Full-Body Tap Detection
                  for (var uncle in _uncles)
                    Positioned(
                      left: (uncle.x * size.width - 48) + (uncle.isHit ? uncle.hitFlyX : 0),
                      top: (uncle.y * size.height - 48) + (uncle.isHit ? uncle.hitFlyY : 0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) {
                          if (uncle.isHit || uncle.hp <= 0 || _isGameOver) return;
                          _executeAttackAt(
                            Offset(uncle.x * size.width, uncle.y * size.height),
                            targetedUncle: uncle,
                          );
                        },
                        child: Transform.rotate(
                          angle: uncle.wobbleAngle + (uncle.isHit ? uncle.recoilAngle : 0),
                          child: UncleCharacterWidget(
                            size: 96 * uncle.scale,
                            skin: uncle.skin,
                            isHit: uncle.isHit,
                            hp: uncle.hp,
                            maxHp: uncle.maxHp,
                            isElectrified: uncle.isElectrified,
                            isWebbed: uncle.isWebbed,
                            isFrozen: uncle.isFrozen,
                            recoilAngle: uncle.recoilAngle,
                          ),
                        ),
                      ),
                    ),

                  // 4. ATTACK VISUAL EFFECTS
                  // A. ⚡ Finger Lightning ("ungli se current nikalna")
                  if (_isFingerLightningActive)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: FingerLightningStrikeWidget(
                          start: _fingerTouchPoint,
                          target: _fingerTargetPoint,
                        ),
                      ),
                    ),

                  // B. ❄️ Glacier Frost Freeze Beam
                  if (_isFrostBeamActive)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: FrostBeamWidget(
                          start: _frostBeamStart,
                          target: _frostBeamTarget,
                        ),
                      ),
                    ),

                  // C. 🔨 Sledgehammer Slam
                  if (_isHammerSwinging)
                    Positioned(
                      left: _hammerPosition.dx - 35,
                      top: _hammerPosition.dy - 65,
                      child: IgnorePointer(
                        child: ComicHammerWidget(size: 85, swingAngle: -0.35),
                      ),
                    ),

                  // D. 💥 Plasma Laser Beam
                  if (_isLaserActive)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _LaserBeamPainter(start: _laserStart, end: _laserEnd),
                        ),
                      ),
                    ),

                  // E. Flying Glove (Spring / Rolling Drill / Rocket)
                  if (_isGloveFlying)
                    Positioned(
                      left: _currentGloveTip.dx - 36,
                      top: _currentGloveTip.dy - 36,
                      child: IgnorePointer(
                        child: Transform.scale(
                          scale: _punchImpactSquash,
                          child: _buildFlyingGloveWidget(),
                        ),
                      ),
                    ),

                  // Base Spring Boxing Glove (when not flying)
                  if (!_isGloveFlying)
                    Positioned(
                      bottom: size.height * 0.16,
                      right: 18,
                      child: IgnorePointer(
                        child: Transform.rotate(
                          angle: _isDragging ? _aimAngle : -0.2,
                          child: BoxingGloveWidget(
                            size: 82,
                            gloveColor: _activeWeapon.primaryColor,
                          ),
                        ),
                      ),
                    ),

                  // Floating Action Words
                  for (var text in _floatingTexts)
                    Positioned(
                      left: size.width * 0.5 - 95,
                      top: size.height * 0.22,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD50000),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFFFD54F), width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Color(0xFFFFD54F),
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 5. MODERN FLOATING BOTTOM WEAPON DOCK
                  Positioned(
                    bottom: 10,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: GameTheme.modernGlassCard(
                        tint: const Color(0xFF0D47A1),
                        opacity: 0.88,
                        borderColor: const Color(0xFF64B5F6),
                        borderWidth: 2.5,
                        radius: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'WEAPONS (${_weapons.where((w) => widget.level >= w.unlockLevel).length}/${_weapons.length})',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD54F),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10,
                                    letterSpacing: 1.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Equipped: ${_activeWeapon.shortName}',
                                style: TextStyle(
                                  color: _activeWeapon.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _weapons.length,
                              itemBuilder: (context, index) {
                                final weapon = _weapons[index];
                                final isUnlocked = widget.level >= weapon.unlockLevel;
                                final isSelected = _activeWeapon.id == weapon.id;

                                return GestureDetector(
                                  onTap: () => _selectWeapon(weapon),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? weapon.primaryColor.withValues(alpha: 0.35)
                                          : (isUnlocked
                                              ? const Color(0xFF1565C0).withValues(alpha: 0.7)
                                              : Colors.black45),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? weapon.primaryColor
                                            : (isUnlocked ? Colors.white30 : Colors.white12),
                                        width: isSelected ? 2.5 : 1.2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: weapon.glowColor.withValues(alpha: 0.6),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isUnlocked ? weapon.icon : Icons.lock,
                                          color: isUnlocked
                                              ? (isSelected ? Colors.white : weapon.primaryColor)
                                              : Colors.white38,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 6),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              weapon.shortName,
                                              style: TextStyle(
                                                color: isUnlocked ? Colors.white : Colors.white54,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              isUnlocked ? '+${weapon.bonusDamage} pts' : 'Lvl ${weapon.unlockLevel}',
                                              style: TextStyle(
                                                color: isUnlocked ? const Color(0xFFFFD54F) : Colors.white38,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 6. MODERN FLOATING TOP HUD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: GameTheme.modernGlassCard(
                        tint: const Color(0xFF0D47A1),
                        opacity: 0.88,
                        borderColor: const Color(0xFF64B5F6),
                        borderWidth: 2.0,
                        radius: 20,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _openPauseMenu,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E88E5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: const Icon(Icons.settings, color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Target Uncle Miniature
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: UncleCharacterWidget(size: 24, skin: levelTargetSkin),
                          ),
                          const SizedBox(width: 6),

                          // Level & Character Name
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Level ${widget.level}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  levelTargetName,
                                  style: const TextStyle(
                                    color: Color(0xFFFFD54F),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),

                          // Targets Defeated Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0039CB).withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF64B5F6), width: 1.2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🎯', style: TextStyle(fontSize: 11)),
                                const SizedBox(width: 3),
                                Text(
                                  '${_uncles.where((u) => !u.isBomb && (u.isHit || u.hp <= 0)).length}/${_uncles.where((u) => !u.isBomb).length}',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD54F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),

                          // Hits Left Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFF9C4), Color(0xFFFFD54F)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFF8F00), width: 1.2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🥊', style: TextStyle(fontSize: 11)),
                                const SizedBox(width: 3),
                                Text(
                                  '$_hitsRemaining',
                                  style: const TextStyle(
                                    color: Color(0xFFBF360C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlyingGloveWidget() {
    switch (_activeWeapon.type) {
      case PunchWeaponType.rollingDrill:
        return RollingTornadoPunchWidget(
          size: 75,
          spinAngle: _drillSpinAngle,
          gloveColor: _activeWeapon.primaryColor,
        );
      case PunchWeaponType.rocketFire:
        return RocketFireGloveWidget(
          size: 75,
          angle: -0.25,
        );
      default:
        return BoxingGloveWidget(
          size: 70,
          gloveColor: _activeWeapon.primaryColor,
        );
    }
  }
}

class _LaserBeamPainter extends CustomPainter {
  final Offset start;
  final Offset end;

  _LaserBeamPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = const Color(0xFFD500F9).withValues(alpha: 0.85)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, glow);

    final core = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, core);
  }

  @override
  bool shouldRepaint(covariant _LaserBeamPainter oldDelegate) => true;
}
