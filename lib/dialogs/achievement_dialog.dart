import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class AchievementDialog extends StatelessWidget {
  final AchievementItem achievement;

  const AchievementDialog({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ComicPanel(
        title: 'Achievement Unlocked!',
        titleColor: const Color(0xFFFFD54F),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF64B5F6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // Big Gold Medal
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFF59D), Color(0xFFFFB300), Color(0xFFFF8F00)],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.5),
                    blurRadius: 18,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                achievement.icon,
                size: 50,
                color: const Color(0xFFE65100),
              ),
            ),
            const SizedBox(height: 18),

            // Achievement Title
            Text(
              achievement.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),

            // Achievement Description
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),

            // Reward
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Reward: ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '+${achievement.rewardCoins} Coins',
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // OK Button
            GameButton(
              text: 'OK',
              color: GameButtonColor.green,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
