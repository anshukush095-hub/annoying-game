import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../services/game_state.dart';
import '../services/audio_manager.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';
import 'gameplay_screen.dart';
import '../dialogs/coins_rewards_dialog.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  static const int levelsPerStage = 50;
  static const int totalLevels = 2000;
  final int totalStages = (totalLevels / levelsPerStage).ceil(); // 40 stages

  int _currentStage = 0; // 0-indexed (Stage 1 is index 0)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto-navigate to stage of highest current level
    final currentLvl = GameState().currentLevelNumber;
    _currentStage = ((currentLvl - 1) ~/ levelsPerStage).clamp(0, totalStages - 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showJumpToLevelDialog(BuildContext context, GameState gameState) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0D47A1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF64B5F6), width: 3),
        ),
        title: const Text(
          'Jump to Level (1 - 2000)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'e.g. 150',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1565C0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // Jump to current active level
                    final lvl = gameState.currentLevelNumber;
                    setState(() {
                      _currentStage = ((lvl - 1) ~/ levelsPerStage).clamp(0, totalStages - 1);
                    });
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Latest Level', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final entered = int.tryParse(textController.text.trim());
                    if (entered != null && entered >= 1 && entered <= totalLevels) {
                      setState(() {
                        _currentStage = ((entered - 1) ~/ levelsPerStage).clamp(0, totalStages - 1);
                      });
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text('Go', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState();
    final startLevel = (_currentStage * levelsPerStage) + 1;
    final endLevel = math.min((_currentStage + 1) * levelsPerStage, totalLevels);

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
              return Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        GameIconButton(
                          icon: Icons.arrow_back,
                          backgroundColor: const Color(0xFF1565C0),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Level',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                                ],
                              ),
                            ),
                            Text(
                              'Total 2,000 Levels',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GameIconButton(
                          icon: Icons.search,
                          backgroundColor: const Color(0xFF00897B),
                          onPressed: () => _showJumpToLevelDialog(context, gameState),
                        ),
                        const SizedBox(width: 8),
                        CoinCapsule(
                          coins: gameState.coins,
                          onAddCoins: () {
                            showDialog(
                              context: context,
                              builder: (_) => const CoinsRewardsDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Stage / Chapter Navigation Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF64B5F6), width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                            onPressed: _currentStage > 0
                                ? () {
                                    AudioManager().playTap();
                                    setState(() {
                                      _currentStage--;
                                    });
                                  }
                                : null,
                          ),
                          Column(
                            children: [
                              Text(
                                'Stage ${_currentStage + 1} of $totalStages',
                                style: const TextStyle(
                                  color: Color(0xFFFFD54F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Levels $startLevel - $endLevel',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                            onPressed: _currentStage < totalStages - 1
                                ? () {
                                    AudioManager().playTap();
                                    setState(() {
                                      _currentStage++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Levels Grid for Current Stage (50 levels per stage)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF64B5F6), width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, offset: Offset(0, 6), blurRadius: 10),
                          ],
                        ),
                        child: GridView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: endLevel - startLevel + 1,
                          itemBuilder: (context, index) {
                            final levelNumber = startLevel + index;
                            final levelIndex = levelNumber - 1;
                            final level = (levelIndex >= 0 && levelIndex < gameState.levels.length)
                                ? gameState.levels[levelIndex]
                                : null;
                            final isUnlocked = level?.isUnlocked ?? false;
                            final isCurrent = levelNumber == gameState.currentLevelNumber;
                            final skinForThisLevel = UncleCharacterWidget.getSkinForLevel(levelNumber);

                            return GestureDetector(
                              onTap: isUnlocked
                                  ? () {
                                      AudioManager().playTap();
                                      gameState.setCurrentLevel(levelNumber);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => GameplayScreen(level: levelNumber),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? const Color(0xFFFF9800) // Highlight current level
                                      : (isUnlocked
                                          ? const Color(0xFF42A5F5)
                                          : const Color(0xFF455A64)),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isCurrent
                                        ? const Color(0xFFFFEB3B)
                                        : (isUnlocked ? Colors.white : Colors.white24),
                                    width: isCurrent ? 2.5 : 1.8,
                                  ),
                                  boxShadow: isUnlocked
                                      ? [
                                          BoxShadow(
                                            color: isCurrent
                                                ? const Color(0xFFE65100)
                                                : const Color(0xFF1565C0),
                                            offset: const Offset(0, 3),
                                            blurRadius: 0,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isUnlocked) ...[
                                      // Miniature level-specific Uncle preview!
                                      SizedBox(
                                        width: 26,
                                        height: 30,
                                        child: UncleCharacterWidget(size: 24, skin: skinForThisLevel),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        '$levelNumber',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          3,
                                          (s) => Icon(
                                            Icons.star,
                                            size: 9,
                                            color: s < (level?.stars ?? 0)
                                                ? const Color(0xFFFFD54F)
                                                : Colors.black26,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      const Icon(
                                        Icons.lock,
                                        color: Colors.white60,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$levelNumber',
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Bottom Hint Banner with Dynamic Character of Current Stage
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF42A5F5), width: 2),
                    ),
                    child: Row(
                      children: [
                        UncleCharacterWidget(
                          size: 36,
                          skin: UncleCharacterWidget.getSkinForLevel(startLevel),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Featured: ${UncleCharacterWidget.getCharacterNameForSkin(UncleCharacterWidget.getSkinForLevel(startLevel))}',
                                style: const TextStyle(
                                  color: Color(0xFFFFD54F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                'Every level features a new annoying uncle to punch!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
