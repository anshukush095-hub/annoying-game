import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../widgets/game_button.dart';
import '../services/game_state.dart';
import 'gameplay_screen.dart';

class StartGameScreen extends StatelessWidget {
  final int level;

  const StartGameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState();
    final levelData = gameState.levels.firstWhere(
      (l) => l.levelNumber == level,
      orElse: () => gameState.levels.first,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: GameTheme.skyGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Back Button & Level Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GameIconButton(
                      icon: Icons.arrow_back,
                      backgroundColor: const Color(0xFF1565C0),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                      ),
                      child: Text(
                        'Level $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance spacing
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Instructions / Objective Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0288D1), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Tap the annoying character as many times as you can!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Target Score: ${levelData.targetScore}  •  Time: ${levelData.timeLimit}s',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Uncle Mascot
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UncleCharacterWidget(
                    size: 140,
                    skin: gameState.allSkins
                        .firstWhere((s) => s.id == gameState.equippedSkinId,
                            orElse: () => gameState.allSkins.first)
                        .skinType,
                  ),
                  Container(
                    width: 160,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF90CAF9),
                      borderRadius: const BorderRadius.all(Radius.elliptical(160, 24)),
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),

              // Big Green START Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: GameButton(
                  text: 'START',
                  color: GameButtonColor.green,
                  height: 64,
                  fontSize: 26,
                  isRound: true,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => GameplayScreen(level: level),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
