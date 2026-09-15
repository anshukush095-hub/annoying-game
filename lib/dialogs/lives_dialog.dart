import 'package:flutter/material.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';
import '../theme/game_characters.dart';
import 'rewarded_ad_dialog.dart';

class LivesDialog extends StatelessWidget {
  const LivesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ComicPanel(
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF42A5F5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            // 3 Hearts (empty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.favorite_border,
                    color: Color(0xFFFF5252),
                    size: 38,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'No more lives!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Watch an ad to continue playing',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // Watch Ad Button
            GameButton(
              text: 'Watch Ad',
              icon: Icons.play_circle_fill,
              color: GameButtonColor.green,
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (ctx) => const RewardedAdDialog(rewardAmount: 50),
                ).then((_) {
                  GameState().refillLives();
                });
              },
            ),
            const SizedBox(height: 12),

            // Later Button
            GameButton(
              text: 'Later',
              color: GameButtonColor.blue,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 14),

            // Uncle Mascot
            const UncleCharacterWidget(
              size: 70,
              skin: 'default',
            ),
          ],
        ),
      ),
    );
  }
}
