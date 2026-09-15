import 'package:flutter/material.dart';
import '../theme/game_characters.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRetry;
  final VoidCallback onHome;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.highScore,
    required this.onRetry,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ComicPanel(
        title: 'Game Over',
        titleColor: const Color(0xFFFF5252),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF42A5F5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // Dizzy Uncle with Spinning Stars (Match Reference Screen 6)
            const UncleCharacterWidget(
              size: 100,
              skin: 'dizzy',
              showDizzyStars: true,
            ),
            const SizedBox(height: 12),

            // Scores Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E88E5), width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Score',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$score',
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 16, indent: 40, endIndent: 40),
                  const Text(
                    'Best Score',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$highScore',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Buttons: 🔵 Home, 🟢 Retry
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GameButton(
                    text: 'Home',
                    icon: Icons.home,
                    color: GameButtonColor.blue,
                    height: 46,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onHome();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GameButton(
                    text: 'Retry',
                    icon: Icons.refresh,
                    color: GameButtonColor.green,
                    height: 46,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
