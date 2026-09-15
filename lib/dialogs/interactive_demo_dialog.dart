import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/game_characters.dart';
import '../services/game_state.dart';
import '../services/audio_manager.dart';
import '../widgets/game_button.dart';

class InteractiveDemoDialog extends StatefulWidget {
  final VoidCallback? onStartPlaying;

  const InteractiveDemoDialog({super.key, this.onStartPlaying});

  @override
  State<InteractiveDemoDialog> createState() => _InteractiveDemoDialogState();
}

class _InteractiveDemoDialogState extends State<InteractiveDemoDialog>
    with TickerProviderStateMixin {
  int _currentStep = 0; // 0 to 3
  static const int _totalSteps = 4;

  // Interactive Live Punch Test State
  bool _isPunchFlying = false;
  double _punchProgress = 0.0;
  bool _uncleIsHit = false;
  double _uncleRecoil = 0.0;
  String _comicText = '';
  double _shakeOffset = 0.0;

  // Superpower Test
  bool _demoElectrified = false;
  bool _demoWebbed = false;
  bool _demoFrozen = false;

  // Finger Animation
  late AnimationController _handPulseController;

  @override
  void initState() {
    super.initState();
    _handPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _handPulseController.dispose();
    super.dispose();
  }

  void _triggerDemoPunch({bool isSuper = false}) {
    if (_isPunchFlying) return;

    AudioManager().playWhoosh();
    setState(() {
      _isPunchFlying = true;
      _punchProgress = 0.0;
      _comicText = '';
    });

    // Animate punch flying forward
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _punchProgress += 0.12;
      });

      if (_punchProgress >= 1.0) {
        timer.cancel();
        // Impact!
        AudioManager().playWhack();
        setState(() {
          _uncleIsHit = true;
          _uncleRecoil = -0.5;
          _shakeOffset = 8.0;
          _comicText = isSuper ? '⚡ SHOCK! +200' : 'POW! +100';
        });

        // Shake recovery
        Timer(const Duration(milliseconds: 100), () {
          if (mounted) setState(() => _shakeOffset = 0.0);
        });

        // Uncle recovery & glove retract
        Timer(const Duration(milliseconds: 350), () {
          if (mounted) {
            setState(() {
              _uncleIsHit = false;
              _uncleRecoil = 0.0;
              _isPunchFlying = false;
              _punchProgress = 0.0;
            });
          }
        });
      }
    });
  }

  void _finishDemo() {
    GameState().completeDemo();
    Navigator.of(context).pop();
    widget.onStartPlaying?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 440,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF64B5F6), width: 3.5),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 14, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'STEP ${_currentStep + 1}/$_totalSteps',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Game Demo / How to Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 24),
                    onPressed: _finishDemo,
                  ),
                ],
              ),
            ),

            // Step Progress Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalSteps, (i) {
                final isActive = i == _currentStep;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFFFD54F) : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            // Step Content (Scrollable to prevent overflow)
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildCurrentStepContent(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bottom Navigation Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          AudioManager().playTap();
                          setState(() => _currentStep--);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GameButton(
                      text: _currentStep < _totalSteps - 1 ? 'Next Step ➡️' : 'START PUNCHING! 🥊',
                      color: _currentStep < _totalSteps - 1 ? GameButtonColor.blue : GameButtonColor.green,
                      height: 48,
                      onPressed: () {
                        AudioManager().playTap();
                        if (_currentStep < _totalSteps - 1) {
                          setState(() => _currentStep++);
                        } else {
                          _finishDemo();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1TapPunch();
      case 1:
        return _buildStep2AimDrag();
      case 2:
        return _buildStep3SuperPowers();
      case 3:
      default:
        return _buildStep4BombsAndLevels();
    }
  }

  // STEP 1: Full-Body Touch & Instant Punch
  Widget _buildStep1TapPunch() {
    return Column(
      children: [
        const Text(
          '1. Full-Body Hit Detection 🎯',
          style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 6),
        const Text(
          'Touch ANY PART of Uncle (sir, pet, haath ya pair) to shoot a flying spring punch directly to that spot!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 14),

        // Live Interactive Arena Box
        Transform.translate(
          offset: Offset(_shakeOffset, 0),
          child: Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF42A5F5), width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ground Line
                Positioned(
                  bottom: 28,
                  left: 20,
                  right: 20,
                  child: Container(height: 3, color: Colors.white24),
                ),

                // Interactive Uncle Target
                Positioned(
                  top: 20,
                  child: GestureDetector(
                    onTap: () => _triggerDemoPunch(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        UncleCharacterWidget(
                          size: 110,
                          skin: 'default',
                          isHit: _uncleIsHit,
                          recoilAngle: _uncleRecoil,
                        ),
                        // Pulsing Finger Tap Indicator
                        if (!_uncleIsHit && !_isPunchFlying)
                          Positioned(
                            right: -10,
                            bottom: 20,
                            child: AnimatedBuilder(
                              animation: _handPulseController,
                              builder: (context, _) {
                                final offset = _handPulseController.value * 12;
                                return Transform.translate(
                                  offset: Offset(-offset, offset * 0.5),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF5722),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.deepOrange.withValues(alpha: 0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.touch_app, color: Colors.white, size: 20),
                                        SizedBox(width: 4),
                                        Text(
                                          'TAP HERE!',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
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

                // Flying Boxing Glove
                if (_isPunchFlying)
                  Positioned(
                    bottom: 15 + (_punchProgress * 55),
                    right: 40 - (_punchProgress * 65),
                    child: Transform.scale(
                      scale: 1.0 + (_punchProgress * 0.2),
                      child: const BoxingGloveWidget(size: 50, gloveColor: Color(0xFFE53935)),
                    ),
                  ),

                // Floating Action Word
                if (_comicText.isNotEmpty)
                  Positioned(
                    top: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD50000),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                      ),
                      child: Text(
                        _comicText,
                        style: const TextStyle(
                          color: Color(0xFFFFD54F),
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '👉 Tap on the Uncle above to test punch!',
          style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  // STEP 2: Drag Slingshot Aiming
  Widget _buildStep2AimDrag() {
    return Column(
      children: [
        const Text(
          '2. Slingshot Drag & Aim 🏹',
          style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 6),
        const Text(
          'Uncle idhar-udhar move karega! Glove ko pull karke nishana lagayein aur release karte hi punch shoot hoga.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 14),

        Container(
          height: 190,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF42A5F5), width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Moving Punk Uncle
              Positioned(
                top: 25,
                child: UncleCharacterWidget(
                  size: 95,
                  skin: 'red_hair',
                  isHit: _uncleIsHit,
                  recoilAngle: _uncleRecoil,
                ),
              ),

              // Aim Trajectory Arrow
              Positioned(
                bottom: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    4,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD54F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),

              // Interactive Glove Drag Button
              Positioned(
                bottom: 15,
                child: GestureDetector(
                  onTap: () => _triggerDemoPunch(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD50000),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BoxingGloveWidget(size: 34, gloveColor: Color(0xFFFFD54F)),
                        SizedBox(width: 8),
                        Text(
                          'PULL & RELEASE 🥊',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'PULL & RELEASE button par tap karke punch launch karein!',
          style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  // STEP 3: Super Powers
  Widget _buildStep3SuperPowers() {
    return Column(
      children: [
        const Text(
          '3. Super Powers & Elements ⚡',
          style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 6),
        const Text(
          'Bottom action bar se superpower select karein aur uncle par powerful elemental attack karein!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 14),

        // Live Demo Arena with Elemental Overlay
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF42A5F5), width: 2),
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              UncleCharacterWidget(
                size: 95,
                skin: 'police',
                isElectrified: _demoElectrified,
                isWebbed: _demoWebbed,
                isFrozen: _demoFrozen,
              ),
              if (_demoElectrified)
                Positioned(
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('⚡ SHOCKED!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
              if (_demoFrozen)
                Positioned(
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80D8FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('❄️ FROZEN!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 3 Super Power Test Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPowerButton(
              icon: Icons.flash_on,
              color: const Color(0xFF00E5FF),
              label: 'Electric',
              onTap: () {
                AudioManager().playZap();
                setState(() {
                  _demoElectrified = true;
                  _demoWebbed = false;
                  _demoFrozen = false;
                });
                Timer(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _demoElectrified = false);
                });
              },
            ),
            _buildPowerButton(
              icon: Icons.all_inclusive,
              color: const Color(0xFFE91E63),
              label: 'Spider Web',
              onTap: () {
                AudioManager().playTap();
                setState(() {
                  _demoWebbed = true;
                  _demoElectrified = false;
                  _demoFrozen = false;
                });
                Timer(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _demoWebbed = false);
                });
              },
            ),
            _buildPowerButton(
              icon: Icons.ac_unit,
              color: const Color(0xFF80D8FF),
              label: 'Freeze',
              onTap: () {
                AudioManager().playFreeze();
                setState(() {
                  _demoFrozen = true;
                  _demoElectrified = false;
                  _demoWebbed = false;
                });
                Timer(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _demoFrozen = false);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPowerButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // STEP 4: Bombs, Level Rotation & Let's Play!
  Widget _buildStep4BombsAndLevels() {
    return Column(
      children: [
        const Text(
          '4. Beware of Bombs 💣 & 2,000 Levels!',
          style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.w900, fontSize: 17),
        ),
        const SizedBox(height: 6),
        const Text(
          'Bomb wale uncle ko punch mat karein (-50 points aur life chali jaati hai!).',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 12),

        // Bomb Uncle & Warning Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFD50000).withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFF5252), width: 2),
          ),
          child: const Row(
            children: [
              UncleCharacterWidget(size: 55, skin: 'bomb'),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ AVOID BOMB UNCLES',
                      style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.w900, fontSize: 13),
                    ),
                    Text(
                      'Unhe chhodkar baki uncles ko punch karein aur high score banayein!',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 20 Characters Roster Preview
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF0039CB).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF42A5F5), width: 1.5),
          ),
          child: Column(
            children: [
              const Text(
                '🎭 Har level ke baad Naya Annoying Uncle!',
                style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  UncleCharacterWidget(size: 36, skin: 'clown'),
                  UncleCharacterWidget(size: 36, skin: 'pirate'),
                  UncleCharacterWidget(size: 36, skin: 'vampire'),
                  UncleCharacterWidget(size: 36, skin: 'alien'),
                  UncleCharacterWidget(size: 36, skin: 'ninja'),
                  UncleCharacterWidget(size: 36, skin: 'gold'),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Poore 2,000 Levels & 40 Stages await you!',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
