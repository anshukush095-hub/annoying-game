import 'package:flutter/material.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';
import 'rewarded_ad_dialog.dart';
import 'daily_reward_dialog.dart';

class CoinsRewardsDialog extends StatelessWidget {
  const CoinsRewardsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState();

    return ListenableBuilder(
      listenable: gameState,
      builder: (context, _) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ComicPanel(
            title: 'Your Coins',
            titleColor: const Color(0xFFFFD54F),
            backgroundColor: const Color(0xFF1565C0),
            borderColor: const Color(0xFF64B5F6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // Coin Badge Big
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFD54F), width: 2.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD54F),
                        ),
                        child: const Center(
                          child: Text(
                            '¢',
                            style: TextStyle(
                              color: Color(0xFFE65100),
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${gameState.coins}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Option 1: Watch Ad (+100)
                _buildRewardTile(
                  icon: Icons.play_arrow,
                  title: 'Watch Ad',
                  rewardText: '+100',
                  iconColor: const Color(0xFF42A5F5),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const RewardedAdDialog(rewardAmount: 100),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Option 2: Complete Levels (+50)
                _buildRewardTile(
                  icon: Icons.star,
                  title: 'Complete Levels',
                  rewardText: '+50',
                  iconColor: const Color(0xFFFFB300),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10),

                // Option 3: Daily Reward (+200)
                _buildRewardTile(
                  icon: Icons.card_giftcard,
                  title: 'Daily Reward',
                  rewardText: '+200',
                  iconColor: const Color(0xFFE91E63),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const DailyRewardDialog(),
                    );
                  },
                ),
                const SizedBox(height: 22),

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
      },
    );
  }

  Widget _buildRewardTile({
    required IconData icon,
    required String title,
    required String rewardText,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E88E5), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                rewardText,
                style: const TextStyle(
                  color: Color(0xFFBF360C),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
