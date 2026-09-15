import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../services/game_state.dart';
import '../services/ad_service.dart';
import '../widgets/game_button.dart';

class SkinsPreviewScreen extends StatefulWidget {
  const SkinsPreviewScreen({super.key});

  @override
  State<SkinsPreviewScreen> createState() => _SkinsPreviewScreenState();
}

class _SkinsPreviewScreenState extends State<SkinsPreviewScreen> {
  final GameState gameState = GameState();
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    final index = gameState.allSkins.indexWhere((s) => s.id == gameState.equippedSkinId);
    _currentIndex = index >= 0 ? index : 0;
  }

  void _nextSkin() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % gameState.allSkins.length;
    });
  }

  void _prevSkin() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + gameState.allSkins.length) % gameState.allSkins.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: GameTheme.skyGradient,
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: gameState,
            builder: (context, _) {
              final skin = gameState.allSkins[_currentIndex];
              final isUnlocked = gameState.isSkinUnlocked(skin.id);
              final isEquipped = gameState.equippedSkinId == skin.id;

              return Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        GameIconButton(
                          icon: Icons.arrow_back,
                          backgroundColor: const Color(0xFF1565C0),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Skins Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // 3D Podium & Character View with Navigation Arrows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left Arrow
                      GameIconButton(
                        icon: Icons.arrow_back_ios_new,
                        size: 48,
                        backgroundColor: const Color(0xFF0D47A1),
                        onPressed: _prevSkin,
                      ),
                      const SizedBox(width: 20),

                      // Center Podium & Uncle
                      Column(
                        children: [
                          UncleCharacterWidget(
                            size: 160,
                            skin: skin.skinType,
                          ),
                          // 3D Circular Pedestal / Podium
                          Container(
                            width: 180,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF90CAF9),
                              borderRadius: const BorderRadius.all(Radius.elliptical(180, 28)),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  offset: const Offset(0, 8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),

                      // Right Arrow
                      GameIconButton(
                        icon: Icons.arrow_forward_ios,
                        size: 48,
                        backgroundColor: const Color(0xFF0D47A1),
                        onPressed: _nextSkin,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Skin Name Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                    ),
                    child: Text(
                      skin.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Select / Buy Action Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: isEquipped
                        ? Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 2.5),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'EQUIPPED',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : isUnlocked
                            ? GameButton(
                                text: 'Select',
                                color: GameButtonColor.blue,
                                onPressed: () {
                                  gameState.equipSkin(skin.id);
                                },
                              )
                            : GameButton(
                                text: 'Unlock (${skin.price})',
                                color: GameButtonColor.orange,
                                onPressed: () {
                                  if (gameState.unlockSkin(skin.id, skin.price)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('🎉 Unlocked ${skin.name}!')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('⚠️ Not enough coins! Watch an ad for +500 Coins!'),
                                        backgroundColor: const Color(0xFFC62828),
                                        duration: const Duration(seconds: 4),
                                        action: SnackBarAction(
                                          label: 'GET +500 🪙',
                                          textColor: const Color(0xFFFFD54F),
                                          onPressed: () => AdService().showRewardedAd(context, rewardAmount: 500),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                  ),

                  const Spacer(flex: 2),

                  // Bottom Thumbnails Carousel
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF42A5F5), width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(gameState.allSkins.length, (index) {
                        final s = gameState.allSkins[index];
                        final isSelected = index == _currentIndex;

                        return GestureDetector(
                          onTap: () => setState(() => _currentIndex = index),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0D47A1),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFFFD54F) : Colors.white24,
                                width: isSelected ? 3 : 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.amber.withValues(alpha: 0.6),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: UncleCharacterWidget(
                              size: 32,
                              skin: s.skinType,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
